package org.xtext.bb.generator 
import BbDvgTcl.TRAN
import BbDvgTcl.NormalizationCOp
import BbDvgTcl.LinearNormalization
import BbDvgTcl.Direction

class TRANPattern {
	
	TRAN tran
	
	String code
	
	new (TRAN tran) {
		this.tran = tran
	}
	
	def generate () {
		this.code = ""
		code += generatePatternResolution()
	}
	
	def private generatePatternResolution () {
		'''
		void resolve_«this.tran.name»(List<Node> I) {
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
			Object newValue = 0.0;
			List<Double> s = new ArrayList<Double>();
			
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsptmp = I.get(0).vsp();
			
			for (int i = 0; i < vsptmp.size(); i++) {
				s.add(((Number)vsptmp.get(i).getValue()).doubleValue());
			}
			
			for (int i = 0; i < vsptmp.size(); i++) {
				List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();
				List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();
				headerRow.add(new SimpleEntry<String,Integer>(I.get(0).name(),i));
				if (vsptmp.get(i).getKey() != null) {
					List<List<SimpleEntry<String,Integer>>> htmp = vsptmp.get(i).getKey();
					for (List<SimpleEntry<String,Integer>> row : htmp) {
						for (SimpleEntry<String,Integer> entry : row) {
							headerRow.add(entry);
						}
					}
				}
				header.add(headerRow);
				
				«generateValueFunction»

				ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));	
			}
			
			this.NODE_COLLECTION.put("«this.tran.op.name»", new NodeObject("«this.tran.op.name»", ovsp));
		}
		'''
	}
	
	private def generateValueFunction () {
		'''
		«var NormalizationCOp nf = this.tran.no»
		«IF nf instanceof LinearNormalization»
			«IF nf.min === null && nf.max === null»
				double num = Collections.max(s)-((Number)vsptmp.get(i).getValue()).doubleValue();
				double den = Collections.max(s)-Collections.min(s);
			«ELSEIF nf.min !== null && nf.max === null»
				double num = Collections.max(s)-((Number)vsptmp.get(i).getValue()).doubleValue();
				double den = Collections.max(s)-«nf.min.value.toString»;
			«ELSEIF nf.min === null && nf.max !== null»
				double num = «nf.max.value.toString»-((Number)vsptmp.get(i).getValue()).doubleValue();
				double den = «nf.max.value.toString»-Collections.min(s);
			«ELSE»
				double num = «nf.max.value.toString»-((Number)vsptmp.get(i).getValue()).doubleValue();
				double den = «nf.max.value.toString»-«nf.min.value.toString»;
			«ENDIF»
			
			«IF nf.direction == Direction.DEC»
				newValue = num/den;
			«ELSE»
				newValue = 1-(num/den);
			«ENDIF»
		«ENDIF»
		'''
	}
	
	def String getCode () {
		return this.code
	}
}