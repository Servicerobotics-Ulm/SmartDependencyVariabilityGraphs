package org.xtext.bb.generator 
import java.util.List
import java.util.ArrayList
import java.util.regex.Pattern
import java.util.regex.Matcher

class MinMaxCode {
	StringBuilder minMaxCodeForPatternResolution
	StringBuilder minMaxCodeForValueFunctionDefinition
	StringBuilder minMaxCodeForValueFunctionCall
	
	List<BbDvgTcl.AbstractInputPort> inputSet
	String expr
	
	new (List<BbDvgTcl.AbstractInputPort> inputSet, String expr) {
		this.inputSet = inputSet
		this.expr = expr
		this.minMaxCodeForPatternResolution = new StringBuilder()
		this.minMaxCodeForValueFunctionDefinition = new StringBuilder()
		this.minMaxCodeForValueFunctionCall = new StringBuilder()
	}
	
	def generateCode () {

		var List<String> processedMin = new ArrayList<String>()
		var List<String> processedMax = new ArrayList<String>()
		this.minMaxCodeForPatternResolution.append("List<Object> vtmp;")
		this.minMaxCodeForPatternResolution.append("\n\t")
		
		var List<String> tmp = getSymbolsForMinOperators(this.expr)
		for (i : tmp) {
			if (!processedMin.contains(i)) {
				var int index = Helpers.getTh(i, inputSet)
				this.minMaxCodeForPatternResolution.append("vtmp = I.get("+index+").values();")
				this.minMaxCodeForPatternResolution.append("\n\t")
				this.minMaxCodeForPatternResolution.append("double min_"+i+" = min(vtmp);")
				this.minMaxCodeForPatternResolution.append("\n\t")
				this.minMaxCodeForValueFunctionDefinition.append(", double min_"+i)
				this.minMaxCodeForValueFunctionCall.append(",min_"+i)
				processedMin.add(i)
			}
		}
		tmp = getSymbolsForMaxOperators(this.expr)
		for (i : tmp) {
			if (!processedMax.contains(i)) {
				var int index = Helpers.getTh(i, inputSet)
				this.minMaxCodeForPatternResolution.append("vtmp = I.get("+index+").values();")
				this.minMaxCodeForPatternResolution.append("\n\t")
				this.minMaxCodeForPatternResolution.append("double max_"+i+" = max(vtmp);")
				this.minMaxCodeForPatternResolution.append("\n\t")
				this.minMaxCodeForValueFunctionDefinition.append(", double max_"+i)
				this.minMaxCodeForValueFunctionCall.append(",max_"+i)
				processedMax.add(i)
			}
		}
	}
	
	def List<String> getSymbolsForMinOperators(String expr) {
		var Pattern p = Pattern.compile("(\\$MIN\\([a-zA-Z0-9_]*\\)\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
			var String tmp = m.group().substring(5,m.group().length()-2);
		  	matches.add(tmp);
		}
		return matches
	}
	
	def List<String> getSymbolsForMaxOperators(String expr) {
		var Pattern p = Pattern.compile("(\\$MAX\\([a-zA-Z0-9_]*\\)\\$)");
		var Matcher m = p.matcher(expr);
		var List<String> matches = new ArrayList<String>();
		while (m.find()) {
			var String tmp = m.group().substring(5,m.group().length()-2);
		  	matches.add(tmp);
		}
		return matches
	}
	
	def String getMinMaxCodeForPatternResolution () {
		return this.minMaxCodeForPatternResolution.toString()
	}
	
	def String getMinMaxCodeForValueFunctionDefinition () {
		return this.minMaxCodeForValueFunctionDefinition.toString()
	}
	
	def String getMinMaxCodeForValueFunctionCall () {
		return this.minMaxCodeForValueFunctionCall.toString()
	}
}