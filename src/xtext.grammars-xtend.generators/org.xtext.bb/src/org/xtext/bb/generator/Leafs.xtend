//================================================================
//
//  Copyright (c) 2022 Technische Hochschule Ulm, Servicerobotics Ulm, Germany
//
//        Servicerobotik Ulm 
//        Christian Schlegel
//        Ulm University of Applied Sciences
//        Prittwitzstr. 10
//        89075 Ulm
//        Germany
//
//	  http://www.servicerobotik-ulm.de/
//
//  This file is part of the SmartDependencyVariabilityGraph feature.
//
//  Author:
//		Timo Blender
//
//  Licence:
//
//  BSD 3-Clause License
//  
//  Copyright (c) 2022, Technische Hochschule Ulm, Servicerobotics Ulm
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//  
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//  
//  * Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  https://opensource.org/licenses/BSD-3-Clause
//
//================================================================

package org.xtext.bb.generator

import java.util.List
import java.util.Map

class Leafs {

	def String generateLeafValuesInitBool(String name, List<Boolean> leafValues) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValues = new ArrayList<Object>();")
		code.append("\n\t\t")
		for (i : leafValues) {
			code.append("leafValues.add("+i+");")
			code.append("\n\t\t")			
		}
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues);")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}

	def String generateLeafValuesInitBool(String name, List<Boolean> leafValues, int id) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValues = new ArrayList<Object>();")
		code.append("\n\t\t")
		for (i : leafValues) {
			code.append("leafValues.add("+i+");")
			code.append("\n\t\t")			
		}
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues, "+id+");")
		code.append("\n\t\t")	
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}	
	
	def String generateLeafValuesInitInteger(String name, List<Integer> leafValues) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValues = new ArrayList<Object>();")
		code.append("\n\t\t")
		for (i : leafValues) {
			code.append("leafValues.add("+i+");")
			code.append("\n\t\t")			
		}
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues);")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}

	def String generateLeafValuesInitInteger(String name, List<Integer> leafValues, int id) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValues = new ArrayList<Object>();")
		code.append("\n\t\t")
		for (i : leafValues) {
			code.append("leafValues.add("+i+");")
			code.append("\n\t\t")			
		}
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues, "+id+");")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}
		
	def String generateLeafValuesInitReal(String name, List<Double> leafValues) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValues = new ArrayList<Object>();")
		code.append("\n\t\t")
		for (i : leafValues) {
			code.append("leafValues.add("+i+");")
			code.append("\n\t\t")			
		}
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues);")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}

	def String generateLeafValuesInitReal(String name, List<Double> leafValues, int id) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValues = new ArrayList<Object>();")
		code.append("\n\t\t")
		for (i : leafValues) {
			code.append("leafValues.add("+i+");")
			code.append("\n\t\t")			
		}
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues, "+id+");")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}	
	
	def String generateLeafValuesInitString(String name, List<String> leafValues) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValues = new ArrayList<Object>();")
		code.append("\n\t\t")
		for (i : leafValues) {
			code.append("leafValues.add(\""+i+"\");")
			code.append("\n\t\t")			
		}
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues);")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}

	def String generateLeafValuesInitString(String name, List<String> leafValues, int id) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValues = new ArrayList<Object>();")
		code.append("\n\t\t")
		for (i : leafValues) {
			code.append("leafValues.add(\""+i+"\");")
			code.append("\n\t\t")			
		}
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues, "+id+");")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}	
	
	def String generateRandomIntegers(String name, int number, int min, int max) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValues = new ArrayList<Object>();")
		code.append("\n\t\t")
		code.append("random = new Random();")
		code.append("\n\t\t")
		code.append("leafValues = random.ints("+number+","+min+","+max+").boxed().collect(Collectors.toList());")
		code.append("\n\t\t")
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues);")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}
	
	def String generateRandomReals(String name, int number, double min, double max) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValues = new ArrayList<Object>();")
		code.append("\n\t\t")
		code.append("random = new Random();")
		code.append("\n\t\t")
		code.append("leafValues = random.doubles("+number+","+min+","+max+").boxed().collect(Collectors.toList());")
		code.append("\n\t\t")
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues);")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}
	
	def String generateLeafValuesInit(String name, Map<String,Double> leafValues) {
		var StringBuilder code = new StringBuilder()
		code.append("leafValuesPsMapList= new ArrayList<Map<String,Double>>();")
		code.append("leafValuesPsMap = new HashMap<String,Double>();")
		code.append("\n\t\t")
		for (i : leafValues.entrySet) {
			code.append("leafValuesPsMap.put(\""+i.key+"\","+i.value+");")
			code.append("\n\t\t")			
		}
		code.append("nodePs = new NodePs(\""+name+"\");")
		code.append("\n\t\t")
		code.append("leafValuesPsMapList.add(leafValuesPsMap);")
		code.append("\n\t\t")
		code.append("nodePs.initLeaf(leafValuesPsMapList);")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodePs"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}
	
	def String generateLeafValuesInit(String name, List<List<Object>> leafValues) {
		var StringBuilder code = new StringBuilder()
		
		code.append("leafValues_2 = new ArrayList<List<Object>>();")
		code.append("\n\t\t")
		for (i : leafValues) {
			code.append("leafValues = new ArrayList<Object>();")
			for (j : i) {
				code.append("leafValues.add("+j+");")
				code.append("\n\t\t")	
			}
			code.append("leafValues_2.add(leafValues);")
		}
		
		code.append("nodeObjectList = new NodeObjectList(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObjectList.initLeaf_2(leafValues_2);")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObjectList"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}
	
	def String generateLeafValuesInit(String name, List<List<Object>> leafValues, int id) {
		var StringBuilder code = new StringBuilder()
		
		code.append("leafValues_2 = new ArrayList<List<Object>>();")
		code.append("\n\t\t")
		for (i : leafValues) {
			code.append("leafValues = new ArrayList<Object>();")
			for (j : i) {
				code.append("leafValues.add("+j+");")
				code.append("\n\t\t")	
			}
			code.append("leafValues_2.add(leafValues);")
		}
		
		code.append("nodeObjectList = new NodeObjectList(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObjectList.initLeaf_2(leafValues_2, "+id+");")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObjectList"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}	
	
	def String generateLeafValuesInitComplexTcl(String name) {
		var StringBuilder code = new StringBuilder()
		
		code.append("leafValues_2 = new ArrayList<List<Object>>();")
		code.append("\n\t\t")
		//for (i : leafValues) {
			code.append("leafValues = new ArrayList<Object>();")
			code.append("dataFromFile = getDataFromFile(\""+name+"\");")
			code.append("for (int i = 0; i < dataFromFile.length; i++) {")
			code.append("leafValues.add(Double.parseDouble(dataFromFile[i]));") // Currently always treated as double
			code.append("}")
			code.append("leafValues_2.add(leafValues);")
		//}
		
		code.append("nodeObjectList = new NodeObjectList(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObjectList.initLeaf_2(leafValues_2);")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObjectList"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}
	
	def String generateLeafValuesInitTcl(String name) {
		var StringBuilder code = new StringBuilder()
		
		code.append("leafValues = new ArrayList<Object>();")
		code.append("dataFromFile = getDataFromFile(\""+name+"\");")
		code.append("for (int i = 0; i < dataFromFile.length; i++) {")
		code.append("leafValues.add(Double.parseDouble(dataFromFile[i]));") // Currently always treated as double
		code.append("}")
		
		code.append("nodeObject = new NodeObject(\""+name+"\");")
		code.append("\n\t\t")
		code.append("nodeObject.initLeaf(leafValues);")
		code.append("\n\t\t")
		code.append("this.NODE_COLLECTION.put(\""+name+"\", nodeObject"+");")
		code.append("\n\t\t")
		code.append("\n\t\t")
		return code.toString
	}	
	
}
