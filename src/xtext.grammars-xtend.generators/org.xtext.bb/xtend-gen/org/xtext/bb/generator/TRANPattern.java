package org.xtext.bb.generator;

import BbDvgTcl.Direction;
import BbDvgTcl.LinearNormalization;
import BbDvgTcl.NormalizationCOp;
import BbDvgTcl.TRAN;
import com.google.common.base.Objects;
import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class TRANPattern {
  private TRAN tran;

  private String code;

  public TRANPattern(final TRAN tran) {
    this.tran = tran;
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
    String _name = this.tran.getName();
    _builder.append(_name);
    _builder.append("(List<Node> I) {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("Object newValue = 0.0;");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<Double> s = new ArrayList<Double>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsptmp = I.get(0).vsp();");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < vsptmp.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("s.add(((Number)vsptmp.get(i).getValue()).doubleValue());");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < vsptmp.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(0).name(),i));");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("if (vsptmp.get(i).getKey() != null) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("List<List<SimpleEntry<String,Integer>>> htmp = vsptmp.get(i).getKey();");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("for (List<SimpleEntry<String,Integer>> row : htmp) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("for (SimpleEntry<String,Integer> entry : row) {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("headerRow.add(entry);");
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
    _builder.append("header.add(headerRow);");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.newLine();
    _builder.append("\t\t");
    CharSequence _generateValueFunction = this.generateValueFunction();
    _builder.append(_generateValueFunction, "\t\t");
    _builder.newLineIfNotEmpty();
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("this.NODE_COLLECTION.put(\"");
    String _name_1 = this.tran.getOp().getName();
    _builder.append(_name_1, "\t");
    _builder.append("\", new NodeObject(\"");
    String _name_2 = this.tran.getOp().getName();
    _builder.append(_name_2, "\t");
    _builder.append("\", ovsp));");
    _builder.newLineIfNotEmpty();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generateValueFunction() {
    StringConcatenation _builder = new StringConcatenation();
    NormalizationCOp nf = this.tran.getNo();
    _builder.newLineIfNotEmpty();
    {
      if ((nf instanceof LinearNormalization)) {
        {
          if (((((LinearNormalization)nf).getMin() == null) && (((LinearNormalization)nf).getMax() == null))) {
            _builder.append("double num = Collections.max(s)-((Number)vsptmp.get(i).getValue()).doubleValue();");
            _builder.newLine();
            _builder.append("double den = Collections.max(s)-Collections.min(s);");
            _builder.newLine();
          } else {
            if (((((LinearNormalization)nf).getMin() != null) && (((LinearNormalization)nf).getMax() == null))) {
              _builder.append("double num = Collections.max(s)-((Number)vsptmp.get(i).getValue()).doubleValue();");
              _builder.newLine();
              _builder.append("double den = Collections.max(s)-");
              String _string = Double.valueOf(((LinearNormalization)nf).getMin().getValue()).toString();
              _builder.append(_string);
              _builder.append(";");
              _builder.newLineIfNotEmpty();
            } else {
              if (((((LinearNormalization)nf).getMin() == null) && (((LinearNormalization)nf).getMax() != null))) {
                _builder.append("double num = ");
                String _string_1 = Double.valueOf(((LinearNormalization)nf).getMax().getValue()).toString();
                _builder.append(_string_1);
                _builder.append("-((Number)vsptmp.get(i).getValue()).doubleValue();");
                _builder.newLineIfNotEmpty();
                _builder.append("double den = ");
                String _string_2 = Double.valueOf(((LinearNormalization)nf).getMax().getValue()).toString();
                _builder.append(_string_2);
                _builder.append("-Collections.min(s);");
                _builder.newLineIfNotEmpty();
              } else {
                _builder.append("double num = ");
                String _string_3 = Double.valueOf(((LinearNormalization)nf).getMax().getValue()).toString();
                _builder.append(_string_3);
                _builder.append("-((Number)vsptmp.get(i).getValue()).doubleValue();");
                _builder.newLineIfNotEmpty();
                _builder.append("double den = ");
                String _string_4 = Double.valueOf(((LinearNormalization)nf).getMax().getValue()).toString();
                _builder.append(_string_4);
                _builder.append("-");
                String _string_5 = Double.valueOf(((LinearNormalization)nf).getMin().getValue()).toString();
                _builder.append(_string_5);
                _builder.append(";");
                _builder.newLineIfNotEmpty();
              }
            }
          }
        }
        _builder.newLine();
        {
          Direction _direction = ((LinearNormalization)nf).getDirection();
          boolean _equals = Objects.equal(_direction, Direction.DEC);
          if (_equals) {
            _builder.append("newValue = num/den;");
            _builder.newLine();
          } else {
            _builder.append("newValue = 1-(num/den);");
            _builder.newLine();
          }
        }
      }
    }
    return _builder;
  }

  public String getCode() {
    return this.code;
  }
}
