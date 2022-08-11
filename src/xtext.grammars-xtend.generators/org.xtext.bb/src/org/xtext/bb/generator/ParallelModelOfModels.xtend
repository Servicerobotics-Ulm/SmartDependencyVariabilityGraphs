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
import bbn.Parallel
import org.eclipse.emf.ecore.EObject
import java.util.ArrayList
import bbn.BuildingBlockDescription
import bbn.EquivalenceFork
import bbn.BuildingBlock
import bbn.Container
import java.util.List
import bbn.DVG
import java.util.Map
import java.util.HashMap

class ParallelModelOfModels {
	
	DVG problemDVG
	
	List<List<MatchingAndGenerationData>> matchingAndGenerationDataList
	
	ExternalInformation ei
	
	Helpers he
	JavaFunctions jf
	
	List<Boolean> isEQUF
	
	Map<String,Integer> equfActives
	
	def String start(Decomposition d, DVG problemDVG) {
		this.he = new Helpers()
		this.jf = new JavaFunctions()
		this.problemDVG = problemDVG
		
		this.isEQUF = new ArrayList<Boolean>()
		this.equfActives = new HashMap<String, Integer>()
		
		println("START ParallelModelOfModels")
		if (d instanceof Parallel) {
			
			var StringBuilder code = new StringBuilder()
			
			var boolean firstFinished = false
			
			this.matchingAndGenerationDataList = new ArrayList<List<MatchingAndGenerationData>>()
			
			for (i : d.c) {
				var MatchingAndGeneration mag = new MatchingAndGeneration()
				var EObject bbd = i.bbr.eContainer
				var boolean hasDVGRef = false;
				
				if (bbd instanceof BuildingBlockDescription) {
					if (bbd.dvg !== null) {
						
						if (isEQUF(i)) {
							this.isEQUF.add(true)
							var EqufModelOfModels emom = new EqufModelOfModels()
							if (!firstFinished) {
								code.append(emom.start(i.bbr.dt.get(0), bbd.dvg, false))
								firstFinished = true;
							}
							else {
								code.append(emom.start(i.bbr.dt.get(0), bbd.dvg, true))
							}
							var List<MatchingAndGenerationData> lmagd = emom.getMatchingAndGenerationDataList()
						
							this.matchingAndGenerationDataList.add(lmagd)
							
							this.equfActives = emom.getEqufActives()
						}
						else {
							this.isEQUF.add(false)			
							if (!firstFinished) {
								code.append(mag.start(i.bbr, bbd.dvg, true, true, true))
								firstFinished = true	
							}
							else {
								code.append(mag.start(i.bbr, bbd.dvg, true, false, true))
							}
							
							// Matching and generation finished for a single container/building block
							var MatchingAndGenerationData magd = new MatchingAndGenerationData()
							magd.numberAllocations = mag.getAllocations()
							magd.active = mag.getActive()
							magd.passive = mag.getPassive()
							var List<MatchingAndGenerationData> tmp = new ArrayList<MatchingAndGenerationData>()
							tmp.add(magd)
							this.matchingAndGenerationDataList.add(tmp)
						}
					}
					else {
						mag.start(i.bbr, bbd.dvg, false, false, true)
					}
				}
			}		
			
			
			var String dvgCode = generateDVG()
			
			code.append(generateEvaluation(dvgCode))
						
			return code.toString()
		}
	}
	
	def boolean isEQUF(Container c) {
		if (c.bbr.dt.get(0) instanceof EquivalenceFork) {
			return true
		}
		else {
			return false
		}
	}
	
	def String generateDVG() {
		var DVGResolution dvgres = new DVGResolution()
		var String code = dvgres.start(this.problemDVG)
		this.ei = this.he.getExternalInformation(dvgres.getAbortPattern)
		return code
	}
	
	def String generateEvaluation(String dvgCode) {
		
		var Map<String, Integer> active = new HashMap<String,Integer>()
		var Map<String, Integer> passive = new HashMap<String,Integer>()
		
		var StringBuilder code = new StringBuilder()
		
		code.append("\n\t") 
		code.append("class "+this.problemDVG.name+"{")
			code.append("\n\t") 
			
			code.append("private Map<String, Node> NODE_COLLECTION;")
			
			code.append("\n\t")
			
			code.append(this.jf.generateIsValidCombinationConsiderResource())
			
			code.append("\n\t")
			
			code.append(dvgCode)
			
			code.append("\n\t")
			
			code.append(this.he.generateGenericAllocationAggr)
			
			code.append("\n\t")
			
			// We need to call the abortPattern with the inputs received from the referenced models
			
			code.append("void init() {")
			code.append("\n\t") 
			code.append("this.NODE_COLLECTION = new HashMap<String, Node>();")
			code.append("\n\t") 
			code.append("}")
			
			code.append("\n\t") 
			code.append("\n\t") 
			
			code.append("void solve() {")
			code.append("\n\t")
			code.append("List<Node> params = new ArrayList<Node>();")
			code.append("\n\t") 
			// First we call the abortpattern with the information from externalinformation
			for (var int i = 0; i < this.ei.dvgs.size(); i++) { // we assume ei.dvgs.size == ei.outputs.size == isEQUF.size
				code.append(this.ei.dvgs.get(i) +" ei_"+i+" = new "+this.ei.dvgs.get(i)+"();")
				code.append("\n\t") 
				code.append("ei_"+i+".init();")
				code.append("\n\t") 
				if (this.isEQUF.get(i)) {
					code.append("ei_"+i+".solve();")
					code.append("\n\t") 
					code.append("params.add(ei_"+i+".getNode(\""+this.ei.outputs.get(i)+"\"));")
				}
				else {
					if (this.matchingAndGenerationDataList.get(i).get(0).numberAllocations > 1) { // we know it is only one entry if not equf
					//code.append("if (ei_"+i+".getAllocations() > 1) {")
							code.append("\n\t\t")
							code.append("List<Node> tmp = new ArrayList<Node>();")
							code.append("\n\t\t")
							code.append("for (int i = 0; i < ei_"+i+".getAllocations(); i++) {")
								code.append("\n\t\t\t")
								code.append("tmp.add(ei_"+i+".solve(\""+this.ei.outputs.get(i)+"\",i));")
							code.append("\n\t\t")
							code.append("}")
						//code.append("params.add(AllocationAggr(tmp, \""+inputSet.get(i).get(j).name+"\"));")
						code.append("params.add(AllocationAggr(tmp, \""+"MAGR_ALLOCATION_"+this.ei.dvgs.get(i)+"\"));")
						code.append("\n\t\t")
					//code.append("}")
					code.append("\n\t\t")
					active.put("MAGR_ALLOCATION_"+this.ei.dvgs.get(i), this.matchingAndGenerationDataList.get(i).get(0).numberAllocations)
					}
					else {
					//code.append("else {")
						code.append("\n\t\t")
						code.append("params.add(ei_"+i+".solve(\""+this.ei.outputs.get(i)+"\",0));")
						code.append("\n\t\t")
					//code.append("}")
					}
					//code.append("params.add(ei_"+i+".solve(\""+this.ei.outputs.get(i)+"\"));")	
				}
				code.append("\n\t") 
			}
			code.append("\n\t")
			//code.append(generateCallSequenceCode(magrName, inputSetAg, dvgNames)) // we should insert here the call sequence from the DVGResolution of non-aborting patterns
			code.append("\n\t")
//			var StringBuilder paramList = new StringBuilder()
//			for (var int i = 0; i < this.ei.dvgs.size(); i++) {
//				paramList.append("ei_"+i)
//				if (i < this.ei.dvgs.size()-1) {
//					paramList.append(", ")	
//				}
//			}
			code.append("resolve_"+this.ei.pName+"(params);") 
			
			for (i : this.matchingAndGenerationDataList) {
				for (j : i) {
					active.putAll(j.active)
					passive.putAll(j.passive)
				}
			}
			
			active.putAll(this.equfActives)
		
			code.append("System.out.println(\"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\");")
			
			code.append(FinalEvaluation.getEQUFCode(this.ei.oName, active, passive)) // TODO: Only consistent if there is only one aborting pattern in the dvg
			code.append("\n\t") 
			code.append("}")
			code.append("\n\t") 
			code.append("}") // end of class
			
			
		return code.toString()
			
			

		/* 
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
			var List<MatchingAndGenerationData> magdl = getMatchingAndGenerationDataList
			for (var int i = 0; i < magdl.size(); i++) {
				if (magdl.get(i).numberAllocations > 1) {
					active.put("MAGR_ALLOCATION_"+dvgNames.get(i), magdl.get(i).numberAllocations)
				}
				println("magdl(i): "+ magdl.get(i).active)
			}
			
			// We need to add the EQUF itself
			active.put(magrName, numberInputs)
			
			
			
			code.append(FinalEvaluation.getEQUFCode(aggrOutputNames.get(0), active, passive)) // TODO: currently only consistent if nothing else than a MAGR with a single AGGR is modeled in the EQUF model
			code.append("\n\t") 
			code.append("}")
		code.append("}")
		
		code.append("\n\t") 
		
		return code.toString()
		*/
	}	
}
