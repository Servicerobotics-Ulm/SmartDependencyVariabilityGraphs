package org.xtext.bb.generator;

import bbn.AbstractInputPort;
import bbn.OutputCPort;
import bbn.OutputPort;
import bbn.SAPRO;
import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("all")
public class SAPROPattern {
  private boolean CHECK_FOR_IS_SAM_IN_PRODUCTION = false;

  private Helpers he;

  private JavaFunctions jf;

  public String resolve(final SAPRO p, final List<AbstractInputPort> inputSet) {
    Helpers _helpers = new Helpers();
    this.he = _helpers;
    JavaFunctions _javaFunctions = new JavaFunctions();
    this.jf = _javaFunctions;
    StringBuilder code = new StringBuilder();
    code.append("void");
    code.append(" ");
    String _name = p.getName();
    String _plus = ("resolve_" + _name);
    code.append(_plus);
    code.append("(");
    code.append("List<Node>");
    code.append(" ");
    code.append("I");
    code.append(") {");
    code.append("\n\t");
    if (this.CHECK_FOR_IS_SAM_IN_PRODUCTION) {
      code.append("List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();");
      code.append("\n\t");
      code.append("for (int i = 0; i < I.size(); i++) {");
      code.append("\n\t\t");
      code.append("if (I.get(i).vsp(0) != null) {");
      code.append("\n\t\t\t");
      code.append("headerList.add(I.get(i).header(0));");
      code.append("\n\t\t");
      code.append("}");
      code.append("\n\t");
      code.append("}");
      code.append("\n\t");
      code.append("if (headerList.size() > 0 && isSAM(headerList)) {");
      code.append("\n\t\t");
      String _name_1 = p.getName();
      String _plus_1 = ("System.err.println(\"ERROR: There is a not allowed SAM-Situation for Production pattern " + _name_1);
      String _plus_2 = (_plus_1 + "!\");");
      code.append(_plus_2);
      code.append("\n\t");
      code.append("}");
      code.append("\n\t");
    }
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
    code.append("\n\t");
    code.append("Object newValue;");
    code.append("\n\t");
    StringBuilder fdefcode = new StringBuilder();
    fdefcode.append("\n\t");
    String _name_2 = p.getName();
    String _plus_3 = ("Object operator_" + _name_2);
    String _plus_4 = (_plus_3 + "(List<Object> valueList");
    fdefcode.append(_plus_4);
    StringBuilder fcallcode = new StringBuilder();
    fcallcode.append("\n\t");
    String _name_3 = p.getName();
    String _plus_5 = ("operator_" + _name_3);
    String _plus_6 = (_plus_5 + "(valueList");
    fcallcode.append(_plus_6);
    List<String> processedMin = new ArrayList<String>();
    List<String> processedMax = new ArrayList<String>();
    code.append("List<Object> vtmp;");
    code.append("\n\t");
    List<String> tmp = this.he.getSymbolsForMinOperators(p.getExpr().getExpr());
    for (final String i : tmp) {
      boolean _contains = processedMin.contains(i);
      boolean _not = (!_contains);
      if (_not) {
        int index = this.he.getTh(i, inputSet);
        code.append((("vtmp = I.get(" + Integer.valueOf(index)) + ").values();"));
        code.append("\n\t");
        code.append((("double min_" + i) + " = min(vtmp);"));
        code.append("\n\t");
        fdefcode.append((", double min_" + i));
        fcallcode.append((",min_" + i));
        processedMin.add(i);
      }
    }
    tmp = this.he.getSymbolsForMaxOperators(p.getExpr().getExpr());
    for (final String i_1 : tmp) {
      boolean _contains_1 = processedMax.contains(i_1);
      boolean _not_1 = (!_contains_1);
      if (_not_1) {
        int index_1 = this.he.getTh(i_1, inputSet);
        code.append((("vtmp = I.get(" + Integer.valueOf(index_1)) + ").values();"));
        code.append("\n\t");
        code.append((("double max_" + i_1) + " = max(vtmp);"));
        code.append("\n\t");
        fdefcode.append((", double max_" + i_1));
        fcallcode.append((",max_" + i_1));
        processedMax.add(i_1);
      }
    }
    fdefcode.append(") {");
    fcallcode.append(");");
    code.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();");
    code.append("\n\t");
    code.append("for (Node i : I) {");
    code.append("\n\t\t");
    code.append("List<Integer> tmp = new ArrayList<Integer>();");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < i.vsp().size(); j++) {");
    code.append("\n\t\t\t");
    code.append("tmp.add(j);");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("ir.add(tmp);");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());");
    code.append("\n\t");
    code.append("for (int i = 0; i < cp.size(); i++) {");
    code.append("\n\t\t");
    code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < cp.get(i).size(); j++) {");
    code.append(this.jf.generateHeaderRow());
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("if (isValidCombination(header)) {");
    code.append("\n\t\t\t");
    code.append("List<Object> valueList = new ArrayList<Object>();");
    code.append("\n\t\t\t");
    code.append("for (int j = 0; j < I.size(); j++) {");
    code.append("\n\t\t\t\t");
    code.append("valueList.add(I.get(j).vsp(cp.get(i).get(j)));");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append(("newValue = " + fcallcode));
    code.append("\n\t\t\t");
    code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));");
    code.append("}");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    OutputPort _op = p.getOp();
    boolean _tripleNotEquals = (_op != null);
    if (_tripleNotEquals) {
      String _name_4 = p.getOp().getName();
      String _plus_7 = ("this.NODE_COLLECTION.put(\"" + _name_4);
      String _plus_8 = (_plus_7 + "\", new NodeObject(\"");
      String _name_5 = p.getOp().getName();
      String _plus_9 = (_plus_8 + _name_5);
      String _plus_10 = (_plus_9 + "\", ovsp));");
      code.append(_plus_10);
    } else {
      OutputCPort _ocp = p.getOcp();
      boolean _tripleNotEquals_1 = (_ocp != null);
      if (_tripleNotEquals_1) {
        String _name_6 = p.getOcp().getName();
        String _plus_11 = ("this.NODE_COLLECTION.put(\"" + _name_6);
        String _plus_12 = (_plus_11 + "\", new NodeObject(\"");
        String _name_7 = p.getOcp().getName();
        String _plus_13 = (_plus_12 + _name_7);
        String _plus_14 = (_plus_13 + "\", ovsp));");
        code.append(_plus_14);
      }
    }
    code.append("\n");
    code.append("}");
    code.append("\n\n");
    fdefcode.append(this.he.generateExpressionCode(p.getName(), p.getExpr().getExpr(), inputSet));
    fdefcode.append("\n\t");
    fdefcode.append("}");
    code.append(fdefcode);
    code.append("\n\n");
    return code.toString();
  }
}
