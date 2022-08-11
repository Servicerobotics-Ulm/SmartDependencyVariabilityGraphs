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
import bbn.RPRO
import bbn.MAGR
import bbn.CONT
import bbn.EPROD
import bbn.TRAN
import bbn.COMF
import bbn.PTCC
import java.util.Set
import bbn.OutputPort
import java.util.HashSet
import bbn.BBContainer

class DynamicSolutionLinks {
	
	Helpers he
	
	Set<SimpleEntry<bbn.Pattern, OutputPort>> depToDaggr
	
	def Set<SimpleEntry<bbn.Pattern, OutputPort>> getDepToDaggr() {
		return this.depToDaggr
	} 
	
	def determineDMAGRReferences(DVG dvg) {
		
		this.he = new Helpers()
		this.depToDaggr = new HashSet<SimpleEntry<bbn.Pattern, OutputPort>>()
		
		for (i : dvg.pattern) {
			detDAGGRDep(i)
		}
		
		for (i : dvg.bbcontainer) {
			determineDMAGRReferences(i)
		}
	}
	
	def determineDMAGRReferences(BBContainer bbc) {
		
		for (i : bbc.pattern) {
			detDAGGRDep(i)
		}
		
		for (i : bbc.bbcontainer) {
			determineDMAGRReferences(i) 
		}
	}

	def detDAGGRDep (bbn.Pattern p) {
		
		if (p instanceof RPRO) {
			for (i : p.ip) {
				if (i.outputport !== null) {
					if (this.he.isDaggr(i.outputport)) {
						this.depToDaggr.add(new SimpleEntry<bbn.Pattern, OutputPort>(p, i.outputport))
					}
				}
			}			
		}
		else if (p instanceof SAPRO) {
			for (i : p.ip) {
				if (i.outputport !== null) {
					if (this.he.isDaggr(i.outputport)) {
						this.depToDaggr.add(new SimpleEntry<bbn.Pattern, OutputPort>(p, i.outputport))
					}
				}
			}				
		}
		else if (p instanceof APRO) {
			for (i : p.ip) {
				if (i.outputport !== null) {
					if (this.he.isDaggr(i.outputport)) {
						this.depToDaggr.add(new SimpleEntry<bbn.Pattern, OutputPort>(p, i.outputport))
					}
				}
			}				
		}
		
		// TODO: Are the others also required?
		else if (p instanceof MAGR) {	
			
		}	
		else if (p instanceof CONT) {
	
		}	
		else if (p instanceof EPROD) {	
			
		}		
		else if (p instanceof TRAN) {
	
		}		
		else if (p instanceof COMF) {		
			
		}
		else if (p instanceof PTCC) {	
			
		}	
	}
	
}
