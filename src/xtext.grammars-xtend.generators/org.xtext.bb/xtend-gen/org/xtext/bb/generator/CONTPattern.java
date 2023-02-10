package org.xtext.bb.generator;

import BbDvgTcl.CONT;
import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class CONTPattern {
  private CONT cont;

  private String code;

  public CONTPattern(final CONT cont) {
    this.cont = cont;
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
    String _name = this.cont.getName();
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
    _builder.append("Map<String, Double> valueList = new HashMap<String, Double>();");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("Map<String, Double> ps = new HashMap<String, Double>();");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("for (int j = 0; j < I.size(); j++) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("if (I.get(j) instanceof NodePs) {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> res = I.get(j).vsp();");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("ps = res.get(cp.get(i).get(j)).getValue();");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("else {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> res = I.get(j).vsp();");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("valueList.put(I.get(j).name(), ((Number) res.get(cp.get(i).get(j)).getValue()).doubleValue());");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("for (Map.Entry<String, Double> entry : ps.entrySet()) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("newValue += ps.get(entry.getKey()) * valueList.get(entry.getKey());");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("this.NODE_COLLECTION.put(\"");
    String _name_1 = this.cont.getOp().getName();
    _builder.append(_name_1, "\t");
    _builder.append("\", new NodeObject(\"");
    String _name_2 = this.cont.getOp().getName();
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
