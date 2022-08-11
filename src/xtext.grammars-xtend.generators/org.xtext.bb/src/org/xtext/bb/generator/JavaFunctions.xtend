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

import bbn.NormalizationCOp
import bbn.LinearNormalization
import bbn.Direction
import java.util.List
import java.util.AbstractMap.SimpleEntry

class JavaFunctions {
	
	def String generateGetCartesianProductFunction() {
		
		var StringBuilder code = new StringBuilder()
		
		code.append("List<List<Integer>> getCartesianProduct(ArrayList<Integer> arg, int cnt, List<List<Integer>> input, List<List<Integer>> output) {")
		code.append("\n\t")
		code.append("for (int j = 0; j < input.get(cnt).size(); j++) {")
		code.append("\n\t\t")
		code.append("List<Integer> tmp = new ArrayList<Integer>();")
		code.append("\n\t\t")
        code.append("for (int i = 0; i < cnt; i++) {")
        code.append("\n\t\t\t")
        code.append("tmp.add(arg.get(i));")
        code.append("\n\t\t")
        code.append("}")
 		code.append("\n\t\t")
 		code.append("arg.clear();")
 		code.append("\n\t\t")
 		code.append("arg.addAll(tmp);");
 		code.append("\n\t\t")
        code.append("arg.add(input.get(cnt).get(j));");
        code.append("\n\t\t")
        code.append("if (cnt == input.size()-1) {")
        code.append("\n\t\t\t")
        code.append("output.add(new ArrayList<Integer>());");
        code.append("\n\t\t\t")
        code.append("output.get(output.size()-1).addAll(arg);");
        code.append("\n\t\t")
        code.append("}")
        code.append("\n\t\t")
        code.append("else {")
        code.append("\n\t\t\t")
        code.append("getCartesianProduct(arg, cnt+1, input, output);")
        code.append("\n\t\t")
        code.append("}")
        code.append("\n\t")
        code.append("}")
        code.append("\n\t")
        code.append("return output;")
        code.append("\n")
        code.append("}")
		
		return code.toString;
	}
	
	def String generateIsSAM() {
		
		var StringBuilder code = new StringBuilder()
		
		code.append("boolean isSAM(List<List<List<SimpleEntry<String,Integer>>>> headerList) {")
			code.append("\n\t")
			code.append("List<String> sln = new ArrayList<String>();")
			code.append("\n\t")
			code.append("for (List<List<SimpleEntry<String,Integer>>> i : headerList) {")
				code.append("\n\t\t")
					code.append("for (List<SimpleEntry<String,Integer>> j : i) {")
						code.append("\n\t\t\t")
						code.append("for (SimpleEntry<String,Integer> k : j) {")
							code.append("\n\t\t\t\t")
							code.append("if (!sln.contains(k.getKey())) {")
								code.append("\n\t\t\t\t\t")
								code.append("sln.add(k.getKey());")
							code.append("\n\t\t\t\t")	
							code.append("}")
							code.append("\n\t\t\t\t")
							code.append("else {")
								code.append("\n\t\t\t\t\t")
								code.append("return true;")
							code.append("\n\t\t\t\t")
							code.append("}")
						code.append("\n\t\t\t")		
						code.append("}")
					code.append("\n\t\t")		
					code.append("}")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("return false;")
		code.append("\n")
		code.append("}")
	
		return code.toString
	}
	
	def String generateIsValidCombinationIgnoreResource() {
		
		var StringBuilder code = new StringBuilder
		
		code.append("boolean isValidCombination(List<List<SimpleEntry<String,Integer>>> header) {")
			code.append("\n\t\t")
			code.append("Map<String,Integer> M = new HashMap<String,Integer>();")
			code.append("\n\t\t")
			code.append("for (List<SimpleEntry<String,Integer>> row : header) {")
				code.append("\n\t\t\t")
				code.append("for (SimpleEntry<String,Integer> entry : row) {")
					code.append("\n\t\t\t\t")
					code.append("if (!M.containsKey(entry.getKey())) {")
						code.append("\n\t\t\t\t\t")
						code.append("M.put(entry.getKey(), entry.getValue());")
					code.append("\n\t\t\t\t")
					code.append("}")
					code.append("\n\t\t\t\t")
					code.append("else {")
						code.append("\n\t\t\t\t\t")
						code.append("if (entry.getValue() != M.get(entry.getKey()) && entry.getKey() != \"UNIQUE_RESOURCE_ID\") {")
							code.append("\n\t\t\t\t\t\t")
							code.append("return false;")
						code.append("\n\t\t\t\t\t")
						code.append("}")
					code.append("\n\t\t\t\t")
					code.append("}")
				code.append("\n\t\t\t")
				code.append("}")
			code.append("\n\t\t")	
			code.append("}")
			code.append("\n\t\t")	
			code.append("return true;")
		code.append("\n")
		code.append("}")
		
		return code.toString
	}
	
	def String generateIsValidCombinationConsiderResource() { 
		
		var StringBuilder code = new StringBuilder
		
		code.append("boolean isValidCombination(List<List<SimpleEntry<String,Integer>>> header) {")
			code.append("\n\t\t")
			code.append("List<List<Integer>> indicesLL = new ArrayList<List<Integer>>();")
			code.append("\n\t\t")
			code.append("for (List<SimpleEntry<String,Integer>> row : header) {")
				code.append("\n\t\t\t")
				code.append("List<Integer> indicesL = new ArrayList<Integer>();")
				code.append("\n\t\t\t")
				code.append("for (SimpleEntry<String,Integer> entry : row) {")
					code.append("\n\t\t\t\t")
					code.append("if (entry.getKey() == \"UNIQUE_RESOURCE_ID\") {")
						code.append("\n\t\t\t\t\t")
						code.append("if (!indicesL.contains(entry.getValue())) {")
							code.append("\n\t\t\t\t\t")
							code.append("indicesL.add(entry.getValue());")
						code.append("\n\t\t\t\t")
						code.append("}")
					code.append("\n\t\t\t")
					code.append("}")
				code.append("\n\t\t")	
				code.append("}")
				code.append("\n\t\t")
				code.append("indicesLL.add(indicesL);")
			code.append("\n\t\t")
			code.append("}")
			code.append("\n\t\t")
			code.append("for (int i = 0; i < indicesLL.size(); i++) {")
				code.append("\n\t\t\t")
				code.append("for (int j = 0; j < indicesLL.size(); j++) {")
					code.append("\n\t\t\t\t")
					code.append("if (i != j) {")
						code.append("\n\t\t\t\t\t")
						code.append("for (int k = 0; k < indicesLL.get(i).size(); k++) {")
							code.append("\n\t\t\t\t\t\t")
							code.append("for (int l = 0; l < indicesLL.get(j).size(); l++) {")
								code.append("\n\t\t\t\t\t\t\t")
								code.append("if (indicesLL.get(i).get(k) == indicesLL.get(j).get(l)) {")
									code.append("\n\t\t\t\t\t\t\t\t")
									code.append("return false;")
								code.append("\n\t\t\t\t\t\t\t")
								code.append("}")
							code.append("\n\t\t\t\t\t\t")	
							code.append("}")
						code.append("\n\t\t\t\t\t")	
						code.append("}")
					code.append("\n\t\t\t\t")	
					code.append("}")
				code.append("\n\t\t\t")	
				code.append("}")
			code.append("\n\t\t")	
			code.append("}")
			code.append("\n\t\t")	
			code.append("return true;")
		code.append("\n\t\t")	
		code.append("}")
		
		return code.toString
	}	
	
	def String generateIsValidCombinationInverse() {
		
		var StringBuilder code = new StringBuilder
		
		code.append("boolean isValidCombinationInverse(List<List<SimpleEntry<String,Integer>>> header, String name) {")
			code.append("\n\t\t")
			code.append("int rowc = 0;")
			code.append("\n\t\t")
			code.append("Map<String,Integer> M = new HashMap<String,Integer>();")
			code.append("\n\t\t")
			code.append("Map<String,Integer> M2 = new HashMap<String,Integer>();")
			code.append("\n\t\t")
			code.append("for (List<SimpleEntry<String,Integer>> row : header) {")
				code.append("\n\t\t\t")
				code.append("for (SimpleEntry<String,Integer> entry : row) {")
					code.append("\n\t\t\t\t")
					code.append("if (!M.containsKey(entry.getKey())) {")
						code.append("\n\t\t\t\t\t")
						code.append("M.put(entry.getKey(), entry.getValue());")
						code.append("\n\t\t\t\t\t")
						code.append("M2.put(entry.getKey(), rowc);")
					code.append("\n\t\t\t\t")
					code.append("}")
					code.append("\n\t\t\t\t")
					code.append("else {")
						code.append("\n\t\t\t\t\t")
							code.append("if (M2.get(entry.getKey()) != rowc) {")
								code.append("if (name != entry.getKey() && entry.getValue() != M.get(entry.getKey())) {")
									code.append("\n\t\t\t\t\t\t")
									code.append("return false;")
								code.append("\n\t\t\t\t\t")
								code.append("}")						
								code.append("else if (name == entry.getKey() && entry.getValue() == M.get(entry.getKey())) {")
									code.append("\n\t\t\t\t\t\t")
									code.append("return false;")
								code.append("\n\t\t\t\t\t")
							code.append("}")
						code.append("}")
					code.append("\n\t\t\t\t")
					code.append("}")
				code.append("\n\t\t\t")
				code.append("}")
				code.append("rowc++;")	
			code.append("\n\t\t")	
			code.append("}")
			code.append("\n\t\t")	
			code.append("return true;")
		code.append("\n")
		code.append("}")
		
		return code.toString
	}
	
	def String generateIsValidCombinationMerge() {
		var StringBuilder code = new StringBuilder
		
		code.append("boolean isValidCombinationMerge(List<List<SimpleEntry<String,Integer>>> header) {")
		code.append("\n\t\t")
		code.append("int rowc = 0;")
		code.append("\n\t\t")
		code.append("Map<String,Set<Integer>> M = new HashMap<String,Set<Integer>>();")
		code.append("\n\t\t")
		code.append("Map<String,Integer> M2 = new HashMap<String,Integer>();")
		code.append("\n\t\t")
		code.append("Map<String,List<Integer>> M3 = new HashMap<String,List<Integer>>();")
		code.append("\n\t\t")
		code.append("for (List<SimpleEntry<String,Integer>> row : header) {")
            code.append("\n\t\t\t")
			code.append("for (SimpleEntry<String,Integer> entry : row) {")
                code.append("\n\t\t\t\t")
				code.append("if (!M.containsKey(entry.getKey())) {")
                    code.append("\n\t\t\t\t\t")
					code.append("Set<Integer> set = new HashSet<Integer>();")
					code.append("set.add(entry.getValue());")
					code.append("M.put(entry.getKey(), set);")
					code.append("M2.put(entry.getKey(), rowc);")
                code.append("\n\t\t\t\t")
				code.append("}")
				code.append("else {")
                    code.append("\n\t\t\t\t\t")
					code.append("Set<Integer> set2 = M.get(entry.getKey());")
					code.append("if (M2.get(entry.getKey()) == rowc) {")
                        code.append("\n\t\t\t\t\t\t")
						code.append("set2.add(entry.getValue());")
						code.append("M.put(entry.getKey(), set2);")
					code.append("\n\t\t\t\t\t")
					code.append("}")
					code.append("\n\t\t\t\t\t")
					code.append("else {")
                        code.append("\n\t\t\t\t\t\t")
						code.append("if (!set2.contains(entry.getValue())) {")
                            code.append("\n\t\t\t\t\t\t")
							code.append("return false;")
                        code.append("\n\t\t\t\t\t\t")
						code.append("}")
					code.append("\n\t\t\t\t\t\t")
					code.append("}")
                code.append("\n\t\t\t\t")
                code.append("}")
            code.append("\n\t\t\t")
            code.append("}")
            code.append("rowc++;")
        code.append("\n\t\t")
        code.append("}")
        code.append("return true;")
	 code.append("}")
		
		return code.toString
	}
	
	def String generateIsValidCombinationIgnore() {
		
		var StringBuilder code = new StringBuilder
		
		code.append("boolean isValidCombinationIgnore(List<List<SimpleEntry<String,Integer>>> header) {")
            code.append("\n\t\t")
            code.append("int rowc = 0;")
            code.append("\n\t\t")
            code.append("Map<String,Integer> M = new HashMap<String,Integer>();")
            code.append("\n\t\t")
            code.append("Map<String,Integer> M2 = new HashMap<String,Integer>();")
            code.append("\n\t\t")
            code.append("for (List<SimpleEntry<String,Integer>> row : header) {")
                code.append("\n\t\t\t")
                code.append("for (SimpleEntry<String,Integer> entry : row) {")
                    code.append("\n\t\t\t\t")
                    code.append("if (!M.containsKey(entry.getKey())) {")
                        code.append("\n\t\t\t\t\t")
                        code.append("M.put(entry.getKey(), entry.getValue());")
                        code.append("M2.put(entry.getKey(), rowc);")
                    code.append("\n\t\t\t\t")
                    code.append("}")
                    code.append("\n\t\t\t\t")
                    code.append("else {")
                        code.append("\n\t\t\t\t\t")
                        code.append("if (M2.get(entry.getKey()) != rowc) {")
                            code.append("\n\t\t\t\t\t\t")
                            code.append("if (entry.getValue() != M.get(entry.getKey())) {")
                                code.append("\n\t\t\t\t\t\t")
                                code.append("return false;")
                            code.append("\n\t\t\t\t\t\t")
                            code.append("}")
                        code.append("\n\t\t\t\t\t\t")
                        code.append("}")
                    code.append("\n\t\t\t\t")
                    code.append("}")
                code.append("\n\t\t\t")
                code.append("}")
                code.append("rowc++;")
            code.append("\n\t\t")    
            code.append("}")
            code.append("return true;")
        code.append("\n\t")
		code.append("}")
		
		return code.toString
	}	
	
	def String generateIsDominated() {
		
		var StringBuilder code = new StringBuilder()
		
		code.append("\n\t")
		code.append("Boolean isDominated(List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> F, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> S, List<Boolean> Max) {")
			code.append("\n\t\t")
			code.append("for (int i = 0; i < F.size(); i++) {") 
				code.append("\n\t\t\t")
				code.append("if (Max.get(i)) {")
					code.append("\n\t\t\t\t")
					code.append("if (((Number)F.get(i).getValue()).doubleValue() > ((Number)S.get(i).getValue()).doubleValue()) {")
						code.append("\n\t\t\t\t\t")
						code.append("return false;")
					code.append("\n\t\t\t\t")
					code.append("}")
				code.append("\n\t\t\t")
				code.append("}")
				code.append("else {")
					code.append("\n\t\t\t\t")
					code.append("if (((Number)F.get(i).getValue()).doubleValue() < ((Number)S.get(i).getValue()).doubleValue()) {")
						code.append("\n\t\t\t\t\t")
						code.append("return false;")
					code.append("\n\t\t\t\t")
					code.append("}")
				code.append("\n\t\t\t")
				code.append("}")
			code.append("\n\t\t") 
			code.append("}")
			code.append("\n\t\t") 
			code.append("return true;")
		code.append("\n\t")
		code.append("}")
		
		return code.toString
	}
		
	
	
	def String generateMaxFunction() {
		var StringBuilder code = new StringBuilder()
		code.append("double max(List<Object> list) {")
		code.append("\n\t\t")
			code.append("double max = Double.NEGATIVE_INFINITY;")
			code.append("\n\t\t\t")
			code.append("for (int i = 0; i < list.size(); i++) {")
				code.append("\n\t\t\t\t")
				code.append("if (((Number)list.get(i)).doubleValue() > max) {")
					code.append("\n\t\t\t\t\t")
					code.append("max = ((Number)list.get(i)).doubleValue();")
				code.append("\n\t\t\t\t")
				code.append("}")
			code.append("\n\t\t\t")
			code.append("}")
		code.append("\n\t\t")
		code.append("return max;")
		code.append("\n\t\t")
		code.append("}")
		return code.toString()
	}
	
	def String generateMinFunction() {
		var StringBuilder code = new StringBuilder()
		code.append("double min(List<Object> list) {")
		code.append("\n\t\t")
			code.append("double min = Double.POSITIVE_INFINITY;")
			code.append("\n\t\t\t")
			code.append("for (int i = 0; i < list.size(); i++) {")
				code.append("\n\t\t\t\t")
				code.append("if (((Number)list.get(i)).doubleValue() < min) {")
					code.append("\n\t\t\t\t\t")
					code.append("min = ((Number)list.get(i)).doubleValue();")
				code.append("\n\t\t\t\t")
				code.append("}")
			code.append("\n\t\t\t")
			code.append("}")
		code.append("\n\t\t")
		code.append("return min;")
		code.append("\n\t\t")
		code.append("}")
		return code.toString()
	}
	
	def String generateHeaderRow() {
		
		var StringBuilder code = new StringBuilder()
		
		code.append("\n\t\t\t")
		code.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();")
		code.append("\n\t\t\t")
		code.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(j).name(),cp.get(i).get(j)));")
		code.append("\n\t\t\t")
		code.append("if (I.get(j).header(cp.get(i).get(j)) != null) {")
			code.append("\n\t\t\t\t")
			code.append("List<List<SimpleEntry<String,Integer>>> htmp = I.get(j).header(cp.get(i).get(j));")
			code.append("for (List<SimpleEntry<String,Integer>> row : htmp) {")
				code.append("\n\t\t\t\t\t")
				code.append("for (SimpleEntry<String,Integer> entry : row) {")
					code.append("\n\t\t\t\t\t\t")
					code.append("headerRow.add(entry);")
				code.append("\n\t\t\t\t\t")	
				code.append("}")
			code.append("\n\t\t\t\t")	
			code.append("}")
		code.append("\n\t\t\t")	
		code.append("}")
		code.append("\n\t\t\t")
		code.append("header.add(headerRow);")
		
		
		return code.toString
	}
	
	def String generateHeaderRow(int nodeIndex, int slotIndex) {
		
		var StringBuilder code = new StringBuilder()
		
		code.append("\n\t")
		code.append("headerRow = new ArrayList<SimpleEntry<String,Integer>>();")
		code.append("\n\t")
		code.append("headerRow.add(new SimpleEntry<String,Integer>(I.get("+nodeIndex+").name(),"+slotIndex+"));")
		code.append("\n\t")
		code.append("if (I.get("+nodeIndex+").header("+slotIndex+") != null) {")
			code.append("\n\t\t")
			code.append("htmp = I.get("+nodeIndex+").header("+slotIndex+");")
			code.append("for (List<SimpleEntry<String,Integer>> row : htmp) {")
				code.append("\n\t\t\t")
				code.append("for (SimpleEntry<String,Integer> entry : row) {")
					code.append("\n\t\t\t\t")
					code.append("headerRow.add(entry);")
				code.append("\n\t\t\t")	
				code.append("}")
			code.append("\n\t\t")	
			code.append("}")
		code.append("\n\t")	
		code.append("}")
		code.append("\n\t")
		code.append("header.add(headerRow);")
		
		return code.toString
	}		
	
	def String resolveParetoFilter(String name, List<Boolean> max, boolean check) {
		
		var StringBuilder code = new StringBuilder()
		
		code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>>")
		code.append(" ")
		code.append(name)
		code.append("(")
		code.append("List<Node>")
		code.append(" ")
		code.append("I")

		code.append(") {")
			code.append("\n\t")
			if (check) {
				code.append("List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();")
				code.append("\n\t")
				code.append("for (int i = 0; i < I.size(); i++) {")
					code.append("\n\t\t")
					code.append("if (I.get(i).header(0) != null) {")
						code.append("\n\t\t\t")	
						code.append("headerList.add(I.get(i).header(0));")
					code.append("\n\t\t")
					code.append("}")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				code.append("if (headerList.size() > 0 && !isSAM(headerList)) {")
					code.append("\n\t\t")
					code.append("System.err.println(\"ERROR: There is no SAM-Situation for Contradiction pattern "+name+"!\");")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				/*code.append("else {")
					code.append("\n\t\t")
					code.append("System.out.println(\"No SAM-Situation!\");")
				code.append("\n\t")
				code.append("}")*/
			}
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcomb = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>>();")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcombpf = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>>();")
			code.append("\n\t")
			code.append("double newValue = 0.0;")
			code.append("\n\t")
			code.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();")
			code.append("\n\t")
			code.append("for (Node i : I) {")
				code.append("\n\t\t")
				code.append("List<Integer> tmp = new ArrayList<Integer>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < i.vsp().size(); j++) {")
					code.append("\n\t\t\t")
					code.append("tmp.add(j);")
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t")
				code.append("ir.add(tmp);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());")
			code.append("\n\t")
			code.append("for (int i = 0; i < cp.size(); i++) {")
				code.append("\n\t\t")
				code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> T = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
				code.append("\n\t\t")
				code.append("newValue = 0.0;")
				code.append("\n\t\t")
				code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < cp.get(i).size(); j++) {")
					code.append(generateHeaderRow)
				code.append("\n\t\t")
				code.append("T.add(I.get(j).slot(cp.get(i).get(j)));")
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t")
				code.append("if (isValidCombination(header)) {")
					code.append("\n\t\t\t")
					code.append("vcomb.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>(header,T));")
				code.append("\n\t\t\t")
				code.append("}")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")

			code.append("List<Boolean> max = new ArrayList<Boolean>();")
			code.append("\n\t")
			
			for(var int i = 0; i < max.size; i++) {
				code.append("max.add("+max.get(i)+");")
				code.append("\n\t")
			}
			/*code.append("for (int i = 0; i < I.size()-1; i++) {")
				code.append("\n\t\t")
				code.append("max.add(true);")
			code.append("\n\t")
			code.append("}")*/
			
			code.append("List<Boolean> isDominated = new ArrayList<Boolean>();")
			code.append("\n\t")
			code.append("for (int i = 0; i < vcomb.size(); i++) {")
				code.append("\n\t\t")
				code.append("isDominated.add(false);")
			code.append("\n\t")
			code.append("}")
			
			code.append("\n\t")			
			code.append("for (int i = 0; i < vcomb.size(); i++) {")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < vcomb.size(); j++) {")
					code.append("\n\t\t\t")
					code.append("if (i != j && !isDominated.get(i)) {")
						code.append("\n\t\t\t\t")
						code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> tmp_1 = new ArrayList<>(vcomb.get(i).getValue());")
						code.append("\n\t\t\t\t")
						code.append("tmp_1.remove(tmp_1.size()-1);")
						code.append("\n\t\t\t\t")
						code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> tmp_2 = new ArrayList<>(vcomb.get(j).getValue());")
						code.append("\n\t\t\t\t")
						code.append("tmp_2.remove(tmp_2.size()-1);")
						code.append("\n\t\t\t\t")
						code.append("if (isDominated(tmp_1,tmp_2,max)) {")
							code.append("\n\t\t\t\t\t")
							code.append("isDominated.set(i,true);")
						code.append("\n\t\t\t\t")
						code.append("}")
					code.append("\n\t\t\t")
					code.append("}")
				code.append("\n\t\t")
				code.append("}")
			code.append("\n\t")	
			code.append("}")
			code.append("\n\t")	
			code.append("for (int i = 0; i < isDominated.size(); i++) {")
				code.append("\n\t\t")	
				code.append("if (!isDominated.get(i)) {")
					code.append("\n\t\t\t")	
					code.append("vcombpf.add(vcomb.get(i));")
				code.append("\n\t\t")
				code.append("}")
			code.append("\n\t")	
			code.append("}")
			code.append("\n\t")	
			code.append("return vcombpf;")
			code.append("\n\t")
			
		code.append("\n")
		code.append("}")
		
		return code.toString
	}
	
	def String resolveTransformation(String name, NormalizationCOp nf) {
		
		var StringBuilder code = new StringBuilder();
	
		code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>")
		code.append(" ")
		code.append(name)
		code.append("(")
		code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>")
		code.append(" ")
		code.append("I")
		code.append(") {")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
			code.append("\n\t")
			code.append("Object newValue = 0.0;")
			code.append("\n\t")
			code.append("List<Double> s = new ArrayList<Double>();")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsptmp = I;")
			code.append("\n\t")
			
			code.append("for (int i = 0; i < vsptmp.size(); i++) {")
				code.append("\n\t\t")
				code.append("s.add(((Number)vsptmp.get(i).getValue()).doubleValue());")
			code.append("\n\t")
			code.append("}")

			code.append("for (int i = 0; i < vsptmp.size(); i++) {")
				code.append("\n\t\t")
				if (nf instanceof LinearNormalization) {
					if (nf.min === null && nf.max === null) {
						code.append("double num = Collections.max(s)-((Number)vsptmp.get(i).getValue()).doubleValue();")
						code.append("\n\t\t\t")
						code.append("double den = Collections.max(s)-Collections.min(s);")
						code.append("\n\t\t\t")
					}
					else if (nf.min !== null && nf.max === null) {
						code.append("double num = Collections.max(s)-((Number)vsptmp.get(i).getValue()).doubleValue();")
						code.append("\n\t\t\t")
						code.append("double den = Collections.max(s)-"+nf.min.value.toString+";")
						code.append("\n\t\t\t")
					}
					else if (nf.min === null && nf.max !== null) {
						code.append("double num = "+nf.max.value.toString+"-((Number)vsptmp.get(i).getValue()).doubleValue();")
						code.append("\n\t\t\t")
						code.append("double den = "+nf.max.value.toString+"-Collections.min(s);")
						code.append("\n\t\t\t")	
					}
					else {
						code.append("double num = "+nf.max.value.toString+"-((Number)vsptmp.get(i).getValue()).doubleValue();")
						code.append("\n\t\t\t")
						code.append("double den = "+nf.max.value.toString+"-"+nf.min.value.toString+";")
						code.append("\n\t\t\t")
					}
					
					if (nf.direction == Direction.DEC) {
						code.append("newValue = num/den;")
					}
					else {
						code.append("newValue = 1-(num/den);")
					}
				}
				
				code.append("\n\t\t\t")
				code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(null, newValue));")
			code.append("\n\t")
			code.append("}")
			code.append("return ovsp;")
		code.append("\n")
		code.append("}")
		
		return code.toString
		
	}
	
	def String generateCallSequenceCode(String name, List<bbn.DVGPort> inputSet) {
		
		var StringBuilder code = new StringBuilder()
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
	
		return code.toString
	}	
	
	def String generateCallSequenceCode(String name, List<bbn.DVGPort> inputSet, List<List<SimpleEntry<bbn.AbstractOutputPort,String>>> allocInputSet, List<Boolean> isAlloc) {
		
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
	
	def String generateCallSequenceCodeAg(String name, List<List<bbn.DVGPort>> inputSet) {
		
		var StringBuilder code = new StringBuilder()
		code.append("params_2d = new ArrayList<List<Node>>();")
		code.append("\n\t\t")
		for (var int i = 0; i < inputSet.size; i++) {
			code.append("params = new ArrayList<Node>();")
			for (var int j = 0; j < inputSet.get(i).size; j++) {
				code.append("params.add(this.NODE_COLLECTION.get(\""+inputSet.get(i).get(j).name+"\"));")
				code.append("\n\t\t")
			}
			code.append("params_2d.add(params);")
			code.append("\n\t\t")
		}
		code.append("resolve_"+name+"(params_2d);")
		code.append("\n\t\t")
		code.append("\n\t\t")
	
		return code.toString
	}
	
	
	
}
