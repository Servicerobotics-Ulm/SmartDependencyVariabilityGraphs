package org.xtext.bb.generator 
import BbDvgTcl.MAGR
import java.util.List
import java.util.ArrayList
import BbDvgTcl.AGGR

class MAGRPattern {

	MAGR magr
	
	List<String> aggrName
	
	String code
	
	new (MAGR magr) {
		this.magr = magr
		this.aggrName = new ArrayList<String>()
		for (var int i = 0; i < this.magr.aggr.size; i++) {
			this.aggrName.add("resolve_"+this.magr.name+"_"+i)
		}
	}

	def generate () {
		this.code = ""
		code += generatePatternResolution()
		code += "\n"
		for (var int i = 0; i < this.magr.aggr.size; i++) {
			code += generateAggrResolution(this.magr.aggr.get(i), this.aggrName.get(i), this.magr.name)
			code += "\n"
		}
	}
	
	def private generatePatternResolution () {
		'''
		void resolve_«this.magr.name»(List<List<Node>> I) {
			«FOR i : 0..this.magr.aggr.size-1»
				«this.aggrName.get(i)»(I.get(«i»));
			«ENDFOR»
		}
		'''
	}
	
	def private generateAggrResolution (AGGR aggr, String aggrName, String magrName) {
		
		var String vsp = ""
		var String obj = ""
		
		if (Helpers.isComplexDo(aggr.op.ve)) {
			vsp = "vsp_2"
			obj = "List<Object>"	
		}
		else {
			vsp = "vsp"
			obj = "Object"
		}
		'''
		void «aggrName» (List<Node> I) {
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,«obj»>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,«obj»>>();
			«obj» newValue;
			List<List<Integer>> ir = new ArrayList<List<Integer>>();
			NodeObjectList nodeObjectList;
			for (int i = 0; i < I.size(); i++) {
				SimpleEntry<String, Integer> fid = new SimpleEntry<String, Integer>("«magrName»", i);
				for (int j = 0; j < I.get(i).«vsp»().size(); j++) {
					List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();
					List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();
					headerRow.add(fid);
					headerRow.add(new SimpleEntry<String, Integer>(I.get(i).name(), j));
					if (I.get(i).header(j) != null) {
						List<List<SimpleEntry<String,Integer>>> htmp = I.get(i).header(j);
						for (List<SimpleEntry<String,Integer>> row : htmp) {
							for (SimpleEntry<String,Integer> entry : row) {
								headerRow.add(entry);
							}
						}
					}
					header.add(headerRow);
					newValue = I.get(i).«vsp»(j);
					ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, «obj»>(header, newValue));
				}
			}
			
			«IF Helpers.isComplexDo(aggr.op.ve)»
				nodeObjectList = new NodeObjectList("«aggr.op.name»");
				nodeObjectList.assignVSP_2(ovsp);
				this.NODE_COLLECTION.put("«aggr.op.name»", nodeObjectList);
			«ELSE»
				this.NODE_COLLECTION.put("«aggr.op.name»", new NodeObject("«aggr.op.name»", ovsp));
			«ENDIF»
		}
		'''
	}
	
	def String getCode () {
		return this.code
	}
}