package org.xtext.bb.generator

import java.util.List
import java.util.regex.Pattern
import java.util.regex.Matcher
import java.util.ArrayList
import BbDvgTcl.VariabilityEntity
import dor.TypeDef
import BbDvgTcl.PortElement
import BbDvgTcl.AbstractInputPort
import BbDvgTcl.InternalOutputPort
import BbDvgTcl.InternalInputPort
import BbDvgTcl.InputPort
import BbDvgTcl.InputCPort
import BbDvgTcl.InputWSMPort
import BbDvgTcl.RT
import dor.StringDef
import dor.BoolDef
import dor.IntegerDef
import dor.RealDef
import BbDvgTcl.AbstractInitPort
import BbDvgTcl.InitPort
import org.eclipse.emf.ecore.EObject
import vi.BoolVSPInit
import vi.IntegerVSPInit
import vi.RealVSPInit
import vi.StringVSPInit
import vi.ComplexVSPInit
import BbDvgTcl.InitCPort
import BbDvgTcl.AbstractOutputPort
import BbDvgTcl.AGGR
import BbDvgTcl.MAGR
import BbDvgTcl.InternalPortRef
import BbDvgTcl.DAGGR
import BbDvgTcl.DMAGR
import BbDvgTcl.INIT
import BbDvgTcl.BBContainer
import BbDvgTcl.SAPRO
import BbDvgTcl.DVG
import vi.Bool
import BbDvgTcl.ComparisonCOp
import BbDvgTcl.LessThan
import BbDvgTcl.GreaterThan
import BbDvgTcl.Equal
import BbDvgTcl.RPRO
import BbDvgTcl.APRO
import BbDvgTcl.COMF
import BbDvgTcl.BuildingBlock
import java.util.Map
import BbDvgTcl.FinalOperation
import BbDvgTcl.Container
import dor.ElementRelationship

class Helpers {
	
	static def int getVSPInitSize(AbstractInitPort in) {
		
		if (in instanceof InitPort) {
			var EObject tmp = in.vi
			if (tmp instanceof BoolVSPInit) {
				return tmp.vsp.size
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					return tmp.irg.number
				}
				else {
					return tmp.vsp.size
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					return tmp.rrg.number
				}
				else {
					return tmp.vsp.size
				}
			}
			else if (tmp instanceof StringVSPInit) {
				return tmp.vsp.size
			}
			
			else if (tmp instanceof ComplexVSPInit) {
				return tmp.vi.size
			}
		}
		
		else if (in instanceof InitCPort) {
			var EObject tmp = in.vi
			if (tmp instanceof BoolVSPInit) {
				return tmp.vsp.size
			}
			else if (tmp instanceof IntegerVSPInit) {
				if (tmp.irg !== null) {
					return tmp.irg.number
				}
				else {
					return tmp.vsp.size
				}
			}	
			else if (tmp instanceof RealVSPInit) {
				if (tmp.rrg !== null) {
					return tmp.rrg.number
				}
				else {
					return tmp.vsp.size
				}
			}
			else if (tmp instanceof StringVSPInit) {
				return tmp.vsp.size
			}
			else if (tmp instanceof ComplexVSPInit) {
				return tmp.vi.size
			}
		}
		
	}

def static List<String> getSymbolsForMinOperators(String expr) {
		var Pattern p = Pattern.compile("(\\$MIN\\([a-zA-Z0-9_]*\\)\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
			var String tmp = m.group().substring(5,m.group().length()-2);
		  	matches.add(tmp);
		}
		return matches
	}
	
	def static List<String> getSymbolsForMaxOperators(String expr) {
		var Pattern p = Pattern.compile("(\\$MAX\\([a-zA-Z0-9_]*\\)\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
			var String tmp = m.group().substring(5,m.group().length()-2);
		  	matches.add(tmp);
		}
		return matches
	}
	
	def static List<String> getSymbolsForComplexDo(String expr) {
		var Pattern p = Pattern.compile("(\\$[a-zA-Z0-9_\\[]*\\]\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
			//System.out.println("match: "+m.group())
			var String tmp = "";
			var int c = 1;
			while (m.group().codePointAt(c) != 91) { // 91 = "["
				//System.out.println("ca: "+ m.group().charAt(c));
				tmp += m.group().charAt(c);
				c++;
				//System.out.println("tmp: "+ tmp);
			}
		  	matches.add(tmp);
		}
		return matches
	}
	
	def static int getTh(String name, List<BbDvgTcl.AbstractInputPort> inputSet) {
		var int cnt = 0
		for (i : inputSet) {
			//System.out.println(name+" : "+i.name)
			if (name == i.name) {
				return cnt
			}
			cnt++
		}
		return -1
	}
	
	def static BbDvgTcl.AbstractInputPort getNode(String name, List<BbDvgTcl.AbstractInputPort> inputSet) {
		for (i : inputSet) {
			//System.out.println(name+" : "+i.name)
			if (name == i.name) {
				return i
			}
		}
		return null
	}
	
	def static boolean isComplexDo(VariabilityEntity ve) {
		
		if (ve.dor !== null) {
			if (ve.dor.er === ElementRelationship.XOR) {
				return false
			}
			if (ve.dor.ed.size() > 1 || ve.dor.ed.get(0).td.cardinality == "*") {
				return true
			}
		}
		else if (ve.doc !== null) {
			if (ve.doc.er === ElementRelationship.XOR) {
				return false
			}			
			if (ve.doc.ed.size() > 1 || ve.doc.ed.get(0).td.cardinality == "*") {
				return true
			}
		}	
		
		return false
	}
	
	def static TypeDef getTypeFromVe(VariabilityEntity ve) {
		
		if (ve instanceof PortElement) {
			return ve.e.td
		}
		else {
			if (ve.dor !== null) {
				return ve.dor.ed.get(0).td	
			}
			else if (ve.doc !== null) {
				return ve.doc.ed.get(0).td	
			}
		}
	}
	
	// VT = CONSTANT if all Inputs are CONSTANT
	// VT = ACTIVE if at least one Input is ACTIVE
	// VT = PASSIVE else
	def BbDvgTcl.VT getOutputVTFromInputs(List<AbstractInputPort> inl) {
		
		var List<BbDvgTcl.VT> VTList = new ArrayList<BbDvgTcl.VT>()
		
		for (i : inl) {
			if (inl instanceof InputPort) {
				VTList.add(inl.outputport.vt)
			}
			else if (inl instanceof InternalInputPort) {
				var InternalPortRef tmp = inl.internalportref
				if (tmp instanceof InputPort) {
					VTList.add(tmp.outputport.vt)
				}
				else if (tmp instanceof InternalOutputPort) {
					VTList.add(tmp.vt)
				}
			}
			else if (inl instanceof InputCPort) {
				VTList.add(inl.outputcport.vt)
			}
			else if (inl instanceof InputWSMPort) {
				VTList.add(inl.outputwsmport.vt)
			}
		}
		
		var int numberConstant = 0
		var int numberActive = 0
		
		for (i : VTList) {
			if (i == BbDvgTcl.VT.CONSTANT) {
				numberConstant++
			}
			if (i == BbDvgTcl.VT.ACTIVE) {
				numberActive++
			}
		}
		
		if (numberActive > 0) {
			return BbDvgTcl.VT.ACTIVE
		}
		else if (numberConstant == inl.size()) {
			return BbDvgTcl.VT.CONSTANT
		}
		else {
			return BbDvgTcl.VT.PASSIVE
		}
	}
	
def static String generateExpressionCode(String name, String expr, List<BbDvgTcl.AbstractInputPort> inputSet) {
		
		var String modifiedExpr = expr
		
		var Pattern p = Pattern.compile("(\\$[a-zA-Z0-9_\\[\\]]*\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
		  	matches.add(m.group());
		}
		
		// matches represents the order of the $*$ patterns in expr
		// get i-th input of each expr as stored in the inputSet
		
		var String escaped
		
		for (i : matches) {
			//System.out.println("MATCH: "+i)
			var int index = getTh(i.substring(1,i.length()-1), inputSet)
			var BbDvgTcl.AbstractInputPort node = getNode(i.substring(1,i.length()-1), inputSet)
			//System.out.println("Index: "+index)
			// Replace $i$ with "inputSet.get("index")"
			escaped = "\\"+i.substring(0,i.length()-1)+"\\$"
			//System.out.println("escaped: "+escaped)
			if (index == -1 && escaped == "\\$OUT\\$") {
				modifiedExpr = modifiedExpr.replaceAll(escaped, "OUT")
			}
			else if (node instanceof BbDvgTcl.InputPort) {
				
				if (!isComplexDo(node.outputport.ve)) {
					
					//System.out.println("standard: mod expr: "+ modifiedExpr)
					//System.out.println("escaped: "+escaped)
				
					if (node.outputport.rt == RT.RELATIVE || (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof RealDef)) {
						modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) valueList.get("+index.toString+")).doubleValue()")
					}
					else if (node.outputport.rt == RT.ABSOLUTE && (getTypeFromVe(node.outputport.ve) instanceof IntegerDef || getTypeFromVe(node.outputport.ve) === null)) {
						modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) valueList.get("+index.toString+")).intValue()")
					}
					else if (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof BoolDef) {
						modifiedExpr = modifiedExpr.replaceAll(escaped, "((Boolean) valueList.get("+index.toString+")).booleanValue()")
					}
					else if (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof StringDef) {
						modifiedExpr = modifiedExpr.replaceAll(escaped, "valueList.get("+index.toString+").toString()")
					}
					
					//System.out.println("standard: mod expr: "+ modifiedExpr)
				}
				
				else {
					// This seems to be complex do.size
					//System.out.println("This seems to be complex do.size: " + escaped)
					modifiedExpr = modifiedExpr.replaceAll(escaped, escaped.substring(2,escaped.length()-2))
					
				}			
			}
			else {
				// Check if it is a Complex Do
				// We assume only reals and index access [index]
				// Replace $name[i]$ with ((Number) name.get(i)).doubleValue() 
				//modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) valueList.get("+index.toString+")).doubleValue()")
				
				if (i.substring(i.length()-2, i.length()-1) == "]") {
					//System.out.println("escaped: "+escaped)
					//System.out.println("escaped (quote): "+Pattern.quote(escaped))
					
					var int c = i.length()-2
					
					var String istr = ""
					
					while (i.substring(c-1,c) != "[") {
						//System.out.println("char: " + i.substring(c-1,c))
						istr += i.substring(c-1,c)
						c--
					}
					
					var String olds = ""
					c = 0
					var int num = 0
					while (escaped.substring(c,c+1) != "[") {
						//System.out.println("char: " + i.substring(c-1,c))
						olds += escaped.substring(c,c+1)
						c++
						num++
					}
					
					escaped = olds + "\\[" + new StringBuilder(istr).reverse().toString() + "\\]\\$"
					var String nodename = escaped.substring(2,num)
					
					//System.out.println("new escaped: " + escaped)
					//System.out.println("num: " + num)
					//System.out.println("Name of the Node: " + nodename)
					 
				
					modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) "+nodename+".get("+new StringBuilder(istr).reverse().toString()+")).doubleValue()")						
				}
				else {
					System.err.println("Error in parsing Expression!")
				}				
			}
			//System.out.println("modexpr: "+modifiedExpr)
		}
		
		p = Pattern.compile("(\\$MIN\\([a-zA-Z0-9_]*\\)\\$)");
		m = p.matcher(modifiedExpr);
		matches = new ArrayList<String>();
		
		while (m.find()) {
		  	matches.add(m.group());
		}
		
		for (i : matches) {
			modifiedExpr = modifiedExpr.replaceAll(Pattern.quote(i), "min_"+i.substring(5,i.length()-2))
		}
		
		p = Pattern.compile("(\\$MAX\\([a-zA-Z0-9_]*\\)\\$)");
		m = p.matcher(modifiedExpr);
		matches = new ArrayList<String>();
		
		while (m.find()) {
		  	matches.add(m.group());
		}
		
		for (i : matches) {
			modifiedExpr = modifiedExpr.replaceAll(Pattern.quote(i), "max_"+i.substring(5,i.length()-2))
		}
		
		var StringBuilder code = new StringBuilder()
		
		code.append("\n\t\t")
		code.append(modifiedExpr)
		code.append("\n\t\t")
		code.append("return OUT;")

		return code.toString
	}
	
	def static String generateExpressionCodePs(String name, String expr, List<BbDvgTcl.AbstractInputPort> inputSet) {
		
		// define xtend List<String> lis
		// parse $OUT.<Name>
		// <Name> is name of referenced Output Port of a Input Port of the corresponding CONT Pattern
		// Replace $OUT.<Name> with <Name>
		
		// xtend: lis.add("<Name>",Name)
		
		// ....
		
		
		// for lis
			// internal: map.put(lis) 
		
		
		var String modifiedExpr = expr
		
		var Pattern p = Pattern.compile("(\\$[a-zA-Z0-9_]*\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
		  	matches.add(m.group());
		}
		
		// matches represents the order of the $*$ patterns in expr
		// get i-th input of each expr as stored in the inputSet
		
		var String escaped
		
		for (i : matches) {
			//System.out.println("MATCH: "+i)
			var int index = getTh(i.substring(1,i.length()-1), inputSet)
			var BbDvgTcl.AbstractInputPort node = getNode(i.substring(1,i.length()-1), inputSet)
			//System.out.println("Index: "+index)
			// Replace $i$ with "inputSet.get("index")"
			escaped = "\\"+i.substring(0,i.length()-1)+"\\$"
			//System.out.println("escaped: "+escaped)
			if (index == -1 && escaped == "\\$OUT\\$") {
				modifiedExpr = modifiedExpr.replaceAll(escaped, "OUT")
			}
			else if (node instanceof BbDvgTcl.InputPort) {
				if (node.outputport.rt == RT.RELATIVE || (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof RealDef)) {
					modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) valueList.get("+index.toString+")).doubleValue()")
				}
				else if (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof IntegerDef) {
					modifiedExpr = modifiedExpr.replaceAll(escaped, "((Number) valueList.get("+index.toString+")).intValue()")
				}
				else if (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof BoolDef) {
					modifiedExpr = modifiedExpr.replaceAll(escaped, "((Boolean) valueList.get("+index.toString+")).booleanValue()")
				}
				else if (node.outputport.rt == RT.ABSOLUTE && getTypeFromVe(node.outputport.ve) instanceof StringDef) {
					modifiedExpr = modifiedExpr.replaceAll(escaped, "valueList.get("+index.toString+").toString()")
				}			
			}
			//System.out.println("modexpr: "+modifiedExpr)
		}
		
		var List<String> lis = new ArrayList<String>()
		
		p = Pattern.compile("(\\$OUT.[a-zA-Z0-9_]*\\$)");
		m = p.matcher(modifiedExpr);
		matches = new ArrayList<String>();
		
		while (m.find()) {
		  	matches.add(m.group());
		}
		
		for (i : matches) {
			modifiedExpr = modifiedExpr.replaceAll(Pattern.quote(i), i.substring(5,i.length()-1))
			lis.add(i.substring(5,i.length()-1))
		}
		
		var StringBuilder code = new StringBuilder()
		code.append("Map<String,Double> outMap = new HashMap<String,Double>();")
		code.append("\n\t\t")
		code.append(modifiedExpr)
		for (i : lis) {
			code.append("outMap.put(\""+i+"\","+i+");")
			code.append("\n\t\t")
		}
		code.append("\n\t\t")
		code.append("return outMap;")

		return code.toString
	}	
	
	static def boolean isSAM(List<String> sl) {
		var List<String> sln = new ArrayList<String>()
		
		for (i : sl) {
			if (!sln.contains(i)) {
				sln.add(i)
			}
			else {
				return true
			}
		}
		return false
	}
	
	static def BbDvgTcl.Pattern getPattern(AbstractOutputPort aon) {
		
		var EObject obj = aon.eContainer
		if (obj instanceof BbDvgTcl.Pattern) {
			//System.out.println(obj + " is Pattern")
			return obj	
		}
		else if (obj instanceof AGGR) {
			obj = obj.eContainer
			if (obj instanceof MAGR) {
				return obj
			}
		}
		else if (obj instanceof DAGGR) {
			obj = obj.eContainer
			if (obj instanceof DMAGR) {
				return obj
			}			
		}
	}
	
	def boolean isDaggr(AbstractOutputPort aon) {
		
		var EObject obj = aon.eContainer
		if (obj instanceof DAGGR) {
			return true	
		}
		else {
			return false
		}
	}	
	
	def BbDvgTcl.DVG getDVG(BbDvgTcl.Pattern p) {
		
		var EObject obj = p.eContainer
		if (obj instanceof BbDvgTcl.DVG) {
			return obj	
		}
	}
	
	static def AGGR getAGGR(AbstractOutputPort aon) {
		
		var EObject obj = aon.eContainer
		if (obj instanceof AGGR) {
			//System.out.println(obj + " is Aggregation")
			return obj	
		}
	}

	def DAGGR getDAGGR(AbstractOutputPort aon) {
		
		var EObject obj = aon.eContainer
		if (obj instanceof DAGGR) {
			//System.out.println(obj + " is Aggregation")
			return obj	
		}
	}
	
	static def VariabilityEntity getVeFromPattern(BbDvgTcl.Pattern pattern) {
		if (pattern instanceof INIT) {
			return pattern.ainip.ve
		}
		return null
	}
	
	static def int getResGroupOfPattern(BbDvgTcl.Pattern p) {
		var EObject bbc = p.eContainer
		if (bbc instanceof BBContainer) {
			if (bbc.container !== null) {
				if (bbc.container.resourcegroupid !== null) {
					println("return resourcegroupid: " + bbc.container.resourcegroupid)
					return bbc.container.resourcegroupid.number
				}
				else {
					println("ERROR: No resourcegroupid!")
					return -1
				}
			}
			else {
				println("ERROR No Container ref!")
				return -1
			}
		}
		else {
			return -1
		}
	}
	
	def ExternalInformation getExternalInformation(BbDvgTcl.Pattern p) {
		// TODO: Implement other patterns
		var List<String> dvgs = new ArrayList<String>()
		var List<String> outputs = new ArrayList<String>()
		var String oName
		if (p instanceof SAPRO) {
			oName = p.op.name
			for (i : p.ip) {
				var EObject tmp = getPattern(i.outputport)
				outputs.add(i.outputport.name)
				tmp = tmp.eContainer
				if (tmp instanceof DVG) {
					dvgs.add(tmp.name) // We assume all inputs are external ones!
				}
			}
		}
		var ExternalInformation ei = new ExternalInformation()
		ei.pName = p.name
		ei.oName = oName
		ei.dvgs = dvgs
		ei.outputs = outputs
		return ei
	}
	
	static def List<String> getWrapperAndConversionName(TypeDef td) {
		var List<String> names = new ArrayList<String>(2)
		if (td instanceof BoolDef) {
			names.add("Boolean")
			names.add("booleanValue")
		}
		else if (td instanceof IntegerDef) {
			names.add("Integer")
			names.add("intValue")
		}
		else if (td instanceof RealDef) {
			names.add("Double")
			names.add("doubleValue")
		}
		else if (td instanceof StringDef) {
			names.add("String")
			names.add("toString")
		}
		else {
			System.err.println("getConversionName(TypeDef): Wrong type!")
		}
		return names
	}
	
	static def String getComparisonString(ComparisonCOp cop) {
		var String c
		if (cop instanceof LessThan) {
			if (cop.inclusive) {
				c = "<="
			}
			else {
				c = "<"
			}
		}
		else if (cop instanceof GreaterThan) {
			if (cop.inclusive) {
				c = ">="
			}
			else {
				c = ">"
			}	
		}
		else if (cop instanceof Equal) {
			if (cop.accuracy === null) {
				if (cop.inverse) {
					c = "!="
				}
				else {
					c = "=="
				}
			}
			else {
				if (cop.inverse) {
					c = "> "+cop.accuracy
				}
				else {
					c = "< " +cop.accuracy
				}	
			}
		}
		else {
			System.err.println("getComparisonString(ComparisonCOp): Wrong type!")
		}
		return c
	}
	
	static def String GetBBFromVE(VariabilityEntity ve) {
		var EObject tmp = ve.eContainer.eContainer.eContainer
		if (tmp instanceof BuildingBlock) {
			return tmp.name
		}
		else {
			System.err.println("GetBBFromVE(VariabilityEntity): This should not happen!")
			return null
		}
	}
	
	static def boolean GetFinalOperationIsMax(FinalOperation fo) {
		if (fo !== null) {
			if (fo == FinalOperation.MAX) {
				return true
			}
			else {
				return false
			}
		}
		else {
			return true
		}
	}

}

class ExternalInformation {
	public String pName
	public String oName
	public List<String> dvgs
	public List<String> outputs
}
