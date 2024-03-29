 /*
 * generated by Xtext 2.21.0
 */
package org.xtext.tcl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import BbDvgTcl.Behavior
import BbDvgTcl.TCB
import BbDvgTcl.Block
import BbDvgTcl.LispInstruction
import BbDvgTcl.EventActivation
import BbDvgTcl.EventMode
import BbDvgTcl.ReturnMessage
import BbDvgTcl.Success
import BbDvgTcl.EventHandler
import BbDvgTcl.ActionInstruction
import org.eclipse.emf.common.util.EList
import BbDvgTcl.Rule
import BbDvgTcl.ErrorRef
import BbDvgTcl.TclOneOf
import BbDvgTcl.TCBCall
import BbDvgTcl.Plan
import BbDvgTcl.Function
import BbDvgTcl.GenerationType
import BbDvgTcl.FunctionCall
import BbDvgTcl.Any
import org.eclipse.emf.ecore.EObject
import BbDvgTcl.TCBRef
import BbDvgTcl.SameSignatureTCBs
import BbDvgTcl.SameNameTCBs
import BbDvgTcl.AbstractTCB
import BbDvgTcl.Send
import BbDvgTcl.Query
import BbDvgTcl.Param
import BbDvgTcl.State
import BbDvgTcl.CompositeInstruction
import BbDvgTcl.VariableRef
import BbDvgTcl.TclParameter
import BbDvgTcl.InternalVariableScope
import BbDvgTcl.IfInstruction
import BbDvgTcl.GetValue
import BbDvgTcl.KBInteraction
import BbDvgTcl.KBQuery
import BbDvgTcl.KBQueryAll
import BbDvgTcl.KBUpdate
import BbDvgTcl.KBDelete
import BbDvgTcl.TclParallel
import java.util.List
import java.util.ArrayList
import BbDvgTcl.AttributeValues
import BbDvgTcl.InternalVariable
import java.util.Map
import java.util.HashMap
import BbDvgTcl.Abort
import BbDvgTcl.DeletePlan

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class TclGenerator extends AbstractGenerator {
	
	String behaviorName
	boolean module
	String moduleName
	
	Requirements req
	
	List<Function> provideFunctions
	Map<Function, List<String>> provideFunctionRequirementSpecifications
	List<TCB> provideTCBs
	List<TCB> configureTCBs
	
	boolean requiresSolver
		
	enum CurrentBlockType {
 	 	UNDEFINED,
 	 	TCB,
 	 	FUNCTION
	}
	
	CurrentBlockType cbt

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		
		this.requiresSolver = false
		this.cbt = CurrentBlockType.UNDEFINED
		this.module = false
		this.req = new Requirements()
		this.provideFunctions = new ArrayList<Function>()
		this.provideFunctionRequirementSpecifications = new HashMap<Function, List<String>>()
		this.provideTCBs = new ArrayList<TCB>()
		this.configureTCBs = new ArrayList<TCB>()
		
		for (i : resource.allContents.toIterable.filter(Behavior)) {
			for (j : i.import) {
				collectSolverInterfaceData(j.behavior)
			}
			collectSolverInterfaceData(i)
		}
		
		var String code = ""
		for (i : resource.allContents.toIterable.filter(Behavior)) {
			code += generateInitialKnowledge(i)
			code += "\n\n"
			code += root(i)
		}
		
		if (this.requiresSolver) {
			var String solverInterfaceCode = ""
			solverInterfaceCode += Helpers.generateWriteToFileFunction
			solverInterfaceCode += generateGetDataForSolver
			solverInterfaceCode += generateWriteDataForSolver
			solverInterfaceCode += generateExecuteSolver
			solverInterfaceCode += LispFunctions.generateReadDecodeAndWriteToKB
			fsa.generateFile("solverInterfaceCode.smartTcl", solverInterfaceCode);
		}
		
		fsa.generateFile(this.behaviorName+".smartTcl", code);
	}
	
	def collectSolverInterfaceData(Behavior b) {
		for (i : b.block) {
			if (i instanceof TCB) {
				if (i.provides !== null) {
					this.provideTCBs.add(i)
				}
				if (i.configures !== null) {
					this.configureTCBs.add(i)
				}
			}
			else if (i instanceof Function) {
				if (i.provides !== null) {
					this.provideFunctions.add(i)
				}
				for (j : i.input) {
					if (i.provides !== null && j.requirementspecification !== null) {
						// This function depends on requirement specification parameters that were commanded during runtime
						// we need to consider this when calling this function by passing a corresponding kb-query with 
						// the value of the corresponding requirement specification as input
						if (!this.provideFunctionRequirementSpecifications.containsKey(i)) {
							this.provideFunctionRequirementSpecifications.put(i, new ArrayList<String>())
						}
						var List<String> tmp = this.provideFunctionRequirementSpecifications.get(i)
						tmp.add(j.requirementspecification.name) 
						this.provideFunctionRequirementSpecifications.put(i, tmp)
					}
				}				
			}
		}
	}
	
	def String generateInitialKnowledge(Behavior b) {
		var StringBuilder code = new StringBuilder()
		if (b.initialknowledge !== null) {
			for (i : b.initialknowledge.kbupdate) {
				code.append("(tcl-kb-query :key '(is-a")
				for (j : i.keyattribute) {
					code.append(" ")
					code.append(j.attribute.name)		
				}	
				code.append(") :value `((is-a ")
				code.append(i.kbisagroup.name)
				code.append(")")
				for (j : i.attributevalues) {
					code.append("(")
					code.append(j.attribute.name)
					code.append(" ")
					code.append(getCompositeInstructionCode(j.compositeinstruction))
					code.append(")")			
				}				
				code.append(")")	
				code.append(")")
			}
		}
		return code.toString
	}
	
	def root (Behavior b) {
		this.behaviorName = b.name
		if (b.module !== null) {
			this.module = true
			this.moduleName = b.module.name
		}
		var StringBuilder code = new StringBuilder()
		for (i : b.block) {
			code.append(block(i))
		}
		return code.toString()
	}
	
	def String block (Block b) {
		var StringBuilder code = new StringBuilder()
		if (b.genType != GenerationType.IGNORE) {
			if (b instanceof TCB) {
				code.append(TCB(b))
			}
			else if (b instanceof EventHandler) {
				code.append(EventHandler(b))
			}
			else if (b instanceof Rule) {
				code.append(Rule(b))
			}
			else if (b instanceof Function) {
				code.append(Function(b))
			}
			else if (b instanceof SameSignatureTCBs) {
				for (i : b.tcb) {
					code.append(block(i))
				}
			}
			else if (b instanceof SameNameTCBs) {
				for (i : b.tcb) {
					code.append(block(i))
				}
			}			
		}
		return code.toString()
	}
	
	def String generateRequirementParameters() {
		var List<String> cr = this.req.constraintRequirements
		var List<String> pr = this.req.preferenceRequirements
		var String code = ""
		for (var int i = 0; i < cr.size; i++) {
			code += "?" +cr.get(i) +" "
		}
		for (var int i = 0; i < pr.size; i++) {
			code += "?" +pr.get(i) + " "
		}
		return code
	}
	
	def String generateWriteRequirementsForSolver() {
		// If it is a constraint (single value) we need to put it in a list
		// If it is a preference specification (wsm) we assume the weights are already passed as list
		var List<String> cr = this.req.constraintRequirements
		var List<String> pr = this.req.preferenceRequirements
		var String code = ""
		for (var int i = 0; i < cr.size; i++) {
			code += "(writeToFile '"+cr.get(i)+"(list ?"+cr.get(i)+"))"
		}
		for (var int i = 0; i < pr.size; i++) {
			code += "(writeToFile '"+cr.get(i)+" ?"+cr.get(i)+")"
		}
		return code
	}	
	
	def String TCB (TCB tcb) {
		
		this.cbt = CurrentBlockType.TCB
		
		if (tcb.requirementSpecification) {
			this.requiresSolver = true
		}
		
		'''
		(define-tcb («getName(tcb)»
		«FOR i : tcb.input»
			?«i.name» 
		«ENDFOR»
		«IF tcb.requirementSpecification && tcb.realizes !== null && this.req.determine(tcb.realizes)»
			«generateRequirementParameters»
		«ENDIF»
		«IF tcb.output.size > 0»
			=> 
			«FOR i : tcb.output»
				?«i.name» 
			«ENDFOR»
		«ENDIF»
		)
		
		«IF tcb.module !== null»
			(module "«tcb.module.name»")
		«ELSEIF this.module»
			(module "«this.moduleName»")
		«ENDIF»
		
		«IF tcb.rule.size > 0»
			(rules (
			«FOR i : tcb.rule»
				«i.name» 
			«ENDFOR»
			))	
		«ENDIF»
		
		«IF tcb.precondition !== null»
			(precondition «getCompositeInstructionCode(tcb.precondition.compositeinstruction)»)
		«ENDIF»
		
		«IF tcb.priority !== null»
			(priority «tcb.priority.value»)
		«ENDIF»
		«IF tcb.abortactioninstruction.size > 0»
			(abort-action (
			«FOR i : tcb.abortactioninstruction»
				«IF i instanceof LispInstruction»
					«i.str»
				«ENDIF»
			«ENDFOR»
			))
		«ENDIF»	
		
		(action (
			«IF tcb.requirementSpecification» 
			««« For this tcb requirements can be specified, i.e. before the childs are executed we need to:
			«««		1. Provide all the relevant data (also the requirement parameters of this tcb) for the 
			««« 	associated dvg model (external data from the viewpoint of the dvg model)
			«««		2. Execute the solver
			«««		3. Read and configure the determined configuration bindings
			««« We write each modeled input parameter of this TCB to the KB, in order that solver-interface-functions can take them into account
		(tcl-kb-update :key '(is-a) :value `((is-a requirementSpecification)
			«FOR i: tcb.input»
				(«i.name» ?«i.name»)
			«ENDFOR»
			))
			(if (probe-file "dataForSolver.txt")
				(delete-file "dataForSolver.txt")
			)
			(if (probe-file "dvgConfiguration.json")
				(delete-file "dvgConfiguration.json")
			)
			«generateWriteRequirementsForSolver»
			(tcl-push-plan :plan `((getDataForSolver)(writeDataForSolver)(executeSolver)(readDecodeAndWriteToKb ,(format nil "dvgConfiguration.json"))))
			«ENDIF»
			«ActionInstructions(tcb.actioninstruction, tcb, "TCB", false)»
		))
		
		«IF tcb.plan !== null»
			(plan (
				«FOR i : tcb.plan.callsequence»
					«IF i instanceof TCBCall»
						«TCBCall(i)»
					«ELSEIF i instanceof TclParallel»
						(parallel (
						«FOR j : i.tcbcall»
							«TCBCall(j)»
						«ENDFOR»
						))
					«ELSEIF i instanceof TclOneOf»
						(one-of (
						«FOR j : i.tcbcall»
							«TCBCall(j)»
						«ENDFOR»
						))
					«ENDIF»
				«ENDFOR»
			))
		«ENDIF»
		)
		'''
	}
		
	def String TCBCall(TCBCall tcbc) {
		
		var StringBuilder code = new StringBuilder()
		
		for (i : this.configureTCBs) {
			if (i.^for == tcbc.abstracttcb) {
				code.append("(")
				if (i.callPrefix !== null) {
					code.append(i.callPrefix)
					code.append(".")
				}
				code.append(i.name)
				code.append(" ,(get-value (tcl-kb-query :key '(is-a building-block instance-index variability-entity) :value `((is-a dvg-configuration)
                                         (building-block \""+tcbc.abstracttcb.realizes.name+"\")(instance-index "+tcbc.instance+")(variability-entity \""+i.configures.name+"\"))) 'value)")
				code.append(")\n")
			}
		}
		
		code.append("(")
		if (tcbc.prefix !== null) {
			code.append(tcbc.prefix.str)
			code.append(".")
		}
		
		code.append(getName(tcbc.abstracttcb))
		
		if (tcbc.compositeinstruction !== null) {
			code.append(" ")
			code.append(getCompositeInstructionCode(tcbc.compositeinstruction))
		}
		code.append(")")
		code.append("\n")
		return code.toString()
	}
	
	def String FunctionCall(FunctionCall fc) {
		var StringBuilder code = new StringBuilder()
		code.append("(")
		code.append(BlockName(fc.function))
		if (fc.compositeinstruction !== null) {
			code.append(" ")
			code.append(getCompositeInstructionCode(fc.compositeinstruction))
		}
		code.append(")")
		code.append("\n")
		return code.toString()
	}	
	
	def String ActionInstructions(EList<ActionInstruction> ail, Block b, String blockType, boolean ignore) {
		var StringBuilder code = new StringBuilder()
		
		if (!ignore) {
			code.append("(format t \"==================================>>> "+blockType+": "+BlockName(b)+" ~%\")")
			code.append("\n")
		}
		
		for (i : ail) {
			if (i instanceof LispInstruction) {
				code.append(i.str)
				code.append("\n")
			}
			else if (i instanceof EventActivation) {
				var StringBuilder eventCode = new StringBuilder()
				eventCode.append("(tcl-activate-event")
				eventCode.append(" ")
				eventCode.append(":name")
				eventCode.append(" '")
				eventCode.append(i.evtName)
				eventCode.append(" ")
				eventCode.append(":handler")
				eventCode.append(" '")
				eventCode.append(i.eventhandler.name)
				eventCode.append(" ")
				eventCode.append(":server")
				eventCode.append(" '")
				eventCode.append(i.server)
				eventCode.append(" ")
				eventCode.append(":service")
				eventCode.append(" '")
				eventCode.append(i.service)
				eventCode.append(" ")
				eventCode.append(":mode")
				eventCode.append(" ")
				if (i.eventMode == EventMode.SINGLE) {
					eventCode.append("'single")
				}
				else if (i.eventMode == EventMode.CONTINUOUS) {
					eventCode.append("'continuous")
				}
				if (i.compositeinstruction !== null) {
					eventCode.append(" ")
					eventCode.append(":param")
					eventCode.append(" ")
					eventCode.append(getCompositeInstructionCode(i.compositeinstruction))
				}
				eventCode.append(")")
				eventCode.append("\n")
				code.append(eventCode)
			}
			else if (i instanceof Send) {
				var StringBuilder sendCode = new StringBuilder()
				sendCode.append("(tcl-send")
				sendCode.append(" ")
				sendCode.append(":server")
				sendCode.append(" '")
				sendCode.append(i.server)
				sendCode.append(" ")
				sendCode.append(":service")
				sendCode.append(" '")
				sendCode.append(i.service)
				if (i.compositeinstruction !== null) {
					sendCode.append(" ")
					sendCode.append(":param")
					sendCode.append(" ")
					sendCode.append(getCompositeInstructionCode(i.compositeinstruction))
				}
				sendCode.append(")")
				sendCode.append("\n")
				code.append(sendCode)				
			}
			else if (i instanceof Query) {
				var StringBuilder queryCode = new StringBuilder()
				queryCode.append("(tcl-query")
				queryCode.append(" ")
				queryCode.append(":server")
				queryCode.append(" '")
				queryCode.append(i.server)
				queryCode.append(" ")
				queryCode.append(":service")
				queryCode.append(" '")
				queryCode.append(i.service)
				queryCode.append(" ")
				queryCode.append(":request")
				queryCode.append(" ")
				queryCode.append(getCompositeInstructionCode(i.compositeinstruction))
				queryCode.append(")")
				queryCode.append("\n")
				code.append(queryCode)				
			}	
			else if (i instanceof Param) {
				var StringBuilder paramCode = new StringBuilder()
				paramCode.append("(tcl-param")
				paramCode.append(" ")
				paramCode.append(":server")
				paramCode.append(" '")
				paramCode.append(i.server)
				paramCode.append(" ")
				paramCode.append(":slot")
				paramCode.append(" '")
				paramCode.append(i.slot)
				if (i.compositeinstruction !== null) {
					paramCode.append(" ")
					paramCode.append(":value")
					paramCode.append(" ")
					paramCode.append(getCompositeInstructionCode(i.compositeinstruction))
				}
				paramCode.append(")")
				paramCode.append("\n")
				code.append(paramCode)					
			}		
			else if (i instanceof State) {
				var StringBuilder stateCode = new StringBuilder()
				stateCode.append("(tcl-state")
				stateCode.append(" ")
				stateCode.append(":server")
				stateCode.append(" '")
				stateCode.append(i.server)
				stateCode.append(" ")
				stateCode.append(":state")
				stateCode.append(" \"")
				stateCode.append(i.state)
				stateCode.append("\"")
				stateCode.append(")")
				stateCode.append("\n")
				code.append(stateCode)				
			}	
			else if (i instanceof ReturnMessage) {
				if (i instanceof Success) {
					code.append("'(SUCCESS ())")
				}
				else if (i instanceof ErrorRef) {
					code.append("'")
					code.append(i.error.error)
				}
				code.append("\n")
			}
			else if (i instanceof Plan) {
				code.append("(tcl-push-plan :plan `(")
				for (j : i.callsequence) {
					if (j instanceof TCBCall) {
						code.append(TCBCall(j))
					}
					else if (j instanceof TclParallel) {
						code.append("(parallel (")
						for (k : j.tcbcall) {
							code.append(TCBCall(k))
						}
						code.append("))")
					}
					else if (j instanceof TclOneOf) {
						code.append("(one-of (")
						for (k : j.tcbcall) {
							code.append(TCBCall(k))
						}
						code.append("))")
					}				
				}
				code.append("))")					
			}
			else if (i instanceof FunctionCall) {
				code.append(FunctionCall(i))
			}
			else if (i instanceof InternalVariableScope) {
				code.append("(let* (")
				for (j : i.internalvariabledefinition) {
					code.append("(")
					code.append(j.internalvariable.name)
					code.append(" ")
					var EObject tmp = j.assignmentinstruction
					if (tmp instanceof CompositeInstruction) {
						code.append(getCompositeInstructionCode(tmp))
					}
					code.append(")")
					code.append("\n")
				}
				code.append(")")
				code.append("\n")
				code.append(ActionInstructions(i.actioninstruction, b, blockType, true))
				code.append(")")
			}
			else if (i instanceof IfInstruction) {
				code.append("(cond")
				code.append("\n")
				code.append("(")
				code.append(getCompositeInstructionCode(i.^if.compositeinstruction))
				code.append("\n")
				code.append(ActionInstructions(i.^if.actioninstruction, b, blockType, true))
				code.append("\n")
				code.append(")")
				code.append("\n")
				for (j : i.elseif) {
					code.append("(")
					code.append(getCompositeInstructionCode(j.compositeinstruction))
					code.append("\n")
					code.append(ActionInstructions(j.actioninstruction, b, blockType, true))
					code.append("\n")
					code.append(")")
					code.append("\n")			
				}
				if (i.^else !== null) {
					code.append("(T")
					code.append("\n")
					code.append(ActionInstructions(i.^else.actioninstruction, b, blockType, true))
					code.append("\n")
					code.append(")")
					code.append("\n")				
				}
				
				code.append(")")
			}
			else if (i instanceof VariableRef) {
				code.append(getVariableRefCode(i))
			}
			
			else if (i instanceof KBInteraction) {
				code.append(getKBInteraction(i))
			}
			
			else if (i instanceof GetValue) {
				code.append(getGetValue(i))
			}
			
			else if (i instanceof Abort) { 
				code.append("(tcl-abort)")
			}
			else if (i instanceof DeletePlan) {
				code.append("(tcl-delete-plan)")
			}
			
			code.append("\n")
		}
		code.append("\n")

		return code.toString()		
	}
	
	def String EventHandler (EventHandler eh) {
		var StringBuilder code = new StringBuilder()
		code.append("(define-event-handler (")
		code.append(BlockName(eh))
		code.append(")")
		code.append("\n")
		code.append("(action (")
		code.append("\n")
		code.append(ActionInstructions(eh.actioninstruction, eh, "HANDLER", false))
		code.append("))")
		code.append(")") // closes handler
		code.append("\n\n")
		return code.toString()
	}
	
	def String Rule (Rule r) {
		var StringBuilder code = new StringBuilder()
		code.append("(define-rule (")
		code.append(BlockName(r))
		code.append(")")
		code.append("\n")
		code.append("(tcb (")
		var EObject tmp = r.linkagetype
		if (tmp instanceof Any) {
			code.append("ANY-TCB")
		}
		else if (tmp instanceof TCBRef) {
			code.append(tmp.abstracttcb.name)
			for (i : tmp.abstracttcb.input) {
				code.append(" ")
				code.append("?")
				code.append(i.name)
			}
			if (tmp.abstracttcb.output.size > 0) {
				code.append(" ")
				code.append("=>")
				for (i : tmp.abstracttcb.output) {
					code.append(" ")
					code.append("?")
					code.append(i.name)
				}
			}
		}
		code.append("))")
		code.append("\n")
		code.append("(return-value (ERROR (")
		code.append(r.error.error)
		code.append(")))")
		code.append("\n")
		code.append("(action (")
		code.append("\n")
		code.append(ActionInstructions(r.actioninstruction, r, "RULE", false))
		code.append("))")
		code.append(")") // closes rule
		code.append("\n\n")
		return code.toString()
	}
		
	def String Function (Function f) {
		
		this.cbt = CurrentBlockType.FUNCTION
		
		var StringBuilder code = new StringBuilder()
		code.append("(defun")
		code.append(" ")
		code.append(BlockName(f))
		code.append(" ")
		code.append("(")
		for (i : f.input) {
			code.append(i.name)
			code.append(" ")
		}
		code.append(")")
		code.append("\n")		
		code.append(ActionInstructions(f.actioninstruction, f, "FUNCTION", false))
		code.append(")") // closes function
		code.append("\n\n")
		return code.toString()
	}
	
	def String BlockName (Block b) {
		var String code = ""
		if (b.genType == GenerationType.NAME) {
			code = b.name
		}
		else if (b.genType == GenerationType.EXTERNALNAME || b.genType == GenerationType.IGNORE) {
			code = b.externalName
		}
		
		return code
	}
	
	def String getName (AbstractTCB at) {
		var String bName = BlockName(at)
		var StringBuilder modifiedName = new StringBuilder()
		if (at instanceof TCB) {
			if (at.subname !== null) {
				if (at.eContainer instanceof SameNameTCBs && at.name.indexOf("_") != -1) {
					var String[] name
					name = at.name.split("_")
					modifiedName.append(name.get(0))
					modifiedName.append(" ")
					modifiedName.append("'")
					modifiedName.append(at.subname.name)
				}
				else {
					modifiedName.append(bName)
					modifiedName.append(" ")
					modifiedName.append("'")
					modifiedName.append(at.subname.name)
				}
				
				return modifiedName.toString()
			}
			else {
				return bName
			}	
		}
		else {
			return bName
		}				
	}
	
	def String getCompositeInstructionCode (CompositeInstruction ci) {
		var StringBuilder code = new StringBuilder()
		
		for (i : ci.abstractcompositeinstruction) {
			if (i instanceof LispInstruction) {
				code.append(i.str)
			}
			else if (i instanceof VariableRef) {
				code.append(getVariableRefCode(i))
			}
			else if (i instanceof GetValue) {
				code.append(getGetValue(i))
			}
			else if (i instanceof KBInteraction) {
				code.append(getKBInteraction(i))
			}
			
			code.append(" ")
		}
		return code.toString()
	}
	
	def String getVariableRefCode (VariableRef vr) {
		var StringBuilder code = new StringBuilder()
		if (vr.variable instanceof TclParameter && this.cbt == CurrentBlockType.TCB) {
			code.append("?")
		}
		else if (vr.variable instanceof TclParameter && this.cbt == CurrentBlockType.FUNCTION && (vr.eContainer.eContainer instanceof AttributeValues)) {
			code.append(",")
		}		
		else if (vr.variable instanceof InternalVariable && (vr.eContainer.eContainer instanceof AttributeValues || vr.eContainer.eContainer instanceof TCBCall)) {
			code.append(",")
		}
		code.append(vr.variable.name)
		return code.toString()
	}
	
	def String getGetValue (GetValue gv) {
		var StringBuilder code = new StringBuilder()
		code.append("(get-value ")
		code.append(getCompositeInstructionCode(gv.compositeinstruction))
		code.append(" '")
		code.append(gv.attribute.name)
		code.append(")")
		return code.toString()
	}
	
	def String getKBInteraction (KBInteraction kbi) {
		var StringBuilder code = new StringBuilder()
		if (kbi instanceof KBQuery) {
			code.append("(tcl-kb-query ")
		}
		else if (kbi instanceof KBQueryAll) {
			code.append("(tcl-kb-query-all ")
		}
		else if (kbi instanceof KBUpdate) {
			code.append("(tcl-kb-update ")
		}
		else if (kbi instanceof KBDelete) {
			code.append("(tcl-kb-delete ")	
		}
		code.append(":key '")
		code.append("(is-a")
		if (kbi instanceof KBUpdate) {
			for (i : kbi.keyattribute) {
				code.append(" ")
				code.append(i.attribute.name)		
			}	
		}
		else {
			for (i : kbi.attributevalues) {
				code.append(" ")
				code.append(i.attribute.name)		
			}
		}
		code.append(")")
		code.append(" :value `(")
		code.append("(is-a ")
		code.append(kbi.kbisagroup.name)
		code.append(")")
		for (i : kbi.attributevalues) {
			code.append("(")
			code.append(i.attribute.name)
			code.append(" ")
			code.append(getCompositeInstructionCode(i.compositeinstruction))
			code.append(")")			
		}
		code.append(")")
		code.append(")")
		return code.toString()
	}
	
	def generateGetDataForSolver() {
		'''
		(define-tcb (getDataForSolver)
			(action (
				(tcl-push-back-plan :plan 
					`(
						«FOR i : this.provideTCBs»
							(«i.name»)
						«ENDFOR»
					 )
				)
			))
		)
		'''
	}
	
	def generateWriteDataForSolver() {
		'''
		(define-tcb (writeDataForSolver)
			(action (
			«FOR i : this.provideFunctions»
				«generateProvideFunctionCall(i)»
			«ENDFOR»
			))
		)
		'''
	}
	
	def generateProvideFunctionCall(Function f) {
		'''
		«IF !this.provideFunctionRequirementSpecifications.containsKey(f)»
		(writeToFile '«f.provides.name» («f.name»))
		«ELSE»
		(writeToFile '«f.provides.name» («f.name» 
			«FOR i : this.provideFunctionRequirementSpecifications.get(f)»
			(get-value (tcl-kb-query :key '(is-a) :value `((is-a requirementSpecification))
			           )
			'«i»
			)
			«ENDFOR»
		))
		«ENDIF»
		'''
	}
	
	def generateExecuteSolver() {
		'''
		(define-tcb (executeSolver)
			(action (
				(uiop:run-program "java DVGSolver_«this.req.DVGName»")
			))
		)
		'''
	}
}
