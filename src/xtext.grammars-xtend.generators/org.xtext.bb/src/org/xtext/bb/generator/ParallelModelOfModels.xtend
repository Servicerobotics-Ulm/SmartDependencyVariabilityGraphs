package org.xtext.bb.generator 
import org.eclipse.emf.ecore.EObject
import java.util.ArrayList
import BbDvgTcl.EquivalenceFork
import BbDvgTcl.Container
import java.util.List
import BbDvgTcl.DVG
import java.util.Map
import java.util.HashMap
import BbDvgTcl.SAPRO
import BbDvgTcl.FinalOperation

class ParallelModelOfModels {
	
	String code = ""
	
	String dvgName
	String outputName
	String saproName
		
	List<List<VariabilityInformation>> variabilityInformationListList
	
	List<BbDvgTcl.AbstractInputPort> inputSetInputs
	List<String> dvgNames // The names of the referenced variants of the EQUF
	var List<BbDvgTcl.DVGPort> inputSet
	
	var Map<String, Integer> ACTIVE
	var Map<String, Integer> PASSIVE	
	
	boolean finalOperationIsMax
	
	def String getCode() {
		return this.code
	}
	
	def start (DVG dvg, List<List<VariabilityInformation>> variabilityInformationListList) {
		var EObject tmp = dvg.pattern.get(0)
		
		if (tmp instanceof SAPRO) {
			this.dvgName = dvg.name
			this.saproName = tmp.name
			this.outputName = dvg.outputName
			this.variabilityInformationListList = variabilityInformationListList
			this.finalOperationIsMax = Helpers.GetFinalOperationIsMax(dvg.finalOperation)
			determineSAPROCallInformation(tmp)
			determineVariabilityInformation()
			this.code += generate(tmp)		
		}
		else {
			System.err.println("ERROR: DVG of Parallel model of model does not contain SAPRO as the only pattern!")
		}
	}
	
	def determineSAPROCallInformation(SAPRO sapro) {
		// We expect a corresponding DVG with a SAPRO that must receive its inputs from the return of the solve method of each class
		// we use the link to the output ports as the name for return in solve
		this.inputSet = new ArrayList<BbDvgTcl.DVGPort>()
		this.inputSetInputs = new ArrayList<BbDvgTcl.AbstractInputPort>() // This is for the $names$ in the expressions
		this.dvgNames = new ArrayList<String>()

		for (i : sapro.ip) {
			inputSetInputs.add(i)
			inputSet.add(i.outputport)
			var EObject dvg2 = Helpers.getPattern(i.outputport) 
			dvg2 = dvg2.eContainer
			if (dvg2 instanceof DVG) {
				dvgNames.add(dvg2.name)
			}	
		}	
	}	
	
	def determineVariabilityInformation() {
		this.ACTIVE = new HashMap<String,Integer>()
		this.PASSIVE = new HashMap<String,Integer>()
				
		// We add the allocations of a building block if there are more than one
		for (var int i = 0; i < this.variabilityInformationListList.size(); i++) {
			for (var int j = 0; j < this.variabilityInformationListList.get(i).size(); j++) {
				this.ACTIVE.putAll(this.variabilityInformationListList.get(i).get(j).active)
				this.PASSIVE.putAll(this.variabilityInformationListList.get(i).get(j).passive)
				if (this.variabilityInformationListList.get(i).size == 1 && this.variabilityInformationListList.get(i).get(j).numberAllocations > 1) {
					// This is a multi-robot dependency (no EQUF model of model) for which we need to manage the generic allocation magr here
					this.ACTIVE.put("MAGR_ALLOCATION_"+dvgNames.get(i), this.variabilityInformationListList.get(i).get(j).numberAllocations)
				}
			}
		}
	}		
	
	// determineSAPROCallInformation(SAPRO sapro) must be called before that method
	// determineVariabilityInformation() must be called before that method
	def generate(SAPRO sapro) {
		'''
		class «this.dvgName» {
			private Map<String, Node> NODE_COLLECTION;
			«JavaFunctions.generateIsValidCombinationConsiderResource()»
			«JavaFunctions.generateGetCartesianProduct()»
			
			«generateSAPRO(sapro)»
			
			«JavaFunctions.generateGenericAllocationAggr»
			void init() {
				this.NODE_COLLECTION = new HashMap<String, Node>();
			}
			«FinalEvaluation.generateSolveCode(this.outputName, this.finalOperationIsMax, generateCallSequenceCode(sapro.name, this.inputSet, this.dvgNames), this.ACTIVE, this.PASSIVE)»
		}	
		'''
	}
	
	def String generateSAPRO(SAPRO sapro) {
		var String code = ""
		var SAPROPattern saprop = new SAPROPattern(sapro, this.inputSetInputs)
		saprop.generate()
		code += saprop.code
		return code
	}
	
	def String generateCallSequenceCode(String name, List<BbDvgTcl.DVGPort> inputSet, List<String> dvgNames) {
		
		var StringBuilder code = new StringBuilder()
		
		code.append("params = new ArrayList<Node>();\n")
		// TODO: The following should be generalized:
		// We assume that the order in the bb model matches the order in the DVG model so that the following works correctly
		// i.e. i-th input port of SAPRO must reference an output port of the dvg model of the i-th building block in the Parallel container
		for (var int i = 0; i < this.dvgNames.size(); i++) {
			code.append(this.dvgNames.get(i) +" dvg_"+i+" = new "+this.dvgNames.get(i)+"();\n")
			code.append("dvg_"+i+".init();\n")
			
			if (this.variabilityInformationListList.get(i).size > 1) {
				// This is a EQUF model of model
				code.append("dvg_"+i+".solve();\n")
				code.append("params.add(dvg_"+i+".getNode(\""+this.inputSet.get(i).name+"\"));\n")
			}
			else {
				if (this.variabilityInformationListList.get(i).get(0).numberAllocations > 1) { // we know it is only one entry if it is not a EQUF model of model
					// we need to call the generic allocation aggr
					code.append("List<Node> tmp = new ArrayList<Node>();\n")
					code.append("for (int i = 0; i < dvg_"+i+".getAllocations(); i++) {\n")
						code.append("tmp.add(dvg_"+i+".solve(\""+this.inputSet.get(i).name+"\",i));\n")
					code.append("}\n")
					code.append("params.add(AllocationAggr(tmp, \""+"MAGR_ALLOCATION_"+this.dvgNames.get(i)+"\"));\n")
				}
				else {
					code.append("params.add(dvg_"+i+".solve(\""+this.inputSet.get(i).name+"\",0));\n")
				}
			}
		}
		code.append("resolve_"+this.saproName+"(params);") 
	
		return code.toString
	}	
}