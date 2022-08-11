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

import java.util.Map
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import java.util.List
import java.util.ArrayList
import java.util.AbstractMap.SimpleEntry
import bbn.DVG
import bbn.RPRO
import bbn.APRO
import bbn.CONT
import bbn.PTCC
import bbn.AGGR
import bbn.MAGR
import bbn.InputWSMPort
import bbn.TRAN
import bbn.COMF
import bbn.INIT
import vi.BoolVSPInit
import vi.IntegerVSPInit
import vi.RealVSPInit
import vi.StringVSPInit
import bbn.InitCPort
import bbn.InitWSMPort
import bbn.LessThan
import bbn.Equal
import bbn.GreaterThan
import bbn.InternalCOMF
import bbn.Description
import bbn.InternalOutputPort
import bbn.NormalizationCOp
import bbn.LinearNormalization
import bbn.Direction
import bbn.Core
import bbn.InputCPort
import dor.BoolDef
import dor.IntegerDef
import dor.RealDef
import dor.StringDef
import vi.ComplexVSPInit
import vi.Type
import vi.Real
import bbn.EquivalenceFork
import bbn.ConditionalFork
import bbn.SAPRO
import bbn.EPROD
import bbn.AbstractInitPort
import bbn.InitPort
import bbn.Interface

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
 
class DvgDslGenerator /*extends AbstractGenerator*/ {
		StringBuilder TO_TCL

StringBuilder CODE
StringBuilder CODE_KB
StringBuilder CODE_TCB
StringBuilder CODE_TCB_CALL
	StringBuilder IMPORT_CODE
	StringBuilder SOLVE_CODE
	StringBuilder INITIALIZATION_CODE
	StringBuilder LOCAL_RESOLUTION_CODE
	StringBuilder CALL_SEQUENCE_CODE
	
	Map<String,bbn.Pattern> PATTERN_MAP
	Map<bbn.Pattern,Boolean> IS_RESOLVED_MAP
	
	Map<bbn.Pattern, List<String>> DEPENDENCY_MAP
	
	String NUMERIC_VSP_STANDARD = "List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Double>>"
	String SYMBOLIC_VSP_STANDARD = "List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,String>>"
	String GENERIC_VSP_STANDARD_INPUT = "List<List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>"
	String GENERIC_VSP_STANDARD_OUTPUT = "List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>"
	
	String PS_NODE = "List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<Object>>>" // oder Map?
	
	Map<String, Integer> PASSIVE_LOOKUP
	List<SimpleEntry<String, Integer>> PASSIVE_LOOKUP_LIST
	Map<String, Integer> ACTIVE
	Map<String, Integer> CONSTANT
	
	bbn.Pattern ROOT_PATTERN
	
	boolean CHECK_FOR_IS_SAM_IN_PRODUCTION = false 
	boolean CHECK_FOR_IS_SAM_IN_CONTRADICTION = false
	
	Node no
	Helpers he
	Leafs le
	JavaFunctions jf
	LispFunctions lf
	Lookup lo
	
	
//  SimpleEntry<String,Integer> headerEntry
//	List<SimpleEntry<String,Integer>> headerRow
//	List<List<SimpleEntry<String,Integer>>> header
//	SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> slot
//	List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsp
//	List<List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>> I  

	//override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
	def String root(DVG dvg) {

		this.no = new Node()
		this.he = new Helpers()
		this.le = new Leafs()
		this.jf = new JavaFunctions()
		this.lf = new LispFunctions()
		this.lo = new Lookup()

		this.TO_TCL = new StringBuilder()
		
		this.PASSIVE_LOOKUP = new HashMap<String, Integer>()
		this.PASSIVE_LOOKUP_LIST = new ArrayList<SimpleEntry<String, Integer>>()
		this.ACTIVE = new HashMap<String, Integer>()
		this.CONSTANT = new HashMap<String, Integer>()
		
		System.out.println("CODE GENERATOR!")
		
		this.CODE = new StringBuilder()
		this.CODE_KB = new StringBuilder()
		this.CODE_TCB = new StringBuilder()
		this.CODE_TCB_CALL = new StringBuilder()
		this.IMPORT_CODE = new StringBuilder()
		this.SOLVE_CODE = new StringBuilder()
		this.INITIALIZATION_CODE = new StringBuilder()
		this.LOCAL_RESOLUTION_CODE = new StringBuilder()
		this.CALL_SEQUENCE_CODE = new StringBuilder()
		
		this.PATTERN_MAP = new HashMap<String,bbn.Pattern>()
		this.IS_RESOLVED_MAP = new HashMap<bbn.Pattern,Boolean>()
		
		//System.out.println("0 IS RES MAP: " + this.IS_RESOLVED_MAP )
		
		this.DEPENDENCY_MAP	= new HashMap<bbn.Pattern, List<String>>()
		
		this.IMPORT_CODE.append("import java.util.List;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.util.ArrayList;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.util.AbstractMap.SimpleEntry;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.util.Map;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.util.HashMap;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.util.Collections;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.util.Random;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.util.stream.Collectors;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.util.Scanner;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.util.Set;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.util.HashSet;")
		this.IMPORT_CODE.append("\n")
		this.IMPORT_CODE.append("import java.io.*;")
		this.IMPORT_CODE.append("\n")
		
		this.SOLVE_CODE.append("class Solve {")
			this.SOLVE_CODE.append("\n\t")
			this.SOLVE_CODE.append("private Map<String, Node> NODE_COLLECTION;")
			this.SOLVE_CODE.append("\n\t")
			this.SOLVE_CODE.append("\n\t")
			
		this.INITIALIZATION_CODE.append("\n\t")
		this.INITIALIZATION_CODE.append("void init() {")
			this.INITIALIZATION_CODE.append("\n\t\t")
			this.INITIALIZATION_CODE.append("this.NODE_COLLECTION = new HashMap<String, Node>();")
			this.INITIALIZATION_CODE.append("\n\t\t")
			this.INITIALIZATION_CODE.append("List<Object> leafValues;")
			this.INITIALIZATION_CODE.append("\n\t\t")
			this.INITIALIZATION_CODE.append("List<List<Object>> leafValues_2;")
			this.INITIALIZATION_CODE.append("\n\t\t")
			this.INITIALIZATION_CODE.append("List<Map<String,Double>> leafValuesPsMapList;")
			this.INITIALIZATION_CODE.append("Map<String,Double> leafValuesPsMap;")
			this.INITIALIZATION_CODE.append("\n\t\t")
			this.INITIALIZATION_CODE.append("NodeObject nodeObject;")
			this.INITIALIZATION_CODE.append("\n\t\t")
			this.INITIALIZATION_CODE.append("NodeObjectList nodeObjectList;")
			this.INITIALIZATION_CODE.append("\n\t\t")
			this.INITIALIZATION_CODE.append("NodePs nodePs;")
			this.INITIALIZATION_CODE.append("\n\t\t")
			this.INITIALIZATION_CODE.append("Random random;")
			this.INITIALIZATION_CODE.append("\n\t\t")
			this.INITIALIZATION_CODE.append("String[] dataFromFile;")
			this.INITIALIZATION_CODE.append("\n\t\t")
			this.INITIALIZATION_CODE.append("\n\t\t")
			
		this.CALL_SEQUENCE_CODE.append("\n\t")
		this.CALL_SEQUENCE_CODE.append("void solve() {")
		this.CALL_SEQUENCE_CODE.append("\n\t\t")
		this.CALL_SEQUENCE_CODE.append("List<Node> params;")
		this.CALL_SEQUENCE_CODE.append("\n\t\t")
		this.CALL_SEQUENCE_CODE.append("List<List<Node>> params_2d;")
		this.CALL_SEQUENCE_CODE.append("\n\t\t")
		
		//System.out.println("1 IS RES MAP: " + this.IS_RESOLVED_MAP )
		//for (i : resource.allContents.toIterable.filter(DVG)) {
			determineAbsoluteDependencies(dvg)
		//}
		
		//System.out.println("2 IS RES MAP: " + this.IS_RESOLVED_MAP )
		
		var boolean isValid = true
		for (i : this.DEPENDENCY_MAP.entrySet) {
			var boolean isSAM = this.he.isSAM(i.value)
			//System.out.println(i.key.name+", isSAM: "+isSAM)
			if (isSAM && (i.key instanceof RPRO || i.key instanceof APRO || i.key instanceof SAPRO)) {
				isValid = false
				//System.err.println("ERROR: There is a SAM-Situation for "+ i.key.name+"! Please fix the problem.")
			}
			if (!isSAM && (i.key instanceof CONT || i.key instanceof PTCC || i.key instanceof EPROD)) {
				isValid = false
				System.err.println("ERROR: There is no SAM-Situation for "+ i.key.name+"! Please fix the problem.")
			}
			
			//System.out.println(i.key.name+": ")
			for (j : i.value) {
				//System.out.print(j)
				//System.out.print("\t")
			}
			//System.out.println()
		}
		
		isValid = true; 
		
		if (isValid) {
		
			var String name;
				
			//for (i : resource.allContents.toIterable.filter(DVG)) {
				name = dvg.name
				globalResolution(dvg)
				
			//}
			
			this.INITIALIZATION_CODE.append("\n\t")
			this.INITIALIZATION_CODE.append("}")
			
			var String rootNodeName
			
			
			/*if (this.ROOT_PATTERN instanceof RPRO) {
				rootNodeName = this.ROOT_PATTERN.on.name
			}
			else*/ if (this.ROOT_PATTERN instanceof CONT) {
				rootNodeName = this.ROOT_PATTERN.op.name
			}
			else if (this.ROOT_PATTERN instanceof PTCC) {
				rootNodeName = this.ROOT_PATTERN.op.name
			}
			else if (this.ROOT_PATTERN instanceof EPROD) {
				rootNodeName = this.ROOT_PATTERN.op.name
			}
			
			//System.out.println("***************************** rootNodeName: " + rootNodeName);
			
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("Map<String, Integer> active = new HashMap<String, Integer>();")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("Map<String, Integer> passive = new HashMap<String, Integer>();")			
			
			for (i : this.ACTIVE.entrySet) {
				this.CALL_SEQUENCE_CODE.append("active.put(\""+i.key+"\","+i.value+");")
				this.CALL_SEQUENCE_CODE.append("\n\t\t")
			}

			for (i : this.PASSIVE_LOOKUP.entrySet) {
				this.CALL_SEQUENCE_CODE.append("passive.put(\""+i.key+"\","+i.value+");")
				this.CALL_SEQUENCE_CODE.append("\n\t\t")
			}			
			
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("Map<String, List<Object>> TO_TCL = new HashMap<String, List<Object>>();")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("List<Object> l;")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append(this.TO_TCL)			
			
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("Node result = NODE_COLLECTION.get(\""+rootNodeName+"\");")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("int cnt = 0;")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> rtmp = result.vsp();")			
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> maxSlot = null;")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("double maxValue = 0.0;")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("int maxIndex = 0;")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")			
			this.CALL_SEQUENCE_CODE.append("for (SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> i : rtmp) {")
							
				this.CALL_SEQUENCE_CODE.append("\n\t\t")
				this.CALL_SEQUENCE_CODE.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();")
				this.CALL_SEQUENCE_CODE.append("\n\t\t")
				this.CALL_SEQUENCE_CODE.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();")		
				
				this.CALL_SEQUENCE_CODE.append("\n\t\t")
				this.CALL_SEQUENCE_CODE.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();")
				this.CALL_SEQUENCE_CODE.append("\n\t\t")
				this.CALL_SEQUENCE_CODE.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();")					
				
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("List<List<SimpleEntry<String,Integer>>> header = i.getKey();")
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("for (List<SimpleEntry<String,Integer>> headerRow : header) {")
					this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t")
					this.CALL_SEQUENCE_CODE.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
						this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t\t")
						this.CALL_SEQUENCE_CODE.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());")
						this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t\t")
						this.CALL_SEQUENCE_CODE.append("System.out.print(\"\t\");")
			
			
						this.CALL_SEQUENCE_CODE.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {")
							this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t\t")
							this.CALL_SEQUENCE_CODE.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
							this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t\t")
							this.CALL_SEQUENCE_CODE.append("AflagLeaf.put(headerEntry.getKey(),true);")
						this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t")
						this.CALL_SEQUENCE_CODE.append("}")
						
						this.CALL_SEQUENCE_CODE.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {")
							this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t\t")
							this.CALL_SEQUENCE_CODE.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
							this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t\t")
							this.CALL_SEQUENCE_CODE.append("PflagLeaf.put(headerEntry.getKey(),true);")
						this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t")
						this.CALL_SEQUENCE_CODE.append("}")										
						
					this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t")
					this.CALL_SEQUENCE_CODE.append("}")
					this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t")
					this.CALL_SEQUENCE_CODE.append("System.out.println();")
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("}")

				this.CALL_SEQUENCE_CODE.append("System.out.println(\"################## ACTIVE VARIANT: \");")
				this.CALL_SEQUENCE_CODE.append("\n\t\t")
				this.CALL_SEQUENCE_CODE.append("for (int j = 0; j < AleafNamesAndIndices.size(); j++) {")
					this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
					this.CALL_SEQUENCE_CODE.append("System.out.println(AleafNamesAndIndices.get(j).getKey() + \": \" + AleafNamesAndIndices.get(j).getValue());")
				this.CALL_SEQUENCE_CODE.append("\n\t\t")
				this.CALL_SEQUENCE_CODE.append("}")	

				this.CALL_SEQUENCE_CODE.append("System.out.println(\"################## FOR PASSIVE STATES: \");")
				this.CALL_SEQUENCE_CODE.append("\n\t\t")
				this.CALL_SEQUENCE_CODE.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {")
					this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
					this.CALL_SEQUENCE_CODE.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());")
				this.CALL_SEQUENCE_CODE.append("\n\t\t")
				this.CALL_SEQUENCE_CODE.append("}")		

				
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("System.out.println(\"=================> [\"+cnt+\", \"+i.getValue()+\"]\");")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("System.out.println(\"------------------------------------\");")
		
			
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("if (((Number)i.getValue()).doubleValue() > maxValue) {")
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("maxValue = ((Number)i.getValue()).doubleValue();")
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("maxSlot = i;")
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("maxIndex = cnt;")				
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("}")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("cnt++;")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("}")
			
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("System.out.println(\"\");")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("System.out.println(\"\");")
			//this.CALL_SEQUENCE_CODE.append("\n\t\t")
			//this.CALL_SEQUENCE_CODE.append("System.out.println(\"MaxSlot with MaxValue \"+maxSlot.getValue()+\":\");")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("System.out.println(\"====================== Final Result ====================== \");")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("for (List<SimpleEntry<String,Integer>> headerRow : maxSlot.getKey()) {")
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
					this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t")
					this.CALL_SEQUENCE_CODE.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());")
					this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t")
					this.CALL_SEQUENCE_CODE.append("System.out.print(\"\t\");")
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("}")
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("System.out.println();")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("}")
			
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			
			this.CALL_SEQUENCE_CODE.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")			
			this.CALL_SEQUENCE_CODE.append("for (List<SimpleEntry<String,Integer>> headerRow : maxSlot.getKey()) {")
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {")
					this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t")
						
						this.CALL_SEQUENCE_CODE.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {")
							this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t\t")
							this.CALL_SEQUENCE_CODE.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
							this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t\t")
							this.CALL_SEQUENCE_CODE.append("AflagLeaf.put(headerEntry.getKey(),true);")
						this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t")
						this.CALL_SEQUENCE_CODE.append("}")

						this.CALL_SEQUENCE_CODE.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {")
							this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t\t")
							this.CALL_SEQUENCE_CODE.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));")
							this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t\t")
							this.CALL_SEQUENCE_CODE.append("PflagLeaf.put(headerEntry.getKey(),true);")
						this.CALL_SEQUENCE_CODE.append("\n\t\t\t\t")
						this.CALL_SEQUENCE_CODE.append("}")						
											
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("}")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("}")			
			
			this.CALL_SEQUENCE_CODE.append("System.out.println(\"################## MAX ACTIVE VARIANT: \");")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("for (int i = 0; i < AleafNamesAndIndices.size(); i++) {")
			
				this.CALL_SEQUENCE_CODE.append("if (TO_TCL.containsKey(AleafNamesAndIndices.get(i).getKey())) {\n")
				
				this.CALL_SEQUENCE_CODE.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> lse = this.NODE_COLLECTION.get(AleafNamesAndIndices.get(i).getKey()).vsp();\n")
				this.CALL_SEQUENCE_CODE.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> se = lse.get(AleafNamesAndIndices.get(i).getValue());\n")
				
				this.CALL_SEQUENCE_CODE.append("String outString = \"(tcl-kb-update :key '(is-a name instance) :value '((is-a dvgConfig)(name \"+TO_TCL.get(AleafNamesAndIndices.get(i).getKey()).get(0)+\")(instance \"+TO_TCL.get(AleafNamesAndIndices.get(i).getKey()).get(1)+\")(value \"+se.getValue()+\")))\";\n")

			    this.CALL_SEQUENCE_CODE.append("try {\n")
			        this.CALL_SEQUENCE_CODE.append("FileWriter myWriter = new FileWriter(\"smartSoftConfig.txt\", true);\n")
			        this.CALL_SEQUENCE_CODE.append("myWriter.write(outString+\"\\n\");\n")
			        this.CALL_SEQUENCE_CODE.append("myWriter.close();\n")
			        //this.CALL_SEQUENCE_CODE.append("System.out.println(\"Successfully wrote to the file.\");\n");
			      	this.CALL_SEQUENCE_CODE.append("} catch (IOException e) {\n")
			        this.CALL_SEQUENCE_CODE.append("System.out.println(\"An error occurred.\");\n")
			        this.CALL_SEQUENCE_CODE.append("e.printStackTrace();\n")
			      this.CALL_SEQUENCE_CODE.append("}\n")
			this.CALL_SEQUENCE_CODE.append("}\n")
			
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("System.out.println(AleafNamesAndIndices.get(i).getKey() + \": \" + AleafNamesAndIndices.get(i).getValue());")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("}")

			this.CALL_SEQUENCE_CODE.append("System.out.println(\"################## FOR IDEAL PASSIVE STATES: \");")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {")
				this.CALL_SEQUENCE_CODE.append("\n\t\t\t")
				this.CALL_SEQUENCE_CODE.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());")
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("}")					
			
			this.CALL_SEQUENCE_CODE.append("\n\t\t")
			this.CALL_SEQUENCE_CODE.append("System.out.println(\"=================> [\"+maxIndex+\", \"+maxSlot.getValue()+\"]\");")			
			
			// lookup extension
			
			System.out.println("---------")
			System.out.println("PASSIVE LOOKUP")
			for (i : this.PASSIVE_LOOKUP.entrySet) {
				System.out.println(i.key + " : "+i.value)
			}
			System.out.println("PASSIVE LOOKUP_LIST")
			for (i : this.PASSIVE_LOOKUP_LIST) {
				System.out.println(i.key + " : " + i.value)
			}
			System.out.println("ACTIVE")
			for (i : this.ACTIVE.entrySet) {
				System.out.println(i.key + " : " + i.value)
			}
			System.out.println("---------")
			
			if (this.PASSIVE_LOOKUP.size > 0) {
				//this.CALL_SEQUENCE_CODE.append(this.lo.generateLookupCode(this.PASSIVE_LOOKUP, this.PASSIVE_LOOKUP_LIST))
			}
			
			this.CALL_SEQUENCE_CODE.append("\n\t")
			this.CALL_SEQUENCE_CODE.append("}")
				
				this.SOLVE_CODE.append(this.jf.generateGetCartesianProductFunction)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.jf.generateIsSAM)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.jf.generateIsValidCombinationIgnoreResource)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.jf.generateIsValidCombinationInverse)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.jf.generateIsValidCombinationMerge)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.jf.generateIsValidCombinationIgnore)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.jf.generateIsDominated)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.jf.generateMaxFunction)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.jf.generateMinFunction)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.lf.generateGetDataFromFile)
				this.SOLVE_CODE.append("\n\n")				
				this.SOLVE_CODE.append(this.LOCAL_RESOLUTION_CODE)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.INITIALIZATION_CODE)
				this.SOLVE_CODE.append("\n\n")
				this.SOLVE_CODE.append(this.CALL_SEQUENCE_CODE)
			
			this.SOLVE_CODE.append("\n")
			this.SOLVE_CODE.append("}")
			
			this.CODE.append(this.IMPORT_CODE)
			this.CODE.append("\n\n")
			this.CODE.append(this.no.generateNodeClassCode)
			this.CODE.append("\n\n")
			this.CODE.append(this.no.generateNodeObjectClassCode)
			this.CODE.append("\n\n")
			this.CODE.append(this.no.generateNodeObjectListClassCode)
			this.CODE.append("\n\n")
			this.CODE.append(this.no.generateNodePsClassCode)
			this.CODE.append("\n\n")
			this.CODE.append(this.SOLVE_CODE)
			this.CODE.append("\n\n")
	
			this.CODE.append("public class DVGSolver_"+name+"{")
				this.CODE.append("\n\t") 
				this.CODE.append("public static void main (String[] args) {")
					this.CODE.append("\n\t\t")
					this.CODE.append("Solve solve = new Solve();")
					this.CODE.append("\n\t\t")
					this.CODE.append("solve.init();")
					this.CODE.append("\n\t\t")
					this.CODE.append("solve.solve();")		
	   			this.CODE.append("\n\t")
	   			this.CODE.append("}")
	   		this.CODE.append("\n")   
			this.CODE.append("}")
			
			this.CODE.append("\n\n")
			
			//fsa.generateFile("DVGSolver_"+name+".java", this.CODE);
			return this.CODE.toString()
			
			/*
			var StringBuilder tcldvgpre = new StringBuilder()
			tcldvgpre.append("(define-tcb (writeKBData)\n")
			tcldvgpre.append("(action (\n")
				
			var StringBuilder tcldvgpost = new StringBuilder()
			tcldvgpost.append(")))\n")
			
			var StringBuilder tcldvg = new StringBuilder()
			
			
			tcldvg.append("(defun writeSmartSoftData ()\n")
			
			tcldvg.append("(execute '(writeKBData))\n")
			tcldvg.append(this.CODE_TCB_CALL)
			
			tcldvg.append(")\n")
			
			tcldvg.append(tcldvgpre)
			tcldvg.append(this.CODE_KB)
			tcldvg.append(tcldvgpost)
			
			tcldvg.append(this.CODE_TCB)
			
			tcldvg.append(this.lf.lispCodeWriteToFile)
			
			fsa.generateFile("tcl-dvg-interface.smartTcl", tcldvg);
			*/
		
		}
		
	}
	
	def determineAbsoluteDependencies(DVG dvg) {
		
		for (i : dvg.pattern) {
			this.IS_RESOLVED_MAP.put(i, false)
		}
		
		for (i : dvg.pattern) {
			//if (!this.IS_RESOLVED_MAP.get(i)) {
				this.DEPENDENCY_MAP.put(i, getNext(i))
			//}
		}
		
		//System.out.println("TIMOOOOOOOOOOOOOOOOOOO: "+ this.IS_RESOLVED_MAP)
	}
	
	def List<String> getNext(bbn.Pattern lp) {
		
		var List<String> stringList = new ArrayList<String>()
		
		//System.out.println("lp.name: "+ lp.name)
		//System.out.println("**********************************************************************")
		
		if (lp instanceof RPRO) {
			for (i : lp.ip) {
				if (i.outputport !== null) {
					stringList.add(i.outputport.name)
					var bbn.Pattern lpr = this.he.getPattern(i.outputport)
					//if (!this.IS_RESOLVED_MAP.get(lpr)) {
						if (lpr instanceof MAGR) {
							var AGGR la = this.he.getAGGR(i.outputport)
							stringList.addAll(getNext(la, lpr.name))
						}
						else {
							stringList.addAll(getNext(lpr))
						}	
					//}
				}
				else {
					stringList.add(i.name)
				}
			}
		}
		
		else if (lp instanceof SAPRO) {
			for (i : lp.ip) {
				if (i.outputport !== null) {
					stringList.add(i.outputport.name)
					var bbn.Pattern lpr = this.he.getPattern(i.outputport)
					//if (!this.IS_RESOLVED_MAP.get(lpr)) {
						if (lpr instanceof MAGR) {
							var AGGR la = this.he.getAGGR(i.outputport)
							stringList.addAll(getNext(la, lpr.name))
						}
						else {
							stringList.addAll(getNext(lpr))
						}	
					//}
				}
				else {
					stringList.add(i.name)
				}
			}
		}		
		
		else if (lp instanceof APRO) {
			for (i : lp.ip) {
				if (i.outputport !== null) {
					stringList.add(i.outputport.name)
					var bbn.Pattern lpr = this.he.getPattern(i.outputport)
					//if (!this.IS_RESOLVED_MAP.get(lpr)) {
						if (lpr instanceof MAGR) {
							var AGGR la = this.he.getAGGR(i.outputport)
							stringList.addAll(getNext(la, lpr.name))
						}
						else {
							stringList.addAll(getNext(lpr))
						}
					//}
				}
				else {
					stringList.add(i.name)
				}
			}
		}
		
		else if (lp instanceof MAGR) {
			for (i : lp.aggr) {
				for (j : i.ip) {
					if (j.outputport !== null) {
						stringList.add(j.outputport.name)
						var bbn.Pattern lpr = this.he.getPattern(j.outputport)
						//if (!this.IS_RESOLVED_MAP.get(lpr)) {
							if (lpr instanceof MAGR) {
								var AGGR la = this.he.getAGGR(j.outputport)
								stringList.addAll(getNext(la, lpr.name))
							}
							else {
								stringList.addAll(getNext(lpr))
							}	
						//}
					}
					else {
						stringList.add(j.name)
					}
				}
			}
		}
		
		else if (lp instanceof CONT) {
			for (i : lp.ip) {
				if (i.outputport !== null) {
					stringList.add(i.outputport.name)
					var bbn.Pattern lpr = this.he.getPattern(i.outputport)
					//if (!this.IS_RESOLVED_MAP.get(lpr)) {
						if (lpr instanceof MAGR) {
							var AGGR la = this.he.getAGGR(i.outputport)
							stringList.addAll(getNext(la, lpr.name))
						}
						else {
							stringList.addAll(getNext(lpr))
						}
					//}
				}
				else {
					stringList.add(i.name)
				}
			}
			
			var EObject tmp = lp.ipp
			if (tmp instanceof InputWSMPort) {
				stringList.add(tmp.outputwsmport.name)
				var bbn.Pattern lpr = this.he.getPattern(tmp.outputwsmport)
				stringList.addAll(getNext(lpr))
			}
			
		}
		
		else if (lp instanceof EPROD) {
			for (i : lp.ip) {
				if (i.outputport !== null) {
					stringList.add(i.outputport.name)
					var bbn.Pattern lpr = this.he.getPattern(i.outputport)
					//if (!this.IS_RESOLVED_MAP.get(lpr)) {
						if (lpr instanceof MAGR) {
							var AGGR la = this.he.getAGGR(i.outputport)
							stringList.addAll(getNext(la, lpr.name))
						}
						else {
							stringList.addAll(getNext(lpr))
						}
					//}
				}
				else {
					stringList.add(i.name)
				}
			}
		}		
		
		else if (lp instanceof TRAN) {
			if (lp.ip.outputport !== null) {
				stringList.add(lp.ip.outputport.name)
				var bbn.Pattern lpr = this.he.getPattern(lp.ip.outputport)
				//if (!this.IS_RESOLVED_MAP.get(lpr)) {
					if (lpr instanceof MAGR) {
						var AGGR la = this.he.getAGGR(lp.ip.outputport)
						stringList.addAll(getNext(la, lpr.name))
					}
					else {
						stringList.addAll(getNext(lpr))
					}	
				//}
			}
			else {
				stringList.add(lp.ip.name)
			}
		}
		
		else if (lp instanceof COMF) {
			if (lp.ip.outputport !== null) {
				stringList.add(lp.ip.outputport.name)
				var bbn.Pattern lpr = this.he.getPattern(lp.ip.outputport)
				// if (!this.IS_RESOLVED_MAP.get(lpr)) {
					if (lpr instanceof MAGR) {
						var AGGR la = this.he.getAGGR(lp.ip.outputport)
						stringList.addAll(getNext(la, lpr.name))
					}
					else {
						stringList.addAll(getNext(lpr))
					}
				// }
			}
			else {
				stringList.add(lp.ip.outputport.name)
			}
			
			stringList.add(lp.icp.outputcport.name)
			var bbn.Pattern lpr = this.he.getPattern(lp.icp.outputcport)
			stringList.addAll(getNext(lpr))
		}
		
		else if (lp instanceof PTCC) {
			for (i : lp.ip) {
				if (i.outputport !== null) {
					stringList.add(i.outputport.name)
					var bbn.Pattern lpr = this.he.getPattern(i.outputport)
					//if (!this.IS_RESOLVED_MAP.get(lpr)) {
						if (lpr instanceof MAGR) {
							var AGGR la = this.he.getAGGR(i.outputport)
							stringList.addAll(getNext(la, lpr.name))
						}
						else {
							stringList.addAll(getNext(lpr))
						}
					//}
				}
				else {
					stringList.add(i.name)
				}
			}
			
			var EObject tmp = lp.ipp
			if (tmp instanceof InputWSMPort) {
				stringList.add(tmp.outputwsmport.name)
				var bbn.Pattern lpr = this.he.getPattern(tmp.outputwsmport)
				stringList.addAll(getNext(lpr))
			}
		}
		
		this.IS_RESOLVED_MAP.put(lp, true)
		
		//System.out.println("TIMO:" +lp.name+": "+ stringList)
		return stringList
	}
	
	def List<String> getNext(AGGR a, String pname) {
		var List<String> stringList = new ArrayList<String>()
		stringList.add(pname)
		for (i : a.ip) {
			if (i.outputport !== null) {
				stringList.add(i.outputport.name)
				var bbn.Pattern lpr = this.he.getPattern(i.outputport)
				if (lpr instanceof MAGR) {
					var AGGR la = this.he.getAGGR(i.outputport)
					stringList.addAll(getNext(la, lpr.name))
				}
				else {
					stringList.addAll(getNext(lpr))
				}
			}
			else {
				stringList.add(i.name)
			}
		}
		return stringList
	}		
	
	def globalResolution(DVG dvg) {
		
		//this.IS_RESOLVED_MAP = new HashMap<dvgPattern.Pattern,Boolean>()
		
//		for (i : dvg.pattern) {
//			this.PATTERN_MAP.put(i.name, i)
//			this.IS_RESOLVED_MAP.put(i, false)
//			System.out.println("bla" + i.name)
//		}
		
		for (i : this.IS_RESOLVED_MAP.entrySet) {
			i.value = false
		}
		//System.out.println("--bb--")
		for (i : this.IS_RESOLVED_MAP.entrySet) {
			//System.out.println(i.key + "-" + i.value)
		}
		//System.out.println("--aa")

		for (i : dvg.pattern) {
			if (!this.IS_RESOLVED_MAP.get(i)) {
				resolveNext(i)
			}
		}
	}
	
	def resolveNext(bbn.Pattern lp) {
		
		//System.out.println("TIMO LP:NAME" + lp.name)
		
		var List<bbn.DVGPort> inputSet = new ArrayList<bbn.DVGPort>() // This is for generating the call sequence code of the patterns with the name of the referenced output node
		var List<List<bbn.DVGPort>> inputSetAg = new ArrayList<List<bbn.DVGPort>>()
		var List<bbn.AbstractInputPort> inputSetInputs = new ArrayList<bbn.AbstractInputPort>() // This is for the $names$ in the expressions
		
		if (lp instanceof INIT) {
			
			if (lp.ainip.interface === null) {
				generateLeaf(lp.ainip)
			}
			else if (lp.ainip.interface !== null && lp.ainip.interface == Interface.STANDARD) {
				generateLeaf(lp.ainip)
			}
			else if (lp.ainip.interface !== null && lp.ainip.interface == Interface.FROMTCL) {
				if (lp.ainip.kbisa !== null) {
					this.CODE_KB.append("(setf result (get-value (tcl-kb-query :key '(is-a name) :value `((is-a "+
						lp.ainip.kbisa+")(name "+lp.ainip.kbname+"))) '"+lp.ainip.kbvalue+"))\n")
					this.CODE_KB.append("(writeToFile '"+lp.ainip.name+" "+"result)\n")
				}
				else if (lp.ainip.tcbname !== null) {
					this.CODE_TCB_CALL.append("(execute '("+lp.ainip.tcbname+"))\n")
					this.CODE_TCB.append("(define-tcb ("+lp.ainip.tcbname+")\n")
					this.CODE_TCB.append("(action ())\n")
					this.CODE_TCB.append("(plan(\n")
					if (lp.ainip.isIsList) {
						this.CODE_TCB.append("("+lp.ainip.tclCmd+" => ?p0)\n")
						this.CODE_TCB.append("(writeToFile '"+lp.name +" ?p0")
					}
					else {
						this.CODE_TCB.append("("+lp.ainip.tclCmd+" => ")
						for (var int i = 0; i < lp.ainip.nrParams; i++) {
							this.CODE_TCB.append("?p"+i+" ")
						}
						this.CODE_TCB.append(")\n")
						this.CODE_TCB.append("("+lp.ainip.tcbname+"_toList ")
						for (var int i = 0; i < lp.ainip.nrParams; i++) {
							this.CODE_TCB.append("?p"+i+" ")
						}
						this.CODE_TCB.append(")\n")
					}
					
					this.CODE_TCB.append(")))\n")
					
					if (lp.ainip.isIsList) {
                    
					}
					else {
						this.CODE_TCB.append("(define-tcb ("+lp.ainip.tcbname+"_toList ")
						for (var int i = 0; i < lp.ainip.nrParams; i++) {
							this.CODE_TCB.append("?p"+i+" ")
						}
						this.CODE_TCB.append(")\n")
						this.CODE_TCB.append("(action(\n")
						this.CODE_TCB.append("(setf listvar (list ")
						for (var int i = 0; i < lp.ainip.nrParams; i++) {
							this.CODE_TCB.append("'?p"+i+" ")
						}
						this.CODE_TCB.append("))\n")
						this.CODE_TCB.append("(writeToFile '"+lp.ainip.name+" listvar"+")\n")
						this.CODE_TCB.append("))\n")
						this.CODE_TCB.append(")\n")
					}		
				}
				
				var String res 
				if (this.he.isComplexDo(lp.ainip.ve)) {
					res = this.le.generateLeafValuesInitComplexTcl(lp.ainip.name)
				}
				else {
					res = this.le.generateLeafValuesInitTcl(lp.ainip.name)
				}
				
				this.INITIALIZATION_CODE.append(res)
			
			}
			
			else if (lp.ainip.interface !== null && lp.ainip.interface == Interface.TOTCL) {
				generateLeaf(lp.ainip)
				this.TO_TCL.append("l = new ArrayList<Object>();\n")
				this.TO_TCL.append("l.add(\""+lp.ainip.toTclName+"\");\n")
				this.TO_TCL.append("l.add("+lp.ainip.toTclInst+");\n")
				this.TO_TCL.append("TO_TCL.put(\""+lp.ainip.name+"\",l);\n")	
			}
			
//			if (lp.ainin.ve instanceof ContextInst) {
//				this.PASSIVE_LOOKUP.put(lp.ainin.name, getVSPInitSize(lp.ainin))
//				this.PASSIVE_LOOKUP_LIST.add(new SimpleEntry<String, Integer>(lp.ainin.name, getVSPInitSize(lp.ainin)))
//			}
//			//else if (lp.ainin.ve instanceof ParameterInst) {
//			else {
//				this.ACTIVE.put(lp.ainin.name, getVSPInitSize(lp.ainin))
//			}
			
			if (lp.ainip.vt == bbn.VT.ACTIVE) {
				//System.out.println(lp.ainin.name + " is ACTIVE")
				this.ACTIVE.put(lp.ainip.name, this.he.getVSPInitSize(lp.ainip))
			}
			else if (lp.ainip.vt == bbn.VT.CONSTANT) {
				//System.out.println(lp.ainin.name + " is CONSTANT")
				this.CONSTANT.put(lp.ainip.name, this.he.getVSPInitSize(lp.ainip))
			}
			else {
				//System.out.println(lp.ainin.name + " is PASSIVE")
				this.PASSIVE_LOOKUP.put(lp.ainip.name, this.he.getVSPInitSize(lp.ainip))
				this.PASSIVE_LOOKUP_LIST.add(new SimpleEntry<String, Integer>(lp.ainip.name, this.he.getVSPInitSize(lp.ainip)))
			}
		}
				
		else if (lp instanceof RPRO) {
			for (i : lp.ip) {
				inputSetInputs.add(i)
				inputSet.add(i.outputport)
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
			
			/*if (lp.on !== null) {
				lp.on.vt = getOutputVTFromInputs(inputSetInputs)
				System.out.println("TIMO-------------------: " + lp.name + " with " + getOutputVTFromInputs(inputSetInputs))
			}
			else if (lp.opn !== null) {
				lp.opn.vt = getOutputVTFromInputs(inputSetInputs)
			}*/
			
		}
		
		else if (lp instanceof SAPRO) {
			for (i : lp.ip) {
				inputSetInputs.add(i)
				inputSet.add(i.outputport)
				var bbn.Pattern lpr = this.he.getPattern(i.outputport)
				//System.out.println("AJLEJRLW: "+ lpr);
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
		
		else if (lp instanceof APRO) {
			for (i : lp.ip) {
				inputSetInputs.add(i)
				inputSet.add(i.outputport)
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
			
			/*if (lp.on !== null) {
				lp.on.vt = getOutputVTFromInputs(inputSetInputs)
			}
			else if (lp.ocn !== null) {
				lp.ocn.vt = getOutputVTFromInputs(inputSetInputs)
			}*/
		}
		
		else if (lp instanceof MAGR) {
			
			if (lp.f !== null) {
				if (lp.f instanceof EquivalenceFork) {
					this.ACTIVE.put(lp.name, lp.aggr.get(0).ip.size)
				}
				else if (lp.f instanceof ConditionalFork) {
					this.PASSIVE_LOOKUP.put(lp.name, lp.aggr.get(0).ip.size)
					this.PASSIVE_LOOKUP_LIST.add(new SimpleEntry<String, Integer>(lp.name, lp.aggr.get(0).ip.size)) 
				}	
			}
			
			else if (lp.o !== null) {
				this.ACTIVE.put(lp.name, lp.aggr.get(0).ip.size)
			}
			else if (lp.or !== null) {
				this.ACTIVE.put(lp.name, lp.aggr.get(0).ip.size)
			}
			else if (lp.x !== null) {
				this.ACTIVE.put(lp.name, lp.aggr.get(0).ip.size)
			}						
			
			for (i : lp.aggr) {
				var List<bbn.DVGPort> tmp = new ArrayList<bbn.DVGPort>()
				for (j : i.ip) {
					inputSetInputs.add(j)
					tmp.add(j.outputport)
					var bbn.Pattern lpr = this.he.getPattern(j.outputport)
					
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
				inputSetAg.add(tmp)
			}
		}
		
		else if (lp instanceof CONT) {
			for (i : lp.ip) {
				inputSetInputs.add(i)
				inputSet.add(i.outputport)
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
				//lp.on.vt = getOutputVTFromInputs(inputSetInputs)
			}
			
			var EObject tmp = lp.ipp
			if (tmp instanceof InputWSMPort) {
				inputSetInputs.add(tmp)
				inputSet.add(tmp.outputwsmport)
				var bbn.Pattern lpr = this.he.getPattern(tmp.outputwsmport)
				
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
		
		else if (lp instanceof EPROD) {
			for (i : lp.ip) {
				inputSetInputs.add(i)
				inputSet.add(i.outputport)
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
				//lp.on.vt = getOutputVTFromInputs(inputSetInputs)
			}
		}		
		
		else if (lp instanceof TRAN) {
			inputSetInputs.add(lp.ip)
			inputSet.add(lp.ip.outputport)
			var bbn.Pattern lpr = this.he.getPattern(lp.ip.outputport)
			
			if (!this.IS_RESOLVED_MAP.containsKey(lpr)) {
				this.IS_RESOLVED_MAP.put(lpr,false)
				resolveNext(lpr)
			}
			else {
				if (!this.IS_RESOLVED_MAP.get(lpr)) {
					resolveNext(lpr)
				}
			}
			//lp.on.vt = getOutputVTFromInputs(inputSetInputs)
		}
		
		else if (lp instanceof COMF) {
			inputSetInputs.add(lp.ip)
			inputSet.add(lp.ip.outputport)
			var bbn.Pattern lpr = this.he.getPattern(lp.ip.outputport)
			//System.out.println("lp.in.outputnode.name: " +lp.in.outputnode.name)
			//System.out.println("lpr.name: " +lpr.name)
			//System.out.println("map: "+ this.IS_RESOLVED_MAP.get(lpr))
			//System.out.println("dvg.name: "+ getDVG(lpr).name)
			if (!this.IS_RESOLVED_MAP.containsKey(lpr)) {
				this.IS_RESOLVED_MAP.put(lpr,false)
				resolveNext(lpr)
			}
			else {
				if (!this.IS_RESOLVED_MAP.get(lpr)) {
					//System.out.println("not resolved")
					resolveNext(lpr)
				}
			}
			
			inputSetInputs.add(lp.icp)
			inputSet.add(lp.icp.outputcport)
			lpr = this.he.getPattern(lp.icp.outputcport)
			
			if (!this.IS_RESOLVED_MAP.containsKey(lpr)) {
				this.IS_RESOLVED_MAP.put(lpr,false)
				resolveNext(lpr)
			}
			
			else {
				if (!this.IS_RESOLVED_MAP.get(lpr)) {
					resolveNext(lpr)
				}
			}
			
			//lp.on.vt = getOutputVTFromInputs(inputSetInputs)
		}
		
		else if (lp instanceof PTCC) {
			for (i : lp.ip) {
				inputSetInputs.add(i)
				inputSet.add(i.outputport)
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
			
			var EObject tmp = lp.ipp
			if (tmp instanceof InputWSMPort) {
				inputSetInputs.add(tmp)
				inputSet.add(tmp.outputwsmport)
				var bbn.Pattern lpr = this.he.getPattern(tmp.outputwsmport)
				
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
			
			//lp.on.vt = getOutputVTFromInputs(inputSetInputs)
		}
		
		else {
			//System.out.println("ERROR: Unknown Local Pattern!")
		}
		
		// all dependencies of lp are already resolved/generated
		// call this function with name(list of inputs) where the inputs are instances of nodes with assigned vsps
		
		if (lp instanceof CONT || lp instanceof EPROD) {
			this.ROOT_PATTERN = lp
		}
		resolve(lp, inputSetInputs)
		this.IS_RESOLVED_MAP.put(lp, true)
		if (lp instanceof MAGR) {
			this.CALL_SEQUENCE_CODE.append(this.jf.generateCallSequenceCodeAg(lp.name, inputSetAg))
		}
		else if (!(lp instanceof INIT)) {
			this.CALL_SEQUENCE_CODE.append(this.jf.generateCallSequenceCode(lp.name, inputSet))
		}
	}
	
	def resolve(bbn.Pattern lp, List<bbn.AbstractInputPort> inputSet) {
		
		// If we are here to rlve/generate lp all its dependencies/VSPs are already resolved/generated
		
		//System.out.println("+++++++++++++++++++++++++++++++++ RESOLVE "+ lp.name+"+++++++++++++++++++++++++++++++++++++++++++++++")
		
		if (lp instanceof COMF) {
			resolve(lp)
		}
		
		else if (lp instanceof RPRO) {
			
			if (lp.opp !== null && lp.op !== null) {
				System.out.println("ERROR: RPRO can not have both a OutputNode and a OutputPSNode!")
			}
			else if (lp.opp !== null && lp.op === null) {
				resolve(lp, inputSet, true)
			}
			else if (lp.opp === null && lp.op !== null) {
				resolve(lp, inputSet, false)
			}
			else {
				System.out.println("ERROR: RPRO has no OutputNode!")
			}
		}
		
		else if (lp instanceof SAPRO) {
			resolve(lp, inputSet)
		}
		
		else if (lp instanceof APRO) {
			resolve(lp, inputSet)
		}
		
		else if (lp instanceof MAGR) {
			resolve(lp)
		}
		
		else if (lp instanceof TRAN) {
			resolve(lp)
		}
		
		else if (lp instanceof CONT) {
			resolve(lp)
		}
		
		else if (lp instanceof EPROD) {
			resolve(lp)
		}
		
		else if (lp instanceof PTCC) {
			resolve(lp)
		}
		
		
		
		/*else if (lp instanceof AProduction) {
			var AbstractOutputNode aon = lp.outputnode
			if (aon instanceof TNodeOut) {
				if (aon.staticthreshold !== null) {
					resolveStaticT(lp, aon, inputSet)
				}
				else {
					// dynamic t!
					resolve(lp, inputSet)
				}
			}
			else {
				resolve(lp, inputSet)
			}
		}
		else if (lp instanceof Aggregation) {
			resolve(lp)
		}
		else if (lp instanceof Contradiction) {
			resolve(lp)
		}
		else if (lp instanceof Transformation) {
			resolve(lp)
		}
		else if (lp instanceof ThresholdFilter) {
			resolve(lp)
		}
		else if (lp instanceof PCC) {
			resolve(lp)
		}*/
		else {
			//System.out.println("ERROR: Unknown Local Pattern!")
		}
	}
	
	def generateLeafCS(InitCPort inn) {
	
		var String res = "";
	
		var EObject tmp = inn.vi
		if (tmp instanceof BoolVSPInit) {
			res = this.le.generateLeafValuesInitBool(inn.name, tmp.vsp)
		}
		else if (tmp instanceof IntegerVSPInit) {
			if (tmp.irg !== null) {
				res = this.le.generateRandomIntegers(inn.name, tmp.irg.number, tmp.irg.min, tmp.irg.max)
			}
			else {
				res = this.le.generateLeafValuesInitInteger(inn.name, tmp.vsp)
			}
		}	
		else if (tmp instanceof RealVSPInit) {
			if (tmp.rrg !== null) {
				res = this.le.generateRandomReals(inn.name, tmp.rrg.number, tmp.rrg.min, tmp.rrg.max)
			}
			else {
				res = this.le.generateLeafValuesInitReal(inn.name, tmp.vsp)
			}
		}
		else if (tmp instanceof StringVSPInit) {
			res = this.le.generateLeafValuesInitString(inn.name, tmp.vsp)
		}
		
		return res
	}
	
	def generateLeaf(AbstractInitPort inn) {
		
		var String res = "";
		
		if (inn instanceof InitPort) {
			var EObject tmp = inn.vi
			if (tmp instanceof BoolVSPInit) {
				res = this.le.generateLeafValuesInitBool(inn.name, tmp.vsp)
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					res = this.le.generateRandomIntegers(inn.name, tmp.irg.number, tmp.irg.min, tmp.irg.max)
				}
				else {
					res = this.le.generateLeafValuesInitInteger(inn.name, tmp.vsp)
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					res = this.le.generateRandomReals(inn.name, tmp.rrg.number, tmp.rrg.min, tmp.rrg.max)
				}
				else {
					res = this.le.generateLeafValuesInitReal(inn.name, tmp.vsp)
				}
			}
			else if (tmp instanceof StringVSPInit) {
				res = this.le.generateLeafValuesInitString(inn.name, tmp.vsp)
			}
			
			else if (tmp instanceof ComplexVSPInit) {
				
				//System.out.println("Is Complex VSP INIT *********************************************************")
				
				// We expect here either a list of Elements > 1 each with cardinality = 1 
				// or one Element with cardinality > 1
				if (tmp.vi.get(0).e.size() > 1) {
					// More than one element for the first VI
					// Must be the same for all other VIs
					// Each Element must have cardinality = 1
					var Type ty = null
					
					var List<List<Object>> vsp = new ArrayList<List<Object>>()
					
					// For each VI
					for (var int i = 0; i < tmp.vi.size(); i++) {
						// For each Element of a VI					
						var List<Object> vi = new ArrayList<Object>()
						for (var int j = 0; j < tmp.vi.get(i).e.size(); j++) {
							ty = tmp.vi.get(i).e.get(j).t
							
							if (ty instanceof Real) {
								// Only one value
								vi.add(ty.rv.get(0).value)
							}
						}
						
						vsp.add(vi)
						
						res = this.le.generateLeafValuesInit(inn.name, vsp)		
					}
					
				}
				else if (tmp.vi.get(0).e.size() == 1) {
					
					var Type ty = null
					var List<List<Object>> vsp = new ArrayList<List<Object>>()
					
					// For each VI
					for (var int i = 0; i < tmp.vi.size(); i++) {
						// For each Value of the single Element of a VI					
						var List<Object> vi = new ArrayList<Object>()
						ty = tmp.vi.get(i).e.get(0).t
						
						if (ty instanceof Real) {
							// More than one value
							
							for (var int j = 0; j < ty.rv.size(); j++) {
								vi.add(ty.rv.get(j).value)
							}
							
							vsp.add(vi)
						}
						
						res = this.le.generateLeafValuesInit(inn.name, vsp)		
					}
					
				}
			}
			
			this.INITIALIZATION_CODE.append(res)
		}
		
		else if (inn instanceof InitCPort) {
			var EObject tmp = inn.vi
			if (tmp instanceof BoolVSPInit) {
				res = this.le.generateLeafValuesInitBool(inn.name, tmp.vsp)
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					res = this.le.generateRandomIntegers(inn.name, tmp.irg.number, tmp.irg.min, tmp.irg.max)
				}
				else {
					res = this.le.generateLeafValuesInitInteger(inn.name, tmp.vsp)
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					res = this.le.generateRandomReals(inn.name, tmp.rrg.number, tmp.rrg.min, tmp.rrg.max)
				}
				else {
					res = this.le.generateLeafValuesInitReal(inn.name, tmp.vsp)
				}
			}
			else if (tmp instanceof StringVSPInit) {
				res = this.le.generateLeafValuesInitString(inn.name, tmp.vsp)
			}
			
			this.INITIALIZATION_CODE.append(res)
		}
		
		else if (inn instanceof InitWSMPort) {
			
			var Map<String,Double> dwStruct = new HashMap<String,Double>()
		
			for (i : inn.sws.sw) {
				dwStruct.put(i.inputport.outputport.name, i.weight)
			}
		
			this.INITIALIZATION_CODE.append(this.le.generateLeafValuesInit(inn.name, dwStruct))	
		}
	}
	
	def resolve(COMF p) {
		var StringBuilder code = new StringBuilder();
	
		code.append("void")
		code.append(" ")
		code.append("resolve_"+p.name)
		code.append("(")
		code.append("List<Node>")
		code.append(" ")
		code.append("I")
		code.append(") {")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
			code.append("\n\t")
			code.append("Object newValue = 0.0;")
			code.append("\n\t")
			
			if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof BoolDef) {
				code.append("List<Boolean> toCheck = new ArrayList<Boolean>();")
				code.append("\n\t")
				code.append("List<Boolean> filter = new ArrayList<Boolean>();")
			}
			else if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof IntegerDef) {
				code.append("List<Integer> toCheck = new ArrayList<Integer>();")
				code.append("\n\t")
				code.append("List<Integer> filter = new ArrayList<Integer>();")
			}
			else if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof RealDef) {
				code.append("List<Double> toCheck = new ArrayList<Double>();")
				code.append("\n\t")
				code.append("List<Double> filter = new ArrayList<Double>();")
			}
			else if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof StringDef) {
				code.append("List<String> toCheck = new ArrayList<String>();")
				code.append("\n\t")
				code.append("List<String> filter = new ArrayList<String>();")
			}
			else {
				System.err.println("TypeDef not supported!")
			}

			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> toCheckVsp = I.get(0).vsp();")
			code.append("\n\t")
			
			code.append("for (int i = 0; i < toCheckVsp.size(); i++) {")
				code.append("\n\t\t")
				if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof BoolDef) {
					code.append("toCheck.add(((Boolean)toCheckVsp.get(i).getValue()).booleanValue());")
				}
				else if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof IntegerDef) {
					code.append("toCheck.add(((Integer)toCheckVsp.get(i).getValue()).intValue());")
				}
				else if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof RealDef) {
					code.append("toCheck.add(((Number)toCheckVsp.get(i).getValue()).doubleValue());")
				}
				else if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof StringDef){
					code.append("toCheck.add(toCheckVsp.get(i).getValue().toString());")
				}
				else {
					System.err.println("TypeDef not supported!")
				}
				
			code.append("\n\t")
			code.append("}")
			
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> filterVsp = I.get(1).vsp();")
			code.append("\n\t")
			
			code.append("List<List<SimpleEntry<String,Integer>>> htmp;")
			code.append("\n\t")
			
			code.append("for (int i = 0; i < filterVsp.size(); i++) {")
				code.append("\n\t\t")
				if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof BoolDef) {
					code.append("filter.add(((Boolean)filterVsp.get(i).getValue()).booleanValue());")
				}
				else if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof IntegerDef) {
					code.append("filter.add(((Integer)filterVsp.get(i).getValue()).intValue());")
				}
				else if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof RealDef) {
					code.append("filter.add(((Double)filterVsp.get(i).getValue()).doubleValue());")
				}
				else if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof StringDef) {
					code.append("filter.add(filterVsp.get(i).getValue().toString());")
				}
				else {
					System.err.println("TypeDef not supported!")
				}
				
			code.append("\n\t")
			code.append("}")

			code.append("for (int i = 0; i < toCheckVsp.size(); i++) {")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < filterVsp.size(); j++) {")
					code.append("\n\t\t\t")
					var EObject tmp = p.co
					if (tmp instanceof LessThan) {
						
						if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof BoolDef || this.he.getTypeFromVe(p.ip.outputport.ve) instanceof StringDef) {
							System.err.println("ERROR: LessThan undefined for Bool or String")
						}
						
						if (tmp.inclusive) {
							code.append("if (toCheck.get(i) <= filter.get(j)) {")
						}
						else {
							code.append("if (toCheck.get(i) < filter.get(j)) {")
						}
					}
					else if (tmp instanceof GreaterThan) {
						
						if (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof BoolDef || this.he.getTypeFromVe(p.ip.outputport.ve) instanceof StringDef) {
							System.err.println("ERROR: GreaterThan undefined for Bool or String")
						}
						
						if (tmp.inclusive) {
							code.append("if (toCheck.get(i) >= filter.get(j)) {")
						}
						else {
							code.append("if (toCheck.get(i) > filter.get(j)) {")
						}
					}
					else if (tmp instanceof Equal) {
						
						if (tmp.accuracy !== null && (this.he.getTypeFromVe(p.ip.outputport.ve) instanceof BoolDef || this.he.getTypeFromVe(p.ip.outputport.ve) instanceof StringDef || this.he.getTypeFromVe(p.ip.outputport.ve) instanceof IntegerDef)) {
							System.err.println("WARNING: Accuracy for Bool,String or Integer is ignored!")
						}
						
						if (tmp.accuracy === null) {
							if (tmp.inverse) {
								code.append("if (toCheck.get(i) != filter.get(j)) {")
							}
							else {
								code.append("if (toCheck.get(i) == filter.get(j)) {")
							}
						}
						else {
							// Only meaningful for Reals
							if (tmp.inverse) {
								code.append("if (Math.abs(toCheck.get(i)-filter.get(j)) > "+tmp.accuracy.value.toString+") {")
							}
							else {
								code.append("if (Math.abs(toCheck.get(i)-filter.get(j)) < "+tmp.accuracy.value.toString+") {")
							}
							
						}
					}
						code.append("\n\t\t\t\t")
						code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
						code.append("\n\t\t\t\t")
						code.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();")
						code.append("\n\t\t\t\t")
						code.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(0).name(),i));")
						code.append("\n\t\t\t\t")
						code.append("if (toCheckVsp.get(i).getKey() != null) {")
							code.append("\n\t\t\t\t\t")
							code.append("htmp = toCheckVsp.get(i).getKey();")
							code.append("\n\t\t\t\t\t")
							code.append("for (List<SimpleEntry<String,Integer>> row : htmp) {")
								code.append("\n\t\t\t\t\t\t")
								code.append("for (SimpleEntry<String,Integer> entry : row) {")
									code.append("\n\t\t\t\t\t\t\t")
									code.append("headerRow.add(entry);")
								code.append("\n\t\t\t\t\t\t")	
								code.append("}")
							code.append("\n\t\t\t\t\t")	
							code.append("}")
						code.append("\n\t\t\t\t")	
						code.append("}")
						code.append("\n\t\t\t")
						code.append("header.add(headerRow);")
						code.append("\n\t\t\t")
						code.append("headerRow = new ArrayList<SimpleEntry<String,Integer>>();")
						code.append("\n\t\t\t")
						code.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(1).name(),j));")
						code.append("\n\t\t\t")
						code.append("if (filterVsp.get(j).getKey() != null) {")
							code.append("\n\t\t\t\t")
							code.append("htmp = filterVsp.get(j).getKey();")
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
						code.append("\n\t\t")
						code.append("header.add(headerRow);")
						code.append("\n\t\t")
						code.append("newValue = newValue = toCheck.get(i);")
						code.append("\n\t\t")
						code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));")
						code.append("\n\t\t")
					code.append("}")
				code.append("}")		
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("this.NODE_COLLECTION.put(\""+p.op.name+"\", new NodeObject(\""+p.op.name+"\", ovsp));")
		code.append("\n")
		code.append("}")
		
		this.LOCAL_RESOLUTION_CODE.append(code)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
	}
	
	def String resolve(InternalCOMF p, String name) {
		var StringBuilder code = new StringBuilder();
	
		code.append("void")
		code.append(" ")
		code.append(name)
		code.append("(")
		code.append("List<Node>")
		code.append(" ")
		code.append("I")
		code.append(") {")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
			code.append("\n\t")
			code.append("Object newValue = 0.0;")
			code.append("\n\t")
			
			var EObject tmp = p.iip.internalportref
			
			if (tmp instanceof bbn.InputPort) {
				if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof BoolDef) {
					code.append("List<Boolean> toCheck = new ArrayList<Boolean>();")
					code.append("\n\t")
					code.append("List<Boolean> filter = new ArrayList<Boolean>();")
				}
				else if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof IntegerDef) {
					code.append("List<Integer> toCheck = new ArrayList<Integer>();")
					code.append("\n\t")
					code.append("List<Integer> filter = new ArrayList<Integer>();")
				}
				else if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof RealDef) {
					code.append("List<Double> toCheck = new ArrayList<Double>();")
					code.append("\n\t")
					code.append("List<Double> filter = new ArrayList<Double>();")
				}
				else if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof StringDef) {
					code.append("List<String> toCheck = new ArrayList<String>();")
					code.append("\n\t")
					code.append("List<String> filter = new ArrayList<String>();")
				}
				else {
					System.err.println("TypeDef not supported!")
				}
			}
			else if (tmp instanceof InternalOutputPort) {
				if (this.he.getTypeFromVe(tmp.ve) instanceof BoolDef) {
					code.append("List<Boolean> toCheck = new ArrayList<Boolean>();")
					code.append("\n\t")
					code.append("List<Boolean> filter = new ArrayList<Boolean>();")
				}
				else if (this.he.getTypeFromVe(tmp.ve) instanceof IntegerDef) {
					code.append("List<Integer> toCheck = new ArrayList<Integer>();")
					code.append("\n\t")
					code.append("List<Integer> filter = new ArrayList<Integer>();")
				}
				else if (this.he.getTypeFromVe(tmp.ve) instanceof RealDef) {
					code.append("List<Double> toCheck = new ArrayList<Double>();")
					code.append("\n\t")
					code.append("List<Double> filter = new ArrayList<Double>();")
				}
				else if (this.he.getTypeFromVe(tmp.ve) instanceof StringDef) {
					code.append("List<String> toCheck = new ArrayList<String>();")
					code.append("\n\t")
					code.append("List<String> filter = new ArrayList<String>();")
				}
				else {
					System.err.println("TypeDef not supported!")
				}	
			}

			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> toCheckVsp = I.get(0).vsp();")
			code.append("\n\t")
			
			code.append("for (int i = 0; i < toCheckVsp.size(); i++) {")
				code.append("\n\t\t")
				
				if (tmp instanceof bbn.InputPort) {
				
					if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof BoolDef) {
						code.append("toCheck.add(((Boolean)toCheckVsp.get(i).getValue()).booleanValue());")
					}
					else if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof IntegerDef) {
						code.append("toCheck.add(((Integer)toCheckVsp.get(i).getValue()).intValue());")
					}
					else if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof RealDef) {
						code.append("toCheck.add(((Number)toCheckVsp.get(i).getValue()).doubleValue());")
					}
					else if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof StringDef) {
						code.append("toCheck.add(toCheckVsp.get(i).getValue().toString());")
					}
					else {
						System.err.println("TypeDef not supported!")
					}	
				}
				
				else if (tmp instanceof InternalOutputPort) {
					if (this.he.getTypeFromVe(tmp.ve) instanceof BoolDef) {
						code.append("toCheck.add(((Boolean)toCheckVsp.get(i).getValue()).booleanValue());")
					}
					else if (this.he.getTypeFromVe(tmp.ve) instanceof IntegerDef) {
						code.append("toCheck.add(((Integer)toCheckVsp.get(i).getValue()).intValue());")
					}
					else if (this.he.getTypeFromVe(tmp.ve) instanceof RealDef) {
						code.append("toCheck.add(((Number)toCheckVsp.get(i).getValue()).doubleValue());")
					}
					else if (this.he.getTypeFromVe(tmp.ve) instanceof StringDef) {
						code.append("toCheck.add(toCheckVsp.get(i).getValue().toString());")
					}
					else {
						System.err.println("TypeDef not supported!")
					}	
				}
				
			code.append("\n\t")
			code.append("}")
			
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> filterVsp = I.get(1).vsp();")
			code.append("\n\t")
			
			code.append("List<List<SimpleEntry<String,Integer>>> htmp;")
			code.append("\n\t")
			
			code.append("for (int i = 0; i < filterVsp.size(); i++) {")
				code.append("\n\t\t")
				
				if (tmp instanceof bbn.InputPort) {
				
					if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof BoolDef) {
						code.append("filter.add(((Boolean)filterVsp.get(i).getValue()).booleanValue());")
					}
					else if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof IntegerDef) {
						code.append("filter.add(((Integer)filterVsp.get(i).getValue()).intValue());")
					}
					else if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof RealDef) {
						code.append("filter.add(((Double)filterVsp.get(i).getValue()).doubleValue());")
					}
					else if (this.he.getTypeFromVe(tmp.outputport.ve) instanceof StringDef){
						code.append("filter.add(filterVsp.get(i).getValue().toString());")
					}
					else {
						System.err.println("TypeDef not supported!")
					}	
				}
				else if (tmp instanceof InternalOutputPort) {
					
					if (this.he.getTypeFromVe(tmp.ve) instanceof BoolDef) {
						code.append("filter.add(((Boolean)filterVsp.get(i).getValue()).booleanValue());")
					}
					else if (this.he.getTypeFromVe(tmp.ve) instanceof IntegerDef) {
						code.append("filter.add(((Integer)filterVsp.get(i).getValue()).intValue());")
					}
					else if (this.he.getTypeFromVe(tmp.ve) instanceof RealDef) {
						code.append("filter.add(((Double)filterVsp.get(i).getValue()).doubleValue());")
					}
					else if (this.he.getTypeFromVe(tmp.ve) instanceof StringDef) {
						code.append("filter.add(filterVsp.get(i).getValue().toString());")
					}
					else {
						System.err.println("TypeDef not supported!")
					}
				}
				
			code.append("\n\t")
			code.append("}")

			code.append("for (int i = 0; i < toCheckVsp.size(); i++) {")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < filterVsp.size(); j++) {")
					code.append("\n\t\t\t")
					var EObject tmpc = p.co
					if (tmpc instanceof LessThan) {
						
						/*if (p.in.outputnode.ot instanceof dvgNode.Bool || p.in.outputnode.ot instanceof dvgNode.String) {
							System.err.println("ERROR: LessThan undefined for Bool or String")
						}*/
						
						if (tmpc.inclusive) {
							code.append("if (toCheck.get(i) <= filter.get(j)) {")
						}
						else {
							code.append("if (toCheck.get(i) < filter.get(j)) {")
						}
					}
					else if (tmpc instanceof GreaterThan) {
						
						/*if (p.in.outputnode.ot instanceof dvgNode.Bool || p.in.outputnode.ot instanceof dvgNode.String) {
							System.err.println("ERROR: GreaterThan undefined for Bool or String")
						}*/
						
						if (tmpc.inclusive) {
							code.append("if (toCheck.get(i) >= filter.get(j)) {")
						}
						else {
							code.append("if (toCheck.get(i) > filter.get(j)) {")
						}
					}
					else if (tmpc instanceof Equal) {
						
						/*if (tmpc.accuracy !== null && (p.in.outputnode.ot instanceof Bool || p.in.outputnode.ot instanceof dvgNode.String || p.in.outputnode.ot instanceof dvgNode.Integer)) {
							System.err.println("WARNING: Accuracy for Bool,String or Integer is ignored!")
						}*/
						
						if (tmpc.accuracy === null) {
							if (tmpc.inverse) {
								code.append("if (toCheck.get(i) != filter.get(j)) {")
							}
							else {
								code.append("if (toCheck.get(i) == filter.get(j)) {")
							}
						}
						else {
							// Only meaningful for Reals
							if (tmpc.inverse) {
								code.append("if (Math.abs(toCheck.get(i)-filter.get(j)) > "+tmpc.accuracy.value.toString+") {")
							}
							else {
								code.append("if (Math.abs(toCheck.get(i)-filter.get(j)) < "+tmpc.accuracy.value.toString+") {")
							}
							
						}
					}
						code.append("\n\t\t\t\t")
						code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
						code.append("\n\t\t\t\t")
						code.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();")
						code.append("\n\t\t\t\t")
						code.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(0).name(),i));")
						code.append("\n\t\t\t\t")
						code.append("if (toCheckVsp.get(i).getKey() != null) {")
							code.append("\n\t\t\t\t\t")
							code.append("htmp = toCheckVsp.get(i).getKey();")
							code.append("\n\t\t\t\t\t")
							code.append("for (List<SimpleEntry<String,Integer>> row : htmp) {")
								code.append("\n\t\t\t\t\t\t")
								code.append("for (SimpleEntry<String,Integer> entry : row) {")
									code.append("\n\t\t\t\t\t\t\t")
									code.append("headerRow.add(entry);")
								code.append("\n\t\t\t\t\t\t")	
								code.append("}")
							code.append("\n\t\t\t\t\t")	
							code.append("}")
						code.append("\n\t\t\t\t")	
						code.append("}")
						code.append("\n\t\t\t")
						code.append("header.add(headerRow);")
						code.append("\n\t\t\t")
						code.append("headerRow = new ArrayList<SimpleEntry<String,Integer>>();")
						code.append("\n\t\t\t")
						code.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(1).name(),j));")
						code.append("\n\t\t\t")
						code.append("if (filterVsp.get(j).getKey() != null) {")
							code.append("\n\t\t\t\t")
							code.append("htmp = filterVsp.get(j).getKey();")
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
						code.append("\n\t\t")
						code.append("header.add(headerRow);")
						code.append("\n\t\t")
						code.append("newValue = newValue = toCheck.get(i);")
						code.append("\n\t\t")
						code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));")
						code.append("\n\t\t")
					code.append("}")
				code.append("}")		
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("this.NODE_COLLECTION.put(\""+p.iop.name+"\", new NodeObject(\""+p.iop.name+"\", ovsp));")
			//code.append("return ovsp;")
		code.append("\n")
		code.append("}")
		
		return code.toString()
		//this.LOCAL_RESOLUTION_CODE.append(code)
		//this.LOCAL_RESOLUTION_CODE.append("\n\n")
	}
	
	def resolve(RPRO p, List<bbn.AbstractInputPort> inputSet, boolean isPs) {
		
		// VSP of the output node of the RProduction pattern: List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,*>> VSP
		// * is either Double or String depending on the Representation (Relative/Absolute or String) 
		
		var StringBuilder code = new StringBuilder()
		
//		if (p.outputnode.representation == Representation.ABSOLUTE || p.outputnode.representation == Representation.RELATIVE) {
//			code.append(this.NUMERIC_VSP_STANDARD)
//		}
//		else if (p.outputnode.representation == Representation.STRING) {
//			code.append(this.SYMBOLIC_VSP_STANDARD)
//		}
//		else {
//			System.out.println("ERROR: Representation is UNDEFINED!")
//		}
		//code.append(this.GENERIC_VSP_STANDARD_OUTPUT)
		code.append("void")
		
		code.append(" ")
		code.append("resolve_"+p.name)
		code.append("(")
		
//		for (i : p.inputnode) {
//			if (i.representation == Representation.ABSOLUTE || i.representation == Representation.RELATIVE) {
//				code.append(this.NUMERIC_VSP_STANDARD)
//			}
//			else if (i.representation == Representation.STRING) {
//				code.append(this.SYMBOLIC_VSP_STANDARD)
//			}
//			else {
//				System.out.println("ERROR: Representation is UNDEFINED!")
//			}
//			
//			code.append(" ")
//			code.append(i.name)
//			code.append(", ")	
//		}
		//code.append(this.GENERIC_VSP_STANDARD_INPUT)
		code.append("List<Node>")
		code.append(" ")
		code.append("I")

		code.append(") {")
			code.append("\n\t")
			if (this.CHECK_FOR_IS_SAM_IN_PRODUCTION) {
				code.append("List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();")
				code.append("\n\t")
				code.append("for (int i = 0; i < I.size(); i++) {")
					code.append("\n\t\t")
					code.append("if (I.get(i).vsp(0) != null) {")
						code.append("\n\t\t\t")	
						code.append("headerList.add(I.get(i).header(0));")
					code.append("\n\t\t")
					code.append("}")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				code.append("if (headerList.size() > 0 && isSAM(headerList)) {")
					code.append("\n\t\t")
					code.append("System.err.println(\"ERROR: There is a not allowed SAM-Situation for Production pattern "+p.name+"!\");")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				/*code.append("else {")
					code.append("\n\t\t")
					code.append("System.out.println(\"No SAM-Situation!\");")
				code.append("\n\t")
				code.append("}")*/
			}

			if (isPs) {
				code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>>();")
				code.append("\n\t")
				code.append("Map<String,Double> newValue;")
				code.append("\n\t")
			}
			else {
				code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
				code.append("\n\t")
				code.append("Object newValue;")
				code.append("\n\t")
			}
			
			var StringBuilder fdefcode = new StringBuilder()
			fdefcode.append("\n\t")
			if (isPs) {
				fdefcode.append("Map<String,Double> operator_"+p.name+"(List<Object> valueList")
			}
			else {
				fdefcode.append("Object operator_"+p.name+"(List<Object> valueList")
			}
			
			var StringBuilder fcallcode = new StringBuilder()
			fcallcode.append("\n\t")
			fcallcode.append("operator_"+p.name+"(valueList")
			
			var List<String> processedMin = new ArrayList<String>()
			var List<String> processedMax = new ArrayList<String>()
			code.append("List<Object> vtmp;")
			code.append("\n\t")
			
			var List<String> tmp = this.he.getSymbolsForMinOperators(p.expr.expr)
			for (i : tmp) {
				if (!processedMin.contains(i)) {
					var int index = this.he.getTh(i, inputSet)
					code.append("vtmp = I.get("+index+").values();")
					code.append("\n\t")
					code.append("double min_"+i+" = min(vtmp);")
					code.append("\n\t")
					fdefcode.append(", double min_"+i)
					fcallcode.append(",min_"+i)
					processedMin.add(i)
				}
			}
			tmp = this.he.getSymbolsForMaxOperators(p.expr.expr)
			for (i : tmp) {
				if (!processedMax.contains(i)) {
					var int index = this.he.getTh(i, inputSet)
					code.append("vtmp = I.get("+index+").values();")
					code.append("\n\t")
					code.append("double max_"+i+" = max(vtmp);")
					code.append("\n\t")
					fdefcode.append(", double max_"+i)
					fcallcode.append(",max_"+i)
					processedMax.add(i)
				}
			}
			
			fdefcode.append(") {")
			fcallcode.append(");")
			
			code.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();")
			code.append("\n\t")
			code.append("for (Node i : I) {")
				code.append("\n\t\t")
				code.append("List<Integer> tmp = new ArrayList<Integer>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < i.vsp().size(); j++) {")
					code.append("\n\t\t\t")
					code.append("tmp.add(j);")
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t")
				code.append("ir.add(tmp);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());")
			code.append("\n\t")
			code.append("for (int i = 0; i < cp.size(); i++) {")
				code.append("\n\t\t")
				code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < cp.get(i).size(); j++) {")
					code.append(this.jf.generateHeaderRow)
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t")
			
			// SAMS Filter in RPRO for consistency
			code.append("if (isValidCombination(header)) {")
			code.append("\n\t\t")
				code.append("List<Object> valueList = new ArrayList<Object>();")
				code.append("\n\t\t\t")
				code.append("for (int j = 0; j < I.size(); j++) {")
					code.append("\n\t\t\t\t")
					code.append("valueList.add(I.get(j).vsp(cp.get(i).get(j)));")
				code.append("\n\t\t\t")
				code.append("}")
				code.append("\n\t\t\t")
				code.append("newValue = "+fcallcode)
				code.append("\n\t\t\t")
				if (isPs) {
					code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Map<String,Double>>(header, newValue));")
				}
				else {
					code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));")
				}
			code.append("\n\t\t")
			code.append("}")
			
			
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			
			if (isPs) {
				code.append("this.NODE_COLLECTION.put(\""+p.opp.name+"\", new NodePs(\""+p.opp.name+"\", ovsp));")
			}
			else {
				code.append("this.NODE_COLLECTION.put(\""+p.op.name+"\", new NodeObject(\""+p.op.name+"\", ovsp));")
			}
			
		code.append("\n")
		code.append("}")
		
		this.LOCAL_RESOLUTION_CODE.append(code)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		
		if (isPs) {
			fdefcode.append(this.he.generateExpressionCodePs(p.name, p.expr.expr, inputSet))
		}
		else {
			fdefcode.append(this.he.generateExpressionCode(p.name, p.expr.expr, inputSet))
		}
		
		fdefcode.append("\n\t")
		fdefcode.append("}")
		this.LOCAL_RESOLUTION_CODE.append(fdefcode)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		
	}
	
	def resolve(SAPRO p, List<bbn.AbstractInputPort> inputSet) {
		
		// VSP of the output node of the RProduction pattern: List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,*>> VSP
		// * is either Double or String depending on the Representation (Relative/Absolute or String) 
		
		var StringBuilder code = new StringBuilder()
		
//		if (p.outputnode.representation == Representation.ABSOLUTE || p.outputnode.representation == Representation.RELATIVE) {
//			code.append(this.NUMERIC_VSP_STANDARD)
//		}
//		else if (p.outputnode.representation == Representation.STRING) {
//			code.append(this.SYMBOLIC_VSP_STANDARD)
//		}
//		else {
//			System.out.println("ERROR: Representation is UNDEFINED!")
//		}
		//code.append(this.GENERIC_VSP_STANDARD_OUTPUT)
		code.append("void")
		
		code.append(" ")
		code.append("resolve_"+p.name)
		code.append("(")
		
//		for (i : p.inputnode) {
//			if (i.representation == Representation.ABSOLUTE || i.representation == Representation.RELATIVE) {
//				code.append(this.NUMERIC_VSP_STANDARD)
//			}
//			else if (i.representation == Representation.STRING) {
//				code.append(this.SYMBOLIC_VSP_STANDARD)
//			}
//			else {
//				System.out.println("ERROR: Representation is UNDEFINED!")
//			}
//			
//			code.append(" ")
//			code.append(i.name)
//			code.append(", ")	
//		}
		//code.append(this.GENERIC_VSP_STANDARD_INPUT)
		code.append("List<Node>")
		code.append(" ")
		code.append("I")

		code.append(") {")
			code.append("\n\t")
			if (this.CHECK_FOR_IS_SAM_IN_PRODUCTION) {
				code.append("List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();")
				code.append("\n\t")
				code.append("for (int i = 0; i < I.size(); i++) {")
					code.append("\n\t\t")
					code.append("if (I.get(i).vsp(0) != null) {")
						code.append("\n\t\t\t")	
						code.append("headerList.add(I.get(i).header(0));")
					code.append("\n\t\t")
					code.append("}")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				code.append("if (headerList.size() > 0 && isSAM(headerList)) {")
					code.append("\n\t\t")
					code.append("System.err.println(\"ERROR: There is a not allowed SAM-Situation for Production pattern "+p.name+"!\");")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				/*code.append("else {")
					code.append("\n\t\t")
					code.append("System.out.println(\"No SAM-Situation!\");")
				code.append("\n\t")
				code.append("}")*/
			}


			
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
			code.append("\n\t")
			code.append("Object newValue;")
			code.append("\n\t")
			
			
			var StringBuilder fdefcode = new StringBuilder()
			fdefcode.append("\n\t")

			
			fdefcode.append("Object operator_"+p.name+"(List<Object> valueList")
			
			
			var StringBuilder fcallcode = new StringBuilder()
			fcallcode.append("\n\t")
			fcallcode.append("operator_"+p.name+"(valueList")
			
			var List<String> processedMin = new ArrayList<String>()
			var List<String> processedMax = new ArrayList<String>()
			code.append("List<Object> vtmp;")
			code.append("\n\t")
			
			var List<String> tmp = this.he.getSymbolsForMinOperators(p.expr.expr)
			for (i : tmp) {
				if (!processedMin.contains(i)) {
					var int index = this.he.getTh(i, inputSet)
					code.append("vtmp = I.get("+index+").values();")
					code.append("\n\t")
					code.append("double min_"+i+" = min(vtmp);")
					code.append("\n\t")
					fdefcode.append(", double min_"+i)
					fcallcode.append(",min_"+i)
					processedMin.add(i)
				}
			}
			tmp = this.he.getSymbolsForMaxOperators(p.expr.expr)
			for (i : tmp) {
				if (!processedMax.contains(i)) {
					var int index = this.he.getTh(i, inputSet)
					code.append("vtmp = I.get("+index+").values();")
					code.append("\n\t")
					code.append("double max_"+i+" = max(vtmp);")
					code.append("\n\t")
					fdefcode.append(", double max_"+i)
					fcallcode.append(",max_"+i)
					processedMax.add(i)
				}
			}
			
			fdefcode.append(") {")
			fcallcode.append(");")
			
			code.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();")
			code.append("\n\t")
			code.append("for (Node i : I) {")
				code.append("\n\t\t")
				code.append("List<Integer> tmp = new ArrayList<Integer>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < i.vsp().size(); j++) {")
					code.append("\n\t\t\t")
					code.append("tmp.add(j);")
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t")
				code.append("ir.add(tmp);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());")
			code.append("\n\t")
			code.append("for (int i = 0; i < cp.size(); i++) {")
				code.append("\n\t\t")
				code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < cp.get(i).size(); j++) {")
					code.append(this.jf.generateHeaderRow)
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t") 
				

					code.append("if (isValidCombination(header)) {")
				

					code.append("\n\t\t\t")
					code.append("List<Object> valueList = new ArrayList<Object>();")
					code.append("\n\t\t\t")
					code.append("for (int j = 0; j < I.size(); j++) {")
						code.append("\n\t\t\t\t")
						code.append("valueList.add(I.get(j).vsp(cp.get(i).get(j)));")
					code.append("\n\t\t\t")
					code.append("}")
					code.append("\n\t\t\t")
					code.append("newValue = "+fcallcode)
					code.append("\n\t\t\t")
		
					code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));")
				code.append("}")
			
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			

			if (p.op !== null) {
				code.append("this.NODE_COLLECTION.put(\""+p.op.name+"\", new NodeObject(\""+p.op.name+"\", ovsp));")
			}
			else if (p.ocp !== null) {
				code.append("this.NODE_COLLECTION.put(\""+p.ocp.name+"\", new NodeObject(\""+p.ocp.name+"\", ovsp));")
			}
			
		code.append("\n")
		code.append("}")
		
		this.LOCAL_RESOLUTION_CODE.append(code)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		

	
		fdefcode.append(this.he.generateExpressionCode(p.name, p.expr.expr, inputSet))
		
		
		fdefcode.append("\n\t")
		fdefcode.append("}")
		this.LOCAL_RESOLUTION_CODE.append(fdefcode)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		
	}	
	
	def resolve(APRO p, List<bbn.AbstractInputPort> inputSet) {
	
		var StringBuilder code = new StringBuilder()
		var StringBuilder icscode = new StringBuilder()
		
		for (var int i = 0; i < p.description.size; i++) {
			code.append(resolve(p.description.get(i), "resolve_"+p.name+"_d_"+i.toString, inputSet))
		}
		
		icscode.append("void")
		
		icscode.append(" ")
		icscode.append("resolve_"+p.name)
		icscode.append("(")
		
		icscode.append("List<Node>")
		icscode.append(" ")
		icscode.append("IObsolete")

		icscode.append(") {")
			icscode.append("\n\t")
			icscode.append("NodeObject nodeObject;")
			icscode.append("\n\t")
			icscode.append("List<Object> leafValues;")
			icscode.append("\n\t")
			icscode.append("List<Node> params;")
			icscode.append("\n\t")
			//icscode.append("List<Boolean> ignore;")
			for (var int i = 0; i < p.description.size; i++) {
				icscode.append(generateDescriptionCallCode(p.description.get(i), "resolve_"+p.name+"_d_"+i.toString))
			}
			// All Descriptions are resolved here
			
			if (p.description.size > 1) {
				
				icscode.append("List<Node> I = new ArrayList<Node>();")
				for (var int i = 0; i < p.description.size; i++) {
					icscode.append("I.add(this.NODE_COLLECTION.get(\""+p.description.get(i).core.iop.name+"\"));")	
				}
				
				icscode.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
				icscode.append("\n\t")
				icscode.append("Object newValue;")
				icscode.append("\n\t")
				icscode.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();")
				icscode.append("\n\t")
				icscode.append("for (int i = 0; i < I.size(); i++) {")
					icscode.append("\n\t\t")
					//code.append("SimpleEntry<String, Integer> fid = new SimpleEntry<String, Integer>(\""+pname+"\", i);")
					icscode.append("for (int j = 0; j < I.get(i).vsp().size(); j++) {")
						icscode.append("\n\t\t\t")
						icscode.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
						icscode.append("\n\t\t\t")
						icscode.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();")
						icscode.append("\n\t\t\t")
						//code.append("headerRow.add(fid);")
						//code.append("\n\t\t\t")
						icscode.append("headerRow.add(new SimpleEntry<String, Integer>(I.get(i).name(), j));")
						icscode.append("\n\t\t\t")
						icscode.append("if (I.get(i).header(j) != null) {")
							icscode.append("\n\t\t\t\t")
							icscode.append("List<List<SimpleEntry<String,Integer>>> htmp = I.get(i).header(j);")
							icscode.append("\n\t\t\t\t")
							icscode.append("for (List<SimpleEntry<String,Integer>> row : htmp) {")
								icscode.append("\n\t\t\t\t\t")
								icscode.append("for (SimpleEntry<String,Integer> entry : row) {")
									icscode.append("\n\t\t\t\t\t\t")
									icscode.append("headerRow.add(entry);")
								icscode.append("\n\t\t\t\t\t")
								icscode.append("}")
							icscode.append("\n\t\t\t\t")	
							icscode.append("}")
						icscode.append("\n\t\t\t")
						icscode.append("}")
						icscode.append("\n\t\t\t")
						icscode.append("header.add(headerRow);")
						icscode.append("\n\t\t\t")
						icscode.append("newValue = I.get(i).vsp(j);")
						icscode.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));")
						if (p.op !== null) {
							icscode.append("this.NODE_COLLECTION.put(\""+p.op.name+"\", new NodeObject(\""+p.op.name+"\", ovsp));")
						}
						else {
							icscode.append("this.NODE_COLLECTION.put(\""+p.ocp.name+"\", new NodeObject(\""+p.ocp.name+"\", ovsp));")
						}
					icscode.append("\n\t\t")
					icscode.append("}")
				icscode.append("\n\t")
				icscode.append("}")
			}
			else {
				
				if (p.op !== null) {
					icscode.append("this.NODE_COLLECTION.put(\""+p.op.name+"\", new NodeObject(\""+p.op.name+"\", this.NODE_COLLECTION.get(\""+p.description.get(0).core.iop.name+"\").vsp()));")
				}
				else {
					icscode.append("this.NODE_COLLECTION.put(\""+p.ocp.name+"\", new NodeObject(\""+p.ocp.name+"\", this.NODE_COLLECTION.get(\""+p.description.get(0).core.iop.name+"\").vsp()));")
				}
			}
			
			
		icscode.append("\n")
		icscode.append("}")
				
		this.LOCAL_RESOLUTION_CODE.append(code)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		this.LOCAL_RESOLUTION_CODE.append(icscode)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
	}
	
	def String generateDescriptionCallCode(Description d, String name) {
		var StringBuilder code = new StringBuilder
		

		
		if (d.precond !== null) {
			for (var int i = 0; i < d.precond.internalcomf.size; i++) {
				var EObject tmp = d.precond.internalcomf.get(i).iip.internalportref

				var InputCPort tmpc = d.precond.internalcomf.get(i).icp
				
				var EObject tmpco = tmpc.outputcport	
				if (tmpco instanceof InitCPort) { // Always true
					code.append(generateLeafCS(tmpco))
					code.append("\n\t")
				}
				
				if (tmp instanceof bbn.InputPort) { // Always true
					code.append("params = new ArrayList<Node>();")
					code.append("\n\t")
					code.append("params.add(this.NODE_COLLECTION.get(\""+tmp.outputport.name+"\"));")
					code.append("\n\t")
					code.append("params.add(this.NODE_COLLECTION.get(\""+tmpc.outputcport.name+"\"));")
					code.append(name+"_p_"+i+"(params);")
					//code.append(name+"_p_"+i+"(this.NODE_COLLECTION.get(\""+tmp.outputnode.name+"\", \""+tmpc.outputcsnode.name+"\"));")
					code.append("\n\t")
				}
			}	
		}
		
		var StringBuilder params = new StringBuilder()
		//var StringBuilder ignore = new StringBuilder()
		
		code.append("params = new ArrayList<Node>();")
		code.append("\n\t")
		//code.append("ignore = new ArrayList<Boolean>();")
		//code.append("\n\t")
		
		for (i : d.core.iip) {
			var EObject tmp = i.internalportref
			if (tmp instanceof bbn.InputPort) {
				params.append("params.add(this.NODE_COLLECTION.get(\""+tmp.outputport.name+"\"));")
				params.append("\n\t")
				//ignore.append("ignore.add(false);")
				//ignore.append("\n\t")
			}
			else if (tmp instanceof InternalOutputPort) {
				params.append("params.add(this.NODE_COLLECTION.get(\""+tmp.name+"\"));")
				params.append("\n\t")
				//ignore.append("ignore.add(true);")
				//ignore.append("\n\t")
			}
		}
		code.append(params)
		code.append("\n\t")
		//code.append(ignore)
		code.append("\n\t")
		code.append(name+"_c(params);")
		
		return code.toString
	}
	
	def resolve(Description d, String name, List<bbn.AbstractInputPort> inputSet) {
		
		var StringBuilder code = new StringBuilder()
		
		if (d.precond !== null) {
			for (var int i = 0; i < d.precond.internalcomf.size; i++) {
				code.append(resolve(d.precond.internalcomf.get(i),name+"_p_"+i))
				code.append("\n\n")
			}	
		}
		
		code.append(resolve(d.core, name+"_c", inputSet))
		code.append("\n\n")

		return code.toString()
	}
	
	def String resolve(Core c, String name, List<bbn.AbstractInputPort> inputSet) {
		
		// VSP of the output node of the RProduction pattern: List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,*>> VSP
		// * is either Double or String depending on the Representation (Relative/Absolute or String) 
		
		var StringBuilder code = new StringBuilder();
		
		var StringBuilder cdofdefCode = new StringBuilder();
		var StringBuilder cdofcallCode = new StringBuilder();
		
//		if (p.outputnode.representation == Representation.ABSOLUTE || p.outputnode.representation == Representation.RELATIVE) {
//			code.append(this.NUMERIC_VSP_STANDARD)
//		}
//		else if (p.outputnode.representation == Representation.STRING) {
//			code.append(this.SYMBOLIC_VSP_STANDARD)
//		}
//		else {
//			System.out.println("ERROR: Representation is UNDEFINED!")
//		}
		//code.append(this.GENERIC_VSP_STANDARD_OUTPUT)
		code.append("void")
		
		code.append(" ")
		code.append(name)
		code.append("(")
		
//		for (i : p.inputnode) {
//			if (i.representation == Representation.ABSOLUTE || i.representation == Representation.RELATIVE) {
//				code.append(this.NUMERIC_VSP_STANDARD)
//			}
//			else if (i.representation == Representation.STRING) {
//				code.append(this.SYMBOLIC_VSP_STANDARD)
//			}
//			else {
//				System.out.println("ERROR: Representation is UNDEFINED!")
//			}
//			
//			code.append(" ")
//			code.append(i.name)
//			code.append(", ")	
//		}
		//code.append(this.GENERIC_VSP_STANDARD_INPUT)
		code.append("List<Node> I")

		code.append(") {")
			code.append("\n\t")
			
			if (this.CHECK_FOR_IS_SAM_IN_PRODUCTION) {
				code.append("List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();")
				code.append("\n\t")
				code.append("for (int i = 0; i < I.size(); i++) {")
					code.append("\n\t\t")
					code.append("if (I.get(i).header(0) != null) {")
						code.append("\n\t\t\t")	
						code.append("headerList.add(I.get(i).header(0));")
					code.append("\n\t\t")
					code.append("}")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				code.append("if (headerList.size() > 0 && isSAM(headerList)) {")
					code.append("\n\t\t")
					code.append("System.err.println(\"ERROR: There is a not allowed SAM-Situation for Production pattern "+name+"!\");")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				/*code.append("else {")
					code.append("\n\t\t")
					code.append("System.out.println(\"No SAM-Situation!\");")
				code.append("\n\t")
				code.append("}")*/
			}
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
			code.append("\n\t")
			code.append("Object newValue;")
			code.append("\n\t")
				
			if (c.expr !== null) {
				
				var List<String> alreadyGenerated = new ArrayList<String>()
				var List<String> tmp = this.he.getSymbolsForComplexDo(c.expr.expr)
				//System.out.println("TMPPPPPPPPPP: "+ tmp)
				var List<Integer> cdoi = new ArrayList<Integer>()
				var List<String> cdos = new ArrayList<String>()
				for (i : tmp) {
					if (!alreadyGenerated.contains(i)) {
						var int index = this.he.getTh(i, inputSet)
						cdoi.add(index)
						cdos.add(i)
						code.append("List<Object> " +i+";")
						cdofdefCode.append(",List<Object> "+i)
						cdofcallCode.append(","+i)
						alreadyGenerated.add(i)			
					}
					
				}
				//System.out.println("cdos: "+ cdos)
				//System.out.println("cdoi: "+ cdoi)
				
					code.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();")
					code.append("\n\t")
					code.append("for (Node i : I) {")
						code.append("\n\t\t")
						code.append("List<Integer> tmp = new ArrayList<Integer>();")
						code.append("\n\t\t")
						code.append("if (i instanceof NodeObjectList) {")
							code.append("\n\t\t\t")
								code.append("for (int j = 0; j < i.vsp_2().size(); j++) {")
									code.append("\n\t\t\t\t")
									code.append("tmp.add(j);")
								code.append("\n\t\t\t")
								code.append("}")
						code.append("\n\t\t")
						code.append("}")
						code.append("\n\t\t")
						code.append("else if (i instanceof NodeObject) {")
							code.append("\n\t\t\t")
								code.append("for (int j = 0; j < i.vsp().size(); j++) {")
									code.append("\n\t\t\t\t")
									code.append("tmp.add(j);")
								code.append("\n\t\t\t")
								code.append("}")
						code.append("\n\t\t")
						code.append("}")
						
						code.append("\n\t\t")
						code.append("ir.add(tmp);")
					code.append("\n\t")
					code.append("}")
					code.append("\n\t")
					code.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());")
					code.append("\n\t")
					code.append("for (int i = 0; i < cp.size(); i++) {")
						code.append("\n\t\t")
						code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
						code.append("\n\t\t")
						code.append("for (int j = 0; j < cp.get(i).size(); j++) {")
							code.append(this.jf.generateHeaderRow)
						code.append("\n\t\t")
						code.append("}")
						code.append("\n\t\t")
						code.append("List<Object> valueList = new ArrayList<Object>();")
						code.append("\n\t\t")
						
						
						for (var int i = 0; i < inputSet.size(); i++) {
							
							
							// At the moment, we need to make sure that:
							// (i) the order of Primitive and Complex Input Nodes is not mixed,
							// (ii) first all Primitives then all Complex must come
							// (iii) order in expression is according to input order
							// Also consider that with respect to APRO Pattern the order of input nodes and internal input nodes should match 
							if (cdoi.size() > 0 && cdoi.get(0) == i) {
								// The i-th Input is a ComplexDo under the assumption that the expression is correct
								code.append(cdos.get(0) + " = I.get("+i+").vsp_2(cp.get(i).get("+i+"));")
								code.append("\n\t\t")
								cdoi.remove(0);
								cdos.remove(0);
							}
							else {
								code.append("valueList.add(I.get("+i+").vsp(cp.get(i).get("+i+")));")
								code.append("\n\t\t")
							}
							
						}
						
						/*code.append("for (int j = 0; j < I.size(); j++) {")
							code.append("\n\t\t\t")
							//code.append("if (!ignore.get(j)) {")
								code.append("\n\t\t\t\t")
								code.append("if (I.get(j) instanceof NodeObjectList) {")
									code.append("")
								code.append("}")
								code.append("else {")
									code.append("valueList.add(I.get(j).vsp(cp.get(i).get(j)));")
								code.append("}")
							code.append("\n\t\t\t")
							//code.append("}")
						code.append("\n\t\t")
						code.append("}")*/
						
						
						
						code.append("\n\t\t")
						code.append("if (isValidCombination(header)) {")
							code.append("\n\t\t\t")
							code.append("newValue = operator_"+name+"(valueList"+cdofcallCode+");")
							code.append("\n\t\t\t")
							code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));")
						code.append("\n\t\t")
						code.append("}")
					code.append("\n\t")
					code.append("}")
					code.append("\n\t")
					code.append("this.NODE_COLLECTION.put(\""+c.iop.name+"\", new NodeObject(\""+c.iop.name+"\", ovsp));")
					//code.append("return ovsp;")
				code.append("\n")
				code.append("}")
				code.append("\n")
				
				
				//this.LOCAL_RESOLUTION_CODE.append(code)
				//this.LOCAL_RESOLUTION_CODE.append("\n\n")
				
				var StringBuilder fdefcode = new StringBuilder()
				fdefcode.append("\n\t")
				fdefcode.append("Object operator_"+name+"(List<Object> valueList"+cdofdefCode+") {")
				fdefcode.append(this.he.generateExpressionCode(name, c.expr.expr, inputSet))
				fdefcode.append("\n\t")
				fdefcode.append("}")
				
				code.append(fdefcode)
				code.append("\n")
				//this.LOCAL_RESOLUTION_CODE.append(fdefcode)
				//this.LOCAL_RESOLUTION_CODE.append("\n\n")
			
			}
			else if (c.ca !== null) {
				
				 
				code.append("List<List<SimpleEntry<String,Integer>>> header;")
				code.append("\n\t")
				code.append("List<SimpleEntry<String,Integer>> headerRow;")
				code.append("\n\t")
				code.append("List<List<SimpleEntry<String,Integer>>> htmp;")
				for (i : c.ca.combination) {
					code.append("\n\t")
					code.append("header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
					for (var int j = 0; j < i.element.size(); j++) {
						//var int internalNodeIndex = getTh(j.inputnode, p.opdep.inputnode)
						// We assume that the i-th element refers to the i-th Input Node
						var int internalNodeIndex = j;
						//System.out.println("TIMO TEST INDEX !!!!!!!!!!!!!!!!!!!!!!!!!!!!!: "+internalNodeIndex)
						code.append(this.jf.generateHeaderRow(internalNodeIndex, i.element.get(j).index))
						code.append("\n\t") 
					}
					code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header,"+i.value.value+"));")
					code.append("\n\t") 
				}
				code.append("\n\t")
				code.append("this.NODE_COLLECTION.put(\""+c.iop.name+"\", new NodeObject(\""+c.iop.name+"\", ovsp));")
				code.append("\n")
				code.append("}")
				
				//this.LOCAL_RESOLUTION_CODE.append(code)
				//this.LOCAL_RESOLUTION_CODE.append("\n\n")
				
			}
			
			return code.toString
	}
	
	
	
	def resolve(MAGR p) {
	
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
			lcode.append(resolveAggregation(p.name, name, p.aggr.get(i)))
			lcode.append("\n")
		}
		code.append("\n")
		code.append("}")	
		
		this.LOCAL_RESOLUTION_CODE.append(code)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		this.LOCAL_RESOLUTION_CODE.append(lcode)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
	}
	
	def String resolveAggregation(String pname, String fname, AGGR la) {
		
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
	
	def resolve(TRAN p) {
		
		var StringBuilder code = new StringBuilder();
	
		code.append("void")
		code.append(" ")
		code.append("resolve_"+p.name)
		code.append("(")
		code.append("List<Node>")
		code.append(" ")
		code.append("I")
		code.append(") {")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
			code.append("\n\t")
			code.append("Object newValue = 0.0;")
			code.append("\n\t")
			code.append("List<Double> s = new ArrayList<Double>();")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsptmp = I.get(0).vsp();")
			code.append("\n\t")
			
			code.append("for (int i = 0; i < vsptmp.size(); i++) {")
				code.append("\n\t\t")
				code.append("s.add(((Number)vsptmp.get(i).getValue()).doubleValue());")
			code.append("\n\t")
			code.append("}")

			code.append("for (int i = 0; i < vsptmp.size(); i++) {")
				code.append("\n\t\t")
				code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
				code.append("\n\t\t")
				
		
				code.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();")
				code.append("\n\t\t\t")
				code.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(0).name(),i));")
				code.append("\n\t\t\t")
				code.append("if (vsptmp.get(i).getKey() != null) {")
					code.append("\n\t\t\t\t")
					code.append("List<List<SimpleEntry<String,Integer>>> htmp = vsptmp.get(i).getKey();")
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

				var NormalizationCOp nf = p.no
				if (nf instanceof LinearNormalization) {
					if (nf.min === null && nf.max === null) {
						code.append("double num = Collections.max(s)-((Number)vsptmp.get(i).getValue()).doubleValue();")
						code.append("\n\t\t\t")
						code.append("double den = Collections.max(s)-Collections.min(s);")
						code.append("\n\t\t\t")
					}
					else if (nf.min !== null && nf.max === null) {
						code.append("double num = Collections.max(s)-((Number)vsptmp.get(i).getValue()).doubleValue();")
						code.append("\n\t\t\t")
						code.append("double den = Collections.max(s)-"+nf.min.value.toString+";")
						code.append("\n\t\t\t")
					}
					else if (nf.min === null && nf.max !== null) {
						code.append("double num = "+nf.max.value.toString+"-((Number)vsptmp.get(i).getValue()).doubleValue();")
						code.append("\n\t\t\t")
						code.append("double den = "+nf.max.value.toString+"-Collections.min(s);")
						code.append("\n\t\t\t")	
					}
					else {
						code.append("double num = "+nf.max.value.toString+"-((Number)vsptmp.get(i).getValue()).doubleValue();")
						code.append("\n\t\t\t")
						code.append("double den = "+nf.max.value.toString+"-"+nf.min.value.toString+";")
						code.append("\n\t\t\t")
					}
					
					if (nf.direction == Direction.DEC) {
						code.append("newValue = num/den;")
					}
					else {
						code.append("newValue = 1-(num/den);")
					}
				}
				
				code.append("\n\t\t\t")
				code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("this.NODE_COLLECTION.put(\""+p.op.name+"\", new NodeObject(\""+p.op.name+"\", ovsp));")
		code.append("\n")
		code.append("}")
		
		this.LOCAL_RESOLUTION_CODE.append(code)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
	}
	
	def String resolve(CONT p) {
		
		var StringBuilder code = new StringBuilder()
		
		code.append("void")
		code.append(" ")
		code.append("resolve_"+p.name)
		code.append("(")
		code.append("List<Node>")
		code.append(" ")
		code.append("I")

		code.append(") {")
			code.append("\n\t")
			if (this.CHECK_FOR_IS_SAM_IN_CONTRADICTION) {
				code.append("List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();")
				code.append("\n\t")
				code.append("for (int i = 0; i < I.size(); i++) {")
					code.append("\n\t\t")
					code.append("if (I.get(i).header(0) != null) {")
						code.append("\n\t\t\t")	
						code.append("headerList.add(I.get(i).header(0));")
					code.append("\n\t\t")
					code.append("}")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				code.append("if (headerList.size() > 0 && !isSAM(headerList)) {")
					code.append("\n\t\t")
					code.append("System.err.println(\"ERROR: There is no SAM-Situation for Contradiction pattern "+p.name+"!\");")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				/*code.append("else {")
					code.append("\n\t\t")
					code.append("System.out.println(\"No SAM-Situation!\");")
				code.append("\n\t")
				code.append("}")*/
			}
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
			code.append("\n\t")
			code.append("double newValue = 0.0;")
			code.append("\n\t")
			code.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();")
			code.append("\n\t")
			code.append("for (Node i : I) {")
				code.append("\n\t\t")
				code.append("List<Integer> tmp = new ArrayList<Integer>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < i.vsp().size(); j++) {")
					code.append("\n\t\t\t")
					code.append("tmp.add(j);")
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t")
				code.append("ir.add(tmp);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());")
			code.append("\n\t")
			code.append("for (int i = 0; i < cp.size(); i++) {")
				code.append("\n\t\t")
				code.append("newValue = 0.0;")
				code.append("\n\t\t")
				code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < cp.get(i).size(); j++) {")
					code.append(this.jf.generateHeaderRow)
				code.append("\n\t\t")
				code.append("}")
				
				code.append("\n\t\t")
				code.append("if (isValidCombination(header)) {")
					code.append("\n\t\t\t")
					code.append("Map<String, Double> valueList = new HashMap<String, Double>();")
					code.append("\n\t\t\t")
					code.append("Map<String, Double> ps = new HashMap<String, Double>();")
					code.append("\n\t\t\t")
					code.append("for (int j = 0; j < I.size(); j++) {")
						code.append("\n\t\t\t\t")
						code.append("if (I.get(j) instanceof NodePs) {")
							code.append("\n\t\t\t\t\t")
							code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> res = I.get(j).vsp();")
							code.append("\n\t\t\t\t\t")
							code.append("ps = res.get(cp.get(i).get(j)).getValue();")
						code.append("\n\t\t\t\t")
						code.append("}")
						code.append("\n\t\t\t\t")
						code.append("else {")
							code.append("\n\t\t\t\t\t")
							code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> res = I.get(j).vsp();")
							code.append("\n\t\t\t\t\t")
							code.append("valueList.put(I.get(j).name(), ((Number) res.get(cp.get(i).get(j)).getValue()).doubleValue());")
						code.append("\n\t\t\t\t")
						code.append("}")
					code.append("\n\t\t\t")
					code.append("}")
					code.append("\n\t\t\t")
					code.append("for (Map.Entry<String, Double> entry : ps.entrySet()) {")
						code.append("\n\t\t\t\t")
						code.append("newValue += ps.get(entry.getKey()) * valueList.get(entry.getKey());")
					code.append("\n\t\t\t")
					code.append("}")
					code.append("\n\t\t\t")
					code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));")
				code.append("\n\t\t\t")
				code.append("}")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("this.NODE_COLLECTION.put(\""+p.op.name+"\", new NodeObject(\""+p.op.name+"\", ovsp));")
		code.append("\n")
		code.append("}")
		
		this.LOCAL_RESOLUTION_CODE.append(code)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		
		return code.toString
	}
	
	def String resolve(EPROD p) {
		
		var StringBuilder code = new StringBuilder()
		
		code.append("void")
		code.append(" ")
		code.append("resolve_"+p.name)
		code.append("(")
		code.append("List<Node>")
		code.append(" ")
		code.append("I")

		code.append(") {")
			code.append("\n\t")
			if (this.CHECK_FOR_IS_SAM_IN_CONTRADICTION) {
				code.append("List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();")
				code.append("\n\t")
				code.append("for (int i = 0; i < I.size(); i++) {")
					code.append("\n\t\t")
					code.append("if (I.get(i).header(0) != null) {")
						code.append("\n\t\t\t")	
						code.append("headerList.add(I.get(i).header(0));")
					code.append("\n\t\t")
					code.append("}")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				code.append("if (headerList.size() > 0 && !isSAM(headerList)) {")
					code.append("\n\t\t")
					code.append("System.err.println(\"ERROR: There is no SAM-Situation for SAMF pattern "+p.name+"!\");")
				code.append("\n\t")
				code.append("}")
				code.append("\n\t")
				/*code.append("else {")
					code.append("\n\t\t")
					code.append("System.out.println(\"No SAM-Situation!\");")
				code.append("\n\t")
				code.append("}")*/
			}
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
			code.append("\n\t")
			code.append("double newValue = 0.0;")
			code.append("\n\t")
			code.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();")
			code.append("\n\t")
			code.append("for (Node i : I) {")
				code.append("\n\t\t")
				code.append("List<Integer> tmp = new ArrayList<Integer>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < i.vsp().size(); j++) {")
					code.append("\n\t\t\t")
					code.append("tmp.add(j);")
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t")
				code.append("ir.add(tmp);")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());")
			code.append("\n\t")
			code.append("for (int i = 0; i < cp.size(); i++) {")
				code.append("\n\t\t")
				code.append("newValue = 0.0;")
				code.append("\n\t\t")
				code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < cp.get(i).size(); j++) {")
					code.append(this.jf.generateHeaderRow)
				code.append("\n\t\t")
				code.append("}")
				
				code.append("\n\t\t")
				

					code.append("if (isValidCombination(header)) {")
				

					code.append("\n\t\t\t")
//					code.append("Map<String, Double> valueList = new HashMap<String, Double>();")
//					code.append("\n\t\t\t")
//					code.append("Map<String, Double> ps = new HashMap<String, Double>();")
					code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> res = I.get(0).vsp();")
					code.append("\n\t\t\t")
					code.append("newValue = ((Number) res.get(cp.get(i).get(0)).getValue()).doubleValue();")
//					code.append("for (int j = 0; j < I.size(); j++) {")
//						code.append("\n\t\t\t\t")
//						code.append("if (I.get(j) instanceof NodePs) {")
//							code.append("\n\t\t\t\t\t")
//							code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> res = I.get(j).vsp();")
//							code.append("\n\t\t\t\t\t")
//							code.append("ps = res.get(cp.get(i).get(j)).getValue();")
//						code.append("\n\t\t\t\t")
//						code.append("}")
//						code.append("\n\t\t\t\t")
//						code.append("else {")
//							code.append("\n\t\t\t\t\t")
//							code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> res = I.get(j).vsp();")
//							code.append("\n\t\t\t\t\t")
//							code.append("valueList.put(I.get(j).name(), ((Number) res.get(cp.get(i).get(j)).getValue()).doubleValue());")
//						code.append("\n\t\t\t\t")
//						code.append("}")
//					code.append("\n\t\t\t")
//					code.append("}")
//					code.append("\n\t\t\t")
//					code.append("for (Map.Entry<String, Double> entry : ps.entrySet()) {")
//						code.append("\n\t\t\t\t")
//						code.append("newValue += ps.get(entry.getKey()) * valueList.get(entry.getKey());")
//					code.append("\n\t\t\t")
//					code.append("}")
					code.append("\n\t\t\t")
					code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));")
				code.append("\n\t\t\t")
				code.append("}")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("this.NODE_COLLECTION.put(\""+p.op.name+"\", new NodeObject(\""+p.op.name+"\", ovsp));")
		code.append("\n")
		code.append("}")
		
		this.LOCAL_RESOLUTION_CODE.append(code)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		
		return code.toString
	}	
	
	def resolve(PTCC p) {
		
		var StringBuilder code = new StringBuilder()
		
		var StringBuilder pcc_transf_code = new StringBuilder()
		
		this.LOCAL_RESOLUTION_CODE.append(this.jf.resolveParetoFilter("resolve_"+p.name+"_pf",p.max, this.CHECK_FOR_IS_SAM_IN_CONTRADICTION))
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		
		code.append("void")
		code.append(" ")
		code.append("resolve_"+p.name)
		code.append("(")
		code.append("List<Node>")
		code.append(" ")
		code.append("I")

		code.append(") {")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
			code.append("\n\t")
			code.append("double newValue = 0.0;")
			code.append("\n\t")
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcombpf = resolve_"+p.name+"_pf(I);")
			code.append("\n\t")
			code.append("List<List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>> R = new ArrayList<List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>();")
			code.append("\n\t")
			
			
			
			code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> S;")
			for (var int i = 0; i < p.no.size; i++) { // p.transformationoperator = I.size-1 = vcombpf.get(0).size-1: We do not iterate over the last element which we assume is ps
				code.append("\n\t")
				code.append("S = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();")
				code.append("\n\t")
				code.append("for (int j = 0; j < vcombpf.size(); j++) {")
					code.append("\n\t\t")
					code.append("S.add(vcombpf.get(j).getValue().get("+i+"));")
				code.append("\n\t")
				code.append("}")
				// We assume that the i-th nf is associated with the i-th Input Node!
				var String fname = "resolve_pcc_trans_"+p.ip.get(i).name
				pcc_transf_code.append(this.jf.resolveTransformation(fname, p.no.get(i)))
				pcc_transf_code.append("\n\n")
				code.append("\n\t")
				code.append("R.add("+fname+"(S));")
			}
			code.append("\n\t")
			code.append("Map<String,Double> valueList = new HashMap<String,Double>();")
			code.append("\n\t")
			code.append("Map<String, Double> psm = new HashMap<String, Double>();")
			code.append("\n\t")
			code.append("for (int i = 0; i < vcombpf.size(); i++) {")
				code.append("\n\t\t")
				code.append("newValue = 0.0;")
				code.append("\n\t\t")
				code.append("for (int j = 0; j < R.size(); j++) {")
					code.append("\n\t\t\t")
					code.append("valueList.put(I.get(j).name(),((Number)R.get(j).get(i).getValue()).doubleValue());")
				code.append("\n\t\t")
				code.append("}")
				code.append("int key = vcombpf.get(i).getKey().get(I.size()-1).get(0).getValue();")
				code.append("\n\t\t")
				code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> psVsp = I.get(I.size()-1).vsp();")
				code.append("\n\t\t")
				code.append("psm = psVsp.get(key).getValue();")
				code.append("\n\t\t")
				code.append("for (Map.Entry<String, Double> entry : psm.entrySet()) {")
					code.append("\n\t\t\t")
					code.append("newValue += psm.get(entry.getKey()) * valueList.get(entry.getKey());")
				code.append("\n\t\t")
				code.append("}")
				code.append("\n\t\t")	
				code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>(vcombpf.get(i).getKey(),newValue));")
			code.append("\n\t")
			code.append("}")
			code.append("\n\t")
			code.append("this.NODE_COLLECTION.put(\""+p.op.name+"\", new NodeObject(\""+p.op.name+"\", ovsp));")
		
		code.append("\n")
		code.append("}")
		
		this.LOCAL_RESOLUTION_CODE.append(code)
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		this.LOCAL_RESOLUTION_CODE.append("\n\n")
		this.LOCAL_RESOLUTION_CODE.append(pcc_transf_code)
		
		return code.toString

	}
}
