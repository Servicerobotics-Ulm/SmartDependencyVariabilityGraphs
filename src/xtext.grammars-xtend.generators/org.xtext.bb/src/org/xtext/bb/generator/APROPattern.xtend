package org.xtext.bb.generator 
import java.util.List
import BbDvgTcl.APRO
import BbDvgTcl.Description
import BbDvgTcl.InternalCOMF
import BbDvgTcl.Core
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import BbDvgTcl.InternalOutputPort
import BbDvgTcl.Equal
import BbDvgTcl.InputCPort
import BbDvgTcl.InitCPort

class APROPattern {
	
	APRO apro
	List<BbDvgTcl.AbstractInputPort> inputSet
	MinMaxCode mmc
	
	String code
	
	final String PRECOND_PREFIX = "resolve_apro_precond_"
	final String CORE_PREFIX = "resolve_apro_core_"
	
	List<List<String>> precondNames
	List<String> coreNames
	
	var String codeHelp = ""
	var String operatorDefCodeHelp = ""
	var String operatorCallCodeHelp = ""
	
	var boolean multiRobot
	// multiRobot = true means that the pattern has to calculate its output for several dynamically linked robot data
	// TODO: Preconditions are currently not considered when multiRobot = true 
	
	new (APRO apro, List<BbDvgTcl.AbstractInputPort> inputSet, boolean multiRobot) {
		this.apro = apro
		this.inputSet = inputSet
		this.multiRobot = multiRobot
		this.precondNames = new ArrayList<List<String>>();
		this.coreNames = new ArrayList<String>();
		for (var int i = 0; i < this.apro.description.size(); i++) {
			var List<String> names = new ArrayList<String>();
			if (this.apro.description.get(i).precond !== null) {
				for (var int j = 0; j < this.apro.description.get(i).precond.internalcomf.size(); j++) {
					names.add(PRECOND_PREFIX+this.apro.name+"_"+i+"_"+j);
				}
				this.precondNames.add(names);
			}
			this.coreNames.add(CORE_PREFIX+this.apro.name+"_"+i)
		}		
	}
	
	def generate () {
		this.code = ""

		var String callCode = ""
		
		for (var int i = 0; i < this.apro.description.size; i++) {
			code += generateDescriptionResolution(this.apro.description.get(i), i, this.inputSet)
			code += "\n"
			callCode += generateDescriptionCall(this.apro.description.get(i), i)
			callCode += "\n"
		}
		
		code += generatePatternResolution(callCode)
	}
	
	def private generateDescriptionCall(Description d, int index) {
		'''
		«IF d.precond !== null»
			«FOR i : 0..d.precond.internalcomf.size-1»
				«var EObject tmp = d.precond.internalcomf.get(i).iip.internalportref»
				«var InputCPort tmpc = d.precond.internalcomf.get(i).icp»
				«var EObject tmpco = tmpc.outputcport»
				«IF tmpco instanceof InitCPort»
					«Leafs.generateLeaf(tmpco)»	
				«ENDIF»
				«IF tmp instanceof BbDvgTcl.InputPort»
					params = new ArrayList<Node>();
					params.add(this.NODE_COLLECTION.get("«tmp.outputport.name»"));
					params.add(this.NODE_COLLECTION.get("«tmpc.outputcport.name»"));
					«this.precondNames.get(index).get(i)»(params);
				«ENDIF»
			«ENDFOR»
		«ENDIF»
		
		params = new ArrayList<Node>();
		«FOR i : d.core.iip»
			«var EObject tmp = i.internalportref»
			«IF tmp instanceof BbDvgTcl.InputPort»
				params.add(this.NODE_COLLECTION.get("«tmp.outputport.name»"));
			«ELSEIF tmp instanceof InternalOutputPort»
				params.add(this.NODE_COLLECTION.get("«tmp.name»"));
			«ENDIF»
		«ENDFOR»
		
«««		TODO: The following should be improved: At the moment it is not possible to consider preconditions when multiRobot is true!
		«IF this.multiRobot»
			«this.coreNames.get(index)»(IObsolete);
		«ELSE»
			«this.coreNames.get(index)»(params);
		«ENDIF»
		'''
	}
	
	def private generatePatternResolution (String descriptionCalls) { // This is the final MAGR
		'''
		void resolve_«this.apro.name»(List<Node> IObsolete) {
			NodeObject nodeObject;
			List<Object> leafValues;
			List<Node> params;
			
			«descriptionCalls»
			
			«IF this.apro.description.size > 1»
				List<Node> I = new ArrayList<Node>();
				«FOR i : 0..this.apro.description.size-1»
					I.add(this.NODE_COLLECTION.get("«this.apro.description.get(i).core.iop.name»"));
				«ENDFOR»
				List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
				Object newValue;
				List<List<Integer>> ir = new ArrayList<List<Integer>>();
				for (int i = 0; i < I.size(); i++) {
					for (int j = 0; j < I.get(i).vsp().size(); j++) {
						List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();
						List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();
						headerRow.add(new SimpleEntry<String, Integer>(I.get(i).name(), j));
						if (I.get(i).header(j) != null) {
							List<List<SimpleEntry<String,Integer>>> htmp = I.get(i).header(j);
							for (List<SimpleEntry<String,Integer>> row : htmp) {
								for (SimpleEntry<String,Integer> entry : row) {
									headerRow.add(entry);
								}
							}
						}
						header.add(headerRow);
						newValue = I.get(i).vsp(j);
						ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));
						«IF this.apro.op !== null»
							this.NODE_COLLECTION.put("«this.apro.op.name»", new NodeObject("«this.apro.op.name»", ovsp));
						«ELSE»
							this.NODE_COLLECTION.put("«this.apro.ocp.name»", new NodeObject("«this.apro.ocp.name»", ovsp));
						«ENDIF»
					}				
				}
			«ELSE»
				«IF this.apro.op !== null»
					this.NODE_COLLECTION.put("«this.apro.op.name»", new NodeObject("«this.apro.op.name»", this.NODE_COLLECTION.get("«this.apro.description.get(0).core.iop.name»").vsp()));
				«ELSE»
					this.NODE_COLLECTION.put("«this.apro.ocp.name»", new NodeObject("«this.apro.ocp.name»", this.NODE_COLLECTION.get("«this.apro.description.get(0).core.iop.name»").vsp()));
				«ENDIF»
			«ENDIF»
		}
		'''
	}
	
	private def String generateDescriptionResolution (Description d, int index, List<BbDvgTcl.AbstractInputPort> inputSet) {
		
		var String code = ""
		
		if (d.precond !== null) {
			for (var int i = 0; i < d.precond.internalcomf.size; i++) {
				code += generatePreconditionResolution(d.precond.internalcomf.get(i), this.precondNames.get(index).get(i));
				code += "\n"
			}	
		}
		
		this.codeHelp = ""
		this.operatorDefCodeHelp = ""
		this.operatorCallCodeHelp = ""
		
		if (d.core.expr !== null) {
			code += generateCoreResolutionWithExpr(d.core, this.coreNames.get(index), inputSet);
		}
		else if (d.core.ca !== null) {
			code += generateCoreResolutionWithCA(d.core, this.coreNames.get(index), inputSet);
		}
		
		return code
	}
	
	private def generatePreconditionResolution (InternalCOMF ic, String name) {
		
		var String wrapperName = ""
		var String conversionName = ""
		
		var EObject tmp = ic.iip.internalportref

		if (tmp instanceof BbDvgTcl.InputPort) {
			wrapperName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(tmp.outputport.ve)).get(0)
			conversionName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(tmp.outputport.ve)).get(1)
		}
		else if (tmp instanceof InternalOutputPort) {
			wrapperName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(tmp.ve)).get(0)
			conversionName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(tmp.ve)).get(1)
		}
		
		'''
		void «name» (List<Node> I) {
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
			Object newValue = 0.0;
			
			List<«wrapperName»> toCheck = new ArrayList<«wrapperName»>();
			List<«wrapperName»> filter = new ArrayList<«wrapperName»>();

			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> toCheckVsp = I.get(0).vsp();
			
			for (int i = 0; i < toCheckVsp.size(); i++) {
				toCheck.add(((«wrapperName»)toCheckVsp.get(i).getValue()).«conversionName»());
			}
			
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> filterVsp = I.get(1).vsp();
			List<List<SimpleEntry<String,Integer>>> htmp;
			
			for (int i = 0; i < filterVsp.size(); i++) {
				filter.add(((«wrapperName»)filterVsp.get(i).getValue()).«conversionName»());
			}
			
			for (int i = 0; i < toCheckVsp.size(); i++) {
				for (int j = 0; j < filterVsp.size(); j++) {
					«generateCOMFValueFunction (ic, wrapperName, Helpers.getComparisonString(ic.co))»
					{
						List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();
						List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();
						headerRow.add(new SimpleEntry<String,Integer>(I.get(0).name(),i));
						if (toCheckVsp.get(i).getKey() != null) {
							htmp = toCheckVsp.get(i).getKey();
							for (List<SimpleEntry<String,Integer>> row : htmp) {
								for (SimpleEntry<String,Integer> entry : row) {
									headerRow.add(entry);
								}
							}
						}
						header.add(headerRow);
						headerRow = new ArrayList<SimpleEntry<String,Integer>>();
						headerRow.add(new SimpleEntry<String,Integer>(I.get(1).name(),j));
						if (filterVsp.get(j).getKey() != null) {
							htmp = filterVsp.get(j).getKey();
							for (List<SimpleEntry<String,Integer>> row : htmp) {
								for (SimpleEntry<String,Integer> entry : row) {
									headerRow.add(entry);
								}
							}
						}
						header.add(headerRow);
						newValue = newValue = toCheck.get(i);
						ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));
					}
				}
			}
			
			this.NODE_COLLECTION.put("«ic.iop.name»", new NodeObject("«ic.iop.name»", ovsp));
		} 
		'''
	}
	
	private def generateCOMFValueFunction (InternalCOMF ic, String wrapperName, String comparisonString) {
		'''
		«var EObject tmp = ic.co»
		«IF tmp instanceof Equal»
			«IF tmp.accuracy === null»
				if (toCheck.get(i) «comparisonString» filter.get(j))
			«ELSE»
				if (Math.abs(toCheck.get(i)-filter.get(j)) «comparisonString»)
				«IF (wrapperName == "Boolean" || wrapperName == "String" || wrapperName == "Integer")»
					«System.err.println("WARNING: Accuracy for Boolean, String and Integer is ignored!")»
				«ENDIF»								
			«ENDIF»
		«ELSE»
«««			LessThan or GreaterThan
			if (toCheck.get(i) «comparisonString» filter.get(j))
			«IF (wrapperName == "Boolean" || wrapperName == "String")»
				«System.err.println("ERROR: LessThan and GreaterThan undefined for Boolean and String!")»
			«ENDIF»
		«ENDIF»
		'''
	}	
	
	private def generateHelper(List<Integer> cdoi, List<String> cdos, Core c) {
		
		var List<String> alreadyGenerated = new ArrayList<String>()
		var List<String> tmp = Helpers.getSymbolsForComplexDo(c.expr.expr)
	
		for (i : tmp) {
			if (!alreadyGenerated.contains(i)) {
				var int index = Helpers.getTh(i, inputSet)
				cdoi.add(index)
				cdos.add(i)
				this.codeHelp += "List<Object> " + i + ";\n"
				this.operatorDefCodeHelp += ",List<Object>"+i
				this.operatorCallCodeHelp += ","+i
				alreadyGenerated.add(i)
			}
		}
	}
	
	private def String generateHelper2(List<Integer> cdoi, List<String> cdos, int i) {
		var String code
		code = cdos.get(0) + " = I.get("+i+").vsp_2(cp.get(i).get("+i+"));";
		cdoi.remove(0)
		cdos.remove(0)
		return code
	}
	
	private def generateCoreResolutionWithExpr (Core c, String name, List<BbDvgTcl.AbstractInputPort> inputSet) {
		
		var List<Integer> cdoi = new ArrayList<Integer>()
		var List<String> cdos = new ArrayList<String>()
		
		generateHelper(cdoi, cdos, c)
		
		'''
		void «name» (List<Node> I) {
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
			Object newValue;
			
			«this.codeHelp»
		
			List<List<Integer>> ir = new ArrayList<List<Integer>>();
			for (Node i : I) {
				List<Integer> tmp = new ArrayList<Integer>();
				if (i instanceof NodeObjectList) {
					for (int j = 0; j < i.vsp_2().size(); j++) {
						tmp.add(j);
					}
				}
				else if (i instanceof NodeObject) {
					for (int j = 0; j < i.vsp().size(); j++) {
						tmp.add(j);
					}
				}
		
				ir.add(tmp);
			}

			List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());
			for (int i = 0; i < cp.size(); i++) {
				List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();
				for (int j = 0; j < cp.get(i).size(); j++) {
					«JavaFunctions.generateHeaderRow»
				}
				List<Object> valueList = new ArrayList<Object>();
				
				«FOR i : 0..inputSet.size-1»
«««					// TODO: Should be generalized
«««					// At the moment, we need to make sure that:
«««					// (i) the order of Primitive and Complex Input Nodes is not mixed,
«««					// (ii) first all Primitives then all Complex must come
«««					// (iii) order in expression is according to input order
«««					// Also consider that with respect to APRO Pattern the order of input nodes and internal input nodes should match 			
					«IF cdoi.size() > 0 && cdoi.get(0) == i»
						«/*The i-th Input is a ComplexDo under the assumption that the expression is correct*/»
						«generateHelper2(cdoi, cdos, i)»
					«ELSE»
						valueList.add(I.get(«i»).vsp(cp.get(i).get(«i»)));
					«ENDIF»
				«ENDFOR»

				if (isValidCombination(header)) {
					newValue = operator_«name»(valueList «this.operatorCallCodeHelp»);
					ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));
				}
			}

			this.NODE_COLLECTION.put("«c.iop.name»", new NodeObject("«c.iop.name»", ovsp));
		}
		
		Object operator_«name»(List<Object> valueList «this.operatorDefCodeHelp») {
			«Helpers.generateExpressionCode(name, c.expr.expr, inputSet)»
		}
		'''
	}
	
	private def generateCoreResolutionWithCA (Core c, String name, List<BbDvgTcl.AbstractInputPort> inputSet) {
		'''
		void «name» (List<Node> I) {
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
			Object newValue;
		
			List<List<SimpleEntry<String,Integer>>> header;
			List<SimpleEntry<String,Integer>> headerRow;
			List<List<SimpleEntry<String,Integer>>> htmp;
			«FOR i : c.ca.combination»
				header = new ArrayList<List<SimpleEntry<String,Integer>>>();
				«FOR j : 0..i.element.size-1»
					«JavaFunctions.generateHeaderRow(j, i.element.get(j).index)»
				«ENDFOR»
				ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header,«i.value.value»));
			«ENDFOR»
			
			this.NODE_COLLECTION.put("«c.iop.name»", new NodeObject("«c.iop.name»", ovsp));	
		}
		'''
	}
	
	def String getCode () {
		return this.code
	}
}