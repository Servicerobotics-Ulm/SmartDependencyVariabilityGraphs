/*
 * generated by Xtext 2.27.0
 */
package org.xtext.tcl.formatting2

import BbDvgTcl.Behavior
import BbDvgTcl.KBIsAGroupCollection
import com.google.inject.Inject
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.xtext.tcl.services.TclGrammarAccess

class TclFormatter extends AbstractFormatter2 {
	
	@Inject extension TclGrammarAccess

	def dispatch void format(Behavior behavior, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		behavior.module.format
		behavior.errorcollection.format
		behavior.kbisagroupcollection.format
		for (block : behavior.block) {
			block.format
		}
	}

	def dispatch void format(KBIsAGroupCollection kBIsAGroupCollection, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (kBIsAGroup : kBIsAGroupCollection.kbisagroup) {
			kBIsAGroup.format
		}
	}
	
	// TODO: implement for ErrorCollection, KBIsAGroup, BuildingBlock, TCB, SameNameTCBs, SameSignatureTCBs, Rule, Function, EventHandler, VariabilityEntitySet, Output, BuildingBlockDescription, BuildingBlockInst, Container, Loop, Sequential, Parallel, ConditionalFork, EquivalenceFork, Unsequenceable, Number, ElementDef, BoundedDataObjectDef, UnboundedDataObjectDef, SIUnit, ComplexVSPInit, IntegerVSPInit, RealVSPInit, VI, Element, Bool, Integer, Real, String, Condition, ParameterSet, PropertySet, ContextSet, PortElementSet, ParameterInst, PropertyInst, ContextInst, PortElement, Input, Mandatory, Optional, AND, XOR, OR, DVG, BBContainer, EPROD, EQUF, INIT, SAPRO, COMF, RPRO, APRO, TRAN, PTCC, CONT, MAGR, DMAGR, InitPort, InitCPort, InitWSMPort, StaticWeights, CombinationAssignment, Combination, Equal, Description, Precondition, Core, InternalCOMF, LinearNormalization, AGGR, DAGGR, TclPrecondition, Plan, CompositeInstruction, TclParallel, TclOneOf, TCBCall, FunctionCall, Send, Query, Param, KBQuery, KBQueryAll, KBUpdate, KBDelete, GetValue, EventActivation, InternalVariableScope, IfInstruction, AttributeValues, InternalVariableDefinition, If, ElseIf, Else
}