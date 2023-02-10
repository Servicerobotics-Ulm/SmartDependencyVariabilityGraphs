package org.xtext.bb.generator;

import BbDvgTcl.AGGR;
import BbDvgTcl.MAGR;
import java.util.ArrayList;
import java.util.List;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.IntegerRange;

@SuppressWarnings("all")
public class MAGRPattern {
  private MAGR magr;

  private List<String> aggrName;

  private String code;

  public MAGRPattern(final MAGR magr) {
    this.magr = magr;
    ArrayList<String> _arrayList = new ArrayList<String>();
    this.aggrName = _arrayList;
    for (int i = 0; (i < this.magr.getAggr().size()); i++) {
      String _name = this.magr.getName();
      String _plus = ("resolve_" + _name);
      String _plus_1 = (_plus + "_");
      String _plus_2 = (_plus_1 + Integer.valueOf(i));
      this.aggrName.add(_plus_2);
    }
  }

  public void generate() {
    this.code = "";
    String _code = this.code;
    CharSequence _generatePatternResolution = this.generatePatternResolution();
    this.code = (_code + _generatePatternResolution);
    String _code_1 = this.code;
    this.code = (_code_1 + "\n");
    for (int i = 0; (i < this.magr.getAggr().size()); i++) {
      {
        String _code_2 = this.code;
        CharSequence _generateAggrResolution = this.generateAggrResolution(this.magr.getAggr().get(i), this.aggrName.get(i), this.magr.getName());
        this.code = (_code_2 + _generateAggrResolution);
        String _code_3 = this.code;
        this.code = (_code_3 + "\n");
      }
    }
  }

  private CharSequence generatePatternResolution() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("void resolve_");
    String _name = this.magr.getName();
    _builder.append(_name);
    _builder.append("(List<List<Node>> I) {");
    _builder.newLineIfNotEmpty();
    {
      int _size = this.magr.getAggr().size();
      int _minus = (_size - 1);
      IntegerRange _upTo = new IntegerRange(0, _minus);
      for(final Integer i : _upTo) {
        _builder.append("\t");
        String _get = this.aggrName.get((i).intValue());
        _builder.append(_get, "\t");
        _builder.append("(I.get(");
        _builder.append(i, "\t");
        _builder.append("));");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generateAggrResolution(final AGGR aggr, final String aggrName, final String magrName) {
    CharSequence _xblockexpression = null;
    {
      String vsp = "";
      String obj = "";
      boolean _isComplexDo = Helpers.isComplexDo(aggr.getOp().getVe());
      if (_isComplexDo) {
        vsp = "vsp_2";
        obj = "List<Object>";
      } else {
        vsp = "vsp";
        obj = "Object";
      }
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("void ");
      _builder.append(aggrName);
      _builder.append(" (List<Node> I) {");
      _builder.newLineIfNotEmpty();
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
      _builder.append("SimpleEntry<String, Integer> fid = new SimpleEntry<String, Integer>(\"");
      _builder.append(magrName, "\t\t");
      _builder.append("\", i);");
      _builder.newLineIfNotEmpty();
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
      _builder.newLine();
      {
        boolean _isComplexDo_1 = Helpers.isComplexDo(aggr.getOp().getVe());
        if (_isComplexDo_1) {
          _builder.append("\t");
          _builder.append("nodeObjectList = new NodeObjectList(\"");
          String _name = aggr.getOp().getName();
          _builder.append(_name, "\t");
          _builder.append("\");");
          _builder.newLineIfNotEmpty();
          _builder.append("\t");
          _builder.append("nodeObjectList.assignVSP_2(ovsp);");
          _builder.newLine();
          _builder.append("\t");
          _builder.append("this.NODE_COLLECTION.put(\"");
          String _name_1 = aggr.getOp().getName();
          _builder.append(_name_1, "\t");
          _builder.append("\", nodeObjectList);");
          _builder.newLineIfNotEmpty();
        } else {
          _builder.append("\t");
          _builder.append("this.NODE_COLLECTION.put(\"");
          String _name_2 = aggr.getOp().getName();
          _builder.append(_name_2, "\t");
          _builder.append("\", new NodeObject(\"");
          String _name_3 = aggr.getOp().getName();
          _builder.append(_name_3, "\t");
          _builder.append("\", ovsp));");
          _builder.newLineIfNotEmpty();
        }
      }
      _builder.append("}");
      _builder.newLine();
      _xblockexpression = _builder;
    }
    return _xblockexpression;
  }

  public String getCode() {
    return this.code;
  }
}
