package org.xtext.bb.generator

import BbDvgTcl.DVG
import BbDvgTcl.DMAGR
import dor.DataObjectDef
import java.util.List
import java.util.AbstractMap.SimpleEntry
import java.util.ArrayList
import BbDvgTcl.VariabilityEntity
import org.eclipse.emf.ecore.EObject
import BbDvgTcl.BuildingBlock
import BbDvgTcl.INIT
import BbDvgTcl.SAPRO
import BbDvgTcl.APRO
import BbDvgTcl.AbstractOutputPort
import java.util.Map
import java.util.HashMap
import BbDvgTcl.BuildingBlockDescription

class SolutionInterfaceMatching {
	
	var Map<Integer, List<BbDvgTcl.Pattern>> solutionDVGPattern
	
	def Map<Integer, List<BbDvgTcl.Pattern>> getSolutionDVGPattern() {
		return this.solutionDVGPattern
	}
	
	def start(DVG dvg, Map<Integer, BuildingBlockDescription> solutionBB, List<List<Integer>> allocations) {
		this.solutionDVGPattern = new HashMap<Integer, List<BbDvgTcl.Pattern>>()
		var DMAGR dmagr = getDMAGR(dvg)
		var List<VariabilityEntity> solutionInterface = determineSolutionInterface2(dmagr)
		if (dmagr !== null) {
			
			var List<String> determined = new ArrayList<String>()
			
			for (var int i = 0; i < allocations.size; i++) {
				for (var int j = 0; j < allocations.get(i).size; j++) {
					var String bbdesc = solutionBB.get(allocations.get(i).get(j)).name
					if (!determined.contains(bbdesc)) {
						determined.add(bbdesc)
						if (solutionBB.get(allocations.get(i).get(j)).dvg !== null) {
							var List<BbDvgTcl.Pattern> resPattern = findMatchingOutputPorts2(solutionBB.get(allocations.get(i).get(j)).dvg, solutionInterface)
							this.solutionDVGPattern.put(allocations.get(i).get(j), resPattern)
						}
						else {
							println("ERROR: No DVG reference of a capable resource!")
						}
					}
				}
			}		
		}
	}

	def DMAGR getDMAGR(DVG dvg) {
		for (i : dvg.pattern) {
			if (i instanceof DMAGR) {
				return i
			}
		}
	}	
	
	def List<SimpleEntry<DataObjectDef, String>> determineSolutionInterface1(DMAGR dmagr) {

		var List<SimpleEntry<DataObjectDef, String>> solutionInterface = new ArrayList<SimpleEntry<DataObjectDef, String>>()
		
		for (i : dmagr.daggr) {
			solutionInterface.add(new SimpleEntry<DataObjectDef, String>(i.op.ve.dor, getBB(i.op.ve)))
		}
		
		return solutionInterface
	}
	
	def List<VariabilityEntity> determineSolutionInterface2(DMAGR dmagr) {

		var List<VariabilityEntity> solutionInterface = new ArrayList<VariabilityEntity>()
		
		for (i : dmagr.daggr) {
			solutionInterface.add(i.op.ve)
		}
		
		return solutionInterface
	}	
	
	def String getBB(VariabilityEntity ve) {
		var EObject obj = ve.eContainer.eContainer.eContainer
		if (obj instanceof BuildingBlock) {
			return obj.name	
		}
		else {
			println("getBB: Something did not work!")
		}		
	}
	
	def List<BbDvgTcl.Pattern> findMatchingOutputPorts1(DVG solutionDVG, List<SimpleEntry<DataObjectDef, String>> solutionInterface) {
		// For every entry of the solutionInterface we need to have a match in the solutionDVG
		var List<BbDvgTcl.Pattern> resPattern = new ArrayList<BbDvgTcl.Pattern>()
		for (i : solutionInterface) {
			var DataObjectDef reqDod = i.key
			var String reqBBName = i.value
			var DataObjectDef provDod
			var String provBBName
			var AbstractOutputPort aop
			var boolean ignore = false
			// We need to find an output port whose ve references reqDod and is contained by a bb with name reqBBName
			// TODO: Name matching and the problem with instances (e.g.: GotoLocation1 ...)
			// TODO: Multiple instance problem
			for (j : solutionDVG.pattern) {
				if (!ignore) {
					if (j instanceof INIT) {
						provDod = j.ainip.ve.dor
						provBBName = getBB(j.ainip.ve)
						aop = j.ainip
					}
					else if (j instanceof SAPRO) {
						provDod = j.op.ve.dor
						provBBName = getBB(j.op.ve)
						aop = j.op
					}
					else if (j instanceof APRO) {
						provDod = j.op.ve.dor
						provBBName = getBB(j.op.ve)
						aop = j.op
					}
					
					if (reqDod == provDod && reqBBName == provBBName) {
						// output port of pattern j is a match for the current entry of the solutionInterface
						resPattern.add(getPattern(aop))
						ignore = true
					}	
				}
			}
		}
		if (solutionInterface.size == resPattern.size()) {
			println("Successful match for all entries of the solutionInterface!")
		}
		else {
			println("Unsuccessful match for the solutionInterface!")
		}
		
		println("solutionInterface1: ")
		for (i : solutionInterface) {
			println(i.key+"/"+i.value)
		}
		println("resPattern1: ")
		for (i : resPattern) {
			println(i.name)
		}		
		
		return resPattern
	}
	
	def List<BbDvgTcl.Pattern> findMatchingOutputPorts2(DVG solutionDVG, List<VariabilityEntity> solutionInterface) {
		// For every entry of the solutionInterface we need to have a match in the solutionDVG
		var List<BbDvgTcl.Pattern> resPattern = new ArrayList<BbDvgTcl.Pattern>()
		for (i : solutionInterface) {
			var VariabilityEntity reqVe = i
			var VariabilityEntity provVe
			var AbstractOutputPort aop
			var boolean ignore = false
			// TODO: Multiple instance problem: We assume that every solutionDVG can have at most one match with a ve of the solutionInterface which means
			// that several ports referencing the same ve of a building block are not possible/not considered. That means solutions do not model instances!
			// => (low level aggregation, solutions provide only initializing values, there is one common DVG which is connected to these values of the solutions)
			// the opposite is high level aggregation, i.e. solutions provide their own dvg composing higher level values, the common DVG just aggregates these higher level values  
			// low level aggregation handles multiple instances in the common DVG
			// high level aggregation handles multiple instances in each solution DVG separately
			for (j : solutionDVG.pattern) { // TODO: Containers?
				if (!ignore) {
					if (j instanceof INIT) {
						provVe = j.ainip.ve
						aop = j.ainip
					}
					else if (j instanceof SAPRO) {
						provVe = j.op.ve
						aop = j.op
					}
					else if (j instanceof APRO) {
						provVe = j.op.ve
						aop = j.op
					}
					// TODO: Do we need the other patterns?
					
					if (reqVe == provVe) {
						// output port of pattern j is a match for the current entry of the solutionInterface
						resPattern.add(getPattern(aop))
						ignore = true
					}	
				}
			}
		}
		if (solutionInterface.size == resPattern.size()) {
			println("Successful match for all entries of the solutionInterface!")
		}
		else {
			println("Unsuccessful match for the solutionInterface!")
		}
		
		println("solutionInterface2: ")
		for (i : solutionInterface) {
			println(i)
		}
		println("resPattern2: ")
		for (i : resPattern) {
			println(i.name)
		}		
		
		return resPattern
	}	
	
	def BbDvgTcl.Pattern getPattern(AbstractOutputPort aon) {
		var EObject obj = aon.eContainer
		if (obj instanceof BbDvgTcl.Pattern) {
			return obj	
		}
	}	
	
}
