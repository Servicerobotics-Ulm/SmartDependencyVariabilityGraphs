package org.xtext.bb.generator 
import java.util.Map
import java.util.Set
import java.util.List
import java.util.HashMap
import BbDvgTcl.BuildingBlockDescription
import java.util.LinkedHashSet
import java.util.ArrayList
import BbDvgTcl.BlockType
import BbDvgTcl.Decomposition
import BbDvgTcl.BuildingBlock
import BbDvgTcl.DVG

class BuildingBlockMatching {
	
	var Map<Integer, Set<String>> bReq
	var Map<Integer, Set<String>> bProv
	var Map<Integer, List<Integer>> capableResource
	
	var List<List<Integer>> allocationsListList
	var List<List<Integer>> allocationsListListNoDuplicates	
			
	def int getAllocationsNumber() {
		return allocationsListListNoDuplicates.size()
	}
	
	def List<List<Integer>> getAllocations() {
		return allocationsListListNoDuplicates
	}
	
	def start(BuildingBlock b, DVG d) {
		
		this.bReq = new HashMap<Integer, Set<String>>()
		this.bProv = new HashMap<Integer, Set<String>>()
		this.capableResource = new HashMap<Integer, List<Integer>>
	
		determineBReq(b)
		
		for (var int i = 0; i < b.allocationCandidates.size; i++) {
			determineBProv(b.allocationCandidates.get(i), i)
		}
		determineCapableResources()
		
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
				var int resourcegroupid = -1
				if (j.resourcegroupid !== null) {
					resourcegroupid = j.resourcegroupid.number
				}				
				if (j.bbc !== null) {
					if (j.bbc.blocktype == null || j.bbc.blocktype == BlockType.IDENTIFYING) {
						//println("name: " + j.bbc.name)
						if (resourcegroupid !== -1) {
							addEntry(resourcegroupid, j.bbc.name, data)
							iterateProblem(j.bbc.dt, resourcegroupid, data)
							// all childs must have the same resourcegroupid which we assign automatically
						}
						else {
							addEntry(0, j.bbc.name, data)
							iterateProblem(j.bbc.dt, data)
						}
					}
					else if (j.bbc.blocktype == BlockType.COMPOSED) {			
						if (resourcegroupid !== -1) {
							iterateProblem(j.bbc.dt, resourcegroupid, data)
							// all childs must have the same resourcegroupid which we assign automatically
						}
						else {
							iterateProblem(j.bbc.dt, data)
						}						
					}
					else if (j.bbc.blocktype == BlockType.SUPER_IDENTIFYING) {
						if (resourcegroupid !== -1) {
							addEntry(resourcegroupid, j.bbc.name, data)
						}
						else {
							addEntry(0, j.bbc.name, data)
						}
					}		
				}
				else if (j.bbr !== null) {
					if (j.bbr.blocktype == null || j.bbr.blocktype == BlockType.IDENTIFYING) {
						//println("name: " + j.bbc.name)
						if (resourcegroupid !== -1) {
							addEntry(resourcegroupid, j.bbr.name, data)
							iterateProblem(j.bbr.dt, resourcegroupid, data)
							// all childs must have the same resourcegroupid which we assign automatically
						}
						else {
							addEntry(0, j.bbr.name, data)
							iterateProblem(j.bbr.dt, data)
						}
					}
					else if (j.bbr.blocktype == BlockType.COMPOSED) {			
						if (resourcegroupid !== -1) {
							iterateProblem(j.bbr.dt, resourcegroupid, data)
							// all childs must have the same resourcegroupid which we assign automatically
						}
						else {
							iterateProblem(j.bbr.dt, data)
						}						
					}
					else if (j.bbr.blocktype == BlockType.SUPER_IDENTIFYING) {
						if (resourcegroupid !== -1) {
							addEntry(resourcegroupid, j.bbr.name, data)
						}							
						else {
							addEntry(0, j.bbr.name, data)
						}
					}	
				}
				else if (j.bbi !== null) {
					// TODO: Do we need this case?
				}				
			}	
		}
	}
	
	def iterateProblem(List<Decomposition> dl, int resGroupId, Map<Integer, Set<String>> data) {
		
		for (i : dl) {
			for (j : i.c) {
				var int resourcegroupid = -1
				if (j.resourcegroupid !== null) {
					resourcegroupid = j.resourcegroupid.number
				}
				if (j.bbc !== null) {
					if (j.bbc.blocktype == null || j.bbc.blocktype == BlockType.IDENTIFYING) {
						addEntry(resGroupId, j.bbc.name, data)
						iterateProblem(j.bbc.dt, data)
					}
					else if (j.bbc.blocktype == BlockType.COMPOSED) {
						if (resourcegroupid !== -1) {
							iterateProblem(j.bbc.dt, resourcegroupid, data)
						}
					}
					else if (j.bbc.blocktype == BlockType.SUPER_IDENTIFYING) {
						addEntry(resGroupId, j.bbc.name, data)
					}
				}
				else if (j.bbr !== null) {
					if (j.bbr.blocktype == null || j.bbr.blocktype == BlockType.IDENTIFYING) {
						addEntry(resGroupId, j.bbr.name, data)
						iterateProblem(j.bbr.dt, data)
					}
					else if (j.bbr.blocktype == BlockType.COMPOSED) {
						if (resourcegroupid !== -1) {
							iterateProblem(j.bbr.dt, resourcegroupid, data)
						}
					}
					else if (j.bbr.blocktype == BlockType.SUPER_IDENTIFYING) {
						addEntry(resGroupId, j.bbr.name, data)
					}
				}
				else if (j.bbi !== null) {
					// TODO: Do we need this case?
				}				
			}	
		}
	}	
	
	def iterateSolution(List<Decomposition> dl, int sysId, Map<Integer, Set<String>> data) {
		
		for (i : dl) {
			for (j : i.c) {
				var int resourcegroupid = -1
				if (j.resourcegroupid !== null) {
					resourcegroupid = j.resourcegroupid.number
				}
				if (j.bbc !== null) {
					if (j.bbc.blocktype == null || j.bbc.blocktype == BlockType.IDENTIFYING) {
						if (resourcegroupid !== -1) {
							// TODO: This should not happen for solutions!
						}
						else {
							addEntry(sysId, j.bbc.name, data)
							iterateSolution(j.bbc.dt, sysId, data)
						}
					}
					else if (j.bbc.blocktype == BlockType.COMPOSED) {			
						if (resourcegroupid !== -1) {
							// TODO: Do we need this case?
						}
						else {
							// TODO: Do we need this case?
						}						
					}		
				}
				else if (j.bbr !== null) {
					if (j.bbr.blocktype == null || j.bbr.blocktype == BlockType.IDENTIFYING) {
						if (resourcegroupid !== -1) {
							// TODO: This should not happen for solutions!
						}
						else {
							addEntry(sysId, j.bbr.name, data)
							iterateSolution(j.bbr.dt, sysId, data)
						}
					}
					else if (j.bbr.blocktype == BlockType.COMPOSED) {			
						if (resourcegroupid !== -1) {
							// TODO: Do we need this case?
						}
						else {
							// TODO: Do we need this case?
						}						
					}	
				}
				else if (j.bbi !== null) {
					// TODO: Do we need this case?
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