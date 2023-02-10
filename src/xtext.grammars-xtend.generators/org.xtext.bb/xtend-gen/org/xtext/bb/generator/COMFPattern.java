package org.xtext.bb.generator;

import BbDvgTcl.Accuracy;
import BbDvgTcl.COMF;
import BbDvgTcl.Equal;
import com.google.common.base.Objects;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class COMFPattern {
  private COMF comf;

  private String code;

  public COMFPattern(final COMF comf) {
    this.comf = comf;
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
    CharSequence _xblockexpression = null;
    {
      String wrapperName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(this.comf.getIp().getOutputport().getVe())).get(0);
      String conversionName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(this.comf.getIp().getOutputport().getVe())).get(1);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("void resolve_");
      String _name = this.comf.getName();
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
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<");
      _builder.append(wrapperName, "\t");
      _builder.append("> toCheck = new ArrayList<");
      _builder.append(wrapperName, "\t");
      _builder.append(">();");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.append("List<");
      _builder.append(wrapperName, "\t");
      _builder.append("> filter = new ArrayList<");
      _builder.append(wrapperName, "\t");
      _builder.append(">();");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> toCheckVsp = I.get(0).vsp();");
      _builder.newLine();
      _builder.newLine();
      _builder.append("\t");
      _builder.append("for (int i = 0; i < toCheckVsp.size(); i++) {");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("toCheck.add(((");
      _builder.append(wrapperName, "\t\t");
      _builder.append(")toCheckVsp.get(i).getValue()).");
      _builder.append(conversionName, "\t\t");
      _builder.append("());");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> filterVsp = I.get(1).vsp();");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<List<SimpleEntry<String,Integer>>> htmp;");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("for (int i = 0; i < filterVsp.size(); i++) {");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("filter.add(((");
      _builder.append(wrapperName, "\t\t");
      _builder.append(")filterVsp.get(i).getValue()).");
      _builder.append(conversionName, "\t\t");
      _builder.append("());");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("for (int i = 0; i < toCheckVsp.size(); i++) {");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("for (int j = 0; j < filterVsp.size(); j++) {");
      _builder.newLine();
      _builder.append("\t\t\t");
      CharSequence _generateValueFunction = this.generateValueFunction();
      _builder.append(_generateValueFunction, "\t\t\t");
      _builder.newLineIfNotEmpty();
      _builder.append("\t\t\t");
      _builder.append("{");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(0).name(),i));");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("if (toCheckVsp.get(i).getKey() != null) {");
      _builder.newLine();
      _builder.append("\t\t\t\t\t");
      _builder.append("htmp = toCheckVsp.get(i).getKey();");
      _builder.newLine();
      _builder.append("\t\t\t\t\t");
      _builder.append("for (List<SimpleEntry<String,Integer>> row : htmp) {");
      _builder.newLine();
      _builder.append("\t\t\t\t\t\t");
      _builder.append("for (SimpleEntry<String,Integer> entry : row) {");
      _builder.newLine();
      _builder.append("\t\t\t\t\t\t\t");
      _builder.append("headerRow.add(entry);");
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
      _builder.append("\t\t\t\t");
      _builder.append("header.add(headerRow);");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("headerRow = new ArrayList<SimpleEntry<String,Integer>>();");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(1).name(),j));");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("if (filterVsp.get(j).getKey() != null) {");
      _builder.newLine();
      _builder.append("\t\t\t\t\t");
      _builder.append("htmp = filterVsp.get(j).getKey();");
      _builder.newLine();
      _builder.append("\t\t\t\t\t");
      _builder.append("for (List<SimpleEntry<String,Integer>> row : htmp) {");
      _builder.newLine();
      _builder.append("\t\t\t\t\t\t");
      _builder.append("for (SimpleEntry<String,Integer> entry : row) {");
      _builder.newLine();
      _builder.append("\t\t\t\t\t\t\t");
      _builder.append("headerRow.add(entry);");
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
      _builder.append("\t\t\t\t");
      _builder.append("header.add(headerRow);");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("newValue = newValue = toCheck.get(i);");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));");
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
      _builder.append("this.NODE_COLLECTION.put(\"");
      String _name_1 = this.comf.getOp().getName();
      _builder.append(_name_1, "\t");
      _builder.append("\", new NodeObject(\"");
      String _name_2 = this.comf.getOp().getName();
      _builder.append(_name_2, "\t");
      _builder.append("\", ovsp));");
      _builder.newLineIfNotEmpty();
      _builder.append("}");
      _builder.newLine();
      _xblockexpression = _builder;
    }
    return _xblockexpression;
  }

  private CharSequence generateValueFunction() {
    CharSequence _xblockexpression = null;
    {
      String wrapperName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(this.comf.getIp().getOutputport().getVe())).get(0);
      String comparisonString = Helpers.getComparisonString(this.comf.getCo());
      StringConcatenation _builder = new StringConcatenation();
      EObject tmp = this.comf.getCo();
      _builder.newLineIfNotEmpty();
      {
        if ((tmp instanceof Equal)) {
          {
            Accuracy _accuracy = ((Equal)tmp).getAccuracy();
            boolean _tripleEquals = (_accuracy == null);
            if (_tripleEquals) {
              _builder.append("if (toCheck.get(i) ");
              _builder.append(comparisonString);
              _builder.append(" filter.get(j))");
              _builder.newLineIfNotEmpty();
            } else {
              _builder.append("if (Math.abs(toCheck.get(i)-filter.get(j)) ");
              _builder.append(comparisonString);
              _builder.append(")");
              _builder.newLineIfNotEmpty();
              {
                if (((Objects.equal(wrapperName, "Boolean") || Objects.equal(wrapperName, "String")) || Objects.equal(wrapperName, "Integer"))) {
                  System.err.println("WARNING: Accuracy for Boolean, String and Integer is ignored!");
                  _builder.newLineIfNotEmpty();
                }
              }
            }
          }
        } else {
          _builder.append("if (toCheck.get(i) ");
          _builder.append(comparisonString);
          _builder.append(" filter.get(j))");
          _builder.newLineIfNotEmpty();
          {
            if ((Objects.equal(wrapperName, "Boolean") || Objects.equal(wrapperName, "String"))) {
              System.err.println("ERROR: LessThan and GreaterThan undefined for Boolean and String!");
              _builder.newLineIfNotEmpty();
            }
          }
        }
      }
      _xblockexpression = _builder;
    }
    return _xblockexpression;
  }

  public String getCode() {
    return this.code;
  }
}
