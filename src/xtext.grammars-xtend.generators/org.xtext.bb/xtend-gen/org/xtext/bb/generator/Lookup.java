package org.xtext.bb.generator;

import java.util.AbstractMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@SuppressWarnings("all")
public class Lookup {
  public static String generateLookupCode(final Map<String, Integer> pl, final List<AbstractMap.SimpleEntry<String, Integer>> pll) {
    StringBuilder lookupCode = new StringBuilder();
    lookupCode.append("\n\t\t");
    lookupCode.append("Map<String, Integer> lookupIndices = new HashMap<String, Integer>();");
    lookupCode.append("List<SimpleEntry<String, Integer>> passiveNodes = new ArrayList<>();");
    lookupCode.append("\n\t\t");
    int _size = pl.entrySet().size();
    int _size_1 = pll.size();
    boolean _notEquals = (_size != _size_1);
    if (_notEquals) {
      System.out.println("THIS SHOULD NEVER HAPPEN !!!!!!!!!!!");
    }
    Set<Map.Entry<String, Integer>> _entrySet = pl.entrySet();
    for (final Map.Entry<String, Integer> i : _entrySet) {
      {
        String _key = i.getKey();
        String _plus = ("lookupIndices.put(\"" + _key);
        String _plus_1 = (_plus + "\",");
        Integer _value = i.getValue();
        String _plus_2 = (_plus_1 + _value);
        String _plus_3 = (_plus_2 + ");");
        lookupCode.append(_plus_3);
        lookupCode.append("\n\t\t");
      }
    }
    for (final AbstractMap.SimpleEntry<String, Integer> i_1 : pll) {
      {
        String _key = i_1.getKey();
        String _plus = ("passiveNodes.add(new SimpleEntry<>(\"" + _key);
        String _plus_1 = (_plus + "\",");
        Integer _value = i_1.getValue();
        String _plus_2 = (_plus_1 + _value);
        String _plus_3 = (_plus_2 + "));");
        lookupCode.append(_plus_3);
        lookupCode.append("\n\t\t");
      }
    }
    lookupCode.append("List<SimpleEntry<String,Integer>> sortedIndexList = new ArrayList<SimpleEntry<String,Integer>>();");
    lookupCode.append("\n\t\t");
    lookupCode.append("List<List<SimpleEntry<String,Integer>>> firstheader = rtmp.get(0).getKey();");
    lookupCode.append("\n\t\t");
    lookupCode.append("List<String> alreadyChecked = new ArrayList<String>();");
    lookupCode.append("\n\t\t");
    lookupCode.append("for (List<SimpleEntry<String,Integer>> headerRow : firstheader) {");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("for (SimpleEntry<String,Integer> entry : passiveNodes) {");
    lookupCode.append("\n\t\t\t\t\t");
    lookupCode.append("if (entry.getKey() == headerEntry.getKey() && !alreadyChecked.contains(headerEntry.getKey())) {");
    lookupCode.append("\n\t\t\t\t\t\t");
    lookupCode.append("sortedIndexList.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), entry.getValue()));");
    lookupCode.append("\n\t\t\t\t\t\t");
    lookupCode.append("alreadyChecked.add(headerEntry.getKey());");
    lookupCode.append("\n\t\t\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t");
    lookupCode.append("if (sortedIndexList.size() != passiveNodes.size()) {");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("System.err.println(\"ERROR: sortedIndexList.size() != passiveNodes.size()\");");
    lookupCode.append("}");
    lookupCode.append("\n\t\t");
    lookupCode.append("int");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append("[]");
    }
    lookupCode.append(" luti = new int");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append((("[sortedIndexList.get(" + Integer.valueOf(i_2)) + ").getValue()]"));
    }
    lookupCode.append(";");
    lookupCode.append("\n\t\t");
    lookupCode.append("Object");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append("[]");
    }
    lookupCode.append(" luto = new Object");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append((("[sortedIndexList.get(" + Integer.valueOf(i_2)) + ").getValue()]"));
    }
    lookupCode.append(";");
    lookupCode.append("\n\t\t");
    lookupCode.append("for (int i_0 = 0; i_0 < luti.length; i_0++) {");
    for (int i_2 = 1; (i_2 < pll.size()); i_2++) {
      {
        StringBuilder t = new StringBuilder();
        for (int j = 0; (j < i_2); j++) {
          t.append("\t");
        }
        StringBuilder tmp = new StringBuilder();
        tmp.append("luti");
        for (int j = 0; (j < i_2); j++) {
          tmp.append((("[i_" + Integer.valueOf(j)) + "]"));
        }
        tmp.append(".length");
        lookupCode.append(("\n\t\t" + t));
        lookupCode.append((((((((("for (int i_" + Integer.valueOf(i_2)) + " = 0; i_") + Integer.valueOf(i_2)) + " < ") + tmp) + "; i_") + Integer.valueOf(i_2)) + "++) {"));
      }
    }
    lookupCode.append("\n\t\t");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append("\t");
    }
    lookupCode.append("luti");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append((("[i_" + Integer.valueOf(i_2)) + "]"));
    }
    lookupCode.append(" = -1;");
    lookupCode.append("\n\t\t");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      {
        StringBuilder t = new StringBuilder();
        for (int j = pll.size(); (j > i_2); j--) {
          t.append("\t");
        }
        lookupCode.append("\n\t");
        lookupCode.append(t);
        lookupCode.append("}");
      }
    }
    lookupCode.append("\n\t\t");
    lookupCode.append("for (int i_0 = 0; i_0 < luto.length; i_0++) {");
    for (int i_2 = 1; (i_2 < pll.size()); i_2++) {
      {
        StringBuilder t = new StringBuilder();
        for (int j = 0; (j < i_2); j++) {
          t.append("\t");
        }
        StringBuilder tmp = new StringBuilder();
        tmp.append("luto");
        for (int j = 0; (j < i_2); j++) {
          tmp.append((("[i_" + Integer.valueOf(j)) + "]"));
        }
        tmp.append(".length");
        lookupCode.append(("\n\t\t" + t));
        lookupCode.append((((((((("for (int i_" + Integer.valueOf(i_2)) + " = 0; i_") + Integer.valueOf(i_2)) + " < ") + tmp) + "; i_") + Integer.valueOf(i_2)) + "++) {"));
      }
    }
    lookupCode.append("\n\t\t");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append("\t");
    }
    lookupCode.append("luto");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append((("[i_" + Integer.valueOf(i_2)) + "]"));
    }
    lookupCode.append(" = 0.0;");
    lookupCode.append("\n\t\t");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      {
        StringBuilder t = new StringBuilder();
        for (int j = pll.size(); (j > i_2); j--) {
          t.append("\t");
        }
        lookupCode.append("\n\t");
        lookupCode.append(t);
        lookupCode.append("}");
      }
    }
    lookupCode.append("\n\t\t");
    lookupCode.append("List<SimpleEntry<String,Integer>> namesAndIndices = new ArrayList<>();");
    lookupCode.append("\n\t\t");
    lookupCode.append("cnt = 0;");
    lookupCode.append("\n\t\t");
    lookupCode.append("for (SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object> i : rtmp) {");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("namesAndIndices = new ArrayList<SimpleEntry<String,Integer>>();");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("Map<String, Boolean> flag = new HashMap<String, Boolean>();");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("List<List<SimpleEntry<String,Integer>>> header = i.getKey();");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("for (List<SimpleEntry<String,Integer>> headerRow : header) {");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    lookupCode.append("\n\t\t\t\t\t");
    lookupCode.append("if (lookupIndices.containsKey(headerEntry.getKey()) && !flag.containsKey(headerEntry.getKey())) {");
    lookupCode.append("\n\t\t\t\t\t\t");
    lookupCode.append("namesAndIndices.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    lookupCode.append("\n\t\t\t\t\t\t");
    lookupCode.append("flag.put(headerEntry.getKey(),true);");
    lookupCode.append("\n\t\t\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("if (lookupIndices.entrySet().size() != namesAndIndices.size() && passiveNodes.size() != namesAndIndices.size()) {");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("System.out.println(\"(Lookup-2) THIS SHOULD NEVER HAPPEN !!!!!!!!!!!\");");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("else {");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("if (((Number)i.getValue()).doubleValue() >");
    lookupCode.append("((Number)luto");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append((("[namesAndIndices.get(" + Integer.valueOf(i_2)) + ").getValue()]"));
    }
    lookupCode.append(").doubleValue()) {");
    lookupCode.append("\n\t\t\t\t\t");
    lookupCode.append("luto");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append((("[namesAndIndices.get(" + Integer.valueOf(i_2)) + ").getValue()]"));
    }
    lookupCode.append(" = ((Number)i.getValue()).doubleValue();");
    lookupCode.append("\n\t\t\t\t\t");
    lookupCode.append("luti");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append((("[namesAndIndices.get(" + Integer.valueOf(i_2)) + ").getValue()]"));
    }
    lookupCode.append(" = cnt;");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("cnt++;");
    lookupCode.append("\n\t\t");
    lookupCode.append("}");
    lookupCode.append("Boolean as = true;");
    lookupCode.append("\n\t\t");
    lookupCode.append("for (int i_0 = 0; i_0 < luti.length; i_0++) {");
    for (int i_2 = 1; (i_2 < pll.size()); i_2++) {
      {
        StringBuilder t = new StringBuilder();
        for (int j = 0; (j < i_2); j++) {
          t.append("\t");
        }
        StringBuilder tmp = new StringBuilder();
        tmp.append("luti");
        for (int j = 0; (j < i_2); j++) {
          tmp.append((("[i_" + Integer.valueOf(j)) + "]"));
        }
        tmp.append(".length");
        lookupCode.append(("\n\t\t" + t));
        lookupCode.append((((((((("for (int i_" + Integer.valueOf(i_2)) + " = 0; i_") + Integer.valueOf(i_2)) + " < ") + tmp) + "; i_") + Integer.valueOf(i_2)) + "++) {"));
      }
    }
    lookupCode.append("\n\t\t");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append("\t");
    }
    lookupCode.append("if (luti");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      lookupCode.append((("[i_" + Integer.valueOf(i_2)) + "]"));
    }
    lookupCode.append(" == -1) {");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("as = false;");
    lookupCode.append("\n\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t");
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      {
        StringBuilder t = new StringBuilder();
        for (int j = pll.size(); (j > i_2); j--) {
          t.append("\t");
        }
        lookupCode.append("\n\t");
        lookupCode.append(t);
        lookupCode.append("}");
      }
    }
    lookupCode.append("\n\t\t");
    lookupCode.append("System.out.println(\"Always Satisfiable: \" + as);");
    lookupCode.append("\n\t\t");
    lookupCode.append("Scanner scanner = new Scanner(System.in);");
    lookupCode.append("\n\t\t");
    lookupCode.append("while(true) {");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("List<Integer> indexl = new ArrayList<Integer>();");
    lookupCode.append("\n\t\t\t");
    int _size_2 = pll.size();
    String _plus = ("for (int i = 0; i < " + Integer.valueOf(_size_2));
    String _plus_1 = (_plus + "; i++) {");
    lookupCode.append(_plus_1);
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("System.out.print(\"Please enter an index for \"+ sortedIndexList.get(i).getKey() +\" (0-\"+new Integer(sortedIndexList.get(i).getValue()-1).toString()+\") : \");");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("int input = scanner.nextInt();");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("indexl.add(input);");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("}");
    StringBuilder stb = new StringBuilder();
    for (int i_2 = 0; (i_2 < pll.size()); i_2++) {
      stb.append((("[indexl.get(" + Integer.valueOf(i_2)) + ")]"));
    }
    lookupCode.append("\n\t\t\t");
    lookupCode.append((("if (luti" + stb) + " == -1) {"));
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("System.out.println(\"No Solution!\");");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("else {");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append((("System.out.println(\"Result: \" + rtmp.get(luti" + stb) + "));"));
    lookupCode.append("\n\t\t\t");
    lookupCode.append("List<SimpleEntry<String,Integer>> namesAndIndicesActive = new ArrayList<>();");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("Map<String, Boolean> flag = new HashMap<String, Boolean>();");
    lookupCode.append("\n\t\t\t");
    lookupCode.append((("List<List<SimpleEntry<String,Integer>>> header = rtmp.get(luti" + stb) + ").getKey();"));
    lookupCode.append("\n\t\t\t");
    lookupCode.append("for (List<SimpleEntry<String,Integer>> headerRow : header) {");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("for (SimpleEntry<String,Integer> headerEntry : headerRow) {");
    lookupCode.append("\n\t\t\t\t\t");
    lookupCode.append("if (active.containsKey(headerEntry.getKey()) && !flag.containsKey(headerEntry.getKey())) {");
    lookupCode.append("\n\t\t\t\t\t\t");
    lookupCode.append("namesAndIndicesActive.add(new SimpleEntry<String,Integer>(headerEntry.getKey(), headerEntry.getValue()));");
    lookupCode.append("\n\t\t\t\t\t\t");
    lookupCode.append("flag.put(headerEntry.getKey(),true);");
    lookupCode.append("\n\t\t\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("System.out.println(\"*************************************************************************\");");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("System.out.println(\"Result: \");");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("for (int i = 0; i < namesAndIndicesActive.size(); i++) {");
    lookupCode.append("\n\t\t\t\t");
    lookupCode.append("System.out.println(namesAndIndicesActive.get(i).getKey() + \": \" + namesAndIndicesActive.get(i).getValue());");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t\t");
    lookupCode.append("}");
    lookupCode.append("\n\t\t");
    lookupCode.append("}");
    return lookupCode.toString();
  }
}
