package org.xtext.bb.generator

import org.eclipse.emf.ecore.EObject
import BbDvgTcl.MAGR
import java.util.List
import java.util.ArrayList
import java.util.Map
import BbDvgTcl.DVG
import java.util.HashMap
import BbDvgTcl.FinalOperation

class EqufModelOfModels {
	
	String code = ""
	
	String dvgName // The name of the EQUF model of model
	String outputName
	String magrName
		
	List<VariabilityInformation> variabilityInformationList // the variability information for each variant of the EQUF
	
	int numberInputs
	List<String> dvgNames // The names of the referenced variants of the EQUF
	List<List<BbDvgTcl.DVGPort>> inputSetAg
	
	var Map<String, Integer> ACTIVE
	var Map<String, Integer> PASSIVE	
	
	boolean finalOperationIsMax
	
	def Map<String, Integer> getActive() {
		return this.ACTIVE
	}
	
	def Map<String, Integer> getPassive() {
		return this.PASSIVE
	}	
	
	def String getCode() {
		return this.code
	}
	
	def String generateCallSequenceCode(String name, List<List<BbDvgTcl.DVGPort>> inputSet, List<String> dvgNames) {
		
		var StringBuilder code = new StringBuilder()

		code.append("params_2d = new ArrayList<List<Node>>();\n")
		for (var int i = 0; i < inputSet.size; i++) {
			code.append("params = new ArrayList<Node>();\n")
			for (var int j = 0; j < inputSet.get(i).size; j++) {
				code.append(dvgNames.get(j)+" s_"+j.toString()+" = new "+dvgNames.get(j)+"();\n")
				var String instName = "s_"+j.toString()
				var String magrName = "MAGR_ALLOCATION_"+dvgNames.get(j)
				code.append(instName+".init();\n")
				if (this.variabilityInformationList.get(j).numberAllocations > 1) {
					code.append("List<Node> tmp = new ArrayList<Node>();\n")
					code.append("for (int i = 0; i < "+instName+".getAllocations(); i++) {\n")
						code.append("tmp.add("+instName+".solve(\""+inputSet.get(i).get(j).name+"\",i));\n")
					code.append("}\n")
				code.append("params.add(AllocationAggr(tmp, \""+magrName+"\"));\n")
				}
				else {
					code.append("params.add("+instName+".solve(\""+inputSet.get(i).get(j).name+"\",0));\n")
				}
			}
			code.append("params_2d.add(params);\n")
		}
		code.append("resolve_"+name+"(params_2d);\n")
	
		return code.toString
	}
	
	def start(DVG dvg, List<VariabilityInformation> variabilityInformationList) {
		
		var EObject tmp = dvg.pattern.get(0)
		
		if (tmp instanceof MAGR) {
			this.dvgName = dvg.name
			this.magrName = tmp.name
			this.outputName = dvg.outputName
			this.variabilityInformationList = variabilityInformationList
			this.finalOperationIsMax = Helpers.GetFinalOperationIsMax(dvg.finalOperation)
			determineMAGRCallInformation(tmp)
			determineVariabilityInformation()
			this.code += generate(tmp)			
		}
		else {
			System.err.println("ERROR: DVG of EQUF model of model does not contain MAGR as the only pattern!")
		}
	}
	
	def determineMAGRCallInformation(MAGR magr) {
		// We expect a corresponding DVG with a MAGR that must receive its inputs from the return of the solve method of each class
		// we use the link to the output ports as the name for return in solve
		this.inputSetAg = new ArrayList<List<BbDvgTcl.DVGPort>>()
		this.dvgNames = new ArrayList<String>()
		this.numberInputs = 0

		for (i : magr.aggr) {
			var List<BbDvgTcl.DVGPort> tmp2 = new ArrayList<BbDvgTcl.DVGPort>()
			numberInputs = i.ip.size
			for (j : i.ip) {
				tmp2.add(j.outputport)
				var EObject dvg2 = Helpers.getPattern(j.outputport) 
				dvg2 = dvg2.eContainer
				if (dvg2 instanceof DVG) {
					dvgNames.add(dvg2.name)
				}
			}
			inputSetAg.add(tmp2)
		}
	}	
	
	def determineVariabilityInformation() {
		this.ACTIVE = new HashMap<String,Integer>()
		this.PASSIVE = new HashMap<String,Integer>()
		
		// TODO: Should we add all ACTIVEs and PASSIVEs from the different building blocks of the EQUF?
		
		// We add the allocations of a building block if there are more than one
		for (var int i = 0; i < this.variabilityInformationList.size(); i++) {
			if (this.variabilityInformationList.get(i).numberAllocations > 1) {
				this.ACTIVE.put("MAGR_ALLOCATION_"+dvgNames.get(i), this.variabilityInformationList.get(i).numberAllocations)
			}
		}
		
		// We add the EQUF itself
		this.ACTIVE.put(magrName, numberInputs)
	}	
	
	// determineMAGRCallInformation(MAGR magr) must be called before that method
	// determineVariabilityInformation() must be called before that method
	def generate(MAGR magr) {	
		'''
		class «this.dvgName» {
			Node getNode(String name) {
				return NODE_COLLECTION.get(name);
			}
			private Map<String, Node> NODE_COLLECTION;
			
			«generateMAGR(magr)»
			
			«JavaFunctions.generateGenericAllocationAggr»
			
			void init() {
				this.NODE_COLLECTION = new HashMap<String, Node>();
			}
			«FinalEvaluation.generateSolveCode(this.outputName, this.finalOperationIsMax, generateCallSequenceCode(magr.name, this.inputSetAg, this.dvgNames), this.ACTIVE, this.PASSIVE)»
		}
		'''
	}
	
	def String generateMAGR(MAGR magr) {
		var String code = ""
		var MAGRPattern magrp = new MAGRPattern(magr)
		magrp.generate()
		code += magrp.code
		return code
	}
}




