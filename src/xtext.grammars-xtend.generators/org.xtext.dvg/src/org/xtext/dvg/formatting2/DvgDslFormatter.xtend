/*
 * generated by Xtext 2.21.0
 */
package org.xtext.dvg.formatting2

import BbDvgTcl.BuildingBlock
import BbDvgTcl.DVG
import com.google.inject.Inject
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.xtext.dvg.services.DvgDslGrammarAccess

class DvgDslFormatter extends AbstractFormatter2 {
	
	@Inject extension DvgDslGrammarAccess 

	def dispatch void format(DVG dVG, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (pattern : dVG.pattern) {
			pattern.format
		}
		for (bBContainer : dVG.bbcontainer) {
			bBContainer.format
		}
	}

	def dispatch void format(BuildingBlock buildingBlock, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		buildingBlock.ves.format
		for (output : buildingBlock.o) {
			output.format
		}
		for (inputRelationship : buildingBlock.ir) {
			inputRelationship.format
		}
		buildingBlock.sharedresources.format
	}
	
	// TODO: implement for BBContainer, EPROD, EQUF, INIT, SAPRO, COMF, RPRO, APRO, TRAN, PTCC, CONT, MAGR, DMAGR, BuildingBlockInst, InitPort, Output, Input, PropertyInst, ParameterInst, ContextInst, PortElement, Number, Condition, ElementDef, BoundedDataObjectDef, UnboundedDataObjectDef, SIUnit, ComplexVSPInit, IntegerVSPInit, RealVSPInit, VI, Element, Bool, Integer, Real, String, VariabilityEntitySet, BuildingBlockDescription, Container, Loop, Sequential, Parallel, ConditionalFork, EquivalenceFork, Unsequenceable, ParameterSet, PropertySet, ContextSet, PortElementSet, Mandatory, Optional, AND, XOR, OR, InitCPort, InitWSMPort, StaticWeights, CombinationAssignment, Combination, Equal, Description, Precondition, Core, InternalCOMF, LinearNormalization, AGGR, DAGGR
}
