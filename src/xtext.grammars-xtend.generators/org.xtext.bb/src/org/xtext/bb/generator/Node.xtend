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

class Node {
	
	def String generateNodeClassCode() {
		
		var StringBuilder code = new StringBuilder()
		
		code.append("class Node<T> {")
			code.append("\n\t")	
			code.append("private String name;")
			code.append("\n\t")
			code.append("private List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>> vsp;")
			code.append("\n\t")
			code.append("private List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>> vsp_2;")
			code.append("\n\t")
			code.append("public Node(String name) {")
				code.append("\n\t\t")
				code.append("this.name = name;")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("public Node(String name, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>> vsp) {")
				code.append("\n\t\t")
				code.append("this.name = name;")
				code.append("\n\t\t")
				code.append("this.vsp = vsp;")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("public String name() {")
				code.append("\n\t\t")
				code.append("return this.name;")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>> vsp() {")
				code.append("\n\t\t")
				code.append("return this.vsp;")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>> vsp_2() {")
				code.append("\n\t\t")
				code.append("return this.vsp_2;")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("T vsp(int slotIndex) {")
				code.append("\n\t\t")
				code.append("return this.vsp.get(slotIndex).getValue();")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("List<T> vsp_2(int slotIndex) {")
				code.append("\n\t\t")
				code.append("return this.vsp_2.get(slotIndex).getValue();")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T> slot(int slotIndex) {")
				code.append("\n\t\t")
				code.append("return this.vsp.get(slotIndex);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>> slot_2(int slotIndex) {")
				code.append("\n\t\t")
				code.append("return this.vsp_2.get(slotIndex);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("\n\t")
			code.append("List<List<SimpleEntry<String,Integer>>> header(int slotIndex) {")
				code.append("\n\t\t")
				code.append("if (this instanceof NodeObjectList) {")
					code.append("\n\t\t\t")
					code.append("return this.vsp_2.get(slotIndex).getKey();")
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t")
				code.append("else {")
					code.append("\n\t\t\t")
					code.append("return this.vsp.get(slotIndex).getKey();")
				code.append("\n\t\t")
				code.append("}")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
//			code.append("List<List<SimpleEntry<String,Integer>>> header_2(int slotIndex) {")
//				code.append("\n\t\t")
//				code.append("return this.vsp_2.get(slotIndex).getKey();")
//			code.append("\n\t")
//			code.append("}")
//			code.append("\n\t")

			code.append("public List<List<SimpleEntry<String,Integer>>> initUniqueResourceIdHeader(int id) {")
				code.append("\n\t\t")
				code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
				code.append("\n\t\t")
				code.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();")
				code.append("\n\t\t")
				code.append("SimpleEntry<String,Integer> pair = new SimpleEntry<String,Integer>(\"UNIQUE_RESOURCE_ID\", id);")
				code.append("\n\t\t")
				code.append("headerRow.add(pair);")
				code.append("\n\t\t")
				code.append("header.add(headerRow);")
				code.append("\n\t\t")
				code.append("return header;")
			code.append("}")
	
			code.append("\n\t")
			code.append("public void initLeaf(List<T> leafValues) {")
				code.append("\n\t\t")
				code.append("this.vsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>>();")
				code.append("\n\t\t")
				code.append("for (int i = 0; i < leafValues.size(); i++) {")
					code.append("\n\t\t\t")
					code.append("this.vsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>(null,leafValues.get(i)));")
				code.append("\n\t\t")
				code.append("}")
			code.append("\n\t")
			code.append("}")
			
			code.append("\n\t")
			code.append("public void initLeaf_2(List<List<T>> leafValues) {")
				code.append("\n\t\t")
				code.append("this.vsp_2 = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>>();")
				code.append("\n\t\t")
				code.append("for (int i = 0; i < leafValues.size(); i++) {")
					code.append("\n\t\t\t")
					code.append("this.vsp_2.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>(null,leafValues.get(i)));")
				code.append("\n\t\t")
				code.append("}")
			code.append("\n\t")
			code.append("}")
			
			code.append("public void initLeaf(List<T> leafValues, int id) {")
				code.append("\n\t\t")
				code.append("this.vsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>>();")
				code.append("\n\t\t")
				code.append("for (int i = 0; i < leafValues.size(); i++) {")
					code.append("\n\t\t\t")
					code.append("this.vsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>(initUniqueResourceIdHeader(id),leafValues.get(i)));")
				code.append("\n\t\t")
				code.append("}")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("public void initLeaf_2(List<List<T>> leafValues, int id) {")
				code.append("\n\t\t")
				code.append("this.vsp_2 = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>>();")
				code.append("\n\t\t")
				code.append("for (int i = 0; i < leafValues.size(); i++) {")
					code.append("\n\t\t\t")
					code.append("this.vsp_2.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>(initUniqueResourceIdHeader(id),leafValues.get(i)));")
				code.append("\n\t\t")
				code.append("}")
			code.append("\n\t")
			code.append("}")			
			
			code.append("public void assignVSP_2(List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>> p) {")
				code.append("\n\t\t")
				code.append("this.vsp_2 = p;")
			code.append("\n\t")
			code.append("}")			
			code.append("\n\t")
			code.append("\n\t")
			code.append("List <T> values() {")
				code.append("\n\t\t")
				code.append("List<T> tmp = new ArrayList<T>();")
				code.append("\n\t\t")
				code.append("for (int i = 0; i < this.vsp.size(); i++) {")
					code.append("\n\t\t\t")
					code.append("tmp.add(this.vsp.get(i).getValue());")
				code.append("\n\t\t")
				code.append("}")
			code.append("\n\t")
			code.append("return tmp;")
			code.append("\n\t")
			code.append("}")
			
		code.append("\n")
		code.append("}")
		
		return code.toString	
	}
	
	def String generateNodeObjectClassCode() {
		var StringBuilder code = new StringBuilder()
		
		code.append("class NodeObject extends Node<Object> {")
			code.append("\n\t")
			//code.append("private List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsp;")
			//code.append("\n\t")
			code.append("public NodeObject(String name) {")
				code.append("\n\t\t")
				code.append("super(name);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("public NodeObject(String name, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsp) {")
				code.append("\n\t\t")
				code.append("super(name,vsp);")
				//code.append("\n\t\t")
				//code.append("this.vsp = vsp;")
			code.append("\n\t")
			code.append("}")
			//code.append("\n\t")
			//code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsp() {")
			//	code.append("\n\t\t")
			//	code.append("return this.vsp;")
			//code.append("\n\t")
			//code.append("}")
			//code.append("\n\t")
			//code.append("List<List<SimpleEntry<String,Integer>>> header(int slotIndex) {")
			//	code.append("\n\t\t")
			//	code.append("return this.vsp.get(slotIndex).getKey();")
			//code.append("\n\t")
			//code.append("}")
		code.append("\n")
		code.append("}")
		
		return code.toString	
	}
	
	def String generateNodeObjectListClassCode() {
		var StringBuilder code = new StringBuilder()
		
		code.append("class NodeObjectList extends Node<Object> {")
			code.append("\n\t")
			//code.append("private List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsp;")
			//code.append("\n\t")
			code.append("public NodeObjectList(String name) {")
				code.append("\n\t\t")
				code.append("super(name);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("public NodeObjectList(String name, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsp) {")
				code.append("\n\t\t")
				code.append("super(name,vsp);")
				//code.append("\n\t\t")
				//code.append("this.vsp = vsp;")
			code.append("\n\t")
			code.append("}")
			//code.append("\n\t")
			//code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsp() {")
			//	code.append("\n\t\t")
			//	code.append("return this.vsp;")
			//code.append("\n\t")
			//code.append("}")
			//code.append("\n\t")
			//code.append("List<List<SimpleEntry<String,Integer>>> header(int slotIndex) {")
			//	code.append("\n\t\t")
			//	code.append("return this.vsp.get(slotIndex).getKey();")
			//code.append("\n\t")
			//code.append("}")
		code.append("\n")
		code.append("}")
		
		return code.toString	
	}
	
	def String generateNodePsClassCode() {
		var StringBuilder code = new StringBuilder()
		
		code.append("class NodePs extends Node<Map<String,Double>> {")
			code.append("\n\t")
			//code.append("private List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> vsp;")
			//code.append("\n\t")
			code.append("public NodePs(String name) {")
				code.append("\n\t\t")
				code.append("super(name);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("public NodePs(String name, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> vsp) {")
				code.append("\n\t\t")
				code.append("super(name,vsp);")
				//code.append("\n\t\t")
				//code.append("this.vsp = vsp;")
			code.append("\n\t")
			code.append("}")
			//code.append("\n\t")
			//code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> vsp() {")
			//	code.append("\n\t\t")
			//	code.append("return this.vsp;")
			//code.append("\n\t")
			//code.append("}")
			//code.append("\n\t")
			//code.append("List<List<SimpleEntry<String,Integer>>> header(int slotIndex) {")
			//	code.append("\n\t\t")
			//	code.append("return this.vsp.get(slotIndex).getKey();")
			//code.append("\n\t")
			//code.append("}")
		code.append("\n")
		code.append("}")
		
		return code.toString	
	}	
	
}
