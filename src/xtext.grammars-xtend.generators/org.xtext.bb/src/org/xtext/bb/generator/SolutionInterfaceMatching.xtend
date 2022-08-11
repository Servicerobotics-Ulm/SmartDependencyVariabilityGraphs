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

import bbn.DVG
import bbn.DMAGR
import dor.DataObjectDef
import java.util.List
import java.util.AbstractMap.SimpleEntry
import java.util.ArrayList
import bbn.VariabilityEntity
import org.eclipse.emf.ecore.EObject
import bbn.BuildingBlock
import bbn.INIT
import bbn.SAPRO
import bbn.APRO
import bbn.AbstractOutputPort

class SolutionInterfaceMatching {

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
	
	def List<bbn.Pattern> findMatchingOutputPorts1(DVG solutionDVG, List<SimpleEntry<DataObjectDef, String>> solutionInterface) {
		// For every entry of the solutionInterface we need to have a match in the solutionDVG
		var List<bbn.Pattern> resPattern = new ArrayList<bbn.Pattern>()
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
	
	def List<bbn.Pattern> findMatchingOutputPorts2(DVG solutionDVG, List<VariabilityEntity> solutionInterface) {
		// For every entry of the solutionInterface we need to have a match in the solutionDVG
		var List<bbn.Pattern> resPattern = new ArrayList<bbn.Pattern>()
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
	
	def bbn.Pattern getPattern(AbstractOutputPort aon) {
		var EObject obj = aon.eContainer
		if (obj instanceof bbn.Pattern) {
			return obj	
		}
	}	
	
}
