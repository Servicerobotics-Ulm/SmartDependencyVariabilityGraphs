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

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import bbn.BuildingBlockDescription
import bbn.BlockType
import bbn.BuildingBlock
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.util.HashMap
import bbn.Decomposition
import java.util.Set
import java.util.LinkedHashSet
import bbn.DVG
import bbn.DMAGR
import bbn.Pattern
import bbn.VariabilityEntity
import bbn.EQUF
import bbn.Parallel
import bbn.EquivalenceFork
import bbn.MAGR
import org.eclipse.emf.ecore.EObject

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class BbDslGenerator extends AbstractGenerator {
	
	//var Map<Integer, List<String>> bReq
	var Map<Integer, Set<String>> bReq
	var Map<Integer, Set<String>> bProv
	var Map<Integer, List<Integer>> capableResource
	var Set<Integer> allocations
	var Map<Integer, Set<Integer>> allocationsMap
	//var Map<String, Integer> resGroupdIdMap
	
	var List<Set<Integer>> allocationsListSet
	var List<List<Integer>> allocationsListList
	var List<List<Integer>> allocationsListListNoDuplicates
	
	var BuildingBlock problemBB
	var DVG problemDVG
	var Map<Integer, BuildingBlockDescription> solutionBB
	var Map<Integer, List<bbn.Pattern>> solutionDVGPattern
	
	SolutionInterfaceMatching sim
	BdvgDslGenerator bdvg
	DvgDslGenerator dvg
	
	//List<MatchingAndGenerationData> matchingAndGenerationDataList
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		
		//this.bReq = new HashMap<Integer, List<String>>()
		this.bReq = new HashMap<Integer, Set<String>>()
		this.bProv = new HashMap<Integer, Set<String>>()
		this.capableResource = new HashMap<Integer, List<Integer>>
		//this.resGroupdIdMap = new HashMap<String, Integer>()
		
		//this.allocations = new LinkedHashSet<Integer>()
		this.allocationsMap = new HashMap<Integer, Set<Integer>>()
		
		var String code
		
		for (i : resource.allContents.toIterable.filter(BuildingBlockDescription)) {
			code = root(i)
		}
				
		fsa.generateFile("DVGSolver_"+this.problemDVG.name+".java", code);
	}
	
	def String root(BuildingBlockDescription bbd) {
		var boolean isValid = false;
		var boolean hasDVGRef = false;  
		var rootBlock = bbd.bb.get(0)
		if (rootBlock.blocktype == BlockType.ALLOCATABLE) {
			if (rootBlock.allocationCandidates.size > 0) {
				isValid = true;
			}
		}
		if (isValid) {
			println("This is a valid model for determining allocations!")
			this.problemBB = rootBlock
			if (bbd.dvg !== null) {
				this.problemDVG = bbd.dvg
				hasDVGRef = true
				//this.sim = new SolutionInterfaceMatching()
			}
			
			var boolean isEQUFModelOfModels = false
			var boolean isParallelModelOfModels = false
			
			if (rootBlock.dt.get(0) instanceof EquivalenceFork) {
				if (rootBlock.dt.get(0).c.get(0).bbr !== null) {
					if (rootBlock.dt.get(0).c.get(0).bbr.blocktype == BlockType.ALLOCATABLE) {
						isEQUFModelOfModels = true	
					}
				}
			}
			
			if (rootBlock.dt.get(0) instanceof Parallel) {
				if (rootBlock.dt.get(0).c.get(0).bbr !== null) {
					if (rootBlock.dt.get(0).c.get(0).bbr.blocktype == BlockType.ALLOCATABLE) {
						isParallelModelOfModels = true	
					}
				}
			}
			
			if (isEQUFModelOfModels) {
				println("isEQUFModelOfModels!!!")
				var EqufModelOfModels emom = new EqufModelOfModels()
				
				var StringBuilder code = new StringBuilder() 
									
				code.append(emom.start(rootBlock.dt.get(0), this.problemDVG, false))

				code.append("")
					code.append("public class DVGSolver_"+this.problemDVG.name+"{")
					code.append("\n\t") 
					code.append("public static void main (String[] args) {")
						code.append("\n\t") 
						code.append(this.problemDVG.name+" dvg = new "+this.problemDVG.name+"();")
						code.append("dvg.init();")
						code.append("\n\t\t")
						code.append("dvg.solve();")
						code.append("\n\t\t")
						//code.append("solve.solve();")		
		   			code.append("\n\t")
		   			code.append("}")
		   		code.append("\n")   
				code.append("}")
				code.append("\n\n")				
				return code.toString()				
				
			}	
			else if (isParallelModelOfModels) {
				println("isParallelModelOfModels!!!")
				
				var ParallelModelOfModels pmom = new ParallelModelOfModels()
				
				var StringBuilder code = new StringBuilder() 
									
				code.append(pmom.start(rootBlock.dt.get(0), this.problemDVG))				
				
				// if follows EQUF for a pattern -> call equf procedure (aggregating allocations if necessary)
				// if not equf -> standard (aggregating allocations if necessary)
				// apply dvg
					// if we reach the pattern with connections to the other models (transportation time, magr orderpicking time) filter redundant resource combinations between the inputs
				
				code.append("\n\t") 
				
				code.append("")
					code.append("public class DVGSolver_"+this.problemDVG.name+"{")
					code.append("\n\t") 
					code.append("public static void main (String[] args) {")
						code.append("\n\t") 
						code.append(this.problemDVG.name+" dvg = new "+this.problemDVG.name+"();")
						code.append("dvg.init();")
						code.append("\n\t\t")
						code.append("dvg.solve();")
						code.append("\n\t\t")
						//code.append("solve.solve();")		
		   			code.append("\n\t")
		   			code.append("}")
		   		code.append("\n")   
				code.append("}")
				code.append("\n\n")				
				
				return code.toString()
			}	
			else {
				var MatchingAndGeneration mag = new MatchingAndGeneration()
				return mag.start(this.problemBB, this.problemDVG, hasDVGRef, true, false)
			}
		}
		else {
			println("This is NOT a valid model for determining multi-robot task allocations!")
			println("Therefore the DVG solver for a concrete building block is generated!")
			this.dvg = new DvgDslGenerator()
			if (bbd.dvg !== null) {
				this.problemDVG = bbd.dvg
				var String code = this.dvg.root(this.problemDVG)
				return code	
			}
			else {
				println("ERROR: BuildingBlockDescription has no reference to a DVG!")
			}
		}
		
	}
}
