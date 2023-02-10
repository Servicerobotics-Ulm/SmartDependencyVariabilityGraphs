package org.xtext.bb.generator 
import BbDvgTcl.PTCC
import BbDvgTcl.LinearNormalization
import BbDvgTcl.Direction
import BbDvgTcl.NormalizationCOp
import java.util.List
import java.util.ArrayList

class PTCCPattern {
	
	final String PARETO_PREFIX = "resolve_ptcc_pf_"
	final String TRAN_PREFIX = "resolve_ptcc_tran_"
	String paretoName
	List<String> tranNames
	
	PTCC ptcc
	
	String code
	
	new (PTCC ptcc) {
		this.ptcc = ptcc
		
		this.paretoName = PARETO_PREFIX+this.ptcc.name
		
		this.tranNames = new ArrayList<String>();
		for (var int i = 0; i < this.ptcc.no.size(); i++) {
			this.tranNames.add(TRAN_PREFIX+this.ptcc.ip.get(i).name);
		}
	}

	def generate () {
		this.code = ""
		code += generateParetoFilterResolution()
		code += "\n"
		for (var int i = 0; i < this.ptcc.no.size(); i++) {
			code += generateTransformation(this.tranNames.get(i), this.ptcc.no.get(i))
		}
		code += "\n"
		code += generatePatternResolution()
	}
	
	def private generateParetoFilterResolution () {
		'''
		List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> «this.ptcc.name» (List<Node> I) {
			if (check) {
				List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();
				for (int i = 0; i < I.size(); i++) {
					if (I.get(i).header(0) != null) {
						headerList.add(I.get(i).header(0));
					}
				}
				if (headerList.size() > 0 && !isSAM(headerList)) {
					System.err.println("ERROR: There is no SAM-Situation for PTCC pattern «this.ptcc.name»!");
				}
			}
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcomb = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>>();
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcombpf = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>>();
			double newValue = 0.0;
			List<List<Integer>> ir = new ArrayList<List<Integer>>();
			for (Node i : I) {
				List<Integer> tmp = new ArrayList<Integer>();
				for (int j = 0; j < i.vsp().size(); j++) {
					tmp.add(j);
				}
				r.add(tmp);
			}
			List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());
			for (int i = 0; i < cp.size(); i++) {
				List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> T = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
				newValue = 0.0;
				List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();
				for (int j = 0; j < cp.get(i).size(); j++) {
					«JavaFunctions.generateHeaderRow»
					T.add(I.get(j).slot(cp.get(i).get(j)));
				}
				if (isValidCombination(header)) {
					vcomb.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>(header,T));
				}
			}

			List<Boolean> max = new ArrayList<Boolean>();
			
			«FOR i : 0..this.ptcc.max.size-1»
				max.add(«this.ptcc.max.get(i)»);
			«ENDFOR»

			List<Boolean> isDominated = new ArrayList<Boolean>();
			for (int i = 0; i < vcomb.size(); i++) {
				isDominated.add(false);
			}
			
			for (int i = 0; i < vcomb.size(); i++) {
				for (int j = 0; j < vcomb.size(); j++) {
					if (i != j && !isDominated.get(i)) {
						List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> tmp_1 = new ArrayList<>(vcomb.get(i).getValue());
						tmp_1.remove(tmp_1.size()-1);
						List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> tmp_2 = new ArrayList<>(vcomb.get(j).getValue());
						tmp_2.remove(tmp_2.size()-1);
						if (isDominated(tmp_1,tmp_2,max)) {
							isDominated.set(i,true);
						}
					}
				}
			}
			for (int i = 0; i < isDominated.size(); i++) {
				if (!isDominated.get(i)) {
					vcombpf.add(vcomb.get(i));
				}
			}
			return vcombpf;
		}
		'''
	}
	
	def private generateTransformation(String name, NormalizationCOp nf) {
		'''
		List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> «name» (List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> I) {
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
			Object newValue = 0.0;
			List<Double> s = new ArrayList<Double>();
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsptmp = I;
			
			for (int i = 0; i < vsptmp.size(); i++) {
				s.add(((Number)vsptmp.get(i).getValue()).doubleValue());
			}

			for (int i = 0; i < vsptmp.size(); i++) {
				«generateValueFunction(nf)»
				ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(null, newValue));
			}
			
			return ovsp;
		}
		'''
	}
	
	private def generateValueFunction (NormalizationCOp nf) {
		'''
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
	
	def private generatePatternResolution () {
		'''
		void resolve_«this.ptcc.name»(List<Node> I) {
			
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
			double newValue = 0.0;
			
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcombpf = «this.paretoName»(I);
			List<List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>> R = new ArrayList<List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>();
			
«««			TODO: Do not transform if there is only one solution on the pareto front
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> S;
			«FOR i : 0..this.ptcc.no.size-1» «/*p.transformationoperator = I.size-1 = vcombpf.get(0).size-1: We do not iterate over the last element which we assume is ps*/»
				S = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();
				for (int j = 0; j < vcombpf.size(); j++) {
					S.add(vcombpf.get(j).getValue().get(«i»));
				}
				«/*We assume that the i-th nf is associated with the i-th Input Node!*/»
				R.add(«this.tranNames.get(i)»(S));
			«ENDFOR»
			Map<String,Double> valueList = new HashMap<String,Double>();
			Map<String, Double> psm = new HashMap<String, Double>();
			for (int i = 0; i < vcombpf.size(); i++) {
				newValue = 0.0;
				for (int j = 0; j < R.size(); j++) {
					valueList.put(I.get(j).name(),((Number)R.get(j).get(i).getValue()).doubleValue());
				}
				int key = vcombpf.get(i).getKey().get(I.size()-1).get(0).getValue();
				List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> psVsp = I.get(I.size()-1).vsp();
				psm = psVsp.get(key).getValue();
				for (Map.Entry<String, Double> entry : psm.entrySet()) {
					newValue += psm.get(entry.getKey()) * valueList.get(entry.getKey());
				}
				ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>(vcombpf.get(i).getKey(),newValue));
			}
			this.NODE_COLLECTION.put("«this.ptcc.op.name»", new NodeObject("«this.ptcc.op.name»", ovsp));
		}
		'''
	}
	
	def String getCode () {
		return this.code
	}
}