package org.xtext.bb.generator 
import java.util.List
import BbDvgTcl.SAPRO

class SAPROPattern {
	
	SAPRO sapro
	List<BbDvgTcl.AbstractInputPort> inputSet
	MinMaxCode mmc
	
	String code
	
	new (SAPRO sapro, List<BbDvgTcl.AbstractInputPort> inputSet) {
		this.sapro = sapro
		this.inputSet = inputSet
	}
	
	def generate () {
		this.code = ""
		if (this.sapro.ca !== null) {
			code += generatePatternResolutionCombinationAssignment()
		}
		else {
			this.mmc = new MinMaxCode(inputSet, sapro.expr.expr)
			this.mmc.generateCode()			
			code += generatePatternResolution()
			code += generateValueFunction()		
		}
	}
	
	def private generatePatternResolution () {
		'''
		void resolve_«this.sapro.name»(List<Node> I) {
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
			Object newValue;
			
			«this.mmc.minMaxCodeForPatternResolution»
			
			List<List<Integer>> ir = new ArrayList<List<Integer>>();
			for (Node i : I) {
				List<Integer> tmp = new ArrayList<Integer>();
				for (int j = 0; j < i.vsp().size(); j++) {
					tmp.add(j);
				}
				ir.add(tmp);
			}	
			List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());
			for (int i = 0; i < cp.size(); i++) {
				List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();
				for (int j = 0; j < cp.get(i).size(); j++) {
					«JavaFunctions.generateHeaderRow()»
				}
				if (isValidCombination(header)) {
					List<Object> valueList = new ArrayList<Object>();
					for (int j = 0; j < I.size(); j++) {
						valueList.add(I.get(j).vsp(cp.get(i).get(j)));
					}
					
					newValue = «generateValueFunctionCall(this.sapro.name)»
					
					ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));
				}
			}
			«IF this.sapro.op !== null»
				this.NODE_COLLECTION.put("«this.sapro.op.name»", new NodeObject("«this.sapro.op.name»", ovsp));
			«ELSEIF this.sapro.ocp !== null»
				this.NODE_COLLECTION.put("«this.sapro.ocp.name»", new NodeObject("«this.sapro.ocp.name»", ovsp));
			«ENDIF»
		}
		'''
	}
	
	def private generatePatternResolutionCombinationAssignment () {
		'''
		void resolve_«this.sapro.name»(List<Node> I) {
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
			Object newValue;
		
			List<List<SimpleEntry<String,Integer>>> header;
			List<SimpleEntry<String,Integer>> headerRow;
			List<List<SimpleEntry<String,Integer>>> htmp;
			«FOR i : this.sapro.ca.combination»
				header = new ArrayList<List<SimpleEntry<String,Integer>>>();
				«FOR j : 0..i.element.size-1»
					«JavaFunctions.generateHeaderRow(j, i.element.get(j).index)»
				«ENDFOR»
				ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header,«i.value.value»));
			«ENDFOR»
			«IF this.sapro.op !== null»
				this.NODE_COLLECTION.put("«this.sapro.op.name»", new NodeObject("«this.sapro.op.name»", ovsp));
			«ELSEIF this.sapro.ocp !== null»
				this.NODE_COLLECTION.put("«this.sapro.ocp.name»", new NodeObject("«this.sapro.ocp.name»", ovsp));
			«ENDIF»
		}
		'''
	}	
	
	private def generateValueFunction () {
		'''
		Object operator_«this.sapro.name»(List<Object> valueList
		«this.mmc.minMaxCodeForValueFunctionDefinition»
		) {
			«Helpers.generateExpressionCode(this.sapro.name, this.sapro.expr.expr, this.inputSet)»
		}
		'''
	}
	
	private def generateValueFunctionCall (String name) {
		'''
		operator_«name»(valueList
		«this.mmc.minMaxCodeForValueFunctionCall»
		);
		'''
	}
	
	def String getCode () {
		return this.code
	}
}