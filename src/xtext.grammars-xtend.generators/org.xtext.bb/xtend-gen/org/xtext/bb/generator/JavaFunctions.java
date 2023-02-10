package org.xtext.bb.generator;

import BbDvgTcl.AbstractOutputPort;
import BbDvgTcl.DVGPort;
import java.util.AbstractMap;
import java.util.List;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.IntegerRange;

@SuppressWarnings("all")
public class JavaFunctions {
  public static CharSequence generateGetCartesianProduct() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("List<List<Integer>> getCartesianProduct(ArrayList<Integer> arg, int cnt, List<List<Integer>> input, List<List<Integer>> output) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int j = 0; j < input.get(cnt).size(); j++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("List<Integer> tmp = new ArrayList<Integer>();");
    _builder.newLine();
    _builder.append("    \t");
    _builder.append("for (int i = 0; i < cnt; i++) {");
    _builder.newLine();
    _builder.append("    \t\t");
    _builder.append("tmp.add(arg.get(i));");
    _builder.newLine();
    _builder.append("   \t\t ");
    _builder.append("}");
    _builder.newLine();
    _builder.append(" \t\t");
    _builder.append("arg.clear();");
    _builder.newLine();
    _builder.append(" \t\t");
    _builder.append("arg.addAll(tmp);");
    _builder.newLine();
    _builder.append("        ");
    _builder.append("arg.add(input.get(cnt).get(j));");
    _builder.newLine();
    _builder.append("        ");
    _builder.append("if (cnt == input.size()-1) {");
    _builder.newLine();
    _builder.append("\t        ");
    _builder.append("output.add(new ArrayList<Integer>());");
    _builder.newLine();
    _builder.append("\t        ");
    _builder.append("output.get(output.size()-1).addAll(arg);");
    _builder.newLine();
    _builder.append("        ");
    _builder.append("}");
    _builder.newLine();
    _builder.append("        ");
    _builder.append("else {");
    _builder.newLine();
    _builder.append("        \t");
    _builder.append("getCartesianProduct(arg, cnt+1, input, output);");
    _builder.newLine();
    _builder.append("        ");
    _builder.append("}");
    _builder.newLine();
    _builder.append("    ");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return output;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public static CharSequence generateIsSAM() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("boolean isSAM(List<List<List<SimpleEntry<String,Integer>>>> headerList) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<String> sln = new ArrayList<String>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (List<List<SimpleEntry<String,Integer>>> i : headerList) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("for (List<SimpleEntry<String,Integer>> j : i) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("for (SimpleEntry<String,Integer> k : j) {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("if (!sln.contains(k.getKey())) {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t\t");
    _builder.append("sln.add(k.getKey());");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("else {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t\t");
    _builder.append("return true;");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return false;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public static CharSequence generateIsValidCombinationIgnoreResource() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("boolean isValidCombination(List<List<SimpleEntry<String,Integer>>> header) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("Map<String,Integer> M = new HashMap<String,Integer>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (List<SimpleEntry<String,Integer>> row : header) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (SimpleEntry<String,Integer> entry : row) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("if (!M.containsKey(entry.getKey())) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("M.put(entry.getKey(), entry.getValue());");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("else {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("if (entry.getValue() != M.get(entry.getKey()) && entry.getKey() != \"UNIQUE_RESOURCE_ID\") {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("return false;");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return true;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public static CharSequence generateIsValidCombinationConsiderResource() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("boolean isValidCombination(List<List<SimpleEntry<String,Integer>>> header) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<List<Integer>> indicesLL = new ArrayList<List<Integer>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (List<SimpleEntry<String,Integer>> row : header) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("List<Integer> indicesL = new ArrayList<Integer>();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (SimpleEntry<String,Integer> entry : row) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("if (entry.getKey() == \"UNIQUE_RESOURCE_ID\") {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("if (!indicesL.contains(entry.getValue())) {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("indicesL.add(entry.getValue());");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("indicesLL.add(indicesL);");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < indicesLL.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (int j = 0; j < indicesLL.size(); j++) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("if (i != j) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("for (int k = 0; k < indicesLL.get(i).size(); k++) {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("for (int l = 0; l < indicesLL.get(j).size(); l++) {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t\t");
    _builder.append("if (indicesLL.get(i).get(k) == indicesLL.get(j).get(l)) {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t\t\t");
    _builder.append("return false;");
    _builder.newLine();
    _builder.append("\t\t\t\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return true;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public static CharSequence generateHeaderRow() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();");
    _builder.newLine();
    _builder.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(j).name(),cp.get(i).get(j)));");
    _builder.newLine();
    _builder.append("if (I.get(j).header(cp.get(i).get(j)) != null) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<List<SimpleEntry<String,Integer>>> htmp = I.get(j).header(cp.get(i).get(j));");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (List<SimpleEntry<String,Integer>> row : htmp) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (SimpleEntry<String,Integer> entry : row) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("headerRow.add(entry);");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    _builder.append("header.add(headerRow);");
    _builder.newLine();
    return _builder;
  }

  public static CharSequence generateHeaderRow(final int nodeIndex, final int slotIndex) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("headerRow = new ArrayList<SimpleEntry<String,Integer>>();");
    _builder.newLine();
    _builder.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(");
    _builder.append(nodeIndex);
    _builder.append(").name(),");
    _builder.append(slotIndex);
    _builder.append("));");
    _builder.newLineIfNotEmpty();
    _builder.append("if (I.get(");
    _builder.append(nodeIndex);
    _builder.append(").header(");
    _builder.append(slotIndex);
    _builder.append(") != null) {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("htmp = I.get(");
    _builder.append(nodeIndex, "\t");
    _builder.append(").header(");
    _builder.append(slotIndex, "\t");
    _builder.append(");");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("for (List<SimpleEntry<String,Integer>> row : htmp) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (SimpleEntry<String,Integer> entry : row) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("headerRow.add(entry);");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    _builder.append("header.add(headerRow);");
    _builder.newLine();
    return _builder;
  }

  public static CharSequence generateIsDominated() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("Boolean isDominated(List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> F, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> S, List<Boolean> Max) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < F.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("if (Max.get(i)) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("if (((Number)F.get(i).getValue()).doubleValue() > ((Number)S.get(i).getValue()).doubleValue()) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("return false;");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("else {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("if (((Number)F.get(i).getValue()).doubleValue() < ((Number)S.get(i).getValue()).doubleValue()) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("return false;");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return true;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public static CharSequence generateMaxFunction() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("double max(List<Object> list) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("double max = Double.NEGATIVE_INFINITY;");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < list.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("if (((Number)list.get(i)).doubleValue() > max) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("max = ((Number)list.get(i)).doubleValue();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return max;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public static CharSequence generateMinFunction() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("double min(List<Object> list) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("double min = Double.POSITIVE_INFINITY;");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < list.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("if (((Number)list.get(i)).doubleValue() < min) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("min = ((Number)list.get(i)).doubleValue();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return min;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public static CharSequence generateCallSequenceCode(final String name, final List<DVGPort> inputSet) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("params = new ArrayList<Node>();");
    _builder.newLine();
    {
      int _size = inputSet.size();
      boolean _greaterThan = (_size > 0);
      if (_greaterThan) {
        {
          int _size_1 = inputSet.size();
          int _minus = (_size_1 - 1);
          IntegerRange _upTo = new IntegerRange(0, _minus);
          for(final Integer i : _upTo) {
            _builder.append("params.add(this.NODE_COLLECTION.get(\"");
            String _name = inputSet.get((i).intValue()).getName();
            _builder.append(_name);
            _builder.append("\"));");
            _builder.newLineIfNotEmpty();
          }
        }
      }
    }
    _builder.append("resolve_");
    _builder.append(name);
    _builder.append("(params);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateCallSequenceCodeAg(final String name, final List<List<DVGPort>> inputSet) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("params_2d = new ArrayList<List<Node>>();");
    _builder.newLine();
    {
      int _size = inputSet.size();
      boolean _greaterThan = (_size > 0);
      if (_greaterThan) {
        {
          int _size_1 = inputSet.size();
          int _minus = (_size_1 - 1);
          IntegerRange _upTo = new IntegerRange(0, _minus);
          for(final Integer i : _upTo) {
            _builder.append("params = new ArrayList<Node>();");
            _builder.newLine();
            {
              int _size_2 = inputSet.get((i).intValue()).size();
              int _minus_1 = (_size_2 - 1);
              IntegerRange _upTo_1 = new IntegerRange(0, _minus_1);
              for(final Integer j : _upTo_1) {
                _builder.append("params.add(this.NODE_COLLECTION.get(\"");
                String _name = inputSet.get((i).intValue()).get((j).intValue()).getName();
                _builder.append(_name);
                _builder.append("\"));");
                _builder.newLineIfNotEmpty();
              }
            }
            _builder.append("params_2d.add(params);");
            _builder.newLine();
          }
        }
      }
    }
    _builder.append("resolve_");
    _builder.append(name);
    _builder.append("(params_2d);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateGetDataFromFile() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("String[] getDataFromFile(String searchForName) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("try {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("FileInputStream fstream = new FileInputStream(\"dataForSolver.txt\");");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("DataInputStream in = new DataInputStream(fstream);");
    _builder.newLine();
    _builder.append("        ");
    _builder.append("BufferedReader br = new BufferedReader(new InputStreamReader(in));");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("String strLine;");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("while ((strLine = br.readLine()) != null) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("String[] tokens = strLine.split(\":\");");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("if (tokens[0].equalsIgnoreCase(searchForName)) {");
    _builder.newLine();
    _builder.append("                ");
    _builder.append("String[] tokens2 = tokens[1].split(\",\");");
    _builder.newLine();
    _builder.append("                ");
    _builder.append("return tokens2;");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("in.close();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("catch (Exception e){");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("System.err.println(\"Error: \" + e.getMessage());");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return null;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public static String generateCallSequenceCode(final String name, final List<DVGPort> inputSet, final List<List<AbstractMap.SimpleEntry<AbstractOutputPort, String>>> allocInputSet, final List<Boolean> isAlloc) {
    for (int i = 0; (i < allocInputSet.size()); i++) {
      for (int j = 0; (j < allocInputSet.get(i).size()); j++) {
        String _plus = (Integer.valueOf(i) + ",");
        String _plus_1 = (_plus + Integer.valueOf(j));
        String _plus_2 = (_plus_1 + ": ");
        AbstractMap.SimpleEntry<AbstractOutputPort, String> _get = allocInputSet.get(i).get(j);
        String _plus_3 = (_plus_2 + _get);
        InputOutput.<String>println(_plus_3);
      }
    }
    StringBuilder code = new StringBuilder();
    int _size = allocInputSet.size();
    boolean _equals = (_size == 0);
    if (_equals) {
      code.append("\n\t\t");
      code.append("params = new ArrayList<Node>();");
      code.append("\n\t\t");
      for (int i = 0; (i < inputSet.size()); i++) {
        {
          String _name = inputSet.get(i).getName();
          String _plus = ("params.add(this.NODE_COLLECTION.get(\"" + _name);
          String _plus_1 = (_plus + "\"));");
          code.append(_plus_1);
          code.append("\n\t\t");
        }
      }
      code.append((("resolve_" + name) + "(params);"));
      code.append("\n\t\t");
      code.append("\n\t\t");
    } else {
      for (int l = 0; (l < allocInputSet.get(0).size()); l++) {
        {
          String _string = Integer.valueOf(l).toString();
          String _plus = ("if (allocation == " + _string);
          String _plus_1 = (_plus + ") {");
          code.append(_plus_1);
          code.append("\n\t\t");
          int inputSetCounter = 0;
          int allocInputSetCounter = 0;
          code.append("\n\t\t");
          code.append("params = new ArrayList<Node>();");
          code.append("\n\t\t");
          for (final Boolean i : isAlloc) {
            if ((i).booleanValue()) {
              String _value = allocInputSet.get(allocInputSetCounter).get(l).getValue();
              String _plus_2 = ("params.add(this.NODE_COLLECTION.get(\"" + _value);
              String _plus_3 = (_plus_2 + "\"));");
              code.append(_plus_3);
              code.append("\n\t\t");
              allocInputSetCounter++;
            } else {
              String _name = inputSet.get(inputSetCounter).getName();
              String _plus_4 = ("params.add(this.NODE_COLLECTION.get(\"" + _name);
              String _plus_5 = (_plus_4 + "\"));");
              code.append(_plus_5);
              code.append("\n\t\t");
              inputSetCounter++;
            }
          }
          code.append((("resolve_" + name) + "(params);"));
          code.append("\n\t\t");
          code.append("\n\t\t }");
          code.append("\n\t\t");
        }
      }
    }
    return code.toString();
  }

  public static CharSequence generateCreateJSONMessageEntry() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("String createJSONMessageEntry (String bbname, int iindex, String vename, Object value) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("String json = \"{\";");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("json += \"\\\"building-block\\\": \\\"\"+bbname+\"\\\", \";");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("json += \"\\\"instance-index\\\": \"+iindex+\", \";");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("json += \"\\\"variability-entity\\\": \\\"\"+vename+\"\\\", \";");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("json += \"\\\"value\\\": \\\"\"+value+\"\\\"\";");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("json += \"}\";");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return json;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public static String generateGenericAllocationAggr() {
    String _xblockexpression = null;
    {
      String vsp = null;
      String obj = null;
      vsp = "vsp";
      obj = "Object";
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("Node AllocationAggr (List<Node>I, String name) {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,");
      _builder.append(obj, "\t");
      _builder.append(">> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,");
      _builder.append(obj, "\t");
      _builder.append(">>();");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.append(obj, "\t");
      _builder.append(" newValue;");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("NodeObjectList nodeObjectList;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("for (int i = 0; i < I.size(); i++) {");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("SimpleEntry<String, Integer> fid = new SimpleEntry<String, Integer>(name, i);");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("for (int j = 0; j < I.get(i).");
      _builder.append(vsp, "\t\t");
      _builder.append("().size(); j++) {");
      _builder.newLineIfNotEmpty();
      _builder.append("\t\t\t");
      _builder.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("headerRow.add(fid);");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("headerRow.add(new SimpleEntry<String, Integer>(I.get(i).name(), j));");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("if (I.get(i).header(j) != null) {");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("List<List<SimpleEntry<String,Integer>>> htmp = I.get(i).header(j);");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("for (List<SimpleEntry<String,Integer>> row : htmp) {");
      _builder.newLine();
      _builder.append("\t\t\t\t\t");
      _builder.append("for (SimpleEntry<String,Integer> entry : row) {");
      _builder.newLine();
      _builder.append("\t\t\t\t\t\t");
      _builder.append("headerRow.add(entry);");
      _builder.newLine();
      _builder.append("\t\t\t\t\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("header.add(headerRow);");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("newValue = I.get(i).");
      _builder.append(vsp, "\t\t\t");
      _builder.append("(j);");
      _builder.newLineIfNotEmpty();
      _builder.append("\t\t\t");
      _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, ");
      _builder.append(obj, "\t\t\t");
      _builder.append(">(header, newValue));");
      _builder.newLineIfNotEmpty();
      _builder.append("\t\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("return new NodeObject(name, ovsp);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _xblockexpression = _builder.toString();
    }
    return _xblockexpression;
  }
}
