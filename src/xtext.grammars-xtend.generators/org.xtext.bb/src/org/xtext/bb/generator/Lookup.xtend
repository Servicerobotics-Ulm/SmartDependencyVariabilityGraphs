package org.xtext.bb.generator

import java.util.Map
import java.util.List
import java.util.AbstractMap.SimpleEntry

class Lookup {

// SHOULD WORK CORRECTLY IF THERE ARE NO PASSIVE NODE DEPENDENCIES FOR ALL MAGRs	
static def String generateLookupCode(Map<String, Integer> pl, List<SimpleEntry<String, Integer>> pll) {
		
		var StringBuilder lookupCode = new StringBuilder()
		lookupCode.append("\n\t\t")
		lookupCode.append("Map<String, Integer> lookupIndices = new HashMap<String, Integer>();")
		lookupCode.append("List<SimpleEntry<String, Integer>> passiveNodes = new ArrayList<>();")
		//lookupCode.append("Map<String, Integer> active = new HashMap<String, Integer>();")
		lookupCode.append("\n\t\t")
		
		if (pl.entrySet.size != pll.size) {
			System.out.println("THIS SHOULD NEVER HAPPEN !!!!!!!!!!!")
		}
		
		for (i : pl.entrySet) {
			lookupCode.append("lookupIndices.put(\""+i.key+"\","+i.value+");")
			lookupCode.append("\n\t\t")
		}
		
		for (i : pll) {
			lookupCode.append("passiveNodes.add(new SimpleEntry<>(\""+i.key+"\","+i.value+"));")
			lookupCode.append("\n\t\t")
		}
		
		/*for (i : this.ACTIVE.entrySet) {
			lookupCode.append("active.put(\""+i.key+"\","+i.value+");")
			lookupCode.append("\n\t\t")
		}*/
		
//			lookupCode.append("\n\t\t")
//			lookupCode.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> firstSlot = rtmp.get(0);")
//			lookupCode.append("\n\t\t")
//			lookupCode.append("List<String> names = new ArrayList<>();")
//			lookupCode.append("\n\t\t")
//			lookupCode.append("Map<String, Boolean> flag = new HashMap<String, Boolean>();")
//			lookupCode.append("\n\t\t")
//			lookupCode.append("List<List<SimpleEntry<String,Integer>>> header = firstSlot.getKey();")
//			lookupCode.append("\n\t\t")
//			lookupCode.append("for (List<SimpleEntry<String,Integer>> headerRow : header) {")
//				lookupCode.append("\n\t\t\t")
//				lookupCode.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
//					lookupCode.append("\n\t\t\t\t")
//					lookupCode.append("if (lookupIndices.containsKey(headerEntry.getKey()) && !flag.containsKey(headerEntry.getKey())) {")
//						lookupCode.append("\n\t\t\t\t\t")
//						lookupCode.append("names.add(headerEntry.getKey());")
//						lookupCode.append("flag.put(headerEntry.getKey(),true);")
//					lookupCode.append("\n\t\t\t\t")
//					lookupCode.append("}")
//				lookupCode.append("\n\t\t\t")
//				lookupCode.append("}")
//			lookupCode.append("\n\t\t")
//			lookupCode.append("}")
		
//			lookupCode.append("\n\t\t")
//			lookupCode.append("List<Integer> vspSizes = new ArrayList<Integer>();")
//			lookupCode.append("\n\t\t")
//			lookupCode.append("for (int la = 0; la < names.size(); la++) {")
//				lookupCode.append("\n\t\t\t")
//				lookupCode.append("if (lookupIndices.containsKey(names.get(la))) {")
//					lookupCode.append("\n\t\t\t\t")
//					lookupCode.append("vspSizes.add(lookupIndices.get(names.get(la)));")
//				lookupCode.append("\n\t\t\t")
//				lookupCode.append("}")
//				lookupCode.append("\n\t\t\t")
//				lookupCode.append("else {")
//					lookupCode.append("\n\t\t\t\t")
//					lookupCode.append("System.out.println(\"(Lookup-1) THIS SHOULD NEVER HAPPEN !!!!!!!!!!!\");");
//				lookupCode.append("\n\t\t\t")
//				lookupCode.append("}")
//			lookupCode.append("\n\t\t")
//			lookupCode.append("}")
//			lookupCode.append("\n\t\t")
		
//			lookupCode.append("\n\t\t")
//			for (var int i = 0; i < pl.entrySet.size; i++) {
//				lookupCode.append("List<")
//			}
//			lookupCode.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>")
//			for (var int i = 0; i < pl.entrySet.size; i++) {
//				lookupCode.append(">")
//			}
//			lookupCode.append(" lookupTable = new ArrayList<>();")
		
//			for (var int i = 0, var int j = pl.entrySet.size; i < pl.entrySet.size; i++, j--) {
//				
//				for (var int k = 0; k < j; k++) {
//					lookupCode.append("List<")
//				}
//				lookupCode.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>")
//				for (var int k = 0; k < j; k++) {
//					lookupCode.append(">")
//				}
//				lookupCode.append(" lut_"+i.toString+" = new ArrayList<>();")
//				lookupCode.append("\n\t\t")
//			}
		
//			for (var int i = 0; i < pl.entrySet.size; i++) {
//				var StringBuilder t = new StringBuilder()
//				for (var int j = 0; j < i; j++) {
//					t.append("\t")
//				}
//				
//				lookupCode.append("for (int i_"+i+" = 0; i_"+i+" < passiveNodes.get("+i+").getValue(); i_"+i+"++) {")
//					lookupCode.append("\n\t\t\t")
//					lookupCode.append(t)
//					if (i < pl.entrySet.size-1) {
//						lookupCode.append("lut_"+i+".add(lut_"+(i+1).toString+");")
//					}
//					else {
//						lookupCode.append("lut_"+i+".add(new SimpleEntry<>(null,0.0));")
//					} 
//					lookupCode.append("\n\t\t\t")
//					lookupCode.append(t) 
//			}
		
		lookupCode.append("List<SimpleEntry<String,Integer>> sortedIndexList = new ArrayList<SimpleEntry<String,Integer>>();")
		lookupCode.append("\n\t\t")
		lookupCode.append("List<List<SimpleEntry<String,Integer>>> firstheader = rtmp.get(0).getKey();")
		lookupCode.append("\n\t\t")
		lookupCode.append("List<String> alreadyChecked = new ArrayList<String>();")
		lookupCode.append("\n\t\t")
		
		lookupCode.append("for (List<SimpleEntry<String,Integer>> headerRow : firstheader) {")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("for (SimpleEntry<String,Integer> entry : passiveNodes) {")
					lookupCode.append("\n\t\t\t\t\t")
					lookupCode.append("if (entry.getKey() == headerEntry.getKey() && !alreadyChecked.contains(headerEntry.getKey())) {")
						lookupCode.append("\n\t\t\t\t\t\t")
						lookupCode.append("sortedIndexList.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), entry.getValue()));")
						lookupCode.append("\n\t\t\t\t\t\t")
						lookupCode.append("alreadyChecked.add(headerEntry.getKey());")
					lookupCode.append("\n\t\t\t\t\t")
					lookupCode.append("}")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("}")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("}")
		lookupCode.append("\n\t\t")	
		lookupCode.append("}")
		
		lookupCode.append("\n\t\t")
		lookupCode.append("if (sortedIndexList.size() != passiveNodes.size()) {")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("System.err.println(\"ERROR: sortedIndexList.size() != passiveNodes.size()\");")
		lookupCode.append("}")
		lookupCode.append("\n\t\t")
		
		lookupCode.append("int")
		for (var int i = 0; i < pll.size; i++) {
			lookupCode.append("[]")
		}
		lookupCode.append(" luti = new int")
		for (var int i = 0; i < pll.size; i++) {
			lookupCode.append("[sortedIndexList.get("+i+").getValue()]")
		}
		lookupCode.append(";")
		lookupCode.append("\n\t\t")
		lookupCode.append("Object")
		for (var int i = 0; i < pll.size; i++) {
			lookupCode.append("[]")
		}
		lookupCode.append(" luto = new Object")
		for (var int i = 0; i < pll.size; i++) {
			lookupCode.append("[sortedIndexList.get("+i+").getValue()]")
		}
		lookupCode.append(";")
		
		lookupCode.append("\n\t\t")
		
		lookupCode.append("for (int i_0 = 0; i_0 < luti.length; i_0++) {")
		for (var int i = 1; i < pll.size; i++) {
			var StringBuilder t = new StringBuilder()
			for (var int j = 0; j < i; j++) {
				t.append("\t")
			}
			var StringBuilder tmp = new StringBuilder()
			tmp.append("luti")
			for (var int j = 0; j < i; j++) {
				tmp.append("[i_"+j+"]")
			}
			tmp.append(".length")
			
			lookupCode.append("\n\t\t"+t)
			lookupCode.append("for (int i_"+i+" = 0; i_"+i+" < "+tmp+"; i_"+i+"++) {")
			
		}
		
		lookupCode.append("\n\t\t")
		for (var int i = 0; i < pll.size; i++) {
			lookupCode.append("\t")
		}
		
		lookupCode.append("luti")
		for (var int i = 0; i < pll.size; i++) {
			lookupCode.append("[i_"+i+"]")
		}
		lookupCode.append(" = -1;")
		lookupCode.append("\n\t\t")
		
		for (var int i = 0; i < pll.size; i++) {
			var StringBuilder t = new StringBuilder()
			for (var int j = pll.size; j > i; j--) {
				t.append("\t")
			}
			lookupCode.append("\n\t")
			lookupCode.append(t)
			lookupCode.append("}")
		}
		lookupCode.append("\n\t\t")
		
		lookupCode.append("for (int i_0 = 0; i_0 < luto.length; i_0++) {")
		for (var int i = 1; i < pll.size; i++) {
			var StringBuilder t = new StringBuilder()
			for (var int j = 0; j < i; j++) {
				t.append("\t")
			}
			var StringBuilder tmp = new StringBuilder()
			tmp.append("luto")
			for (var int j = 0; j < i; j++) {
				tmp.append("[i_"+j+"]")
			}
			tmp.append(".length")
			
			lookupCode.append("\n\t\t"+t)
			lookupCode.append("for (int i_"+i+" = 0; i_"+i+" < "+tmp+"; i_"+i+"++) {")
			
		}
		
		lookupCode.append("\n\t\t")
		for (var int i = 0; i < pll.size; i++) {
			lookupCode.append("\t")
		}
		
		lookupCode.append("luto")
		for (var int i = 0; i < pll.size; i++) {
			lookupCode.append("[i_"+i+"]")
		}
		lookupCode.append(" = 0.0;")
		lookupCode.append("\n\t\t")
		
		for (var int i = 0; i < pll.size; i++) {
			var StringBuilder t = new StringBuilder()
			for (var int j = pll.size; j > i; j--) {
				t.append("\t")
			}
			lookupCode.append("\n\t")
			lookupCode.append(t)
			lookupCode.append("}")
		}
		lookupCode.append("\n\t\t")
		
//			// tmp-1
//			lookupCode.append("\n\t\t")
//			for (var int i = 0; i < pl.entrySet.size-1; i++) {
//				lookupCode.append("List<")
//			}
//			lookupCode.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>")
//			for (var int i = 0; i < pl.entrySet.size-1; i++) {
//				lookupCode.append(">")
//			}
//			lookupCode.append(" lookupTable = new ArrayList<>();")
//			
//			// tmp-2
//			lookupCode.append("\n\t\t")
//			for (var int i = 0; i < pl.entrySet.size-2; i++) {
//				lookupCode.append("List<")
//			}
//			lookupCode.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>")
//			for (var int i = 0; i < pl.entrySet.size-2; i++) {
//				lookupCode.append(">")
//			}
//			lookupCode.append(" lookupTable = new ArrayList<>();")
//			
//			// tmp-3
//			lookupCode.append("\n\t\t")
//			for (var int i = 0; i < pl.entrySet.size-3; i++) {
//				lookupCode.append("List<")
//			}
//			lookupCode.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>")
//			for (var int i = 0; i < pl.entrySet.size-3; i++) {
//				lookupCode.append(">")
//			}
//			lookupCode.append(" lookupTable = new ArrayList<>();")
		
		lookupCode.append("List<SimpleEntry<String,Integer>> namesAndIndices = new ArrayList<>();")
		lookupCode.append("\n\t\t")
		lookupCode.append("cnt = 0;")
		lookupCode.append("\n\t\t")
		lookupCode.append("for (SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> i : rtmp) {")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("namesAndIndices = new ArrayList<SimpleEntry<String,Integer>>();")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("Map<String, Boolean> flag = new HashMap<String, Boolean>();")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("List<List<SimpleEntry<String,Integer>>> header = i.getKey();")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("for (List<SimpleEntry<String,Integer>> headerRow : header) {")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
					lookupCode.append("\n\t\t\t\t\t")
					lookupCode.append("if (lookupIndices.containsKey(headerEntry.getKey()) && !flag.containsKey(headerEntry.getKey())) {")
						lookupCode.append("\n\t\t\t\t\t\t")
						lookupCode.append("namesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
						lookupCode.append("\n\t\t\t\t\t\t")
						lookupCode.append("flag.put(headerEntry.getKey(),true);")
					lookupCode.append("\n\t\t\t\t\t")
					lookupCode.append("}")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("}")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("}")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("if (lookupIndices.entrySet().size() != namesAndIndices.size() && passiveNodes.size() != namesAndIndices.size()) {")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("System.out.println(\"(Lookup-2) THIS SHOULD NEVER HAPPEN !!!!!!!!!!!\");")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("}")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("else {")
				lookupCode.append("\n\t\t\t\t")
//					lookupCode.append("if (((Number)i.getValue()).doubleValue() >")
//						var StringBuilder nget = new StringBuilder()
//						for (var int i = 0; i < pl.entrySet.size(); i++) {
//							nget.append(".get(namesAndIndices.get("+i+").getValue())")
//						}
//						lookupCode.append("((Number)lut_0"+nget+".getValue()).doubleValue()) {")
//						lookupCode.append("\n\t\t\t\t")
//						nget = new StringBuilder()
//						for (var int i = 0; i < pl.entrySet.size(); i++) {
//							if (i < pl.entrySet.size()-1) {
//								nget.append(".get(namesAndIndices.get("+i+").getValue())")
//							}
//							else {
//								nget.append(".set(namesAndIndices.get("+i+").getValue(),i)")							
//							}
//						}
//						lookupCode.append("lut_0"+nget+";")
					lookupCode.append("if (((Number)i.getValue()).doubleValue() >")
					lookupCode.append("((Number)luto")
					for (var int i = 0; i < pll.size(); i++) {
						lookupCode.append("[namesAndIndices.get("+i+").getValue()]")
					}
					lookupCode.append(").doubleValue()) {")
					lookupCode.append("\n\t\t\t\t\t")
					lookupCode.append("luto")
					for (var int i = 0; i < pll.size(); i++) {
						lookupCode.append("[namesAndIndices.get("+i+").getValue()]")
					}
					lookupCode.append(" = ((Number)i.getValue()).doubleValue();")
					lookupCode.append("\n\t\t\t\t\t")
					lookupCode.append("luti")
					for (var int i = 0; i < pll.size(); i++) {
						lookupCode.append("[namesAndIndices.get("+i+").getValue()]")
					}
					lookupCode.append(" = cnt;")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("}")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("}")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("cnt++;")
		lookupCode.append("\n\t\t")
		lookupCode.append("}")
		
		
		lookupCode.append("Boolean as = true;")
		lookupCode.append("\n\t\t")
		lookupCode.append("for (int i_0 = 0; i_0 < luti.length; i_0++) {")
		for (var int i = 1; i < pll.size; i++) {
			var StringBuilder t = new StringBuilder()
			for (var int j = 0; j < i; j++) {
				t.append("\t")
			}
			var StringBuilder tmp = new StringBuilder()
			tmp.append("luti")
			for (var int j = 0; j < i; j++) {
				tmp.append("[i_"+j+"]")
			}
			tmp.append(".length")
			
			lookupCode.append("\n\t\t"+t)
			lookupCode.append("for (int i_"+i+" = 0; i_"+i+" < "+tmp+"; i_"+i+"++) {")
			
		}
		
		lookupCode.append("\n\t\t")
		for (var int i = 0; i < pll.size; i++) {
			lookupCode.append("\t")
		}
		
		lookupCode.append("if (luti")
		for (var int i = 0; i < pll.size; i++) {
			lookupCode.append("[i_"+i+"]")
		}
		lookupCode.append(" == -1) {")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("as = false;")
		lookupCode.append("\n\t\t")
		lookupCode.append("}")
		lookupCode.append("\n\t\t")
		
		for (var int i = 0; i < pll.size; i++) {
			var StringBuilder t = new StringBuilder()
			for (var int j = pll.size; j > i; j--) {
				t.append("\t")
			}
			lookupCode.append("\n\t")
			lookupCode.append(t)
			lookupCode.append("}")
		}
		lookupCode.append("\n\t\t")
		
		lookupCode.append("System.out.println(\"Always Satisfiable: \" + as);")
		
		
		
		lookupCode.append("\n\t\t")
		lookupCode.append("Scanner scanner = new Scanner(System.in);")
		lookupCode.append("\n\t\t")
		lookupCode.append("while(true) {")
			//var StringBuilder stb = new StringBuilder
			/*for (var int i = 0; i < pll.size; i++) {
				lookupCode.append("\n\t\t\t")
				lookupCode.append("System.out.print(\"Please enter an index for " + pll.get(i).key + " (0-"+(pll.get(i).value-1).toString+") : \");")
				lookupCode.append("\n\t\t\t")
				lookupCode.append("int i_"+i+" = scanner.nextInt();")
				stb.append("[i_"+i+"]")
			}*/
			lookupCode.append("\n\t\t\t")
			lookupCode.append("List<Integer> indexl = new ArrayList<Integer>();")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("for (int i = 0; i < "+pll.size+"; i++) {")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("System.out.print(\"Please enter an index for \"+ sortedIndexList.get(i).getKey() +\" (0-\"+new Integer(sortedIndexList.get(i).getValue()-1).toString()+\") : \");")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("int input = scanner.nextInt();")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("indexl.add(input);");
			lookupCode.append("\n\t\t\t")
			lookupCode.append("}")
			var StringBuilder stb = new StringBuilder
			for (var int i = 0; i < pll.size; i++) {
				stb.append("[indexl.get("+i+")]")
			}
			
			lookupCode.append("\n\t\t\t")
			lookupCode.append("if (luti"+stb+" == -1) {")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("System.out.println(\"No Solution!\");")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("}")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("else {")
				lookupCode.append("\n\t\t\t\t")
				lookupCode.append("System.out.println(\"Result: \" + rtmp.get(luti"+stb+"));")
				
				lookupCode.append("\n\t\t\t")
				
				lookupCode.append("List<SimpleEntry<String,Integer>> namesAndIndicesActive = new ArrayList<>();")
				lookupCode.append("\n\t\t\t")
				lookupCode.append("Map<String, Boolean> flag = new HashMap<String, Boolean>();")
				lookupCode.append("\n\t\t\t")
				lookupCode.append("List<List<SimpleEntry<String,Integer>>> header = rtmp.get(luti"+stb+").getKey();")
				lookupCode.append("\n\t\t\t")
				lookupCode.append("for (List<SimpleEntry<String,Integer>> headerRow : header) {")
					lookupCode.append("\n\t\t\t\t")
					lookupCode.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
						lookupCode.append("\n\t\t\t\t\t")
						lookupCode.append("if (active.containsKey(headerEntry.getKey()) && !flag.containsKey(headerEntry.getKey())) {")
							lookupCode.append("\n\t\t\t\t\t\t")
							lookupCode.append("namesAndIndicesActive.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
							lookupCode.append("\n\t\t\t\t\t\t")
							lookupCode.append("flag.put(headerEntry.getKey(),true);")
						lookupCode.append("\n\t\t\t\t\t")
						lookupCode.append("}")
					lookupCode.append("\n\t\t\t\t")
					lookupCode.append("}")
				lookupCode.append("\n\t\t\t")
				lookupCode.append("}")
				lookupCode.append("\n\t\t\t")
				lookupCode.append("System.out.println(\"*************************************************************************\");")
				lookupCode.append("\n\t\t\t")
				lookupCode.append("System.out.println(\"Result: \");")
				lookupCode.append("\n\t\t\t")
				lookupCode.append("for (int i = 0; i < namesAndIndicesActive.size(); i++) {")
					lookupCode.append("\n\t\t\t\t")
					lookupCode.append("System.out.println(namesAndIndicesActive.get(i).getKey() + \": \" + namesAndIndicesActive.get(i).getValue());")
				lookupCode.append("\n\t\t\t")
				lookupCode.append("}")
			lookupCode.append("\n\t\t\t")
			lookupCode.append("}")
		lookupCode.append("\n\t\t")
		lookupCode.append("}")
		
		return lookupCode.toString
		
	}
	
}