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

import bbn.Decomposition
import bbn.EquivalenceFork
import org.eclipse.emf.ecore.EObject
import bbn.BuildingBlockDescription
import bbn.MAGR
import java.util.List
import java.util.ArrayList
import bbn.AGGR
import java.util.Map
import bbn.DVG
import java.util.HashMap

class EqufModelOfModels {
	
	Helpers he;
	
	List<MatchingAndGenerationData> matchingAndGenerationDataList
	
	DVG problemDVG
	
	Map<String,Integer> equfActives;
	
	def Map<String, Integer> getEqufActives() {
		return this.equfActives
	}
	
	def List<MatchingAndGenerationData> getMatchingAndGenerationDataList() {
		return this.matchingAndGenerationDataList
	}
	
	boolean firstFinished = false
	
	def String start(Decomposition d, DVG problemDVG, boolean ff) {
		this.equfActives = new HashMap<String,Integer>()
		this.problemDVG = problemDVG
		this.firstFinished = ff
		println("START EqufModelOfModels")
		if (d instanceof EquivalenceFork) {
			
			var StringBuilder code = new StringBuilder()
			
			this.matchingAndGenerationDataList = new ArrayList<MatchingAndGenerationData>()
			
			for (i : d.c) {
				var MatchingAndGeneration mag = new MatchingAndGeneration()
				var EObject bbd = i.bbr.eContainer
				var boolean hasDVGRef = false;  
				if (bbd instanceof BuildingBlockDescription) {
					if (bbd.dvg !== null) {
						if (!firstFinished) {
							code.append(mag.start(i.bbr, bbd.dvg, true, true, true))
							firstFinished = true	
						}
						else {
							code.append(mag.start(i.bbr, bbd.dvg, true, false, true))
						}
					}
					else {
						mag.start(i.bbr, bbd.dvg, false, false, true)
					}
					// Matching and generation finished for a single container/building block
					var MatchingAndGenerationData magd = new MatchingAndGenerationData()
					magd.numberAllocations = mag.getAllocations()
					magd.active = mag.getActive()
					magd.passive = mag.getPassive()
					this.matchingAndGenerationDataList.add(magd)
				}
			}
			
			code.append(generateEvaluation())		
						
			return code.toString()
		}
	}
	
	
	def String resolve(MAGR p) {
		
		this.he = new Helpers()
	
		var StringBuilder code = new StringBuilder()
		var StringBuilder lcode = new StringBuilder()
		
		code.append("void")
		
		code.append(" ")
		code.append("resolve_"+p.name)
		code.append("(")
	
		code.append("List<List<Node>>")
		code.append(" ")
		code.append("I")

		code.append(") {")
		code.append("\n\t")
		
		for (var int i = 0; i < p.aggr.size; i++) {
			var String name = "resolve_"+p.name+"_"+i.toString;
			code.append(name+"(I.get("+i+"));")
			code.append("\n\t")
			lcode.append(resolveAGGR(p.name, name, p.aggr.get(i)))
			lcode.append("\n")
		}
		code.append("\n")
		code.append("}")	
		
		var StringBuilder res = new StringBuilder()
		
		res.append(code)
		res.append("\n\n")
		res.append(lcode)
		res.append("\n\n")
		
		return res.toString()
	}
	
	def String resolveAGGR(String pname, String fname, AGGR la) {
		
		var StringBuilder code = new StringBuilder();
		
		var String vsp
		var String obj
		
		if (this.he.isComplexDo(la.op.ve)) {
			vsp = "vsp_2"
			obj = "List<Object>"
		}
		else {
			vsp = "vsp"
			obj = "Object"
		}
		
		code.append("void")
		
		code.append(" ")
		code.append(fname)
		code.append("(")
	
		code.append("List<Node>")
		code.append(" ")
		code.append("I")

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
				code.append("SimpleEntry<String, Integer> fid = new SimpleEntry<String, Integer>(\""+pname+"\", i);")
				
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
			if (this.he.isComplexDo(la.op.ve)) {
				code.append("nodeObjectList = new NodeObjectList(\""+la.op.name+"\");")
				code.append("nodeObjectList.assignVSP_2(ovsp);")
				code.append("this.NODE_COLLECTION.put(\""+la.op.name+"\", nodeObjectList);")
			}
			else {
				code.append("this.NODE_COLLECTION.put(\""+la.op.name+"\", new NodeObject(\""+la.op.name+"\", ovsp));")
			}	
		code.append("}")
		
		return code.toString	
	}
	
	def String generateCallSequenceCode(String name, List<List<bbn.DVGPort>> inputSet, List<String> dvgNames) {
		
		var StringBuilder code = new StringBuilder()
		
		/*for (var int i = 0; i < dvgNames.size(); i++) {
			code.append("\n\t\t")
			code.append("Solve_"+dvgNames.get(i)+" s_"+i.toString()+" = new Solve_"+dvgNames.get(i)+"();")
			var String instName = "s_"+i.toString()
			code.append("\n\t\t")
			code.append(instName+".init();")
			code.append("\n\t\t")
			code.append("if ("+instName+".getAllocations() > 1) {")
			code.append("\n\t\t")
				code.append("List<Node> tmp = new ArrayList<Node>();")
				code.append("\n\t\t")
				code.append("for (int i = 0; i < "+instName+".getAllocations(); i++) {")
				code.append("\n\t\t\t")
					code.append("tmp.add("+instName+".solve(\""+inputSet.get(0).get(0).name+"\",i));")
				code.append("\n\t\t")
				code.append("}")
				code.append("AllocationAggr(tmp, "+inputSet.get(0).get(0).name+");")
				code.append("\n\t\t")
			code.append("}")
			code.append("\n\t\t")
		}*/
		
		code.append("List<Node> params;")
		code.append("\n\t\t")
		code.append("List<List<Node>> params_2d;")
		code.append("\n\t\t")
		
		code.append("params_2d = new ArrayList<List<Node>>();")
		code.append("\n\t\t")
		for (var int i = 0; i < inputSet.size; i++) {
			code.append("params = new ArrayList<Node>();")
			code.append("\n\t\t")
			for (var int j = 0; j < inputSet.get(i).size; j++) {
				code.append("\n\t\t")
				code.append(dvgNames.get(j)+" s_"+j.toString()+" = new "+dvgNames.get(j)+"();")
				var String instName = "s_"+j.toString()
				var String magrName = "MAGR_ALLOCATION_"+dvgNames.get(j)
				code.append("\n\t\t")
				code.append(instName+".init();")
				if (this.matchingAndGenerationDataList.get(j).numberAllocations > 1) {
				//code.append("if ("+instName+".getAllocations() > 1) {")
					code.append("\n\t\t")
					code.append("List<Node> tmp = new ArrayList<Node>();")
					code.append("\n\t\t")
					code.append("for (int i = 0; i < "+instName+".getAllocations(); i++) {")
						code.append("\n\t\t\t")
						code.append("tmp.add("+instName+".solve(\""+inputSet.get(i).get(j).name+"\",i));")
					code.append("\n\t\t")
					code.append("}")
				//code.append("params.add(AllocationAggr(tmp, \""+inputSet.get(i).get(j).name+"\"));")
				code.append("params.add(AllocationAggr(tmp, \""+magrName+"\"));")
				code.append("\n\t\t")
			//code.append("}")
				}
				else {
					code.append("\n\t\t")	
					//code.append("else {")
					code.append("params.add("+instName+".solve(\""+inputSet.get(i).get(j).name+"\",0));")
					code.append("\n\t\t")
					//code.append("}")
					code.append("\n\t\t")								
					code.append("\n\t\t")
				}
			}
			code.append("params_2d.add(params);")
			code.append("\n\t\t")
		}
		code.append("resolve_"+name+"(params_2d);")
		code.append("\n\t\t")
		code.append("\n\t\t")
	
		return code.toString
	}
	
	def String generateEvaluation() { // TODO: The dvg resolution part should be decoupled!
		
		var StringBuilder code = new StringBuilder()
		
		code.append("\n\t") 
		code.append("class "+this.problemDVG.name+"{")
			code.append("\n\t") 
			
			code.append("\n\t")
			code.append("Node getNode(String name) {")
			code.append("\n\t")
			code.append("return NODE_COLLECTION.get(name);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")			
			
			code.append("private Map<String, Node> NODE_COLLECTION;")
			
			code.append("\n\t") 
			
			// We expect a corresponding DVG with a MAGR that must receive its inputs from the return of the solve method of each class
			// we use the link to the output ports as the name for return in solve
			var EObject tmp = this.problemDVG.pattern.get(0)
			var List<List<bbn.DVGPort>> inputSetAg = new ArrayList<List<bbn.DVGPort>>()
			var List<String> aggrOutputNames = new ArrayList<String>()
			var List<String> dvgNames = new ArrayList<String>()
			var String magrName
			var int numberInputs = 0
			if (tmp instanceof MAGR) {
				magrName = tmp.name
				code.append(resolve(tmp))
				
				for (i : tmp.aggr) {
					aggrOutputNames.add(i.op.name)
					var List<bbn.DVGPort> tmp2 = new ArrayList<bbn.DVGPort>()
					numberInputs = i.ip.size
					for (j : i.ip) {
						tmp2.add(j.outputport)
						var EObject dvg2 = j.outputport.eContainer.eContainer()
						if (dvg2 instanceof DVG) {
							dvgNames.add(dvg2.name)
						}
					}
					inputSetAg.add(tmp2)
				}
			}
			
			code.append("\n\t") 
			
			code.append(this.he.generateGenericAllocationAggr)
			
			code.append("\n\t") 
			
			code.append("void init() {")
			code.append("\n\t") 
			code.append("this.NODE_COLLECTION = new HashMap<String, Node>();")
			code.append("\n\t") 
			code.append("}")
			
			code.append("void solve() {")
			code.append("\n\t")
			code.append(generateCallSequenceCode(magrName, inputSetAg, dvgNames))
			code.append("\n\t") 
			
			var Map<String, Integer> active = new HashMap<String,Integer>()
			var Map<String, Integer> passive = new HashMap<String,Integer>()
			
			// TODO: We should add active and passive from the different building blocks of the equf
			
			// We need to add the allocations of a building block if there are more than one 
			//var List<MatchingAndGenerationData> magdl = getMatchingAndGenerationDataList
			for (var int i = 0; i < this.matchingAndGenerationDataList.size(); i++) {
				if (this.matchingAndGenerationDataList.get(i).numberAllocations > 1) {
					active.put("MAGR_ALLOCATION_"+dvgNames.get(i), this.matchingAndGenerationDataList.get(i).numberAllocations)
					this.equfActives.put("MAGR_ALLOCATION_"+dvgNames.get(i), this.matchingAndGenerationDataList.get(i).numberAllocations)
				}
				println("magdl(i): "+ this.matchingAndGenerationDataList.get(i).active)
			}
			
			// We need to add the EQUF itself
			active.put(magrName, numberInputs)
			this.equfActives.put(magrName, numberInputs)
			
			code.append(FinalEvaluation.getEQUFCode(aggrOutputNames.get(0), active, passive)) // TODO: currently only consistent if nothing else than a MAGR with a single AGGR is modeled in the EQUF model
			code.append("\n\t") 
			code.append("}")
		code.append("}")
		
		code.append("\n\t") 
		
		return code.toString()
	}
		
}



class MatchingAndGenerationData {
	public int numberAllocations;
	public Map<String, Integer> active;
	public Map<String, Integer> passive;
}
