package org.xtext.bb.generator

class Node {
	
	static def generateNodeClassCode() {
		'''
		class Node<T> {
			private String name;
			private List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>> vsp;
			private List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>> vsp_2;
			public Node(String name) {
				this.name = name;
			}
			public Node(String name, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>> vsp) {
				this.name = name;
				this.vsp = vsp;
			}
			public String name() {
				return this.name;
			}
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>> vsp() {
				return this.vsp;
			}
			List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>> vsp_2() {
				return this.vsp_2;
			}
			T vsp(int slotIndex) {
				return this.vsp.get(slotIndex).getValue();
			}
			List<T> vsp_2(int slotIndex) {
				return this.vsp_2.get(slotIndex).getValue();
			}
			SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T> slot(int slotIndex) {
				return this.vsp.get(slotIndex);
			}
			SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>> slot_2(int slotIndex) {
				return this.vsp_2.get(slotIndex);
			}
			List<List<SimpleEntry<String,Integer>>> header(int slotIndex) {
				if (this instanceof NodeObjectList) {
					return this.vsp_2.get(slotIndex).getKey();
				}
				else {
					return this.vsp.get(slotIndex).getKey();
				}
			}

			public List<List<SimpleEntry<String,Integer>>> initUniqueResourceIdHeader(int id) {
				List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();
				List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();
				SimpleEntry<String,Integer> pair = new SimpleEntry<String,Integer>("UNIQUE_RESOURCE_ID", id);
				headerRow.add(pair);
				header.add(headerRow);
				return header;
			}
			
			public void initLeaf(List<T> leafValues) {
				this.vsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>>();
				for (int i = 0; i < leafValues.size(); i++) {
					this.vsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>(null,leafValues.get(i)));
				}
			}
			
			public void initLeaf_2(List<List<T>> leafValues) {
				this.vsp_2 = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>>();
				for (int i = 0; i < leafValues.size(); i++) {
					this.vsp_2.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>(null,leafValues.get(i)));
				}
			}
			
			public void initLeaf(List<T> leafValues, int id) {
				this.vsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>>();
				for (int i = 0; i < leafValues.size(); i++) {
					this.vsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,T>(initUniqueResourceIdHeader(id),leafValues.get(i)));
				}
			}
			public void initLeaf_2(List<List<T>> leafValues, int id) {
				this.vsp_2 = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>>();
				for (int i = 0; i < leafValues.size(); i++) {
					this.vsp_2.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>(initUniqueResourceIdHeader(id),leafValues.get(i)));
				}
			}			
			
			public void assignVSP_2(List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<T>>> p) {
				this.vsp_2 = p;
			}			
			List <T> values() {
				List<T> tmp = new ArrayList<T>();
				for (int i = 0; i < this.vsp.size(); i++) {
					tmp.add(this.vsp.get(i).getValue());
				}
			return tmp;
			}
			
		}
		'''
	}
	
	static def generateNodeObjectClassCode() {
		'''
		class NodeObject extends Node<Object> {
			public NodeObject(String name) {
				super(name);
			}
			public NodeObject(String name, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsp) {
				super(name,vsp);
			}
		}
		'''
	}
	
	static def String generateNodeObjectListClassCode() {
		'''
		class NodeObjectList extends Node<Object> {
			public NodeObjectList(String name) {
				super(name);
			}
			public NodeObjectList(String name, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsp) {
				super(name,vsp);
			}
		}
		'''
	}
	
	static def generateNodePsClassCode() {
		'''
		class NodePs extends Node<Map<String,Double>> {
			public NodePs(String name) {
				super(name);
			}
			public NodePs(String name, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> vsp) {
				super(name,vsp);
			}
		}
		'''
	}	
	
}