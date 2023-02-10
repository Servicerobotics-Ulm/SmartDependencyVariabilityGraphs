package org.xtext.bb.generator

import java.util.List
import java.util.AbstractMap.SimpleEntry
import java.util.Map

class JavaFunctions {
	
	static def generateGetCartesianProduct() {
		'''
		List<List<Integer>> getCartesianProduct(ArrayList<Integer> arg, int cnt, List<List<Integer>> input, List<List<Integer>> output) {
			for (int j = 0; j < input.get(cnt).size(); j++) {
				List<Integer> tmp = new ArrayList<Integer>();
		    	for (int i = 0; i < cnt; i++) {
		    		tmp.add(arg.get(i));
		   		 }
		 		arg.clear();
		 		arg.addAll(tmp);
		        arg.add(input.get(cnt).get(j));
		        if (cnt == input.size()-1) {
			        output.add(new ArrayList<Integer>());
			        output.get(output.size()-1).addAll(arg);
		        }
		        else {
		        	getCartesianProduct(arg, cnt+1, input, output);
		        }
		    }
			return output;
		}
        '''
	}
	
	static def generateIsSAM() {
		'''
		boolean isSAM(List<List<List<SimpleEntry<String,Integer>>>> headerList) {
			List<String> sln = new ArrayList<String>();
			for (List<List<SimpleEntry<String,Integer>>> i : headerList) {
					for (List<SimpleEntry<String,Integer>> j : i) {
						for (SimpleEntry<String,Integer> k : j) {
							if (!sln.contains(k.getKey())) {
								sln.add(k.getKey());
							}
							else {
								return true;
							}
						}
					}
			}
			return false;
		}
		'''
	}
	
	static def generateIsValidCombinationIgnoreResource() {
		'''
		boolean isValidCombination(List<List<SimpleEntry<String,Integer>>> header) {
			Map<String,Integer> M = new HashMap<String,Integer>();
			for (List<SimpleEntry<String,Integer>> row : header) {
				for (SimpleEntry<String,Integer> entry : row) {
					if (!M.containsKey(entry.getKey())) {
						M.put(entry.getKey(), entry.getValue());
					}
					else {
						if (entry.getValue() != M.get(entry.getKey()) && entry.getKey() != "UNIQUE_RESOURCE_ID") {
							return false;
						}
					}
				}
			}
			return true;
		}
		'''
	}
	
	static def generateIsValidCombinationConsiderResource() { 
		'''
		boolean isValidCombination(List<List<SimpleEntry<String,Integer>>> header) {
			List<List<Integer>> indicesLL = new ArrayList<List<Integer>>();
			for (List<SimpleEntry<String,Integer>> row : header) {
				List<Integer> indicesL = new ArrayList<Integer>();
				for (SimpleEntry<String,Integer> entry : row) {
					if (entry.getKey() == "UNIQUE_RESOURCE_ID") {
						if (!indicesL.contains(entry.getValue())) {
							indicesL.add(entry.getValue());
						}
					}
				}
				indicesLL.add(indicesL);
			}
			for (int i = 0; i < indicesLL.size(); i++) {
				for (int j = 0; j < indicesLL.size(); j++) {
					if (i != j) {
						for (int k = 0; k < indicesLL.get(i).size(); k++) {
							for (int l = 0; l < indicesLL.get(j).size(); l++) {
								if (indicesLL.get(i).get(k) == indicesLL.get(j).get(l)) {
									return false;
								}
							}
						}
					}
				}
			}
			return true;
		}
		'''
	}	
	
	def static generateHeaderRow() {
		'''
		List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();
		headerRow.add(new SimpleEntry<String,Integer>(I.get(j).name(),cp.get(i).get(j)));
		if (I.get(j).header(cp.get(i).get(j)) != null) {
			List<List<SimpleEntry<String,Integer>>> htmp = I.get(j).header(cp.get(i).get(j));
			for (List<SimpleEntry<String,Integer>> row : htmp) {
				for (SimpleEntry<String,Integer> entry : row) {
					headerRow.add(entry);
				}
			}
		}
		header.add(headerRow);
		'''
	}
	
	def static generateHeaderRow(int nodeIndex, int slotIndex) {
		'''
		headerRow = new ArrayList<SimpleEntry<String,Integer>>();
		headerRow.add(new SimpleEntry<String,Integer>(I.get(«nodeIndex»).name(),«slotIndex»));
		if (I.get(«nodeIndex»).header(«slotIndex») != null) {
			htmp = I.get(«nodeIndex»).header(«slotIndex»);
			for (List<SimpleEntry<String,Integer>> row : htmp) {
				for (SimpleEntry<String,Integer> entry : row) {
					headerRow.add(entry);
				}
			}
		}
		header.add(headerRow);
		'''
	}		
	
	static def generateIsDominated() {
		'''
		Boolean isDominated(List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> F, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> S, List<Boolean> Max) {
			for (int i = 0; i < F.size(); i++) {
				if (Max.get(i)) {
					if (((Number)F.get(i).getValue()).doubleValue() > ((Number)S.get(i).getValue()).doubleValue()) {
						return false;
					}
				}
				else {
					if (((Number)F.get(i).getValue()).doubleValue() < ((Number)S.get(i).getValue()).doubleValue()) {
						return false;
					}
				}
			}
			return true;
		}
		'''
	}
	
	static def generateMaxFunction() {
		'''
		double max(List<Object> list) {
			double max = Double.NEGATIVE_INFINITY;
			for (int i = 0; i < list.size(); i++) {
				if (((Number)list.get(i)).doubleValue() > max) {
					max = ((Number)list.get(i)).doubleValue();
				}
			}
			return max;
		}
		'''
	}
	
	static def generateMinFunction() {
		'''
		double min(List<Object> list) {
			double min = Double.POSITIVE_INFINITY;
			for (int i = 0; i < list.size(); i++) {
				if (((Number)list.get(i)).doubleValue() < min) {
					min = ((Number)list.get(i)).doubleValue();
				}
			}
			return min;
		}
		'''
	}
	
	static def generateCallSequenceCode(String name, List<BbDvgTcl.DVGPort> inputSet) {
		'''
		params = new ArrayList<Node>();
		«IF inputSet.size > 0»
			«FOR i : 0..inputSet.size-1»
				params.add(this.NODE_COLLECTION.get("«inputSet.get(i).name»"));
			«ENDFOR»
		«ENDIF»
		resolve_«name»(params);
		'''
	}
	
	static def generateCallSequenceCodeAg(String name, List<List<BbDvgTcl.DVGPort>> inputSet) {
		'''
		params_2d = new ArrayList<List<Node>>();
		«IF inputSet.size > 0»
			«FOR i : 0..inputSet.size-1»
				params = new ArrayList<Node>();
				«FOR j : 0..inputSet.get(i).size-1»
					params.add(this.NODE_COLLECTION.get("«inputSet.get(i).get(j).name»"));
				«ENDFOR»
				params_2d.add(params);
			«ENDFOR»
		«ENDIF»
		resolve_«name»(params_2d);
		'''
	}
	
	static def generateGetDataFromFile() {
		'''
		String[] getDataFromFile(String searchForName) {
			try {
				FileInputStream fstream = new FileInputStream("dataForSolver.txt");
				DataInputStream in = new DataInputStream(fstream);
		        BufferedReader br = new BufferedReader(new InputStreamReader(in));
				String strLine;
				while ((strLine = br.readLine()) != null) {
					String[] tokens = strLine.split(":");
					if (tokens[0].equalsIgnoreCase(searchForName)) {
		                String[] tokens2 = tokens[1].split(",");
		                return tokens2;
					}
				}
				in.close();
			}
			catch (Exception e){
				System.err.println("Error: " + e.getMessage());
			}
			return null;
		}
		'''
	}		
	
	static def String generateCallSequenceCode(String name, List<BbDvgTcl.DVGPort> inputSet, List<List<SimpleEntry<BbDvgTcl.AbstractOutputPort,String>>> allocInputSet, List<Boolean> isAlloc) {
		
		for (var int i = 0; i < allocInputSet.size(); i++) {
			for (var int j = 0; j < allocInputSet.get(i).size(); j++) {
				println(i+","+j+": "+allocInputSet.get(i).get(j))
			}
		}
		
		var StringBuilder code = new StringBuilder()
		
		if (allocInputSet.size() == 0) {
		
			code.append("\n\t\t")
			code.append("params = new ArrayList<Node>();")
			code.append("\n\t\t")
			for (var int i = 0; i < inputSet.size; i++) {
				code.append("params.add(this.NODE_COLLECTION.get(\""+inputSet.get(i).name+"\"));")
				code.append("\n\t\t")
			}
			code.append("resolve_"+name+"(params);")
			code.append("\n\t\t")
			code.append("\n\t\t")
		}
		else {
			
			// allocInputSet[0].size == allocInputSet[1].size == ... == ... allocInputSet[n].size should be the case
			for (var int l = 0; l < allocInputSet.get(0).size; l++) {
				
				code.append("if (allocation == "+l.toString()+") {")
				code.append("\n\t\t")
				
				var int inputSetCounter = 0;
				var int allocInputSetCounter = 0;
				
				code.append("\n\t\t")
				code.append("params = new ArrayList<Node>();")
				code.append("\n\t\t")
			
				for (i : isAlloc) {
					if (i) {
						code.append("params.add(this.NODE_COLLECTION.get(\""+allocInputSet.get(allocInputSetCounter).get(l).value+"\"));")
						code.append("\n\t\t")
						allocInputSetCounter++;			
					}
					else {
						code.append("params.add(this.NODE_COLLECTION.get(\""+inputSet.get(inputSetCounter).name+"\"));")
						code.append("\n\t\t")
						inputSetCounter++;					
					}
				}

				code.append("resolve_"+name+"(params);")
				code.append("\n\t\t")
				code.append("\n\t\t }")
				code.append("\n\t\t")	
			}
		}
		return code.toString
	}
	
	static def generateCreateJSONMessageEntry () {
		'''
		String createJSONMessageEntry (String bbname, int iindex, String vename, Object value) {
			String json = "{";
			json += "\"building-block\": \""+bbname+"\", ";
			json += "\"instance-index\": "+iindex+", ";
			json += "\"variability-entity\": \""+vename+"\", ";
			json += "\"value\": \""+value+"\"";
			json += "}";
			return json;
		}
		'''
	}
	
	static def String generateGenericAllocationAggr() {

		var String vsp
		var String obj
		
		vsp = "vsp"
		obj = "Object"
		
		'''
		Node AllocationAggr (List<Node>I, String name) {
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,«obj»>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,«obj»>>();
			«obj» newValue;
			List<List<Integer>> ir = new ArrayList<List<Integer>>();
			NodeObjectList nodeObjectList;
			for (int i = 0; i < I.size(); i++) {
				SimpleEntry<String, Integer> fid = new SimpleEntry<String, Integer>(name, i);
				
				for (int j = 0; j < I.get(i).«vsp»().size(); j++) {
					List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();
					List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();
					headerRow.add(fid);
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
					newValue = I.get(i).«vsp»(j);
					ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, «obj»>(header, newValue));
				}
			}
			return new NodeObject(name, ovsp);
		}
		'''
	}		
}