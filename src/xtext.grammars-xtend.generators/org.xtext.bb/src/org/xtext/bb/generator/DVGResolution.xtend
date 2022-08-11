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
import java.util.HashMap
import java.util.Map
import java.util.List
import java.util.ArrayList
import bbn.AbstractOutputPort
import java.util.AbstractMap.SimpleEntry
import bbn.INIT
import bbn.RPRO
import bbn.SAPRO
import bbn.APRO
import bbn.DMAGR
import bbn.MAGR
import bbn.EquivalenceFork
import bbn.ConditionalFork
import bbn.CONT
import org.eclipse.emf.ecore.EObject
import bbn.InputWSMPort
import bbn.EPROD
import bbn.TRAN
import bbn.COMF
import bbn.PTCC
import bbn.InputPort
import bbn.ExtInputPort
import bbn.PropertyInst
import bbn.BuildingBlock
import bbn.BlockType

class DVGResolution {
	
	Map<bbn.Pattern,Boolean> IS_RESOLVED_MAP
	
	Helpers he
	JavaFunctions jf
	
	var StringBuilder code
	
	bbn.Pattern abortPattern

	def bbn.Pattern getAbortPattern() {
		return this.abortPattern
	}
	
	def String start(DVG dvg) {
		
		println("DVGResolution***************************************************************************************************************************************************")
		
		this.he = new Helpers()
		this.jf = new JavaFunctions()
		
		this.IS_RESOLVED_MAP = new HashMap<bbn.Pattern,Boolean>()
		
		this.code = new StringBuilder()
		
		for (i : dvg.pattern) {
			if (!this.IS_RESOLVED_MAP.containsKey(i)) {
				resolveNext(i)
			}
			else {
				if (!this.IS_RESOLVED_MAP.get(i)) {
					resolveNext(i)
				}	
			}
		}
		
		code.append(this.jf.generateGetCartesianProductFunction())
		code.append("\n")
		//code.append(this.jf.generateIsValidCombinationIgnoreResource())
		code.append("\n")
		
		return this.code.toString()
	}
	
	def resolveNext(bbn.Pattern lp) {
		
		System.out.println("resolveNext, Pattern name: " + lp.name)
		
		var List<bbn.DVGPort> inputSet = new ArrayList<bbn.DVGPort>() // This is for generating the call sequence code of the patterns with the name of the referenced output node
		var List<List<bbn.DVGPort>> inputSetAg = new ArrayList<List<bbn.DVGPort>>()
		var List<bbn.AbstractInputPort> inputSetInputs = new ArrayList<bbn.AbstractInputPort>() // This is for the $names$ in the expressions
		var List<List<SimpleEntry<AbstractOutputPort,String>>> allocInputSet = new ArrayList<List<SimpleEntry<AbstractOutputPort,String>>>()
		var List<Boolean> isAlloc = new ArrayList<Boolean>()
		var boolean abort = false
		
		// TODO: Implement others
		
		if (lp instanceof INIT) {}
				
		else if (lp instanceof RPRO) {}
		
		else if (lp instanceof SAPRO) {
			abort = abort(lp.ip)
			if (abort) {
				this.abortPattern = lp
			}
			for (i : lp.ip) {
				inputSetInputs.add(i)
				inputSet.add(i.outputport)
				if (!abort) {
					var bbn.Pattern lpr = this.he.getPattern(i.outputport)
					if (!this.IS_RESOLVED_MAP.containsKey(lpr)) {
						this.IS_RESOLVED_MAP.put(lpr,false)
						resolveNext(lpr)
					}
					else {
						if (!this.IS_RESOLVED_MAP.get(lpr)) {
							resolveNext(lpr)
						}
					}	
				}
			}	

		}		
		
		else if (lp instanceof APRO) {}
		
		else if (lp instanceof MAGR) {}
		
		else if (lp instanceof DMAGR) {}
		
		else if (lp instanceof CONT) {}
		
		else if (lp instanceof EPROD) {}		
		
		else if (lp instanceof TRAN) {}
		
		else if (lp instanceof COMF) {}
		
		else if (lp instanceof PTCC) {}
		
		else {
			println("Unknown Pattern!")
		}
		
		this.code.append(resolve(lp, inputSetInputs))
		this.IS_RESOLVED_MAP.put(lp, true)
		
		// TODO: Generate call sequence for non-aborting patterns
		
		if (lp instanceof MAGR) {
			//this.CALL_SEQUENCE_CODE.append(this.jf.generateCallSequenceCodeAg(lp.name, inputSetAg))
		}
		else if (!(lp instanceof INIT) && !(lp instanceof DMAGR)) {
			//this.CALL_SEQUENCE_CODE.append(this.jf.generateCallSequenceCode(lp.name, inputSet, allocInputSet, isAlloc))
		}
	}
	
	def String resolve(bbn.Pattern lp, List<bbn.AbstractInputPort> inputSet) {
		
		// TODO: Implement others
		
		if (lp instanceof COMF) {}
		
		else if (lp instanceof RPRO) {}
		
		else if (lp instanceof SAPRO) {
			var SAPROPattern saprop = new SAPROPattern()
			return saprop.resolve(lp, inputSet)
		}
		
		else if (lp instanceof APRO) {}
		
		else if (lp instanceof MAGR) {}
		
		else if (lp instanceof TRAN) {}
		
		else if (lp instanceof CONT) {}
		
		else if (lp instanceof EPROD) {}
		
		else if (lp instanceof PTCC) {}
		
		else {
			println("Unknown Pattern!")
		}
	}
	
	def boolean abort(List<InputPort> ipl) {
		var boolean abort = false
		for (i : ipl) {
			if (i instanceof ExtInputPort) {
				if (i.outputport.ve instanceof PropertyInst) {
					var EObject tmp = i.outputport.ve.eContainer.eContainer.eContainer
					if (tmp instanceof BuildingBlock) {
						if (tmp.blocktype == BlockType.ALLOCATABLE) {
							abort = true
						}
					}
				}
				// TODO: Implement other cases
			}
		}
		return abort
	}
}
