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
import java.util.ArrayList

class SAPROPattern {
	
	boolean CHECK_FOR_IS_SAM_IN_PRODUCTION = false
	
	Helpers he
	JavaFunctions jf
	
	def String resolve(bbn.SAPRO p, List<bbn.AbstractInputPort> inputSet) {
		
		this.he = new Helpers()
		this.jf = new JavaFunctions()

		// VSP of the output node of the RProduction pattern: List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,*>> VSP
		// * is either Double or String depending on the Representation (Relative/Absolute or String) 
		
		var StringBuilder code = new StringBuilder()
		
//		if (p.outputport.representation == Representation.ABSOLUTE || p.outputport.representation == Representation.RELATIVE) {
//			code.append(this.NUMERIC_VSP_STANDARD)
//		}
//		else if (p.outputport.representation == Representation.STRING) {
//			code.append(this.SYMBOLIC_VSP_STANDARD)
//		}
//		else {
//			System.out.println("ERROR: Representation is UNDEFINED!")
//		}
		//code.append(this.GENERIC_VSP_STANDARD_OUTPUT)
		code.append("void")
		
		code.append(" ")
		code.append("resolve_"+p.name)
		code.append("(")
		
//		for (i : p.InputPort) {
//			if (i.representation == Representation.ABSOLUTE || i.representation == Representation.RELATIVE) {
//				code.append(this.NUMERIC_VSP_STANDARD)
//			}
//			else if (i.representation == Representation.STRING) {
//				code.append(this.SYMBOLIC_VSP_STANDARD)
//			}
//			else {
//				System.out.println("ERROR: Representation is UNDEFINED!")
//			}
//			
//			code.append(" ")
//			code.append(i.name)
//			code.append(", ")	
//		}
		//code.append(this.GENERIC_VSP_STANDARD_INPUT)
		code.append("List<Node>")
		code.append(" ")
		code.append("I")

		code.append(") {")
			code.append("\n\t")
			if (this.CHECK_FOR_IS_SAM_IN_PRODUCTION) {
				code.append("List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();")
				code.append("\n\t")
				code.append("for (int i = 0; i < I.size(); i++) {")
					code.append("\n\t\t")
					code.append("if (I.get(i).vsp(0) != null) {")
						code.append("\n\t\t\t")	
						code.append("headerList.add(I.get(i).header(0));")
					code.append("\n\t\t")
					code.append("}")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				code.append("if (headerList.size() > 0 && isSAM(headerList)) {")
					code.append("\n\t\t")
					code.append("System.err.println(\"ERROR: There is a not allowed SAM-Situation for Production pattern "+p.name+"!\");")
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
			code.append("Object newValue;")
			code.append("\n\t")
			
			var StringBuilder fdefcode = new StringBuilder()
			fdefcode.append("\n\t")

			fdefcode.append("Object operator_"+p.name+"(List<Object> valueList")
			
			var StringBuilder fcallcode = new StringBuilder()
			fcallcode.append("\n\t")
			fcallcode.append("operator_"+p.name+"(valueList")
			
			var List<String> processedMin = new ArrayList<String>()
			var List<String> processedMax = new ArrayList<String>()
			code.append("List<Object> vtmp;")
			code.append("\n\t")
			
			var List<String> tmp = this.he.getSymbolsForMinOperators(p.expr.expr)
			for (i : tmp) {
				if (!processedMin.contains(i)) {
					var int index = this.he.getTh(i, inputSet)
					code.append("vtmp = I.get("+index+").values();")
					code.append("\n\t")
					code.append("double min_"+i+" = min(vtmp);")
					code.append("\n\t")
					fdefcode.append(", double min_"+i)
					fcallcode.append(",min_"+i)
					processedMin.add(i)
				}
			}
			tmp = this.he.getSymbolsForMaxOperators(p.expr.expr)
			for (i : tmp) {
				if (!processedMax.contains(i)) {
					var int index = this.he.getTh(i, inputSet)
					code.append("vtmp = I.get("+index+").values();")
					code.append("\n\t")
					code.append("double max_"+i+" = max(vtmp);")
					code.append("\n\t")
					fdefcode.append(", double max_"+i)
					fcallcode.append(",max_"+i)
					processedMax.add(i)
				}
			}
			
			fdefcode.append(") {")
			fcallcode.append(");")
			
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
				code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < cp.get(i).size(); j++) {")
					code.append(this.jf.generateHeaderRow)
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t") 
				


					code.append("if (isValidCombination(header)) {")
				
					code.append("\n\t\t\t")
					code.append("List<Object> valueList = new ArrayList<Object>();")
					code.append("\n\t\t\t")
					code.append("for (int j = 0; j < I.size(); j++) {")
						code.append("\n\t\t\t\t")
						code.append("valueList.add(I.get(j).vsp(cp.get(i).get(j)));")
					code.append("\n\t\t\t")
					code.append("}")
					code.append("\n\t\t\t")
					code.append("newValue = "+fcallcode)
					code.append("\n\t\t\t")
		
					code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));")
				code.append("}")
			
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			

			if (p.op !== null) {
				code.append("this.NODE_COLLECTION.put(\""+p.op.name+"\", new NodeObject(\""+p.op.name+"\", ovsp));")
			}
			else if (p.ocp !== null) {
				code.append("this.NODE_COLLECTION.put(\""+p.ocp.name+"\", new NodeObject(\""+p.ocp.name+"\", ovsp));")
			}
			
		code.append("\n")
		code.append("}")
		
		//this.LOCAL_RESOLUTION_CODE.append(code)
		//this.LOCAL_RESOLUTION_CODE.append("\n\n")
		code.append("\n\n")
		
		fdefcode.append(this.he.generateExpressionCode(p.name, p.expr.expr, inputSet))
		fdefcode.append("\n\t")
		fdefcode.append("}")
		
		code.append(fdefcode)
		code.append("\n\n")
		//this.LOCAL_RESOLUTION_CODE.append(fdefcode)
		//this.LOCAL_RESOLUTION_CODE.append("\n\n")
		
		return code.toString()
	}	
}
