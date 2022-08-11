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
import java.util.Map

class FinalEvaluation {
	
	def String getNonSoSCode(String name, Map<String, Integer> active, Map<String, Integer> passive, StringBuilder to_tcl) {
		var StringBuilder code = new StringBuilder()

				code.append("\n\t\t")
				code.append("Map<String, Integer> active = new HashMap<String, Integer>();")
				code.append("\n\t\t")
				code.append("Map<String, Integer> passive = new HashMap<String, Integer>();")			
				
				for (i : active.entrySet) {
					code.append("active.put(\""+i.key+"\","+i.value+");")
					code.append("\n\t\t")
				}
	
				for (i : passive.entrySet) {
					code.append("passive.put(\""+i.key+"\","+i.value+");")
					code.append("\n\t\t")
				}			
				
				code.append("\n\t\t")
				code.append("Map<String, List<Object>> TO_TCL = new HashMap<String, List<Object>>();")
				code.append("\n\t\t")
				code.append("List<Object> l;")
				code.append("\n\t\t")
				code.append(to_tcl)			
				
				code.append("\n\t\t")
				code.append("Node result = NODE_COLLECTION.get(\""+name+"\");")
				code.append("\n\t\t")
				code.append("int cnt = 0;")
				code.append("\n\t\t")
				code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> rtmp = result.vsp();")			
				code.append("\n\t\t")
				code.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> maxSlot = null;")
				code.append("\n\t\t")
				code.append("double maxValue = 0.0;")
				code.append("\n\t\t")
				code.append("int maxIndex = 0;")
				code.append("\n\t\t")			
				code.append("for (SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> i : rtmp) {")
								
					code.append("\n\t\t")
					code.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();")
					code.append("\n\t\t")
					code.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();")		
					
					code.append("\n\t\t")
					code.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();")
					code.append("\n\t\t")
					code.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();")					
					
					code.append("\n\t\t\t")
					code.append("List<List<SimpleEntry<String,Integer>>> header = i.getKey();")
					code.append("\n\t\t\t")
					code.append("for (List<SimpleEntry<String,Integer>> headerRow : header) {")
						code.append("\n\t\t\t\t")
						code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
							code.append("\n\t\t\t\t\t")
							code.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());")
							code.append("\n\t\t\t\t\t")
							code.append("System.out.print(\"\t\");")
				
				
							code.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {")
								code.append("\n\t\t\t\t\t")
								code.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
								code.append("\n\t\t\t\t\t")
								code.append("AflagLeaf.put(headerEntry.getKey(),true);")
							code.append("\n\t\t\t\t")
							code.append("}")
							
							code.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {")
								code.append("\n\t\t\t\t\t")
								code.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
								code.append("\n\t\t\t\t\t")
								code.append("PflagLeaf.put(headerEntry.getKey(),true);")
							code.append("\n\t\t\t\t")
							code.append("}")										
							
						code.append("\n\t\t\t\t")
						code.append("}")
						code.append("\n\t\t\t\t")
						code.append("System.out.println();")
					code.append("\n\t\t\t")
					code.append("}")
	
					code.append("System.out.println(\"################## ACTIVE VARIANT: \");")
					code.append("\n\t\t")
					code.append("for (int j = 0; j < AleafNamesAndIndices.size(); j++) {")
						code.append("\n\t\t\t")
						code.append("System.out.println(AleafNamesAndIndices.get(j).getKey() + \": \" + AleafNamesAndIndices.get(j).getValue());")
					code.append("\n\t\t")
					code.append("}")	
	
					code.append("System.out.println(\"################## FOR PASSIVE STATES: \");")
					code.append("\n\t\t")
					code.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {")
						code.append("\n\t\t\t")
						code.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());")
					code.append("\n\t\t")
					code.append("}")		
	
					
				code.append("\n\t\t")
				code.append("System.out.println(\"=================> [\"+cnt+\", \"+i.getValue()+\"]\");")
				code.append("\n\t\t")
				code.append("System.out.println(\"------------------------------------\");")
			
				
				code.append("\n\t\t")
				code.append("if (((Number)i.getValue()).doubleValue() > maxValue) {")
					code.append("\n\t\t\t")
					code.append("maxValue = ((Number)i.getValue()).doubleValue();")
					code.append("\n\t\t\t")
					code.append("maxSlot = i;")
					code.append("\n\t\t\t")
					code.append("maxIndex = cnt;")				
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t")
				code.append("cnt++;")
				code.append("\n\t\t")
				code.append("}")
				
				code.append("\n\t\t")
				code.append("System.out.println(\"\");")
				code.append("\n\t\t")
				code.append("System.out.println(\"\");")
				//code.append("\n\t\t")
				//code.append("System.out.println(\"MaxSlot with MaxValue \"+maxSlot.getValue()+\":\");")
				code.append("\n\t\t")
				code.append("System.out.println(\"====================== Final Result ====================== \");")
				code.append("\n\t\t")
				code.append("for (List<SimpleEntry<String,Integer>> headerRow : maxSlot.getKey()) {")
					code.append("\n\t\t\t")
					code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
						code.append("\n\t\t\t\t")
						code.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());")
						code.append("\n\t\t\t\t")
						code.append("System.out.print(\"\t\");")
					code.append("\n\t\t\t")
					code.append("}")
					code.append("\n\t\t\t")
					code.append("System.out.println();")
				code.append("\n\t\t")
				code.append("}")
				
				code.append("\n\t\t")
				
				code.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();")
				code.append("\n\t\t")
				code.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();")
				code.append("\n\t\t")
				code.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();")
				code.append("\n\t\t")
				code.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();")
				code.append("\n\t\t")			
				code.append("for (List<SimpleEntry<String,Integer>> headerRow : maxSlot.getKey()) {")
					code.append("\n\t\t\t")
					code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
						code.append("\n\t\t\t\t")
							
							code.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {")
								code.append("\n\t\t\t\t\t")
								code.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
								code.append("\n\t\t\t\t\t")
								code.append("AflagLeaf.put(headerEntry.getKey(),true);")
							code.append("\n\t\t\t\t")
							code.append("}")
	
							code.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {")
								code.append("\n\t\t\t\t\t")
								code.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
								code.append("\n\t\t\t\t\t")
								code.append("PflagLeaf.put(headerEntry.getKey(),true);")
							code.append("\n\t\t\t\t")
							code.append("}")						
												
					code.append("\n\t\t\t")
					code.append("}")
				code.append("\n\t\t")
				code.append("}")			
				
				code.append("System.out.println(\"################## MAX ACTIVE VARIANT: \");")
				code.append("\n\t\t")
				code.append("for (int i = 0; i < AleafNamesAndIndices.size(); i++) {")
				
					code.append("if (TO_TCL.containsKey(AleafNamesAndIndices.get(i).getKey())) {\n")
					
					code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> lse = this.NODE_COLLECTION.get(AleafNamesAndIndices.get(i).getKey()).vsp();\n")
					code.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> se = lse.get(AleafNamesAndIndices.get(i).getValue());\n")
					
					code.append("String outString = \"(tcl-kb-update :key '(is-a name instance) :value '((is-a dvgConfig)(name \"+TO_TCL.get(AleafNamesAndIndices.get(i).getKey()).get(0)+\")(instance \"+TO_TCL.get(AleafNamesAndIndices.get(i).getKey()).get(1)+\")(value \"+se.getValue()+\")))\";\n")
	
				    code.append("try {\n")
				        code.append("FileWriter myWriter = new FileWriter(\"smartSoftConfig.txt\", true);\n")
				        code.append("myWriter.write(outString+\"\\n\");\n")
				        code.append("myWriter.close();\n")
				        //code.append("System.out.println(\"Successfully wrote to the file.\");\n");
				      	code.append("} catch (IOException e) {\n")
				        code.append("System.out.println(\"An error occurred.\");\n")
				        code.append("e.printStackTrace();\n")
				      code.append("}\n")
				code.append("}\n")
				
					code.append("\n\t\t\t")
					code.append("System.out.println(AleafNamesAndIndices.get(i).getKey() + \": \" + AleafNamesAndIndices.get(i).getValue());")
				code.append("\n\t\t")
				code.append("}")
	
				code.append("System.out.println(\"################## FOR IDEAL PASSIVE STATES: \");")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {")
					code.append("\n\t\t\t")
					code.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());")
				code.append("\n\t\t")
				code.append("}")					
				
				code.append("\n\t\t")
				code.append("System.out.println(\"=================> [\"+maxIndex+\", \"+maxSlot.getValue()+\"]\");")	
	
				code.append("\n\t\t")
	
				code.append("if (maxValue > prevValue) {")
				code.append("\n\t\t")
				code.append("solution = allocation;")
				code.append("\n\t\t")
				code.append("prevValue = maxValue;")
				code.append("\n\t\t")
				code.append("solutionSlot = maxSlot;")
				code.append("\n\t\t")
				code.append("solutionIndex = maxIndex;")
				code.append("\n\t\t")
				code.append("}")
	
				code.append("}") // End of allocation loop	
	
				code.append("\n\t\t")
	
				code.append("System.out.println(\"Best allocation is: \" + solution);");
				code.append("\n\t\t")	
	
				code.append("Map<String, Integer> active = new HashMap<String, Integer>();")
				code.append("\n\t\t")
				code.append("Map<String, Integer> passive = new HashMap<String, Integer>();")
				code.append("\n\t\t")
	
				code.append("\n\t\t")
				code.append("System.out.println(\"\");")
				code.append("\n\t\t")
				code.append("System.out.println(\"\");")
				//code.append("\n\t\t")
				//code.append("System.out.println(\"MaxSlot with MaxValue \"+maxSlot.getValue()+\":\");")
				code.append("\n\t\t")
				code.append("System.out.println(\"====================== Final Result ====================== \");")
				code.append("\n\t\t")
				code.append("for (List<SimpleEntry<String,Integer>> headerRow : solutionSlot.getKey()) {")
					code.append("\n\t\t\t")
					code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
						code.append("\n\t\t\t\t")
						code.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());")
						code.append("\n\t\t\t\t")
						code.append("System.out.print(\"\t\");")
					code.append("\n\t\t\t")
					code.append("}")
					code.append("\n\t\t\t")
					code.append("System.out.println();")
				code.append("\n\t\t")
				code.append("}")
				
				code.append("\n\t\t")
				
				code.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();")
				code.append("\n\t\t")
				code.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();")
				code.append("\n\t\t")
				code.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();")
				code.append("\n\t\t")
				code.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();")
				code.append("\n\t\t")			
				code.append("for (List<SimpleEntry<String,Integer>> headerRow : solutionSlot.getKey()) {")
					code.append("\n\t\t\t")
					code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
						code.append("\n\t\t\t\t")
							
							code.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {")
								code.append("\n\t\t\t\t\t")
								code.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
								code.append("\n\t\t\t\t\t")
								code.append("AflagLeaf.put(headerEntry.getKey(),true);")
							code.append("\n\t\t\t\t")
							code.append("}")
	
							code.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {")
								code.append("\n\t\t\t\t\t")
								code.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
								code.append("\n\t\t\t\t\t")
								code.append("PflagLeaf.put(headerEntry.getKey(),true);")
							code.append("\n\t\t\t\t")
							code.append("}")						
												
					code.append("\n\t\t\t")
					code.append("}")
				code.append("\n\t\t")
				code.append("}")			
				
				code.append("System.out.println(\"################## MAX ACTIVE VARIANT: \");")
				code.append("\n\t\t")
				code.append("for (int i = 0; i < AleafNamesAndIndices.size(); i++) {")
				
					code.append("\n\t\t\t")
					code.append("System.out.println(AleafNamesAndIndices.get(i).getKey() + \": \" + AleafNamesAndIndices.get(i).getValue());")
				code.append("\n\t\t")
				code.append("}")
	
				code.append("System.out.println(\"################## FOR IDEAL PASSIVE STATES: \");")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {")
					code.append("\n\t\t\t")
					code.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());")
				code.append("\n\t\t")
				code.append("}")					
				
				code.append("\n\t\t")
				code.append("System.out.println(\"=================> [\"+solutionIndex+\", \"+solutionSlot.getValue()+\"]\");")	
	
				code.append("\n\t\t")		
		
		return code.toString()
	}
	
	def String getSoSCode() {
		var StringBuilder code = new StringBuilder()
		code.append("\n\t")
		code.append("\n\t")
		code.append("return this.NODE_COLLECTION.get(name);")
		code.append("\n\t")
		return code.toString()
	}
	
	def static String getEQUFCode(String name, Map<String, Integer> active, Map<String, Integer> passive) {
		var StringBuilder code = new StringBuilder()
		
		code.append("\n\t\t")
		code.append("Map<String, Integer> active = new HashMap<String, Integer>();")
		code.append("\n\t\t")
		code.append("Map<String, Integer> passive = new HashMap<String, Integer>();")			
		
		for (i : active.entrySet) {
			code.append("active.put(\""+i.key+"\","+i.value+");")
			code.append("\n\t\t")
		}

		for (i : passive.entrySet) {
			code.append("passive.put(\""+i.key+"\","+i.value+");")
			code.append("\n\t\t")
		}			
		
		code.append("\n\t\t")
		code.append("Map<String, List<Object>> TO_TCL = new HashMap<String, List<Object>>();")
		code.append("\n\t\t")
		code.append("List<Object> l;")
		code.append("\n\t\t")		
		
		code.append("\n\t\t")
		code.append("Node result = NODE_COLLECTION.get(\""+name+"\");")
		code.append("\n\t\t")
		code.append("int cnt = 0;")
		code.append("\n\t\t")
		code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> rtmp = result.vsp();")			
		code.append("\n\t\t")
		code.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> maxSlot = null;")
		code.append("\n\t\t")
		code.append("double maxValue = 0.0;")
		code.append("\n\t\t")
		code.append("int maxIndex = 0;")
		code.append("\n\t\t")			
		code.append("for (SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> i : rtmp) {")
						
			code.append("\n\t\t")
			code.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();")
			code.append("\n\t\t")
			code.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();")		
			
			code.append("\n\t\t")
			code.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();")
			code.append("\n\t\t")
			code.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();")					
			
			code.append("\n\t\t\t")
			code.append("List<List<SimpleEntry<String,Integer>>> header = i.getKey();")
			code.append("\n\t\t\t")
			code.append("for (List<SimpleEntry<String,Integer>> headerRow : header) {")
				code.append("\n\t\t\t\t")
				code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
					code.append("\n\t\t\t\t\t")
					code.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());")
					code.append("\n\t\t\t\t\t")
					code.append("System.out.print(\"\t\");")
		
		
					code.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {")
						code.append("\n\t\t\t\t\t")
						code.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
						code.append("\n\t\t\t\t\t")
						code.append("AflagLeaf.put(headerEntry.getKey(),true);")
					code.append("\n\t\t\t\t")
					code.append("}")
					
					code.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {")
						code.append("\n\t\t\t\t\t")
						code.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
						code.append("\n\t\t\t\t\t")
						code.append("PflagLeaf.put(headerEntry.getKey(),true);")
					code.append("\n\t\t\t\t")
					code.append("}")										
					
				code.append("\n\t\t\t\t")
				code.append("}")
				code.append("\n\t\t\t\t")
				code.append("System.out.println();")
			code.append("\n\t\t\t")
			code.append("}")

			code.append("System.out.println(\"################## ACTIVE VARIANT: \");")
			code.append("\n\t\t")
			code.append("for (int j = 0; j < AleafNamesAndIndices.size(); j++) {")
				code.append("\n\t\t\t")
				code.append("System.out.println(AleafNamesAndIndices.get(j).getKey() + \": \" + AleafNamesAndIndices.get(j).getValue());")
			code.append("\n\t\t")
			code.append("}")	

			code.append("System.out.println(\"################## FOR PASSIVE STATES: \");")
			code.append("\n\t\t")
			code.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {")
				code.append("\n\t\t\t")
				code.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());")
			code.append("\n\t\t")
			code.append("}")		

			
		code.append("\n\t\t")
		code.append("System.out.println(\"=================> [\"+cnt+\", \"+i.getValue()+\"]\");")
		code.append("\n\t\t")
		code.append("System.out.println(\"------------------------------------\");")
	
		
		code.append("\n\t\t")
		code.append("if (((Number)i.getValue()).doubleValue() > maxValue) {")
			code.append("\n\t\t\t")
			code.append("maxValue = ((Number)i.getValue()).doubleValue();")
			code.append("\n\t\t\t")
			code.append("maxSlot = i;")
			code.append("\n\t\t\t")
			code.append("maxIndex = cnt;")				
		code.append("\n\t\t")
		code.append("}")
		code.append("\n\t\t")
		code.append("cnt++;")
		code.append("\n\t\t")
		code.append("}")
		
		code.append("\n\t\t")
		code.append("System.out.println(\"\");")
		code.append("\n\t\t")
		code.append("System.out.println(\"\");")
		//code.append("\n\t\t")
		//code.append("System.out.println(\"MaxSlot with MaxValue \"+maxSlot.getValue()+\":\");")
		code.append("\n\t\t")
		code.append("System.out.println(\"====================== Final Result ====================== \");")
		code.append("\n\t\t")
		code.append("for (List<SimpleEntry<String,Integer>> headerRow : maxSlot.getKey()) {")
			code.append("\n\t\t\t")
			code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
				code.append("\n\t\t\t\t")
				code.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());")
				code.append("\n\t\t\t\t")
				code.append("System.out.print(\"\t\");")
			code.append("\n\t\t\t")
			code.append("}")
			code.append("\n\t\t\t")
			code.append("System.out.println();")
		code.append("\n\t\t")
		code.append("}")
		
		code.append("\n\t\t")
		
		code.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();")
		code.append("\n\t\t")
		code.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();")
		code.append("\n\t\t")
		code.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();")
		code.append("\n\t\t")
		code.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();")
		code.append("\n\t\t")			
		code.append("for (List<SimpleEntry<String,Integer>> headerRow : maxSlot.getKey()) {")
			code.append("\n\t\t\t")
			code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
				code.append("\n\t\t\t\t")
					
					code.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {")
						code.append("\n\t\t\t\t\t")
						code.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
						code.append("\n\t\t\t\t\t")
						code.append("AflagLeaf.put(headerEntry.getKey(),true);")
					code.append("\n\t\t\t\t")
					code.append("}")

					code.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {")
						code.append("\n\t\t\t\t\t")
						code.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
						code.append("\n\t\t\t\t\t")
						code.append("PflagLeaf.put(headerEntry.getKey(),true);")
					code.append("\n\t\t\t\t")
					code.append("}")						
										
			code.append("\n\t\t\t")
			code.append("}")
		code.append("\n\t\t")
		code.append("}")			
		
		code.append("System.out.println(\"################## MAX ACTIVE VARIANT: \");")
		code.append("\n\t\t")
		code.append("for (int i = 0; i < AleafNamesAndIndices.size(); i++) {")
			code.append("\n\t\t\t")
			code.append("System.out.println(AleafNamesAndIndices.get(i).getKey() + \": \" + AleafNamesAndIndices.get(i).getValue());")
		code.append("\n\t\t")
		code.append("}")

		code.append("System.out.println(\"################## FOR IDEAL PASSIVE STATES: \");")
		code.append("\n\t\t")
		code.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {")
			code.append("\n\t\t\t")
			code.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());")
		code.append("\n\t\t")
		code.append("}")					
		
		code.append("\n\t\t")
		code.append("System.out.println(\"=================> [\"+maxIndex+\", \"+maxSlot.getValue()+\"]\");")	

		code.append("\n\t\t")
		
		return code.toString()
	}
	
}
