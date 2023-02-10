package org.xtext.bb.generator 
import BbDvgTcl.CONT
import org.eclipse.emf.ecore.EObject

class CONTPattern {
	
	CONT cont
	
	String code
	
	new (CONT cont) {
		this.cont = cont
	}
	
	def generate () {
		this.code = ""
		code += generatePatternResolution()
	}
	
	def private generatePatternResolution () {
		'''
		void resolve_«this.cont.name»(List<Node> I) {
			
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
					Map<String, Double> valueList = new HashMap<String, Double>();
					Map<String, Double> ps = new HashMap<String, Double>();
					for (int j = 0; j < I.size(); j++) {
						if (I.get(j) instanceof NodePs) {
							List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> res = I.get(j).vsp();
							ps = res.get(cp.get(i).get(j)).getValue();
						}
						else {
							List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> res = I.get(j).vsp();
							valueList.put(I.get(j).name(), ((Number) res.get(cp.get(i).get(j)).getValue()).doubleValue());
						}
					}
					for (Map.Entry<String, Double> entry : ps.entrySet()) {
						newValue += ps.get(entry.getKey()) * valueList.get(entry.getKey());
					}
					ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));
				}
			}	
			this.NODE_COLLECTION.put("«this.cont.op.name»", new NodeObject("«this.cont.op.name»", ovsp));
		}
		'''
	}
	
	def String getCode () {
		return this.code
	}
	
}