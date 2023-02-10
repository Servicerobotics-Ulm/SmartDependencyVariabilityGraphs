package org.xtext.bb.generator 
import BbDvgTcl.COMF
import org.eclipse.emf.ecore.EObject
import BbDvgTcl.Equal

class COMFPattern {
	
	COMF comf
	
	String code
	
	new (COMF comf) {
		this.comf = comf
	}
	
	def generate () {
		this.code = ""
		code += generatePatternResolution()
	}
	
	def private generatePatternResolution () {
		
		var String wrapperName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(this.comf.ip.outputport.ve)).get(0)
		var String conversionName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(this.comf.ip.outputport.ve)).get(1)

		'''
		void resolve_«this.comf.name»(List<Node> I) {
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
					«generateValueFunction»
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
			this.NODE_COLLECTION.put("«this.comf.op.name»", new NodeObject("«this.comf.op.name»", ovsp));
		}
		'''
	}
	
	private def generateValueFunction () {
		var String wrapperName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(this.comf.ip.outputport.ve)).get(0)
		var String comparisonString = Helpers.getComparisonString(this.comf.co)
		'''
		«var EObject tmp = this.comf.co»
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
	
	def String getCode () {
		return this.code
	}
}