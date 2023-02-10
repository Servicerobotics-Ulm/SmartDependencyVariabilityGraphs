package org.xtext.tcl.generator

import BbDvgTcl.BuildingBlock
import BbDvgTcl.BuildingBlockDescription
import BbDvgTcl.DVG
import org.eclipse.emf.ecore.EObject
import BbDvgTcl.INIT
import BbDvgTcl.InitCPort
import BbDvgTcl.InitWSMPort
import java.util.ArrayList
import java.util.List

class Requirements {
	
	var List<String> constraintRequirements
	var List<String> preferenceRequirements
	var boolean alreadyDetermined
	DVG dvg
	
	new () {
		this.alreadyDetermined = false
		this.constraintRequirements = new ArrayList<String>()
		this.preferenceRequirements = new ArrayList<String>()
	}
	
	def boolean determine(BuildingBlock bb) {
		
		if (!this.alreadyDetermined) {
			var EObject tmp = bb.eContainer
			
			if (tmp instanceof BuildingBlockDescription) {
				this.dvg = tmp.dvg
				// bb is the reference to the root building block for which requirements can be commanded
				// we need to determine all requirement ports (init preference ports, init constraint ports) of the associated dvg
				for (i : dvg.pattern) {
					if (i instanceof INIT) {
						if (i.ainip instanceof InitCPort) {
							this.constraintRequirements.add(i.ainip.name)
						}
						else if (i.ainip instanceof InitWSMPort) {
							this.preferenceRequirements.add(i.ainip.name)
						}
					}
				}
				this.alreadyDetermined = true	
			}
			return true
		}
		return false
	}
	
	def String generateTclCode() {
		var String code = ""
		for (var int i = 0; i < this.constraintRequirements.size; i++) {
			code += "?" +this.constraintRequirements.get(i) +" "
		}
		for (var int i = 0; i < this.preferenceRequirements.size; i++) {
			code += "?" +this.preferenceRequirements.get(i) + " "
		}
		return code
	}
	
	def String getDVGName() {
		if (this.dvg !== null) {
			return this.dvg.name
		}
		else {
			return "solver"
		}
	}
	
	def List<String> getConstraintRequirements() {
		return this.constraintRequirements
	}
	
	def List<String> getPreferenceRequirements() {
		return this.preferenceRequirements
	}	
	
//	def generateTclCode() {
//		'''
//		«FOR i : 0..this.constraintRequirements.size-1»
//			?«this.constraintRequirements.get(i)» 
//		«ENDFOR»
//		«FOR i : 0..this.preferenceRequirements.size-1»
//			?«this.preferenceRequirements.get(i)» 
//		«ENDFOR»
//		'''
//	}
	
}