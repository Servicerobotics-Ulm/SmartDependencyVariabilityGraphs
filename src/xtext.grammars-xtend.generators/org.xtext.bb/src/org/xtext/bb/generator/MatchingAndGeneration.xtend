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
import java.util.Set
import java.util.List
import java.util.HashMap
import bbn.BuildingBlockDescription
import java.util.LinkedHashSet
import java.util.ArrayList
import bbn.BlockType
import bbn.Decomposition
import bbn.BuildingBlock
import bbn.VariabilityEntity
import bbn.DVG
import bbn.DMAGR

class MatchingAndGeneration {
	
	var Map<Integer, Set<String>> bReq
	var Map<Integer, Set<String>> bProv
	var Map<Integer, List<Integer>> capableResource
	var Set<Integer> allocations
	var Map<Integer, Set<Integer>> allocationsMap
	
	var List<Set<Integer>> allocationsListSet
	var List<List<Integer>> allocationsListList
	var List<List<Integer>> allocationsListListNoDuplicates	
	
	var BuildingBlock problemBB
	var DVG problemDVG
	
	var Map<Integer, BuildingBlockDescription> solutionBB
	var Map<Integer, List<bbn.Pattern>> solutionDVGPattern
	
	SolutionInterfaceMatching sim
	BdvgDslGenerator bdvg
	
	boolean generateStaticCode = true
	boolean sos = false
	
def int getAllocations() {
	return allocationsListListNoDuplicates.size()
}

def Map<String, Integer> getActive() {
	return this.bdvg.getActive()
}

def Map<String, Integer> getPassive() {
	return this.bdvg.getPassive()
}
	
def String start(BuildingBlock b, DVG d, boolean hasDVGRef, boolean gsc, boolean sos) {
	
		this.problemBB = b
		this.problemDVG = d
		
		this.generateStaticCode = gsc
		this.sos = sos
		
		this.bReq = new HashMap<Integer, Set<String>>()
		this.bProv = new HashMap<Integer, Set<String>>()
		this.capableResource = new HashMap<Integer, List<Integer>>
		this.allocationsMap = new HashMap<Integer, Set<Integer>>()	
		this.sim = new SolutionInterfaceMatching()
	
		determineBReq(b)
		
		this.solutionBB = new HashMap<Integer, BuildingBlockDescription>()
		
		for (var int i = 0; i < b.allocationCandidates.size; i++) {
			this.solutionBB.put(i, b.allocationCandidates.get(i))
			determineBProv(b.allocationCandidates.get(i), i)
		}
		determineCapableResources()
		
		
		/*
		this.capableResource = new HashMap<Integer, List<Integer>>()
		
		var List<Integer> testl0 = new ArrayList<Integer>()
		var List<Integer> testl1 = new ArrayList<Integer>()
		var List<Integer> testl2 = new ArrayList<Integer>()
		
		testl0.add(0)
		testl0.add(1)
		testl1.add(0)
		testl1.add(1)
		testl2.add(0)
		testl2.add(1)
		testl2.add(2)
		
		this.capableResource.put(0, testl0)
		this.capableResource.put(1, testl1)
		this.capableResource.put(2, testl2)
		*/
		println("capableResources: ")
		for (i : this.capableResource.entrySet) {
			println(i.key + " : "+i.value)	
		}
		
		this.allocationsListList = new ArrayList<List<Integer>>()
		this.allocationsListListNoDuplicates = new ArrayList<List<Integer>>()
		
		cartesianProduct(new ArrayList<Integer>(), 0)
		
		for (var int i = 0; i < this.allocationsListList.size; i++) {
			if (!hasDuplicates(this.allocationsListList.get(i))) {
				this.allocationsListListNoDuplicates.add(this.allocationsListList.get(i))
			}
		}
		
		println()
		println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
		println("Possible Allocations for <<ALLOCATABLE>> "+problemBB.name)
		println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
		for (var int i = 0; i < this.allocationsListListNoDuplicates.size; i++) {
			println("\t---------------------------------------------------------------------")
			println("\tAllocation "+ i+":")
			for (var int j = 0; j < this.allocationsListListNoDuplicates.get(i).size; j++) {
				print("\t"+j+"-th resource group by resource: "+this.solutionBB.get(this.allocationsListListNoDuplicates.get(i).get(j)).name)
				print("\t")
			}
			println()
			println("\t---------------------------------------------------------------------")
		}
		
		if (hasDVGRef) {
			// Search for DMAGR to check which DOs of which building blocks are required from the possible solution models
			this.solutionDVGPattern = new HashMap<Integer, List<bbn.Pattern>>()
			this.bdvg = new BdvgDslGenerator()
			var DMAGR dmagr = this.sim.getDMAGR(this.problemDVG)
			var List<VariabilityEntity> solutionInterface = this.sim.determineSolutionInterface2(dmagr)
			if (dmagr !== null) {
				
				var List<String> determined = new ArrayList<String>()
				
				for (var int i = 0; i < this.allocationsListListNoDuplicates.size; i++) {
					for (var int j = 0; j < this.allocationsListListNoDuplicates.get(i).size; j++) {
						var String bbdesc = this.solutionBB.get(this.allocationsListListNoDuplicates.get(i).get(j)).name
						if (!determined.contains(bbdesc)) {
							determined.add(bbdesc)
							if (this.solutionBB.get(this.allocationsListListNoDuplicates.get(i).get(j)).dvg !== null) {
								var List<bbn.Pattern> resPattern = this.sim.findMatchingOutputPorts2(this.solutionBB.get(this.allocationsListListNoDuplicates.get(i).get(j)).dvg, solutionInterface)
								this.solutionDVGPattern.put(this.allocationsListListNoDuplicates.get(i).get(j), resPattern)
							}
							else {
								println("ERROR: No DVG reference of a capable resource!")
							}
						}
						
					}
				}
				
				// Relevant now is allocationsListListNoDuplicates, solutionInterface and solutionDVGPattern
				// for each solution resource with @id there should be a reference in solutionDVGPattern to the corresponding patterns at key @id
				
				// when we arrive at a DMAGR we use solutionInterface to check for every entry the corresponding pattern match in solutionDVGPattern for
				// the current allocation and its resource groups
				return this.bdvg.root(this.problemDVG, this.allocationsListListNoDuplicates, this.solutionDVGPattern, this.generateStaticCode, this.sos)
				
			}
			else {
				println("ERROR: No DMAGR found!")
			}
		}
		else {
			println("Problem model has no DVG reference!")
		}	
	}
	
	def determineBReq(BuildingBlock b) {
		iterateProblem(b.dt, this.bReq)
		println("bReq: ")
		for (i : this.bReq.entrySet) {
			println(i.key + " : "+i.value)
		}
	}

	def determineBProv(BuildingBlockDescription bd, int sysId) {
		println("bbdescp: "+ bd.name)
		for (i : bd.bb) {
			println("candidates bb: " + i.name)
			addEntry(sysId, i.name, this.bProv)
			iterateSolution(i.dt, sysId, this.bProv)
		}
		for (i : bd.c) {
			println("candidates bb: " + i.bbr.name)
			addEntry(sysId, i.bbr.name, this.bProv)
			iterateSolution(i.bbr.dt, sysId, this.bProv)
		}		
		println("bProv: ")
		for (i : this.bProv.entrySet) {
			println(i.key + " : "+i.value)	
		}
	}	
	
	def iterateProblem(List<Decomposition> dl, Map<Integer, Set<String>> data) {
		
		for (i : dl) {
			for (j : i.c) {
				if (j.bbc !== null) {
					if (j.bbc.blocktype == BlockType.CONCRETE) {
						//println("name: " + j.bbc.name)
						if (j.bbc.resourcegroupid !== null) {
							addEntry(j.bbc.resourcegroupid.number, j.bbc.name, data)
							iterateProblem(j.bbc.dt, j.bbc.resourcegroupid.number, data)
							// all childs must have the same resourcegroupid which we assign automatically
						}
						else {
							addEntry(0, j.bbc.name, data)
							iterateProblem(j.bbc.dt, data)
						}
					}
					else if (j.bbc.blocktype == BlockType.ABSTRACT) {			
						if (j.bbc.resourcegroupid !== null) {
							iterateProblem(j.bbc.dt, j.bbc.resourcegroupid.number, data)
							// all childs must have the same resourcegroupid which we assign automatically
						}
						else {
							iterateProblem(j.bbc.dt, data)
						}						
					}		
				}
				else if (j.bbr !== null) {
					if (j.bbr.blocktype == BlockType.CONCRETE) {
						//println("name: " + j.bbc.name)
						if (j.bbr.resourcegroupid !== null) {
							addEntry(j.bbr.resourcegroupid.number, j.bbr.name, data)
							iterateProblem(j.bbr.dt, j.bbr.resourcegroupid.number, data)
							// all childs must have the same resourcegroupid which we assign automatically
						}
						else {
							addEntry(0, j.bbr.name, data)
							iterateProblem(j.bbr.dt, data)
						}
					}
					else if (j.bbr.blocktype == BlockType.ABSTRACT) {			
						if (j.bbr.resourcegroupid !== null) {
							iterateProblem(j.bbr.dt, j.bbr.resourcegroupid.number, data)
							// all childs must have the same resourcegroupid which we assign automatically
						}
						else {
							iterateProblem(j.bbr.dt, data)
						}						
					}	
				}
				else if (j.bbi !== null) {
					// TODO
				}				
			}	
		}
	}
	
	def iterateProblem(List<Decomposition> dl, int resGroupId, Map<Integer, Set<String>> data) {
		
		for (i : dl) {
			for (j : i.c) {
				if (j.bbc !== null) {
					if (j.bbc.blocktype == BlockType.CONCRETE) {
						addEntry(resGroupId, j.bbc.name, data)
						iterateProblem(j.bbc.dt, data)
					}
					else if (j.bbc.blocktype == BlockType.ABSTRACT) {
						iterateProblem(j.bbc.dt, j.bbc.resourcegroupid.number, data)
					}
				}
				else if (j.bbr !== null) {
					if (j.bbr.blocktype == BlockType.CONCRETE) {
						addEntry(resGroupId, j.bbr.name, data)
						iterateProblem(j.bbr.dt, data)
					}
					else if (j.bbr.blocktype == BlockType.ABSTRACT) {
						iterateProblem(j.bbr.dt, j.bbr.resourcegroupid.number, data)
					}
				}
				else if (j.bbi !== null) {
					// TODO
				}				
			}	
		}
	}	
	
	def iterateSolution(List<Decomposition> dl, int sysId, Map<Integer, Set<String>> data) {
		
		for (i : dl) {
			for (j : i.c) {
				if (j.bbc !== null) {
					if (j.bbc.blocktype == BlockType.CONCRETE) {
						if (j.bbc.resourcegroupid !== null) {
							// TODO: This should not happen for solutions!
						}
						else {
							addEntry(sysId, j.bbc.name, data)
							iterateSolution(j.bbc.dt, sysId, data)
						}
					}
					else if (j.bbc.blocktype == BlockType.ABSTRACT) {			
						if (j.bbc.resourcegroupid !== null) {
							// TODO:
						}
						else {
							// TODO:
						}						
					}		
				}
				else if (j.bbr !== null) {
					if (j.bbr.blocktype == BlockType.CONCRETE) {
						if (j.bbr.resourcegroupid !== null) {
							// TODO: This should not happen for solutions!
						}
						else {
							addEntry(sysId, j.bbr.name, data)
							iterateSolution(j.bbr.dt, sysId, data)
						}
					}
					else if (j.bbr.blocktype == BlockType.ABSTRACT) {			
						if (j.bbr.resourcegroupid !== null) {
							// TODO:
						}
						else {
							// TODO:
						}						
					}	
				}
				else if (j.bbi !== null) {
					// TODO
				}				
			}	
		}
	}	
	
	def addEntry(int id, String name, Map<Integer, Set<String>> data) {
		if (data.containsKey(id)) {
			//var List<String> strList = bReq.get(id)
			var Set<String> strSet = data.get(id)
			strSet.add(name)
			data.put(id, strSet)
		}
		else {
			//var List<String> strList = new ArrayList<String>()
			var Set<String> strSet = new LinkedHashSet<String>()
			strSet.add(name)
			data.put(id, strSet)
		}		
	}
	
	def determineCapableResources() { // Variant 1: There must be an allocation for each resource group (special case: No resource group) 
									  
		var Map<String, Integer> tmp
		
		for (i : this.bProv.entrySet) {
			// for i-th resource
			tmp = new HashMap<String, Integer>()
			for (j : i.value) {
				// for j-th bb
				tmp.put(j, 0)
			}
			
			for (j : this.bReq.entrySet) {
				// for j-th resource group
				var boolean isCapable = true
				for (k : j.value) {
					// for k-th bb
					if (!tmp.containsKey(k)) {
						// j-th resource group can not be assigned to i-th resource
						isCapable = false
					}
				}
				if (isCapable) {
					addSolutionEntry(j.key, i.key, this.capableResource)
				}
			}			
			
		}
	
		println("capableResources: ")
		for (i : this.capableResource.entrySet) {
			println(i.key + " : "+i.value)	
		}

	}

	def addSolutionEntry(int group, int resource, Map<Integer, List<Integer>> data) {
		if (data.containsKey(group)) {
			var List<Integer> l = data.get(group)
			l.add(resource)
			data.put(group, l)
		}
		else {
			var List<Integer> l = new ArrayList<Integer>()
			l.add(resource)
			data.put(group, l)
		}		
	}	
	
	def cartesianProduct(List<Integer> arg, int cnt) {
		
		for (var int j = 0; j < this.capableResource.get(cnt).size; j++) {
		
            var List<Integer> tmp = new ArrayList<Integer>();
			
            for (var int i = 0; i < cnt; i++) {
           		tmp.add(arg.get(i));
            }
            
            arg.clear();
            arg.addAll(tmp);
            arg.add(this.capableResource.get(cnt).get(j))
            
            if (cnt == this.capableResource.size-1) {
            	this.allocationsListList.add(new ArrayList<Integer>())
                this.allocationsListList.get(this.allocationsListList.size()-1).addAll(arg);
            }
            else {
            	cartesianProduct(arg, cnt+1);
            }
        }
	}
	
	def hasDuplicates(List<Integer> param) {
		var Set<Integer> tmp = new LinkedHashSet<Integer>()
		for (i : param) {
			if (!tmp.add(i)) {
				return true
			}
		}
		return false
	}	
	
}
