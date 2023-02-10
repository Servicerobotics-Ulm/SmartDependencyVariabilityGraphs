package org.xtext.bb.generator;

import BbDvgTcl.AbstractInputPort;
import BbDvgTcl.Combination;
import BbDvgTcl.CombinationAssignment;
import BbDvgTcl.OutputCPort;
import BbDvgTcl.OutputPort;
import BbDvgTcl.SAPRO;
import java.util.List;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.IntegerRange;

@SuppressWarnings("all")
public class SAPROPattern {
  private SAPRO sapro;

  private List<AbstractInputPort> inputSet;

  private MinMaxCode mmc;

  private String code;

  public SAPROPattern(final SAPRO sapro, final List<AbstractInputPort> inputSet) {
    this.sapro = sapro;
    this.inputSet = inputSet;
  }

  public String generate() {
    String _xblockexpression = null;
    {
      this.code = "";
      String _xifexpression = null;
      CombinationAssignment _ca = this.sapro.getCa();
      boolean _tripleNotEquals = (_ca != null);
      if (_tripleNotEquals) {
        String _code = this.code;
        CharSequence _generatePatternResolutionCombinationAssignment = this.generatePatternResolutionCombinationAssignment();
        _xifexpression = this.code = (_code + _generatePatternResolutionCombinationAssignment);
      } else {
        String _xblockexpression_1 = null;
        {
          String _expr = this.sapro.getExpr().getExpr();
          MinMaxCode _minMaxCode = new MinMaxCode(this.inputSet, _expr);
          this.mmc = _minMaxCode;
          this.mmc.generateCode();
          String _code_1 = this.code;
          CharSequence _generatePatternResolution = this.generatePatternResolution();
          this.code = (_code_1 + _generatePatternResolution);
          String _code_2 = this.code;
          CharSequence _generateValueFunction = this.generateValueFunction();
          _xblockexpression_1 = this.code = (_code_2 + _generateValueFunction);
        }
        _xifexpression = _xblockexpression_1;
      }
      _xblockexpression = _xifexpression;
    }
    return _xblockexpression;
  }

  private CharSequence generatePatternResolution() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("void resolve_");
    String _name = this.sapro.getName();
    _builder.append(_name);
    _builder.append("(List<Node> I) {");
    _builder.newLineIfNotEmpty();
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
    CharSequence _generateValueFunctionCall = this.generateValueFunctionCall(this.sapro.getName());
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
    {
      OutputPort _op = this.sapro.getOp();
      boolean _tripleNotEquals = (_op != null);
      if (_tripleNotEquals) {
        _builder.append("\t");
        _builder.append("this.NODE_COLLECTION.put(\"");
        String _name_1 = this.sapro.getOp().getName();
        _builder.append(_name_1, "\t");
        _builder.append("\", new NodeObject(\"");
        String _name_2 = this.sapro.getOp().getName();
        _builder.append(_name_2, "\t");
        _builder.append("\", ovsp));");
        _builder.newLineIfNotEmpty();
      } else {
        OutputCPort _ocp = this.sapro.getOcp();
        boolean _tripleNotEquals_1 = (_ocp != null);
        if (_tripleNotEquals_1) {
          _builder.append("\t");
          _builder.append("this.NODE_COLLECTION.put(\"");
          String _name_3 = this.sapro.getOcp().getName();
          _builder.append(_name_3, "\t");
          _builder.append("\", new NodeObject(\"");
          String _name_4 = this.sapro.getOcp().getName();
          _builder.append(_name_4, "\t");
          _builder.append("\", ovsp));");
          _builder.newLineIfNotEmpty();
        }
      }
    }
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generatePatternResolutionCombinationAssignment() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("void resolve_");
    String _name = this.sapro.getName();
    _builder.append(_name);
    _builder.append("(List<Node> I) {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("Object newValue;");
    _builder.newLine();
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<List<SimpleEntry<String,Integer>>> header;");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<String,Integer>> headerRow;");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<List<SimpleEntry<String,Integer>>> htmp;");
    _builder.newLine();
    {
      EList<Combination> _combination = this.sapro.getCa().getCombination();
      for(final Combination i : _combination) {
        _builder.append("\t");
        _builder.append("header = new ArrayList<List<SimpleEntry<String,Integer>>>();");
        _builder.newLine();
        {
          int _size = i.getElement().size();
          int _minus = (_size - 1);
          IntegerRange _upTo = new IntegerRange(0, _minus);
          for(final Integer j : _upTo) {
            _builder.append("\t");
            CharSequence _generateHeaderRow = JavaFunctions.generateHeaderRow((j).intValue(), i.getElement().get((j).intValue()).getIndex());
            _builder.append(_generateHeaderRow, "\t");
            _builder.newLineIfNotEmpty();
          }
        }
        _builder.append("\t");
        _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header,");
        double _value = i.getValue().getValue();
        _builder.append(_value, "\t");
        _builder.append("));");
        _builder.newLineIfNotEmpty();
      }
    }
    {
      OutputPort _op = this.sapro.getOp();
      boolean _tripleNotEquals = (_op != null);
      if (_tripleNotEquals) {
        _builder.append("\t");
        _builder.append("this.NODE_COLLECTION.put(\"");
        String _name_1 = this.sapro.getOp().getName();
        _builder.append(_name_1, "\t");
        _builder.append("\", new NodeObject(\"");
        String _name_2 = this.sapro.getOp().getName();
        _builder.append(_name_2, "\t");
        _builder.append("\", ovsp));");
        _builder.newLineIfNotEmpty();
      } else {
        OutputCPort _ocp = this.sapro.getOcp();
        boolean _tripleNotEquals_1 = (_ocp != null);
        if (_tripleNotEquals_1) {
          _builder.append("\t");
          _builder.append("this.NODE_COLLECTION.put(\"");
          String _name_3 = this.sapro.getOcp().getName();
          _builder.append(_name_3, "\t");
          _builder.append("\", new NodeObject(\"");
          String _name_4 = this.sapro.getOcp().getName();
          _builder.append(_name_4, "\t");
          _builder.append("\", ovsp));");
          _builder.newLineIfNotEmpty();
        }
      }
    }
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generateValueFunction() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("Object operator_");
    String _name = this.sapro.getName();
    _builder.append(_name);
    _builder.append("(List<Object> valueList");
    _builder.newLineIfNotEmpty();
    String _minMaxCodeForValueFunctionDefinition = this.mmc.getMinMaxCodeForValueFunctionDefinition();
    _builder.append(_minMaxCodeForValueFunctionDefinition);
    _builder.newLineIfNotEmpty();
    _builder.append(") {");
    _builder.newLine();
    _builder.append("\t");
    String _generateExpressionCode = Helpers.generateExpressionCode(this.sapro.getName(), this.sapro.getExpr().getExpr(), this.inputSet);
    _builder.append(_generateExpressionCode, "\t");
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
