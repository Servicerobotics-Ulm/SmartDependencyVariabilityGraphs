package org.xtext.bb.generator

import java.util.List
import java.util.Map
import BbDvgTcl.AbstractInitPort
import BbDvgTcl.InitPort
import org.eclipse.emf.ecore.EObject
import vi.BoolVSPInit
import vi.IntegerVSPInit
import vi.RealVSPInit
import vi.StringVSPInit
import vi.ComplexVSPInit
import java.util.ArrayList
import BbDvgTcl.InitWSMPort
import java.util.HashMap
import BbDvgTcl.InitCPort
import vi.Type
import vi.Real

class Leafs {
	
	static def String generateLeaf(AbstractInitPort inn) {

		var String res = "";
		
		if (inn instanceof InitPort) {
			var EObject tmp = inn.vi
			if (tmp instanceof BoolVSPInit) {
				res += generateLeafValuesBoolean(inn.name, tmp.vsp)
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					res += generateRandomIntegers(inn.name, tmp.irg.number, tmp.irg.min, tmp.irg.max)
				}
				else {
					res += generateLeafValuesInteger(inn.name, tmp.vsp)
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					res += generateRandomReals(inn.name, tmp.rrg.number, tmp.rrg.min, tmp.rrg.max)
				}
				else {
					res += generateLeafValuesDouble(inn.name, tmp.vsp)
				}
			}
			else if (tmp instanceof StringVSPInit) {
				res += generateLeafValuesString(inn.name, tmp.vsp)
			}
			
			else if (tmp instanceof ComplexVSPInit) {
				
				//System.out.println("Is Complex VSP INIT *********************************************************")
				
				// We expect here either a list of Elements > 1 each with cardinality = 1 
				// or one Element with cardinality > 1
				if (tmp.vi.get(0).e.size() > 1) {
					// More than one element for the first VI
					// Must be the same for all other VIs
					// Each Element must have cardinality = 1
					var Type ty = null
					
					var List<List<Object>> vsp = new ArrayList<List<Object>>()
					
					// For each VI
					for (var int i = 0; i < tmp.vi.size(); i++) {
						// For each Element of a VI					
						var List<Object> vi = new ArrayList<Object>()
						for (var int j = 0; j < tmp.vi.get(i).e.size(); j++) {
							ty = tmp.vi.get(i).e.get(j).t
							
							if (ty instanceof Real) {
								// Only one value
								vi.add(ty.rv.get(0).value)
							}
							else if (ty instanceof vi.String) {
								vi.add(ty.sv.get(0).value)
							}
							// TODO: Add other types										
						}
						
						vsp.add(vi)
						
						res += generateLeafValues(inn.name, vsp)		
					}
					
				}
				else if (tmp.vi.get(0).e.size() == 1) {
					
					var Type ty = null
					var List<List<Object>> vsp = new ArrayList<List<Object>>()
					
					// For each VI
					for (var int i = 0; i < tmp.vi.size(); i++) {
						// For each Value of the single Element of a VI					
						var List<Object> vi = new ArrayList<Object>()
						ty = tmp.vi.get(i).e.get(0).t
						
						if (ty instanceof Real) {
							// More than one value
							
							for (var int j = 0; j < ty.rv.size(); j++) {
								vi.add(ty.rv.get(j).value)
							}
							
							vsp.add(vi)
						}
						else if (ty instanceof vi.String) {
							vi.add(ty.sv.get(0).value)
						}
						// TODO: Add other types						
						
						res += generateLeafValues(inn.name, vsp)		
					}
					
				}
			}
			
		}
		
		else if (inn instanceof InitCPort) {
			var EObject tmp = inn.vi
			if (tmp instanceof BoolVSPInit) {
				res += generateLeafValuesBoolean(inn.name, tmp.vsp)
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					res += generateRandomIntegers(inn.name, tmp.irg.number, tmp.irg.min, tmp.irg.max)
				}
				else {
					res += generateLeafValuesInteger(inn.name, tmp.vsp)
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					res += generateRandomReals(inn.name, tmp.rrg.number, tmp.rrg.min, tmp.rrg.max)
				}
				else {
					res += generateLeafValuesDouble(inn.name, tmp.vsp)
				}
			}
			else if (tmp instanceof StringVSPInit) {
				res += generateLeafValuesString(inn.name, tmp.vsp)
			}
			
		}
		
		else if (inn instanceof InitWSMPort) {
			
			var Map<String,Double> dwStruct = new HashMap<String,Double>()
		
			for (i : inn.sws.sw) {
				dwStruct.put(i.inputport.outputport.name, i.weight)
			}
		
			res += generateLeafValues(inn.name, dwStruct)
		}
		
		return res
	}
	
	static def String generateLeaf(AbstractInitPort inn, String name) {
		
		var String res = "";
		
		if (inn instanceof InitPort) {
			var EObject tmp = inn.vi
			if (tmp instanceof BoolVSPInit) {
				res += Leafs.generateLeafValuesBoolean(name, tmp.vsp)
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					res += Leafs.generateRandomIntegers(name, tmp.irg.number, tmp.irg.min, tmp.irg.max)
				}
				else {
					res += Leafs.generateLeafValuesInteger(name, tmp.vsp)
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					res += Leafs.generateRandomReals(name, tmp.rrg.number, tmp.rrg.min, tmp.rrg.max)
				}
				else {
					res += Leafs.generateLeafValuesDouble(name, tmp.vsp)
				}
			}
			else if (tmp instanceof StringVSPInit) {
				res += Leafs.generateLeafValuesString(name, tmp.vsp)
			}
			
			else if (tmp instanceof ComplexVSPInit) {
				
				//System.out.println("Is Complex VSP INIT *********************************************************")
				
				// We expect here either a list of Elements > 1 each with cardinality = 1 
				// or one Element with cardinality > 1
				if (tmp.vi.get(0).e.size() > 1) {
					// More than one element for the first VI
					// Must be the same for all other VIs
					// Each Element must have cardinality = 1
					var Type ty = null
					
					var List<List<Object>> vsp = new ArrayList<List<Object>>()
					
					// For each VI
					for (var int i = 0; i < tmp.vi.size(); i++) {
						// For each Element of a VI					
						var List<Object> vi = new ArrayList<Object>()
						for (var int j = 0; j < tmp.vi.get(i).e.size(); j++) {
							ty = tmp.vi.get(i).e.get(j).t
							
							if (ty instanceof Real) {
								// Only one value
								vi.add(ty.rv.get(0).value)
							}
							else if (ty instanceof vi.String) {
								vi.add(ty.sv.get(0).value)
							}
							// TODO: Add other types
						}
						
						vsp.add(vi)
						
						res += Leafs.generateLeafValues(name, vsp)		
					}
					
				}
				else if (tmp.vi.get(0).e.size() == 1) {
					
					var Type ty = null
					var List<List<Object>> vsp = new ArrayList<List<Object>>()
					
					// For each VI
					for (var int i = 0; i < tmp.vi.size(); i++) {
						// For each Value of the single Element of a VI					
						var List<Object> vi = new ArrayList<Object>()
						ty = tmp.vi.get(i).e.get(0).t
						
						if (ty instanceof Real) {
							// More than one value
							
							for (var int j = 0; j < ty.rv.size(); j++) {
								vi.add(ty.rv.get(j).value)
							}
							
							vsp.add(vi)
						}
						// TODO: Add other types
						
						res += Leafs.generateLeafValues(name, vsp)		
					}
					
				}
			}
		}
		
		else if (inn instanceof InitCPort) {
			var EObject tmp = inn.vi
			if (tmp instanceof BoolVSPInit) {
				res += Leafs.generateLeafValuesBoolean(name, tmp.vsp)
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					res += Leafs.generateRandomIntegers(name, tmp.irg.number, tmp.irg.min, tmp.irg.max)
				}
				else {
					res += Leafs.generateLeafValuesInteger(name, tmp.vsp)
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					res += Leafs.generateRandomReals(name, tmp.rrg.number, tmp.rrg.min, tmp.rrg.max)
				}
				else {
					res += Leafs.generateLeafValuesDouble(name, tmp.vsp)
				}
			}
			else if (tmp instanceof StringVSPInit) {
				res += Leafs.generateLeafValuesString(name, tmp.vsp)
			}
			
		}
		
		else if (inn instanceof InitWSMPort) {
			
			var Map<String,Double> dwStruct = new HashMap<String,Double>()
		
			for (i : inn.sws.sw) {
				dwStruct.put(i.inputport.outputport.name, i.weight)
			}
		
			res += Leafs.generateLeafValues(name, dwStruct)
		}
		
		return res
	}		
	
	static def String generateLeaf(AbstractInitPort inn, String name, int id) {
		
		var String res = "";
		
		if (inn instanceof InitPort) {
			var EObject tmp = inn.vi
			if (tmp instanceof BoolVSPInit) {
				res += Leafs.generateLeafValuesBoolean(name, tmp.vsp, id)
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					res += Leafs.generateRandomIntegers(name, tmp.irg.number, tmp.irg.min, tmp.irg.max)
				}
				else {
					res += Leafs.generateLeafValuesInteger(name, tmp.vsp, id)
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					res += Leafs.generateRandomReals(name, tmp.rrg.number, tmp.rrg.min, tmp.rrg.max)
				}
				else {
					res += Leafs.generateLeafValuesDouble(name, tmp.vsp, id)
				}
			}
			else if (tmp instanceof StringVSPInit) {
				res += Leafs.generateLeafValuesString(name, tmp.vsp, id)
			}
			
			else if (tmp instanceof ComplexVSPInit) {
				
				//System.out.println("Is Complex VSP INIT *********************************************************")
				
				// We expect here either a list of Elements > 1 each with cardinality = 1 
				// or one Element with cardinality > 1
				if (tmp.vi.get(0).e.size() > 1) {
					// More than one element for the first VI
					// Must be the same for all other VIs
					// Each Element must have cardinality = 1
					var Type ty = null
					
					var List<List<Object>> vsp = new ArrayList<List<Object>>()
					
					// For each VI
					for (var int i = 0; i < tmp.vi.size(); i++) {
						// For each Element of a VI					
						var List<Object> vi = new ArrayList<Object>()
						for (var int j = 0; j < tmp.vi.get(i).e.size(); j++) {
							ty = tmp.vi.get(i).e.get(j).t
							
							if (ty instanceof Real) {
								// Only one value
								vi.add(ty.rv.get(0).value)
							}
						}
						
						vsp.add(vi)
						
						res += Leafs.generateLeafValues(name, vsp, id)		
					}
					
				}
				else if (tmp.vi.get(0).e.size() == 1) {
					
					var Type ty = null
					var List<List<Object>> vsp = new ArrayList<List<Object>>()
					
					// For each VI
					for (var int i = 0; i < tmp.vi.size(); i++) {
						// For each Value of the single Element of a VI					
						var List<Object> vi = new ArrayList<Object>()
						ty = tmp.vi.get(i).e.get(0).t
						
						if (ty instanceof Real) {
							// More than one value
							
							for (var int j = 0; j < ty.rv.size(); j++) {
								vi.add(ty.rv.get(j).value)
							}
							
							vsp.add(vi)
						}
						
						res += Leafs.generateLeafValues(name, vsp, id)		
					}
					
				}
			}
			
			//res += "// assign node "+ name+ "a UNIQUE RES ID of "+ this.UNIQUE_RESOURCE_ID.get(inn)
			//res += "\n\n
		}
		
		else if (inn instanceof InitCPort) {
			var EObject tmp = inn.vi
			if (tmp instanceof BoolVSPInit) {
				res += Leafs.generateLeafValuesBoolean(name, tmp.vsp)
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					res += Leafs.generateRandomIntegers(name, tmp.irg.number, tmp.irg.min, tmp.irg.max)
				}
				else {
					res += Leafs.generateLeafValuesInteger(name, tmp.vsp)
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					res += Leafs.generateRandomReals(name, tmp.rrg.number, tmp.rrg.min, tmp.rrg.max)
				}
				else {
					res += Leafs.generateLeafValuesDouble(name, tmp.vsp)
				}
			}
			else if (tmp instanceof StringVSPInit) {
				res += Leafs.generateLeafValuesString(name, tmp.vsp)
			}
			
		}
		
		else if (inn instanceof InitWSMPort) {
			
			var Map<String,Double> dwStruct = new HashMap<String,Double>()
		
			for (i : inn.sws.sw) {
				dwStruct.put(i.inputport.outputport.name, i.weight)
			}
		
			res += Leafs.generateLeafValues(name, dwStruct)
		}
		
		return res
	}			
	
	static def generateLeafValuesBoolean(String name, List<Boolean> leafValues) {
		'''
		leafValues = new ArrayList<Object>();
		«FOR i : leafValues»
			leafValues.add(«i»);
		«ENDFOR»
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}
	
	static def generateLeafValuesBoolean(String name, List<Boolean> leafValues, int id) {
		'''
		leafValues = new ArrayList<Object>();
		«FOR i : leafValues»
			leafValues.add(«i»);
		«ENDFOR»
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues, «id»);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}	
	
	static def generateLeafValuesDouble(String name, List<Double> leafValues) {
		'''
		leafValues = new ArrayList<Object>();
		«FOR i : leafValues»
			leafValues.add(«i»);
		«ENDFOR»
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}
	
	static def generateLeafValuesDouble(String name, List<Double> leafValues, int id) {
		'''
		leafValues = new ArrayList<Object>();
		«FOR i : leafValues»
			leafValues.add(«i»);
		«ENDFOR»
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues, «id»);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}	
	
	static def generateLeafValuesInteger(String name, List<Integer> leafValues) {
		'''
		leafValues = new ArrayList<Object>();
		«FOR i : leafValues»
			leafValues.add(«i»);
		«ENDFOR»
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}	
	
	static def generateLeafValuesInteger(String name, List<Integer> leafValues, int id) {
		'''
		leafValues = new ArrayList<Object>();
		«FOR i : leafValues»
			leafValues.add(«i»);
		«ENDFOR»
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues, «id»);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}		
	
	static def generateLeafValuesString(String name, List<String> leafValues) {
		'''
		leafValues = new ArrayList<Object>();
		«FOR i : leafValues»
			leafValues.add("«i»");
		«ENDFOR»
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}	
	
	static def generateLeafValuesString(String name, List<String> leafValues, int id) {
		'''
		leafValues = new ArrayList<Object>();
		«FOR i : leafValues»
			leafValues.add("«i»");
		«ENDFOR»
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues, «id»);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}
	
	static def generateRandomIntegers(String name, int number, int min, int max) {
		'''
		leafValues = new ArrayList<Object>();
		random = new Random();
		leafValues = random.ints(«number», «min», «max»).boxed().collect(Collectors.toList());
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}
	
	static def generateRandomReals(String name, int number, double min, double max) {
		'''
		leafValues = new ArrayList<Object>();
		random = new Random();
		leafValues = random.doubles(«number», «min», «max»).boxed().collect(Collectors.toList());
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}	
	
	static def generateLeafValues(String name, Map<String,Double> leafValues) {
		'''
		leafValuesPsMapList= new ArrayList<Map<String,Double>>();
		leafValuesPsMap = new HashMap<String,Double>();
		«FOR i : leafValues.entrySet»
			leafValuesPsMap.put("«i.key»",«i.value»);
		«ENDFOR»
		nodePs = new NodePs("«name»");
		leafValuesPsMapList.add(leafValuesPsMap);
		nodePs.initLeaf(leafValuesPsMapList);
		this.NODE_COLLECTION.put("«name»", nodePs);
		'''
	}
	
	static def generateLeafValues(String name, List<List<Object>> leafValues) {
		'''
		leafValues_2 = new ArrayList<List<Object>>();
		«FOR i : leafValues»
			leafValues = new ArrayList<Object>();
			«FOR j : i»
				«IF j instanceof String»
					leafValues.add("«j»");
				«ELSE»
					leafValues.add(«j»);
				«ENDIF»
				
			«ENDFOR»
			leafValues_2.add(leafValues);
		«ENDFOR»

		nodeObjectList = new NodeObjectList("«name»");
		nodeObjectList.initLeaf_2(leafValues_2);
		this.NODE_COLLECTION.put("«name»", nodeObjectList);
		'''
	}
	
	static def generateLeafValues(String name, List<List<Object>> leafValues, int id) {
		'''
		leafValues_2 = new ArrayList<List<Object>>();
		«FOR i : leafValues»
			leafValues = new ArrayList<Object>();
			«FOR j : i»
				leafValues.add(«j»);
			«ENDFOR»
			leafValues_2.add(leafValues);
		«ENDFOR»

		nodeObjectList = new NodeObjectList("«name»");
		nodeObjectList.initLeaf_2(leafValues_2, «id»);
		this.NODE_COLLECTION.put("«name»", nodeObjectList);
		'''
	}
	
	static def generateLeafValuesComplexTcl(String name) {
		'''
		leafValues_2 = new ArrayList<List<Object>>();
		leafValues = new ArrayList<Object>();
		dataFromFile = getDataFromFile("«name»");
		for (int i = 0; i < dataFromFile.length; i++) {
			leafValues.add(Double.parseDouble(dataFromFile[i])); «/*Currently always treated as double*/»
		}
		leafValues_2.add(leafValues);
		
		nodeObjectList = new NodeObjectList("«name»");
		nodeObjectList.initLeaf_2(leafValues_2);
		this.NODE_COLLECTION.put("«name»", nodeObjectList);
		'''
	}
	
	static def generateLeafValuesTcl(String name) {
		'''
		leafValues = new ArrayList<Object>();
		dataFromFile = getDataFromFile("«name»");
		for (int i = 0; i < dataFromFile.length; i++) {
			leafValues.add(Double.parseDouble(dataFromFile[i])); «/*Currently always treated as double*/»
		}
		
		nodeObject = new NodeObject("«name»");
		nodeObject.initLeaf(leafValues);
		this.NODE_COLLECTION.put("«name»", nodeObject);
		'''
	}
	
}