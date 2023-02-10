package org.xtext.bb.generator 
import java.util.List
import BbDvgTcl.RPRO

class RPROPattern {
	
	RPRO rpro
	List<BbDvgTcl.AbstractInputPort> inputSet
	boolean isPs
	MinMaxCode mmc
	
	String code
	
	new (RPRO rpro, List<BbDvgTcl.AbstractInputPort> inputSet, boolean isPs) {
		this.rpro = rpro
		this.inputSet = inputSet
		this.isPs = isPs
	}
	
	def generate () {
		this.mmc = new MinMaxCode(inputSet, rpro.expr.expr)
		this.mmc.generateCode()
		
		this.code = ""
		if (!this.isPs) {
			code += generatePatternResolution()
			code += generateValueFunction()	
		}
		else {
			code += generatePatternResolution2()
			code += generateValueFunction2()		
		}
	}
	
	def private generatePatternResolution () {
		'''
		void resolve_«this.rpro.name»(List<Node> I) {
			// new
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
					
					newValue = «generateValueFunctionCall(this.rpro.name)»
					
					ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));
				}
			}
			this.NODE_COLLECTION.put("«this.rpro.op.name»", new NodeObject("«this.rpro.op.name»", ovsp));
		}
		'''
	}
	
	def private generatePatternResolution2 () {
		'''
		void resolve_«this.rpro.name»(List<Node> I) {
			// new 2
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>>();
			Map<String,Double> newValue;
			
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
					
					newValue = «generateValueFunctionCall(this.rpro.name)»
					
					ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Map<String,Double>>(header, newValue));
				}
			}
			this.NODE_COLLECTION.put("«this.rpro.opp.name»", new NodePs("«this.rpro.opp.name»", ovsp));
		}
		'''
	}	
	
	private def generateValueFunction () {
		'''
		Object operator_«this.rpro.name»(List<Object> valueList
		«this.mmc.minMaxCodeForValueFunctionDefinition»
		) {
			«Helpers.generateExpressionCode(this.rpro.name, this.rpro.expr.expr, this.inputSet)»
		}
		'''
	}
	
	private def generateValueFunction2 () {
		'''
		Map<String,Double> operator_«this.rpro.name»(List<Object> valueList
		«this.mmc.minMaxCodeForValueFunctionDefinition»
		) {
			«Helpers.generateExpressionCodePs(this.rpro.name, this.rpro.expr.expr, this.inputSet)»
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