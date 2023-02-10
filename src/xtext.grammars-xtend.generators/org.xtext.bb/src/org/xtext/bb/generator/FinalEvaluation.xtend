package org.xtext.bb.generator 
import java.util.Map
import BbDvgTcl.FinalOperation

class FinalEvaluation {
	
	// used by:
	// - SingleRobot/TCL
	static def generateSolveCode(String outputName, boolean foimax, String CALL_SEQUENCE_CODE, Map<String, Integer> ACTIVE, Map<String, Integer> PASSIVE_LOOKUP, Map<String, String> ACTIVE_BBNAME, Map<String, Integer> ACTIVE_IINDEX, Map<String, String> ACTIVE_VE) {
		'''
		void solve() {
			List<Node> params;
			List<List<Node>> params_2d;
			
			«CALL_SEQUENCE_CODE»
			
			Map<String, Integer> active = new HashMap<String, Integer>();
			Map<String, Integer> passive = new HashMap<String, Integer>();
		
			«FOR i : ACTIVE.entrySet»
				active.put("«i.key»",«i.value»);
			«ENDFOR»
			«FOR i : PASSIVE_LOOKUP.entrySet»
				passive.put("«i.key»",«i.value»);
			«ENDFOR»
			
			Map<String, String> ACTIVE_BBNAME = new HashMap<String, String>();
			«FOR i : ACTIVE_BBNAME.entrySet»
				ACTIVE_BBNAME.put("«i.key»","«i.value»");
			«ENDFOR»	
			Map<String, Integer> ACTIVE_IINDEX = new HashMap<String, Integer>();
			«FOR i : ACTIVE_IINDEX.entrySet»
				ACTIVE_IINDEX.put("«i.key»",«i.value»);
			«ENDFOR»	
			Map<String, String> ACTIVE_VE = new HashMap<String, String>();
			«FOR i : ACTIVE_VE.entrySet»
				ACTIVE_VE.put("«i.key»","«i.value»");
			«ENDFOR»									
		
			Node result = NODE_COLLECTION.get("«outputName»");
			int cnt = 0;
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> rtmp = result.vsp();
			SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> finalSlot = null;
			«IF foimax»
				double finalValue = Double.MIN_VALUE;
			«ELSE»
				double finalValue = Double.MAX_VALUE;
			«ENDIF»
			int finalIndex = 0;
			for (SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> i : rtmp) {
				List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();
				Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();
				List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();
				Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();
			
				List<List<SimpleEntry<String,Integer>>> header = i.getKey();
				for (List<SimpleEntry<String,Integer>> headerRow : header) {
					for (SimpleEntry<String,Integer> headerEntry : headerRow) {
						System.out.print(headerEntry.getKey()+": "+headerEntry.getValue());
						System.out.print("\t");
						if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {
							AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
							AflagLeaf.put(headerEntry.getKey(),true);
						}
						if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {
							PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
							PflagLeaf.put(headerEntry.getKey(),true);
						}
					}
					System.out.println();
				}
		
				System.out.println("################## ACTIVE VARIANT: ");
				for (int j = 0; j < AleafNamesAndIndices.size(); j++) {
					System.out.println(AleafNamesAndIndices.get(j).getKey() + ": " + AleafNamesAndIndices.get(j).getValue());
				}
		
				System.out.println("################## FOR PASSIVE STATES: ");
				for (int j = 0; j < PleafNamesAndIndices.size(); j++) {
					System.out.println(PleafNamesAndIndices.get(j).getKey() + ": " + PleafNamesAndIndices.get(j).getValue());
				}
		
				System.out.println("=================> ["+cnt+", "+i.getValue()+"]");
				System.out.println("------------------------------------");
		
				«IF foimax»
					if (((Number)i.getValue()).doubleValue() > finalValue) {
				«ELSE»
					if (((Number)i.getValue()).doubleValue() < finalValue) {
				«ENDIF»
					finalValue = ((Number)i.getValue()).doubleValue();
					finalSlot = i;
					finalIndex = cnt;
				}
				cnt++;
			}
		
			System.out.println("");
			System.out.println("");
			System.out.println("====================== Final Result ======================");
			for (List<SimpleEntry<String,Integer>> headerRow : finalSlot.getKey()) {
				for (SimpleEntry<String,Integer> headerEntry : headerRow) {
					System.out.print(headerEntry.getKey()+": "+headerEntry.getValue());
					System.out.print("\t");
				}
				System.out.println();
			}
		
		
			List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();
			Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();
			List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();
			Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();
			for (List<SimpleEntry<String,Integer>> headerRow : finalSlot.getKey()) {
				for (SimpleEntry<String,Integer> headerEntry : headerRow) {
						
						if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {
							AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
							AflagLeaf.put(headerEntry.getKey(),true);
						}
						if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {
							PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
							PflagLeaf.put(headerEntry.getKey(),true);
						}
				}
			}
			
			String dvgConfiguration = "{\n\t\"dvg-configuration\":\n\t\t[\n";
			System.out.println("################## BEST ACTIVE VARIANT: ");
			for (int i = 0; i < AleafNamesAndIndices.size(); i++) {
		
				List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> lse = this.NODE_COLLECTION.get(AleafNamesAndIndices.get(i).getKey()).vsp();
				SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> se = lse.get(AleafNamesAndIndices.get(i).getValue());
				
				dvgConfiguration += "\t\t\t";
				dvgConfiguration += createJSONMessageEntry(ACTIVE_BBNAME.get(AleafNamesAndIndices.get(i).getKey()), ACTIVE_IINDEX.get(AleafNamesAndIndices.get(i).getKey()), ACTIVE_VE.get(AleafNamesAndIndices.get(i).getKey()), se.getValue());
				if (i < AleafNamesAndIndices.size()-1) {
					dvgConfiguration += ",";
				}
				dvgConfiguration += "\n";
			
				System.out.println(AleafNamesAndIndices.get(i).getKey() + ": " + AleafNamesAndIndices.get(i).getValue());
			}
			System.out.println("################## FOR IDEAL PASSIVE STATES: ");
			for (int j = 0; j < PleafNamesAndIndices.size(); j++) {
				System.out.println(PleafNamesAndIndices.get(j).getKey() + ": " + PleafNamesAndIndices.get(j).getValue());
			}
			
			System.out.println("=================> ["+finalIndex+", "+finalSlot.getValue()+"]");
			
			dvgConfiguration += "\t\t]\n}";
		    
		    try {
		        FileWriter myWriter = new FileWriter("dvgConfiguration.json", true);
		        myWriter.write(dvgConfiguration+"\n");
		        myWriter.close();
		    } 
			catch (IOException e) {
		        System.out.println("An error occurred.");
		        e.printStackTrace();
		    }
		}
		'''
	}
					
	// used by:
	// - MultiRobot
	static def generateSolveCode(String outputName, boolean foimax, String CALL_SEQUENCE_CODE, Map<String, Integer> ACTIVE, Map<String, Integer> PASSIVE, int size) {
		'''
		void solve() {
			List<Node> params;
			List<List<Node>> params_2d;
			int solution = -1;
			«IF foimax»
				double prevValue = Double.MIN_VALUE;
			«ELSE»
				double prevValue = Double.MAX_VALUE;
			«ENDIF»
			int solutionIndex = -1;
			SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> solutionSlot = null;
			for (int allocation = 0; allocation < «size.toString»; allocation++) {
				System.out.println("**********************************************************************************");
				System.out.println("**********************************************************************************");
				System.out.println("**********************************************************************************");
				
				«CALL_SEQUENCE_CODE»
						
				Map<String, Integer> active = new HashMap<String, Integer>();
				Map<String, Integer> passive = new HashMap<String, Integer>();
				
				«FOR i : ACTIVE.entrySet»
					active.put("«i.key»",«i.value»);
				«ENDFOR»
				
				«FOR i : PASSIVE.entrySet»
					passive.put("«i.key»",«i.value»);
				«ENDFOR»		
		
				Node result = NODE_COLLECTION.get("«outputName»");
				int cnt = 0;
				List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> rtmp = result.vsp();
				SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> finalSlot = null;
				«IF foimax»
					double finalValue = Double.MIN_VALUE;
				«ELSE»
					double finalValue = Double.MAX_VALUE;
				«ENDIF»
				int finalIndex = 0;
				for (SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> i : rtmp) {
								
					List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();
					Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();
					
					List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();
					Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();
					
					List<List<SimpleEntry<String,Integer>>> header = i.getKey();
					for (List<SimpleEntry<String,Integer>> headerRow : header) {
						for (SimpleEntry<String,Integer> headerEntry : headerRow) {
							System.out.print(headerEntry.getKey()+": "+headerEntry.getValue());
							System.out.print("\t");
				
				
							if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {
								AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
								AflagLeaf.put(headerEntry.getKey(),true);
							}
							
							if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {
								PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
								PflagLeaf.put(headerEntry.getKey(),true);
							}									
							
						}
						System.out.println();
					}
		
					System.out.println("################## ACTIVE VARIANT: ");
					for (int j = 0; j < AleafNamesAndIndices.size(); j++) {
						System.out.println(AleafNamesAndIndices.get(j).getKey() + ": " + AleafNamesAndIndices.get(j).getValue());
					}
		
					System.out.println("################## FOR PASSIVE STATES: ");
					for (int j = 0; j < PleafNamesAndIndices.size(); j++) {
						System.out.println(PleafNamesAndIndices.get(j).getKey() + ": " + PleafNamesAndIndices.get(j).getValue());
					}
		
					
				System.out.println("=================> ["+cnt+", "+i.getValue()+"]");
				System.out.println("------------------------------------");
				
				«IF foimax»
					if (((Number)i.getValue()).doubleValue() > finalValue) {
				«ELSE»
					if (((Number)i.getValue()).doubleValue() < finalValue) {
				«ENDIF»
					finalValue = ((Number)i.getValue()).doubleValue();
					finalSlot = i;
					finalIndex = cnt;
				}
				cnt++;
				}
				
				System.out.println("");
				System.out.println("");
				System.out.println("====================== Final Result ====================== ");
				for (List<SimpleEntry<String,Integer>> headerRow : finalSlot.getKey()) {
					for (SimpleEntry<String,Integer> headerEntry : headerRow) {
						System.out.print(headerEntry.getKey()+": "+headerEntry.getValue());
						System.out.print("\t");
					}
					System.out.println();
				}
				
				
				List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();
				Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();
				List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();
				Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();
				for (List<SimpleEntry<String,Integer>> headerRow : finalSlot.getKey()) {
					for (SimpleEntry<String,Integer> headerEntry : headerRow) {
							
							if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {
								AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
								AflagLeaf.put(headerEntry.getKey(),true);
							}
		
							if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {
								PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
								PflagLeaf.put(headerEntry.getKey(),true);
							}
					}
				}
				
				System.out.println("################## BEST ACTIVE VARIANT: ");
				for (int i = 0; i < AleafNamesAndIndices.size(); i++) {
					System.out.println(AleafNamesAndIndices.get(i).getKey() + ": " + AleafNamesAndIndices.get(i).getValue());
				}
		
				System.out.println("################## FOR IDEAL PASSIVE STATES: ");
				for (int j = 0; j < PleafNamesAndIndices.size(); j++) {
					System.out.println(PleafNamesAndIndices.get(j).getKey() + ": " + PleafNamesAndIndices.get(j).getValue());
				}
				
				System.out.println("=================> ["+finalIndex+", "+finalSlot.getValue()+"]");
		
				«IF foimax»
					if (finalValue > prevValue) {
				«ELSE»
					if (finalValue < prevValue) {
				«ENDIF»
					solution = allocation;
					prevValue = finalValue;
					solutionSlot = finalSlot;
					solutionIndex = finalIndex;
				}
		
			} // End of allocation loop
		
		
			System.out.println("Best allocation is: " + solution);

			Map<String, Integer> active = new HashMap<String, Integer>();
			Map<String, Integer> passive = new HashMap<String, Integer>();

			System.out.println("");
			System.out.println("");
			System.out.println("====================== Final Result ====================== ");
			for (List<SimpleEntry<String,Integer>> headerRow : solutionSlot.getKey()) {
				for (SimpleEntry<String,Integer> headerEntry : headerRow) {
					System.out.print(headerEntry.getKey()+": "+headerEntry.getValue());
					System.out.print("\t");
				}
				System.out.println();
			}
			
			List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();
			Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();
			List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();
			Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();
			for (List<SimpleEntry<String,Integer>> headerRow : solutionSlot.getKey()) {
				for (SimpleEntry<String,Integer> headerEntry : headerRow) {
						
						if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {
							AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
							AflagLeaf.put(headerEntry.getKey(),true);
						}

						if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {
							PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
							PflagLeaf.put(headerEntry.getKey(),true);
						}
				}
			}
			
			System.out.println("################## BEST ACTIVE VARIANT: ");
			for (int i = 0; i < AleafNamesAndIndices.size(); i++) {
			
				System.out.println(AleafNamesAndIndices.get(i).getKey() + ": " + AleafNamesAndIndices.get(i).getValue());
			}

			System.out.println("################## FOR IDEAL PASSIVE STATES: ");
			for (int j = 0; j < PleafNamesAndIndices.size(); j++) {
				System.out.println(PleafNamesAndIndices.get(j).getKey() + ": " + PleafNamesAndIndices.get(j).getValue());
			}
			
			System.out.println("=================> ["+solutionIndex+", "+solutionSlot.getValue()+"]");
		}
		'''
	}				
	
	// used by:
	// - MultiRobot-EQUF/NoTCL	
	static def generateSolveCode(String outputName, boolean foimax, String CALL_SEQUENCE_CODE, Map<String, Integer> ACTIVE, Map<String, Integer> PASSIVE_LOOKUP) {
		'''
		void solve() {
			List<Node> params;
			List<List<Node>> params_2d;
			
			«CALL_SEQUENCE_CODE»
			
			Map<String, Integer> active = new HashMap<String, Integer>();
			Map<String, Integer> passive = new HashMap<String, Integer>();
		
			«FOR i : ACTIVE.entrySet»
				active.put("«i.key»",«i.value»);
			«ENDFOR»
			«FOR i : PASSIVE_LOOKUP.entrySet»
				passive.put("«i.key»",«i.value»);
			«ENDFOR»								
		
			Node result = NODE_COLLECTION.get("«outputName»");
			int cnt = 0;
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> rtmp = result.vsp();
			SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> finalSlot = null;
			«IF foimax»
				double finalValue = Double.MIN_VALUE;
			«ELSE»
				double finalValue = Double.MAX_VALUE;
			«ENDIF»
			int finalIndex = 0;
			for (SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> i : rtmp) {
				List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();
				Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();
				List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();
				Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();
			
				List<List<SimpleEntry<String,Integer>>> header = i.getKey();
				for (List<SimpleEntry<String,Integer>> headerRow : header) {
					for (SimpleEntry<String,Integer> headerEntry : headerRow) {
						System.out.print(headerEntry.getKey()+": "+headerEntry.getValue());
						System.out.print("\t");
						if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {
							AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
							AflagLeaf.put(headerEntry.getKey(),true);
						}
						if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {
							PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
							PflagLeaf.put(headerEntry.getKey(),true);
						}
					}
					System.out.println();
				}
		
				System.out.println("################## ACTIVE VARIANT: ");
				for (int j = 0; j < AleafNamesAndIndices.size(); j++) {
					System.out.println(AleafNamesAndIndices.get(j).getKey() + ": " + AleafNamesAndIndices.get(j).getValue());
				}
		
				System.out.println("################## FOR PASSIVE STATES: ");
				for (int j = 0; j < PleafNamesAndIndices.size(); j++) {
					System.out.println(PleafNamesAndIndices.get(j).getKey() + ": " + PleafNamesAndIndices.get(j).getValue());
				}
		
				System.out.println("=================> ["+cnt+", "+i.getValue()+"]");
				System.out.println("------------------------------------");
		
				«IF foimax»
					if (((Number)i.getValue()).doubleValue() > finalValue) {
				«ELSE»
					if (((Number)i.getValue()).doubleValue() < finalValue) {
				«ENDIF»
					finalValue = ((Number)i.getValue()).doubleValue();
					finalSlot = i;
					finalIndex = cnt;
				}
				cnt++;
			}
		
			System.out.println("");
			System.out.println("");
			System.out.println("====================== Final Result ======================");
			for (List<SimpleEntry<String,Integer>> headerRow : finalSlot.getKey()) {
				for (SimpleEntry<String,Integer> headerEntry : headerRow) {
					System.out.print(headerEntry.getKey()+": "+headerEntry.getValue());
					System.out.print("\t");
				}
				System.out.println();
			}
		
		
			List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();
			Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();
			List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();
			Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();
			for (List<SimpleEntry<String,Integer>> headerRow : finalSlot.getKey()) {
				for (SimpleEntry<String,Integer> headerEntry : headerRow) {
						
						if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {
							AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
							AflagLeaf.put(headerEntry.getKey(),true);
						}
						if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {
							PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));
							PflagLeaf.put(headerEntry.getKey(),true);
						}
				}
			}
			
			System.out.println("################## BEST ACTIVE VARIANT: ");
			for (int i = 0; i < AleafNamesAndIndices.size(); i++) {
				System.out.println(AleafNamesAndIndices.get(i).getKey() + ": " + AleafNamesAndIndices.get(i).getValue());
			}
			System.out.println("################## FOR IDEAL PASSIVE STATES: ");
			for (int j = 0; j < PleafNamesAndIndices.size(); j++) {
				System.out.println(PleafNamesAndIndices.get(j).getKey() + ": " + PleafNamesAndIndices.get(j).getValue());
			}
			
			System.out.println("=================> ["+finalIndex+", "+finalSlot.getValue()+"]");
		}
		'''
	}
}