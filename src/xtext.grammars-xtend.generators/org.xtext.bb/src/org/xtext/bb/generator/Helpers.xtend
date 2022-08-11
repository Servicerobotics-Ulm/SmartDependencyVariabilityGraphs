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
import java.util.regex.Pattern
import java.util.regex.Matcher
import java.util.ArrayList
import bbn.VariabilityEntity
import dor.TypeDef
import bbn.PortElement
import bbn.AbstractInputPort
import bbn.InternalOutputPort
import bbn.InternalInputPort
import bbn.InputPort
import bbn.InputCPort
import bbn.InputWSMPort
import bbn.RT
import dor.StringDef
import dor.BoolDef
import dor.IntegerDef
import dor.RealDef
import bbn.AbstractInitPort
import bbn.InitPort
import org.eclipse.emf.ecore.EObject
import vi.BoolVSPInit
import vi.IntegerVSPInit
import vi.RealVSPInit
import vi.StringVSPInit
import vi.ComplexVSPInit
import bbn.InitCPort
import bbn.AbstractOutputPort
import bbn.AGGR
import bbn.MAGR
import bbn.AbstractInitPort
import bbn.InternalPortRef
import bbn.DAGGR
import bbn.DMAGR
import bbn.INIT
import bbn.BBContainer
import bbn.SAPRO
import bbn.DVG

class Helpers {
	
	def int getVSPInitSize(AbstractInitPort in) {
		
		if (in instanceof InitPort) {
			var EObject tmp = in.vi
			if (tmp instanceof BoolVSPInit) {
				return tmp.vsp.size
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					return tmp.irg.number
				}
				else {
					return tmp.vsp.size
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					return tmp.rrg.number
				}
				else {
					return tmp.vsp.size
				}
			}
			else if (tmp instanceof StringVSPInit) {
				return tmp.vsp.size
			}
			
			else if (tmp instanceof ComplexVSPInit) {
				return tmp.vi.size
			}
		}
		
		else if (in instanceof InitCPort) {
			var EObject tmp = in.vi
			if (tmp instanceof BoolVSPInit) {
				return tmp.vsp.size
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					return tmp.irg.number
				}
				else {
					return tmp.vsp.size
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					return tmp.rrg.number
				}
				else {
					return tmp.vsp.size
				}
			}
			else if (tmp instanceof StringVSPInit) {
				return tmp.vsp.size
			}
			else if (tmp instanceof ComplexVSPInit) {
				return tmp.vi.size
			}
		}
		
	}

def List<String> getSymbolsForMinOperators(String expr) {
		var Pattern p = Pattern.compile("(\\$MIN\\([a-zA-Z0-9_]*\\)\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
			var String tmp = m.group().substring(5,m.group().length()-2);
		  	matches.add(tmp);
		}
		return matches
	}
	
	def List<String> getSymbolsForMaxOperators(String expr) {
		var Pattern p = Pattern.compile("(\\$MAX\\([a-zA-Z0-9_]*\\)\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
			var String tmp = m.group().substring(5,m.group().length()-2);
		  	matches.add(tmp);
		}
		return matches
	}
	
	def List<String> getSymbolsForComplexDo(String expr) {
		var Pattern p = Pattern.compile("(\\$[a-zA-Z0-9_\\[]*\\]\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
			//System.out.println("match: "+m.group())
			var String tmp = "";
			var int c = 1;
			while (m.group().codePointAt(c) != 91) { // 91 = "["
				//System.out.println("ca: "+ m.group().charAt(c));
				tmp += m.group().charAt(c);
				c++;
				//System.out.println("tmp: "+ tmp);
			}
		  	matches.add(tmp);
		}
		return matches
	}
	
	def int getTh(String name, List<bbn.AbstractInputPort> inputSet) {
		var int cnt = 0
		for (i : inputSet) {
			//System.out.println(name+" : "+i.name)
			if (name == i.name) {
				return cnt
			}
			cnt++
		}
		return -1
	}
	
	def bbn.AbstractInputPort getNode(String name, List<bbn.AbstractInputPort> inputSet) {
		for (i : inputSet) {
			//System.out.println(name+" : "+i.name)
			if (name == i.name) {
				//System.out.println("TIMO RETURN")
				return i
			}
		}
		return null
	}
	
	def boolean isComplexDo(VariabilityEntity ve) {
		
		if (ve.dor !== null) {
			if (ve.dor.ed.size() > 1 || ve.dor.ed.get(0).td.cardinality == "*") {
				return true
			}
		}
		else if (ve.doc !== null) {
			if (ve.doc.ed.size() > 1 || ve.doc.ed.get(0).td.cardinality == "*") {
				return true
			}
		}	
		
		return false
	}
	
	def TypeDef getTypeFromVe(VariabilityEntity ve) {
		
		if (ve instanceof PortElement) {
			return ve.e.td
		}
		else {
			if (ve.dor !== null) {
				return ve.dor.ed.get(0).td	
			}
			else if (ve.doc !== null) {
				return ve.doc.ed.get(0).td	
			}
		}
	}
	
	// VT = CONSTANT if all Inputs are CONSTANT
	// VT = ACTIVE if at least one Input is ACTIVE
	// VT = PASSIVE else
	def bbn.VT getOutputVTFromInputs(List<AbstractInputPort> inl) {
		
		var List<bbn.VT> VTList = new ArrayList<bbn.VT>()
		
		for (i : inl) {
			if (inl instanceof InputPort) {
				VTList.add(inl.outputport.vt)
			}
			else if (inl instanceof InternalInputPort) {
				var InternalPortRef tmp = inl.internalportref
				if (tmp instanceof InputPort) {
					VTList.add(tmp.outputport.vt)
				}
				else if (tmp instanceof InternalOutputPort) {
					VTList.add(tmp.vt)
				}
			}
			else if (inl instanceof InputCPort) {
				VTList.add(inl.outputcport.vt)
			}
			else if (inl instanceof InputWSMPort) {
				VTList.add(inl.outputwsmport.vt)
			}
		}
		
		var int numberConstant = 0
		var int numberActive = 0
		
		for (i : VTList) {
			if (i == bbn.VT.CONSTANT) {
				numberConstant++
			}
			if (i == bbn.VT.ACTIVE) {
				numberActive++
			}
		}
		
		if (numberActive > 0) {
			return bbn.VT.ACTIVE
		}
		else if (numberConstant == inl.size()) {
			return bbn.VT.CONSTANT
		}
		else {
			return bbn.VT.PASSIVE
		}
	}
	
def String generateExpressionCode(String name, String expr, List<bbn.AbstractInputPort> inputSet) {
		
		var String modifiedExpr = expr
		
		var Pattern p = Pattern.compile("(\\$[a-zA-Z0-9_\\[\\]]*\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
		  	matches.add(m.group());
		}
		
		// matches represents the order of the $*$ patterns in expr
		// get i-th input of each expr as stored in the inputSet
		
		var String escaped
		
		for (i : matches) {
			//System.out.println("MATCH: "+i)
			var int index = getTh(i.substring(1,i.length()-1), inputSet)
			var bbn.AbstractInputPort node = getNode(i.substring(1,i.length()-1), inputSet)
			//System.out.println("Index: "+index)
			// Replace $i$ with "inputSet.get("index")"
			escaped = "\\"+i.substring(0,i.length()-1)+"\\$"
			//System.out.println("escaped: "+escaped)
			if (index == -1 && escaped == "\\$OUT\\$") {
				//System.out.println("TIMO IS $OUT$")
				modifiedExpr = modifiedExpr.replaceAll(escaped, "OUT")
			}
			else if (node instanceof bbn.InputPort) {
				
				if (!isComplexDo(node.outputport.ve)) {
					
					//System.out.println("standard: mod expr: "+ modifiedExpr)
					//System.out.println("escaped: "+escaped)
				
					if (node.outputport.rt == RT.RELATIVE || (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof RealDef)) {
						modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) valueList.get("+index.toString+")).doubleValue()")
					}
					else if (node.outputport.rt == RT.ABSOLUTE && (getTypeFromVe(node.outputport.ve) instanceof IntegerDef || getTypeFromVe(node.outputport.ve) === null)) {
						modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) valueList.get("+index.toString+")).intValue()")
						//System.out.println("is int !!!!")
					}
					else if (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof BoolDef) {
						modifiedExpr = modifiedExpr.replaceAll(escaped, "((Boolean) valueList.get("+index.toString+")).booleanValue()")
					}
					else if (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof StringDef) {
						modifiedExpr = modifiedExpr.replaceAll(escaped, "valueList.get("+index.toString+").toString()")
					}
					
					//System.out.println("standard: mod expr: "+ modifiedExpr)
				}
				
				else {
					// This seems to be complex do.size
					//System.out.println("This seems to be complex do.size: " + escaped)
					modifiedExpr = modifiedExpr.replaceAll(escaped, escaped.substring(2,escaped.length()-2))
					
				}			
			}
			else {
				// Check if it is a Complex Do
				// Timo Complex Do
				// We assume only reals and index access [index]
				// Replace $name[i]$ with ((Number) name.get(i)).doubleValue() 
				//modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) valueList.get("+index.toString+")).doubleValue()")
				
				if (i.substring(i.length()-2, i.length()-1) == "]") {
					//System.out.println("TIMO IS COMPLEX DO!!!!!!!!!!!!: "+ modifiedExpr)
					//System.out.println("escaped: "+escaped)
					//System.out.println("escaped (quote): "+Pattern.quote(escaped))
					
					var int c = i.length()-2
					
					var String istr = ""
					
					while (i.substring(c-1,c) != "[") {
						//System.out.println("char: " + i.substring(c-1,c))
						istr += i.substring(c-1,c)
						c--
					}
					
					var String olds = ""
					c = 0
					var int num = 0
					while (escaped.substring(c,c+1) != "[") {
						//System.out.println("char: " + i.substring(c-1,c))
						olds += escaped.substring(c,c+1)
						c++
						num++
					}
					
					escaped = olds + "\\[" + new StringBuilder(istr).reverse().toString() + "\\]\\$"
					var String nodename = escaped.substring(2,num)
					
					//System.out.println("new escaped: " + escaped)
					//System.out.println("num: " + num)
					//System.out.println("Name of the Node: " + nodename)
					 
				
					modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) "+nodename+".get("+new StringBuilder(istr).reverse().toString()+")).doubleValue()")
					//System.out.println("MOD EXPR!!!!!!!!!!!!: "+ modifiedExpr)
						
				}
				else {
					System.err.println("Error in parsing Expression!")
				}				
			}
			//System.out.println("modexpr: "+modifiedExpr)
		}
		
		p = Pattern.compile("(\\$MIN\\([a-zA-Z0-9_]*\\)\\$)");
		m = p.matcher(modifiedExpr);
		matches = new ArrayList<String>();
		
		while (m.find()) {
		  	matches.add(m.group());
		}
		
		for (i : matches) {
			modifiedExpr = modifiedExpr.replaceAll(Pattern.quote(i), "min_"+i.substring(5,i.length()-2))
		}
		
		p = Pattern.compile("(\\$MAX\\([a-zA-Z0-9_]*\\)\\$)");
		m = p.matcher(modifiedExpr);
		matches = new ArrayList<String>();
		
		while (m.find()) {
		  	matches.add(m.group());
		}
		
		for (i : matches) {
			modifiedExpr = modifiedExpr.replaceAll(Pattern.quote(i), "max_"+i.substring(5,i.length()-2))
		}
		
		var StringBuilder code = new StringBuilder()
		
		code.append("\n\t\t")
		code.append(modifiedExpr)
		code.append("\n\t\t")
		code.append("return OUT;")

		return code.toString
	}
	
	def String generateExpressionCodePs(String name, String expr, List<bbn.AbstractInputPort> inputSet) {
		
		// define xtend List<String> lis
		// parse $OUT.<Name>
		// <Name> is name of referenced Output Node of a Input Node of the corresponding Contradiction Pattern
		// Replace $OUT.<Name> with <Name>
		
		// xtend: lis.add("<Name>",Name)
		
		// ....
		
		
		// for lis
			// internal: map.put(lis) 
		
		
		var String modifiedExpr = expr
		
		var Pattern p = Pattern.compile("(\\$[a-zA-Z0-9_]*\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
		  	matches.add(m.group());
		}
		
		// matches represents the order of the $*$ patterns in expr
		// get i-th input of each expr as stored in the inputSet
		
		var String escaped
		
		for (i : matches) {
			//System.out.println("MATCH: "+i)
			var int index = getTh(i.substring(1,i.length()-1), inputSet)
			var bbn.AbstractInputPort node = getNode(i.substring(1,i.length()-1), inputSet)
			//System.out.println("Index: "+index)
			// Replace $i$ with "inputSet.get("index")"
			escaped = "\\"+i.substring(0,i.length()-1)+"\\$"
			//System.out.println("escaped: "+escaped)
			if (index == -1 && escaped == "\\$OUT\\$") {
				//System.out.println("TIMO IS $OUT$")
				modifiedExpr = modifiedExpr.replaceAll(escaped, "OUT")
			}
			else if (node instanceof bbn.InputPort) {
				if (node.outputport.rt == RT.RELATIVE || (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof RealDef)) {
					modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) valueList.get("+index.toString+")).doubleValue()")
				}
				else if (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof IntegerDef) {
					modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) valueList.get("+index.toString+")).intValue()")
				}
				else if (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof BoolDef) {
					modifiedExpr = modifiedExpr.replaceAll(escaped, "((Boolean) valueList.get("+index.toString+")).booleanValue()")
				}
				else if (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof StringDef) {
					modifiedExpr = modifiedExpr.replaceAll(escaped, "valueList.get("+index.toString+").toString()")
				}			
			}
			//System.out.println("modexpr: "+modifiedExpr)
		}
		
		var List<String> lis = new ArrayList<String>()
		
		p = Pattern.compile("(\\$OUT.[a-zA-Z0-9_]*\\$)");
		m = p.matcher(modifiedExpr);
		matches = new ArrayList<String>();
		
		while (m.find()) {
		  	matches.add(m.group());
		}
		
		for (i : matches) {
			modifiedExpr = modifiedExpr.replaceAll(Pattern.quote(i), i.substring(5,i.length()-1))
			lis.add(i.substring(5,i.length()-1))
		}
		
		var StringBuilder code = new StringBuilder()
		code.append("Map<String,Double> outMap = new HashMap<String,Double>();")
		code.append("\n\t\t")
		code.append(modifiedExpr)
		for (i : lis) {
			code.append("outMap.put(\""+i+"\","+i+");")
			code.append("\n\t\t")
		}
		code.append("\n\t\t")
		code.append("return outMap;")

		return code.toString
	}	
	
	def boolean isSAM(List<String> sl) {
		var List<String> sln = new ArrayList<String>()
		
		for (i : sl) {
			if (!sln.contains(i)) {
				sln.add(i)
			}
			else {
				return true
			}
		}
		return false
	}
	
	def bbn.Pattern getPattern(AbstractOutputPort aon) {
		
		var EObject obj = aon.eContainer
		if (obj instanceof bbn.Pattern) {
			//System.out.println(obj + " is Pattern")
			return obj	
		}
		else if (obj instanceof AGGR) {
			obj = obj.eContainer
			if (obj instanceof MAGR) {
				return obj
			}
		}
		else if (obj instanceof DAGGR) {
			obj = obj.eContainer
			if (obj instanceof DMAGR) {
				return obj
			}			
		}
	}
	
	def boolean isDaggr(AbstractOutputPort aon) {
		
		var EObject obj = aon.eContainer
		if (obj instanceof DAGGR) {
			return true	
		}
		else {
			return false
		}
	}	
	
	def bbn.DVG getDVG(bbn.Pattern p) {
		
		var EObject obj = p.eContainer
		if (obj instanceof bbn.DVG) {
			return obj	
		}
	}
	
	def AGGR getAGGR(AbstractOutputPort aon) {
		
		var EObject obj = aon.eContainer
		if (obj instanceof AGGR) {
			//System.out.println(obj + " is Aggregation")
			return obj	
		}
	}

	def DAGGR getDAGGR(AbstractOutputPort aon) {
		
		var EObject obj = aon.eContainer
		if (obj instanceof DAGGR) {
			//System.out.println(obj + " is Aggregation")
			return obj	
		}
	}
	
	def VariabilityEntity getVeFromPattern(bbn.Pattern pattern) {
		if (pattern instanceof INIT) {
			return pattern.ainip.ve
		}
		return null
	}
	
	def int getResGroupOfPattern(bbn.Pattern p) {
		var EObject bbc = p.eContainer
		if (bbc instanceof BBContainer) {
			if (bbc.buildingblock !== null) {
				return bbc.buildingblock.resourcegroupid.number
			}
			else {
				println("no bb ref!")
				return -1
			}
		}
		else {
			return -1
		}
	}
	
def String generateGenericAllocationAggr() {
		
		var StringBuilder code = new StringBuilder();
		
		var String vsp
		var String obj
		
		vsp = "vsp"
		obj = "Object"
		
		code.append("Node")
		
		code.append(" ")
		code.append("AllocationAggr")
		code.append("(")
	
		code.append("List<Node>")
		code.append(" ")
		code.append("I, String name")

		code.append(") {")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,"+obj+">> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,"+obj+">>();")
			code.append("\n\t")
			code.append(obj+" newValue;")
			code.append("\n\t")
			code.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();")
			code.append("\n\t")
			code.append("NodeObjectList nodeObjectList;")
			code.append("\n\t")
			code.append("for (int i = 0; i < I.size(); i++) {")
				code.append("\n\t\t")
				code.append("SimpleEntry<String, Integer> fid = new SimpleEntry<String, Integer>(name, i);")
				
				code.append("for (int j = 0; j < I.get(i)."+vsp+"().size(); j++) {")
					code.append("\n\t\t\t")
					code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
					code.append("\n\t\t\t")
					code.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();")
					code.append("\n\t\t\t")
					code.append("headerRow.add(fid);")
					code.append("\n\t\t\t")
					code.append("headerRow.add(new SimpleEntry<String, Integer>(I.get(i).name(), j));")
					code.append("\n\t\t\t")
					code.append("if (I.get(i).header(j) != null) {")
						code.append("\n\t\t\t\t")
						code.append("List<List<SimpleEntry<String,Integer>>> htmp = I.get(i).header(j);")
						code.append("\n\t\t\t\t")
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
					code.append("\n\t\t\t")
					code.append("newValue = I.get(i)."+vsp+"(j);")
					code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, "+obj+">(header, newValue));")
					//code.append("this.NODE_COLLECTION.put(\""+la.on.name+"\", new NodeObject(\""+la.on.name+"\", ovsp));")
				code.append("\n\t\t")
				code.append("}")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("return new NodeObject(name, ovsp);")
			code.append("\n\t")
		code.append("}")
		
		return code.toString	
	}	
	
	def ExternalInformation getExternalInformation(bbn.Pattern p) {
		// TODO: Implement other patterns
		var List<String> dvgs = new ArrayList<String>()
		var List<String> outputs = new ArrayList<String>()
		var String oName
		if (p instanceof SAPRO) {
			oName = p.op.name
			for (i : p.ip) {
				var EObject tmp = getPattern(i.outputport)
				outputs.add(i.outputport.name)
				tmp = tmp.eContainer
				if (tmp instanceof DVG) {
					dvgs.add(tmp.name) // We assume all inputs are external ones!
				}
			}
		}
		var ExternalInformation ei = new ExternalInformation()
		ei.pName = p.name
		ei.oName = oName
		ei.dvgs = dvgs
		ei.outputs = outputs
		return ei
	}
}

class ExternalInformation {
	public String pName
	public String oName
	public List<String> dvgs
	public List<String> outputs
}
