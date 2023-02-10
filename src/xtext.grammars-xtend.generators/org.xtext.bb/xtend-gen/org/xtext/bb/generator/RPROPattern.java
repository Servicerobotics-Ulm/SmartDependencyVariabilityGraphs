package org.xtext.bb.generator;

import BbDvgTcl.AbstractInputPort;
import BbDvgTcl.RPRO;
import java.util.List;
import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class RPROPattern {
  private RPRO rpro;

  private List<AbstractInputPort> inputSet;

  private boolean isPs;

  private MinMaxCode mmc;

  private String code;

  public RPROPattern(final RPRO rpro, final List<AbstractInputPort> inputSet, final boolean isPs) {
    this.rpro = rpro;
    this.inputSet = inputSet;
    this.isPs = isPs;
  }

  public String generate() {
    String _xblockexpression = null;
    {
      String _expr = this.rpro.getExpr().getExpr();
      MinMaxCode _minMaxCode = new MinMaxCode(this.inputSet, _expr);
      this.mmc = _minMaxCode;
      this.mmc.generateCode();
      this.code = "";
      String _xifexpression = null;
      if ((!this.isPs)) {
        String _xblockexpression_1 = null;
        {
          String _code = this.code;
          CharSequence _generatePatternResolution = this.generatePatternResolution();
          this.code = (_code + _generatePatternResolution);
          String _code_1 = this.code;
          CharSequence _generateValueFunction = this.generateValueFunction();
          _xblockexpression_1 = this.code = (_code_1 + _generateValueFunction);
        }
        _xifexpression = _xblockexpression_1;
      } else {
        String _xblockexpression_2 = null;
        {
          String _code = this.code;
          CharSequence _generatePatternResolution2 = this.generatePatternResolution2();
          this.code = (_code + _generatePatternResolution2);
          String _code_1 = this.code;
          CharSequence _generateValueFunction2 = this.generateValueFunction2();
          _xblockexpression_2 = this.code = (_code_1 + _generateValueFunction2);
        }
        _xifexpression = _xblockexpression_2;
      }
      _xblockexpression = _xifexpression;
    }
    return _xblockexpression;
  }

  private CharSequence generatePatternResolution() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("void resolve_");
    String _name = this.rpro.getName();
    _builder.append(_name);
    _builder.append("(List<Node> I) {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("// new");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("Object newValue;");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    String _minMaxCodeForPatternResolution = this.mmc.getMinMaxCodeForPatternResolution();
    _builder.append(_minMaxCodeForPatternResolution, "\t");
    _builder.newLineIfNotEmpty();
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
    _builder.append("}\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < cp.size(); i++) {");
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
    _builder.append("\t\t");
    _builder.append("if (isValidCombination(header)) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("List<Object> valueList = new ArrayList<Object>();");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("for (int j = 0; j < I.size(); j++) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("valueList.add(I.get(j).vsp(cp.get(i).get(j)));");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("newValue = ");
    CharSequence _generateValueFunctionCall = this.generateValueFunctionCall(this.rpro.getName());
    _builder.append(_generateValueFunctionCall, "\t\t\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("this.NODE_COLLECTION.put(\"");
    String _name_1 = this.rpro.getOp().getName();
    _builder.append(_name_1, "\t");
    _builder.append("\", new NodeObject(\"");
    String _name_2 = this.rpro.getOp().getName();
    _builder.append(_name_2, "\t");
    _builder.append("\", ovsp));");
    _builder.newLineIfNotEmpty();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generatePatternResolution2() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("void resolve_");
    String _name = this.rpro.getName();
    _builder.append(_name);
    _builder.append("(List<Node> I) {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("// new 2");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("Map<String,Double> newValue;");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    String _minMaxCodeForPatternResolution = this.mmc.getMinMaxCodeForPatternResolution();
    _builder.append(_minMaxCodeForPatternResolution, "\t");
    _builder.newLineIfNotEmpty();
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
    _builder.append("}\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < cp.size(); i++) {");
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
    _builder.append("\t\t");
    _builder.append("if (isValidCombination(header)) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("List<Object> valueList = new ArrayList<Object>();");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("for (int j = 0; j < I.size(); j++) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("valueList.add(I.get(j).vsp(cp.get(i).get(j)));");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("newValue = ");
    CharSequence _generateValueFunctionCall = this.generateValueFunctionCall(this.rpro.getName());
    _builder.append(_generateValueFunctionCall, "\t\t\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t\t");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Map<String,Double>>(header, newValue));");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("this.NODE_COLLECTION.put(\"");
    String _name_1 = this.rpro.getOpp().getName();
    _builder.append(_name_1, "\t");
    _builder.append("\", new NodePs(\"");
    String _name_2 = this.rpro.getOpp().getName();
    _builder.append(_name_2, "\t");
    _builder.append("\", ovsp));");
    _builder.newLineIfNotEmpty();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generateValueFunction() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("Object operator_");
    String _name = this.rpro.getName();
    _builder.append(_name);
    _builder.append("(List<Object> valueList");
    _builder.newLineIfNotEmpty();
    String _minMaxCodeForValueFunctionDefinition = this.mmc.getMinMaxCodeForValueFunctionDefinition();
    _builder.append(_minMaxCodeForValueFunctionDefinition);
    _builder.newLineIfNotEmpty();
    _builder.append(") {");
    _builder.newLine();
    _builder.append("\t");
    String _generateExpressionCode = Helpers.generateExpressionCode(this.rpro.getName(), this.rpro.getExpr().getExpr(), this.inputSet);
    _builder.append(_generateExpressionCode, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generateValueFunction2() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("Map<String,Double> operator_");
    String _name = this.rpro.getName();
    _builder.append(_name);
    _builder.append("(List<Object> valueList");
    _builder.newLineIfNotEmpty();
    String _minMaxCodeForValueFunctionDefinition = this.mmc.getMinMaxCodeForValueFunctionDefinition();
    _builder.append(_minMaxCodeForValueFunctionDefinition);
    _builder.newLineIfNotEmpty();
    _builder.append(") {");
    _builder.newLine();
    _builder.append("\t");
    String _generateExpressionCodePs = Helpers.generateExpressionCodePs(this.rpro.getName(), this.rpro.getExpr().getExpr(), this.inputSet);
    _builder.append(_generateExpressionCodePs, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generateValueFunctionCall(final String name) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("operator_");
    _builder.append(name);
    _builder.append("(valueList");
    _builder.newLineIfNotEmpty();
    String _minMaxCodeForValueFunctionCall = this.mmc.getMinMaxCodeForValueFunctionCall();
    _builder.append(_minMaxCodeForValueFunctionCall);
    _builder.newLineIfNotEmpty();
    _builder.append(");");
    _builder.newLine();
    return _builder;
  }

  public String getCode() {
    return this.code;
  }
}
