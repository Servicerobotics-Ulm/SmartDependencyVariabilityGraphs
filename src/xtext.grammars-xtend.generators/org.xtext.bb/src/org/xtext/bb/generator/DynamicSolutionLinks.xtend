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
import BbDvgTcl.RPRO
import BbDvgTcl.MAGR
import BbDvgTcl.CONT
import BbDvgTcl.EPROD
import BbDvgTcl.TRAN
import BbDvgTcl.COMF
import BbDvgTcl.PTCC
import java.util.Set
import BbDvgTcl.OutputPort
import java.util.HashSet
import BbDvgTcl.BBContainer
 
class DynamicSolutionLinks {
	
	Helpers he
	
	Set<SimpleEntry<BbDvgTcl.Pattern, OutputPort>> depToDaggr
	
	def Set<SimpleEntry<BbDvgTcl.Pattern, OutputPort>> getDepToDaggr() {
		return this.depToDaggr
	} 
	
	def determineDMAGRReferences(DVG dvg) {
		
		this.he = new Helpers()
		this.depToDaggr = new HashSet<SimpleEntry<BbDvgTcl.Pattern, OutputPort>>()
		
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

	def detDAGGRDep (BbDvgTcl.Pattern p) {
		
		if (p instanceof RPRO) {
			for (i : p.ip) {
				if (i.outputport !== null) {
					if (this.he.isDaggr(i.outputport)) {
						this.depToDaggr.add(new SimpleEntry<BbDvgTcl.Pattern, OutputPort>(p, i.outputport))
					}
				}
			}			
		}
		else if (p instanceof SAPRO) {
			for (i : p.ip) {
				if (i.outputport !== null) {
					if (this.he.isDaggr(i.outputport)) {
						this.depToDaggr.add(new SimpleEntry<BbDvgTcl.Pattern, OutputPort>(p, i.outputport))
					}
				}
			}				
		}
		else if (p instanceof APRO) {
			for (i : p.ip) {
				if (i.outputport !== null) {
					if (this.he.isDaggr(i.outputport)) {
						this.depToDaggr.add(new SimpleEntry<BbDvgTcl.Pattern, OutputPort>(p, i.outputport))
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
