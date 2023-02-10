package org.xtext.bb.generator;

import BbDvgTcl.EPROD;
import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class EPRODPattern {
  private EPROD eprod;

  private String code;

  public EPRODPattern(final EPROD eprod) {
    this.eprod = eprod;
  }

  public String generate() {
    String _xblockexpression = null;
    {
      this.code = "";
      String _code = this.code;
      CharSequence _generatePatternResolution = this.generatePatternResolution();
      _xblockexpression = this.code = (_code + _generatePatternResolution);
    }
    return _xblockexpression;
  }

  private CharSequence generatePatternResolution() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("void resolve_");
    String _name = this.eprod.getName();
    _builder.append(_name);
    _builder.append("(List<Node> I) {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("double newValue = 0.0;");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (Node i : I) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("List<Integer> tmp = new ArrayList<Integer>();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (int j = 0; j < i.vsp().size(); j++) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("tmp.add(j);");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("ir.add(tmp);");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < cp.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("newValue = 0.0;");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (int j = 0; j < cp.get(i).size(); j++) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    CharSequence _generateHeaderRow = JavaFunctions.generateHeaderRow();
    _builder.append(_generateHeaderRow, "\t\t\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("if (isValidCombination(header)) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> res = I.get(0).vsp();");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("newValue = ((Number) res.get(cp.get(i).get(0)).getValue()).doubleValue();");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("this.NODE_COLLECTION.put(\"");
    String _name_1 = this.eprod.getOp().getName();
    _builder.append(_name_1, "\t");
    _builder.append("\", new NodeObject(\"");
    String _name_2 = this.eprod.getOp().getName();
    _builder.append(_name_2, "\t");
    _builder.append("\", ovsp));");
    _builder.newLineIfNotEmpty();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public String getCode() {
    return this.code;
  }
}
