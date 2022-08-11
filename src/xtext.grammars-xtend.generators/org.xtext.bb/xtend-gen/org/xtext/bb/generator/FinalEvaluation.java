package org.xtext.bb.generator;

import java.util.Map;
import java.util.Set;

@SuppressWarnings("all")
public class FinalEvaluation {
  public String getNonSoSCode(final String name, final Map<String, Integer> active, final Map<String, Integer> passive, final StringBuilder to_tcl) {
    StringBuilder code = new StringBuilder();
    code.append("\n\t\t");
    code.append("Map<String, Integer> active = new HashMap<String, Integer>();");
    code.append("\n\t\t");
    code.append("Map<String, Integer> passive = new HashMap<String, Integer>();");
    Set<Map.Entry<String, Integer>> _entrySet = active.entrySet();
    for (final Map.Entry<String, Integer> i : _entrySet) {
      {
        String _key = i.getKey();
        String _plus = ("active.put(\"" + _key);
        String _plus_1 = (_plus + "\",");
        Integer _value = i.getValue();
        String _plus_2 = (_plus_1 + _value);
        String _plus_3 = (_plus_2 + ");");
        code.append(_plus_3);
        code.append("\n\t\t");
      }
    }
    Set<Map.Entry<String, Integer>> _entrySet_1 = passive.entrySet();
    for (final Map.Entry<String, Integer> i_1 : _entrySet_1) {
      {
        String _key = i_1.getKey();
        String _plus = ("passive.put(\"" + _key);
        String _plus_1 = (_plus + "\",");
        Integer _value = i_1.getValue();
        String _plus_2 = (_plus_1 + _value);
        String _plus_3 = (_plus_2 + ");");
        code.append(_plus_3);
        code.append("\n\t\t");
      }
    }
    code.append("\n\t\t");
    code.append("Map<String, List<Object>> TO_TCL = new HashMap<String, List<Object>>();");
    code.append("\n\t\t");
    code.append("List<Object> l;");
    code.append("\n\t\t");
    code.append(to_tcl);
    code.append("\n\t\t");
    code.append((("Node result = NODE_COLLECTION.get(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("int cnt = 0;");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> rtmp = result.vsp();");
    code.append("\n\t\t");
    code.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> maxSlot = null;");
    code.append("\n\t\t");
    code.append("double maxValue = 0.0;");
    code.append("\n\t\t");
    code.append("int maxIndex = 0;");
    code.append("\n\t\t");
    code.append("for (SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> i : rtmp) {");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();");
    code.append("\n\t\t");
    code.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();");
    code.append("\n\t\t");
    code.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();");
    code.append("\n\t\t\t");
    code.append("List<List<SimpleEntry<String,Integer>>> header = i.getKey();");
    code.append("\n\t\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> headerRow : header) {");
    code.append("\n\t\t\t\t");
    code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    code.append("\n\t\t\t\t\t");
    code.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());");
    code.append("\n\t\t\t\t\t");
    code.append("System.out.print(\"\t\");");
    code.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    code.append("\n\t\t\t\t\t");
    code.append("AflagLeaf.put(headerEntry.getKey(),true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    code.append("\n\t\t\t\t\t");
    code.append("PflagLeaf.put(headerEntry.getKey(),true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("System.out.println();");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("System.out.println(\"################## ACTIVE VARIANT: \");");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < AleafNamesAndIndices.size(); j++) {");
    code.append("\n\t\t\t");
    code.append("System.out.println(AleafNamesAndIndices.get(j).getKey() + \": \" + AleafNamesAndIndices.get(j).getValue());");
    code.append("\n\t\t");
    code.append("}");
    code.append("System.out.println(\"################## FOR PASSIVE STATES: \");");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {");
    code.append("\n\t\t\t");
    code.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("System.out.println(\"=================> [\"+cnt+\", \"+i.getValue()+\"]\");");
    code.append("\n\t\t");
    code.append("System.out.println(\"------------------------------------\");");
    code.append("\n\t\t");
    code.append("if (((Number)i.getValue()).doubleValue() > maxValue) {");
    code.append("\n\t\t\t");
    code.append("maxValue = ((Number)i.getValue()).doubleValue();");
    code.append("\n\t\t\t");
    code.append("maxSlot = i;");
    code.append("\n\t\t\t");
    code.append("maxIndex = cnt;");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("cnt++;");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("System.out.println(\"\");");
    code.append("\n\t\t");
    code.append("System.out.println(\"\");");
    code.append("\n\t\t");
    code.append("System.out.println(\"====================== Final Result ====================== \");");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> headerRow : maxSlot.getKey()) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    code.append("\n\t\t\t\t");
    code.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());");
    code.append("\n\t\t\t\t");
    code.append("System.out.print(\"\t\");");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("System.out.println();");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();");
    code.append("\n\t\t");
    code.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();");
    code.append("\n\t\t");
    code.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> headerRow : maxSlot.getKey()) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    code.append("\n\t\t\t\t");
    code.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    code.append("\n\t\t\t\t\t");
    code.append("AflagLeaf.put(headerEntry.getKey(),true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    code.append("\n\t\t\t\t\t");
    code.append("PflagLeaf.put(headerEntry.getKey(),true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("}");
    code.append("System.out.println(\"################## MAX ACTIVE VARIANT: \");");
    code.append("\n\t\t");
    code.append("for (int i = 0; i < AleafNamesAndIndices.size(); i++) {");
    code.append("if (TO_TCL.containsKey(AleafNamesAndIndices.get(i).getKey())) {\n");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> lse = this.NODE_COLLECTION.get(AleafNamesAndIndices.get(i).getKey()).vsp();\n");
    code.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> se = lse.get(AleafNamesAndIndices.get(i).getValue());\n");
    code.append("String outString = \"(tcl-kb-update :key \'(is-a name instance) :value \'((is-a dvgConfig)(name \"+TO_TCL.get(AleafNamesAndIndices.get(i).getKey()).get(0)+\")(instance \"+TO_TCL.get(AleafNamesAndIndices.get(i).getKey()).get(1)+\")(value \"+se.getValue()+\")))\";\n");
    code.append("try {\n");
    code.append("FileWriter myWriter = new FileWriter(\"smartSoftConfig.txt\", true);\n");
    code.append("myWriter.write(outString+\"\\n\");\n");
    code.append("myWriter.close();\n");
    code.append("} catch (IOException e) {\n");
    code.append("System.out.println(\"An error occurred.\");\n");
    code.append("e.printStackTrace();\n");
    code.append("}\n");
    code.append("}\n");
    code.append("\n\t\t\t");
    code.append("System.out.println(AleafNamesAndIndices.get(i).getKey() + \": \" + AleafNamesAndIndices.get(i).getValue());");
    code.append("\n\t\t");
    code.append("}");
    code.append("System.out.println(\"################## FOR IDEAL PASSIVE STATES: \");");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {");
    code.append("\n\t\t\t");
    code.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("System.out.println(\"=================> [\"+maxIndex+\", \"+maxSlot.getValue()+\"]\");");
    code.append("\n\t\t");
    code.append("if (maxValue > prevValue) {");
    code.append("\n\t\t");
    code.append("solution = allocation;");
    code.append("\n\t\t");
    code.append("prevValue = maxValue;");
    code.append("\n\t\t");
    code.append("solutionSlot = maxSlot;");
    code.append("\n\t\t");
    code.append("solutionIndex = maxIndex;");
    code.append("\n\t\t");
    code.append("}");
    code.append("}");
    code.append("\n\t\t");
    code.append("System.out.println(\"Best allocation is: \" + solution);");
    code.append("\n\t\t");
    code.append("Map<String, Integer> active = new HashMap<String, Integer>();");
    code.append("\n\t\t");
    code.append("Map<String, Integer> passive = new HashMap<String, Integer>();");
    code.append("\n\t\t");
    code.append("\n\t\t");
    code.append("System.out.println(\"\");");
    code.append("\n\t\t");
    code.append("System.out.println(\"\");");
    code.append("\n\t\t");
    code.append("System.out.println(\"====================== Final Result ====================== \");");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> headerRow : solutionSlot.getKey()) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    code.append("\n\t\t\t\t");
    code.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());");
    code.append("\n\t\t\t\t");
    code.append("System.out.print(\"\t\");");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("System.out.println();");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();");
    code.append("\n\t\t");
    code.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();");
    code.append("\n\t\t");
    code.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> headerRow : solutionSlot.getKey()) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    code.append("\n\t\t\t\t");
    code.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    code.append("\n\t\t\t\t\t");
    code.append("AflagLeaf.put(headerEntry.getKey(),true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    code.append("\n\t\t\t\t\t");
    code.append("PflagLeaf.put(headerEntry.getKey(),true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("}");
    code.append("System.out.println(\"################## MAX ACTIVE VARIANT: \");");
    code.append("\n\t\t");
    code.append("for (int i = 0; i < AleafNamesAndIndices.size(); i++) {");
    code.append("\n\t\t\t");
    code.append("System.out.println(AleafNamesAndIndices.get(i).getKey() + \": \" + AleafNamesAndIndices.get(i).getValue());");
    code.append("\n\t\t");
    code.append("}");
    code.append("System.out.println(\"################## FOR IDEAL PASSIVE STATES: \");");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {");
    code.append("\n\t\t\t");
    code.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("System.out.println(\"=================> [\"+solutionIndex+\", \"+solutionSlot.getValue()+\"]\");");
    code.append("\n\t\t");
    return code.toString();
  }

  public String getSoSCode() {
    StringBuilder code = new StringBuilder();
    code.append("\n\t");
    code.append("\n\t");
    code.append("return this.NODE_COLLECTION.get(name);");
    code.append("\n\t");
    return code.toString();
  }

  public static String getEQUFCode(final String name, final Map<String, Integer> active, final Map<String, Integer> passive) {
    StringBuilder code = new StringBuilder();
    code.append("\n\t\t");
    code.append("Map<String, Integer> active = new HashMap<String, Integer>();");
    code.append("\n\t\t");
    code.append("Map<String, Integer> passive = new HashMap<String, Integer>();");
    Set<Map.Entry<String, Integer>> _entrySet = active.entrySet();
    for (final Map.Entry<String, Integer> i : _entrySet) {
      {
        String _key = i.getKey();
        String _plus = ("active.put(\"" + _key);
        String _plus_1 = (_plus + "\",");
        Integer _value = i.getValue();
        String _plus_2 = (_plus_1 + _value);
        String _plus_3 = (_plus_2 + ");");
        code.append(_plus_3);
        code.append("\n\t\t");
      }
    }
    Set<Map.Entry<String, Integer>> _entrySet_1 = passive.entrySet();
    for (final Map.Entry<String, Integer> i_1 : _entrySet_1) {
      {
        String _key = i_1.getKey();
        String _plus = ("passive.put(\"" + _key);
        String _plus_1 = (_plus + "\",");
        Integer _value = i_1.getValue();
        String _plus_2 = (_plus_1 + _value);
        String _plus_3 = (_plus_2 + ");");
        code.append(_plus_3);
        code.append("\n\t\t");
      }
    }
    code.append("\n\t\t");
    code.append("Map<String, List<Object>> TO_TCL = new HashMap<String, List<Object>>();");
    code.append("\n\t\t");
    code.append("List<Object> l;");
    code.append("\n\t\t");
    code.append("\n\t\t");
    code.append((("Node result = NODE_COLLECTION.get(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("int cnt = 0;");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> rtmp = result.vsp();");
    code.append("\n\t\t");
    code.append("SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> maxSlot = null;");
    code.append("\n\t\t");
    code.append("double maxValue = 0.0;");
    code.append("\n\t\t");
    code.append("int maxIndex = 0;");
    code.append("\n\t\t");
    code.append("for (SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> i : rtmp) {");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();");
    code.append("\n\t\t");
    code.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();");
    code.append("\n\t\t");
    code.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();");
    code.append("\n\t\t\t");
    code.append("List<List<SimpleEntry<String,Integer>>> header = i.getKey();");
    code.append("\n\t\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> headerRow : header) {");
    code.append("\n\t\t\t\t");
    code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    code.append("\n\t\t\t\t\t");
    code.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());");
    code.append("\n\t\t\t\t\t");
    code.append("System.out.print(\"\t\");");
    code.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    code.append("\n\t\t\t\t\t");
    code.append("AflagLeaf.put(headerEntry.getKey(),true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    code.append("\n\t\t\t\t\t");
    code.append("PflagLeaf.put(headerEntry.getKey(),true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("System.out.println();");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("System.out.println(\"################## ACTIVE VARIANT: \");");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < AleafNamesAndIndices.size(); j++) {");
    code.append("\n\t\t\t");
    code.append("System.out.println(AleafNamesAndIndices.get(j).getKey() + \": \" + AleafNamesAndIndices.get(j).getValue());");
    code.append("\n\t\t");
    code.append("}");
    code.append("System.out.println(\"################## FOR PASSIVE STATES: \");");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {");
    code.append("\n\t\t\t");
    code.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("System.out.println(\"=================> [\"+cnt+\", \"+i.getValue()+\"]\");");
    code.append("\n\t\t");
    code.append("System.out.println(\"------------------------------------\");");
    code.append("\n\t\t");
    code.append("if (((Number)i.getValue()).doubleValue() > maxValue) {");
    code.append("\n\t\t\t");
    code.append("maxValue = ((Number)i.getValue()).doubleValue();");
    code.append("\n\t\t\t");
    code.append("maxSlot = i;");
    code.append("\n\t\t\t");
    code.append("maxIndex = cnt;");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("cnt++;");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("System.out.println(\"\");");
    code.append("\n\t\t");
    code.append("System.out.println(\"\");");
    code.append("\n\t\t");
    code.append("System.out.println(\"====================== Final Result ====================== \");");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> headerRow : maxSlot.getKey()) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    code.append("\n\t\t\t\t");
    code.append("System.out.print(headerEntry.getKey()+\": \"+headerEntry.getValue());");
    code.append("\n\t\t\t\t");
    code.append("System.out.print(\"\t\");");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("System.out.println();");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<String,Integer>> AleafNamesAndIndices = new ArrayList<>();");
    code.append("\n\t\t");
    code.append("Map<String, Boolean> AflagLeaf = new HashMap<String, Boolean>();");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<String,Integer>> PleafNamesAndIndices = new ArrayList<>();");
    code.append("\n\t\t");
    code.append("Map<String, Boolean> PflagLeaf = new HashMap<String, Boolean>();");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> headerRow : maxSlot.getKey()) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    code.append("\n\t\t\t\t");
    code.append("if (active.containsKey(headerEntry.getKey()) && !AflagLeaf.containsKey(headerEntry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("AleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    code.append("\n\t\t\t\t\t");
    code.append("AflagLeaf.put(headerEntry.getKey(),true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("if (passive.containsKey(headerEntry.getKey()) && !PflagLeaf.containsKey(headerEntry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("PleafNamesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    code.append("\n\t\t\t\t\t");
    code.append("PflagLeaf.put(headerEntry.getKey(),true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("}");
    code.append("System.out.println(\"################## MAX ACTIVE VARIANT: \");");
    code.append("\n\t\t");
    code.append("for (int i = 0; i < AleafNamesAndIndices.size(); i++) {");
    code.append("\n\t\t\t");
    code.append("System.out.println(AleafNamesAndIndices.get(i).getKey() + \": \" + AleafNamesAndIndices.get(i).getValue());");
    code.append("\n\t\t");
    code.append("}");
    code.append("System.out.println(\"################## FOR IDEAL PASSIVE STATES: \");");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < PleafNamesAndIndices.size(); j++) {");
    code.append("\n\t\t\t");
    code.append("System.out.println(PleafNamesAndIndices.get(j).getKey() + \": \" + PleafNamesAndIndices.get(j).getValue());");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("System.out.println(\"=================> [\"+maxIndex+\", \"+maxSlot.getValue()+\"]\");");
    code.append("\n\t\t");
    return code.toString();
  }
}