package org.xtext.bb.generator 
import BbDvgTcl.EPROD
import org.eclipse.emf.ecore.EObject

class EPRODPattern {
	
	EPROD eprod
	
	String code
	
	new (EPROD eprod) {
		this.eprod = eprod
	}
	
	def generate () {
		this.code = ""
		code += generatePatternResolution()
	}
	
	def private generatePatternResolution () {
		'''
		void resolve_«this.eprod.name»(List<Node> I) {
			
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
			double newValue = 0.0;
			
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
				newValue = 0.0;
				List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();
				for (int j = 0; j < cp.get(i).size(); j++) {
					«JavaFunctions.generateHeaderRow»
				}
					
				if (isValidCombination(header)) {
					List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> res = I.get(0).vsp();
					newValue = ((Number) res.get(cp.get(i).get(0)).getValue()).doubleValue();
					ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));
					
					
				}
			}	
			this.NODE_COLLECTION.put("«this.eprod.op.name»", new NodeObject("«this.eprod.op.name»", ovsp));
		}
		'''
	}
	
	def String getCode () {
		return this.code
	}
}