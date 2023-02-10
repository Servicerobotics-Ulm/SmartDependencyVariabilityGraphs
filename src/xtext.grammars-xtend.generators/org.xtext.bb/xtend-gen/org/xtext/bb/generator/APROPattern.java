package org.xtext.bb.generator;

import BbDvgTcl.APRO;
import BbDvgTcl.AbstractInitPort;
import BbDvgTcl.AbstractInputPort;
import BbDvgTcl.Accuracy;
import BbDvgTcl.Combination;
import BbDvgTcl.CombinationAssignment;
import BbDvgTcl.Core;
import BbDvgTcl.Description;
import BbDvgTcl.Equal;
import BbDvgTcl.Expression;
import BbDvgTcl.InitCPort;
import BbDvgTcl.InputCPort;
import BbDvgTcl.InputPort;
import BbDvgTcl.InternalCOMF;
import BbDvgTcl.InternalInputPort;
import BbDvgTcl.InternalOutputPort;
import BbDvgTcl.OutputPort;
import BbDvgTcl.Precondition;
import com.google.common.base.Objects;
import java.util.ArrayList;
import java.util.List;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.IntegerRange;

@SuppressWarnings("all")
public class APROPattern {
  private APRO apro;

  private List<AbstractInputPort> inputSet;

  private MinMaxCode mmc;

  private String code;

  private final String PRECOND_PREFIX = "resolve_apro_precond_";

  private final String CORE_PREFIX = "resolve_apro_core_";

  private List<List<String>> precondNames;

  private List<String> coreNames;

  private String codeHelp = "";

  private String operatorDefCodeHelp = "";

  private String operatorCallCodeHelp = "";

  private boolean multiRobot;

  public APROPattern(final APRO apro, final List<AbstractInputPort> inputSet, final boolean multiRobot) {
    this.apro = apro;
    this.inputSet = inputSet;
    this.multiRobot = multiRobot;
    ArrayList<List<String>> _arrayList = new ArrayList<List<String>>();
    this.precondNames = _arrayList;
    ArrayList<String> _arrayList_1 = new ArrayList<String>();
    this.coreNames = _arrayList_1;
    for (int i = 0; (i < this.apro.getDescription().size()); i++) {
      {
        List<String> names = new ArrayList<String>();
        Precondition _precond = this.apro.getDescription().get(i).getPrecond();
        boolean _tripleNotEquals = (_precond != null);
        if (_tripleNotEquals) {
          for (int j = 0; (j < this.apro.getDescription().get(i).getPrecond().getInternalcomf().size()); j++) {
            String _name = this.apro.getName();
            String _plus = (this.PRECOND_PREFIX + _name);
            String _plus_1 = (_plus + "_");
            String _plus_2 = (_plus_1 + Integer.valueOf(i));
            String _plus_3 = (_plus_2 + "_");
            String _plus_4 = (_plus_3 + Integer.valueOf(j));
            names.add(_plus_4);
          }
          this.precondNames.add(names);
        }
        String _name = this.apro.getName();
        String _plus = (this.CORE_PREFIX + _name);
        String _plus_1 = (_plus + "_");
        String _plus_2 = (_plus_1 + Integer.valueOf(i));
        this.coreNames.add(_plus_2);
      }
    }
  }

  public String generate() {
    String _xblockexpression = null;
    {
      this.code = "";
      String callCode = "";
      for (int i = 0; (i < this.apro.getDescription().size()); i++) {
        {
          String _code = this.code;
          String _generateDescriptionResolution = this.generateDescriptionResolution(this.apro.getDescription().get(i), i, this.inputSet);
          this.code = (_code + _generateDescriptionResolution);
          String _code_1 = this.code;
          this.code = (_code_1 + "\n");
          String _callCode = callCode;
          CharSequence _generateDescriptionCall = this.generateDescriptionCall(this.apro.getDescription().get(i), i);
          callCode = (_callCode + _generateDescriptionCall);
          String _callCode_1 = callCode;
          callCode = (_callCode_1 + "\n");
        }
      }
      String _code = this.code;
      CharSequence _generatePatternResolution = this.generatePatternResolution(callCode);
      _xblockexpression = this.code = (_code + _generatePatternResolution);
    }
    return _xblockexpression;
  }

  private CharSequence generateDescriptionCall(final Description d, final int index) {
    StringConcatenation _builder = new StringConcatenation();
    {
      Precondition _precond = d.getPrecond();
      boolean _tripleNotEquals = (_precond != null);
      if (_tripleNotEquals) {
        {
          int _size = d.getPrecond().getInternalcomf().size();
          int _minus = (_size - 1);
          IntegerRange _upTo = new IntegerRange(0, _minus);
          for(final Integer i : _upTo) {
            EObject tmp = d.getPrecond().getInternalcomf().get((i).intValue()).getIip().getInternalportref();
            _builder.newLineIfNotEmpty();
            InputCPort tmpc = d.getPrecond().getInternalcomf().get((i).intValue()).getIcp();
            _builder.newLineIfNotEmpty();
            EObject tmpco = tmpc.getOutputcport();
            _builder.newLineIfNotEmpty();
            {
              if ((tmpco instanceof InitCPort)) {
                String _generateLeaf = Leafs.generateLeaf(((AbstractInitPort)tmpco));
                _builder.append(_generateLeaf);
                _builder.append("\t");
                _builder.newLineIfNotEmpty();
              }
            }
            {
              if ((tmp instanceof InputPort)) {
                _builder.append("params = new ArrayList<Node>();");
                _builder.newLine();
                _builder.append("params.add(this.NODE_COLLECTION.get(\"");
                String _name = ((InputPort)tmp).getOutputport().getName();
                _builder.append(_name);
                _builder.append("\"));");
                _builder.newLineIfNotEmpty();
                _builder.append("params.add(this.NODE_COLLECTION.get(\"");
                String _name_1 = tmpc.getOutputcport().getName();
                _builder.append(_name_1);
                _builder.append("\"));");
                _builder.newLineIfNotEmpty();
                String _get = this.precondNames.get(index).get((i).intValue());
                _builder.append(_get);
                _builder.append("(params);");
                _builder.newLineIfNotEmpty();
              }
            }
          }
        }
      }
    }
    _builder.newLine();
    _builder.append("params = new ArrayList<Node>();");
    _builder.newLine();
    {
      EList<InternalInputPort> _iip = d.getCore().getIip();
      for(final InternalInputPort i_1 : _iip) {
        EObject tmp_1 = i_1.getInternalportref();
        _builder.newLineIfNotEmpty();
        {
          if ((tmp_1 instanceof InputPort)) {
            _builder.append("params.add(this.NODE_COLLECTION.get(\"");
            String _name_2 = ((InputPort)tmp_1).getOutputport().getName();
            _builder.append(_name_2);
            _builder.append("\"));");
            _builder.newLineIfNotEmpty();
          } else {
            if ((tmp_1 instanceof InternalOutputPort)) {
              _builder.append("params.add(this.NODE_COLLECTION.get(\"");
              String _name_3 = ((InternalOutputPort)tmp_1).getName();
              _builder.append(_name_3);
              _builder.append("\"));");
              _builder.newLineIfNotEmpty();
            }
          }
        }
      }
    }
    _builder.newLine();
    {
      if (this.multiRobot) {
        String _get_1 = this.coreNames.get(index);
        _builder.append(_get_1);
        _builder.append("(IObsolete);");
        _builder.newLineIfNotEmpty();
      } else {
        String _get_2 = this.coreNames.get(index);
        _builder.append(_get_2);
        _builder.append("(params);");
        _builder.newLineIfNotEmpty();
      }
    }
    return _builder;
  }

  private CharSequence generatePatternResolution(final String descriptionCalls) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("void resolve_");
    String _name = this.apro.getName();
    _builder.append(_name);
    _builder.append("(List<Node> IObsolete) {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("NodeObject nodeObject;");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<Object> leafValues;");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<Node> params;");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append(descriptionCalls, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.newLine();
    {
      int _size = this.apro.getDescription().size();
      boolean _greaterThan = (_size > 1);
      if (_greaterThan) {
        _builder.append("\t");
        _builder.append("List<Node> I = new ArrayList<Node>();");
        _builder.newLine();
        {
          int _size_1 = this.apro.getDescription().size();
          int _minus = (_size_1 - 1);
          IntegerRange _upTo = new IntegerRange(0, _minus);
          for(final Integer i : _upTo) {
            _builder.append("\t");
            _builder.append("I.add(this.NODE_COLLECTION.get(\"");
            String _name_1 = this.apro.getDescription().get((i).intValue()).getCore().getIop().getName();
            _builder.append(_name_1, "\t");
            _builder.append("\"));");
            _builder.newLineIfNotEmpty();
          }
        }
        _builder.append("\t");
        _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("Object newValue;");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("for (int i = 0; i < I.size(); i++) {");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t");
        _builder.append("for (int j = 0; j < I.get(i).vsp().size(); j++) {");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t");
        _builder.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t");
        _builder.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t");
        _builder.append("headerRow.add(new SimpleEntry<String, Integer>(I.get(i).name(), j));");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t");
        _builder.append("if (I.get(i).header(j) != null) {");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t\t");
        _builder.append("List<List<SimpleEntry<String,Integer>>> htmp = I.get(i).header(j);");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t\t");
        _builder.append("for (List<SimpleEntry<String,Integer>> row : htmp) {");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t\t\t");
        _builder.append("for (SimpleEntry<String,Integer> entry : row) {");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t\t\t\t");
        _builder.append("headerRow.add(entry);");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t\t\t");
        _builder.append("}");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t\t");
        _builder.append("}");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t");
        _builder.append("}");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t");
        _builder.append("header.add(headerRow);");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t");
        _builder.append("newValue = I.get(i).vsp(j);");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t\t");
        _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));");
        _builder.newLine();
        {
          OutputPort _op = this.apro.getOp();
          boolean _tripleNotEquals = (_op != null);
          if (_tripleNotEquals) {
            _builder.append("\t");
            _builder.append("\t\t");
            _builder.append("this.NODE_COLLECTION.put(\"");
            String _name_2 = this.apro.getOp().getName();
            _builder.append(_name_2, "\t\t\t");
            _builder.append("\", new NodeObject(\"");
            String _name_3 = this.apro.getOp().getName();
            _builder.append(_name_3, "\t\t\t");
            _builder.append("\", ovsp));");
            _builder.newLineIfNotEmpty();
          } else {
            _builder.append("\t");
            _builder.append("\t\t");
            _builder.append("this.NODE_COLLECTION.put(\"");
            String _name_4 = this.apro.getOcp().getName();
            _builder.append(_name_4, "\t\t\t");
            _builder.append("\", new NodeObject(\"");
            String _name_5 = this.apro.getOcp().getName();
            _builder.append(_name_5, "\t\t\t");
            _builder.append("\", ovsp));");
            _builder.newLineIfNotEmpty();
          }
        }
        _builder.append("\t");
        _builder.append("\t");
        _builder.append("}\t\t\t\t");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("}");
        _builder.newLine();
      } else {
        {
          OutputPort _op_1 = this.apro.getOp();
          boolean _tripleNotEquals_1 = (_op_1 != null);
          if (_tripleNotEquals_1) {
            _builder.append("\t");
            _builder.append("this.NODE_COLLECTION.put(\"");
            String _name_6 = this.apro.getOp().getName();
            _builder.append(_name_6, "\t");
            _builder.append("\", new NodeObject(\"");
            String _name_7 = this.apro.getOp().getName();
            _builder.append(_name_7, "\t");
            _builder.append("\", this.NODE_COLLECTION.get(\"");
            String _name_8 = this.apro.getDescription().get(0).getCore().getIop().getName();
            _builder.append(_name_8, "\t");
            _builder.append("\").vsp()));");
            _builder.newLineIfNotEmpty();
          } else {
            _builder.append("\t");
            _builder.append("this.NODE_COLLECTION.put(\"");
            String _name_9 = this.apro.getOcp().getName();
            _builder.append(_name_9, "\t");
            _builder.append("\", new NodeObject(\"");
            String _name_10 = this.apro.getOcp().getName();
            _builder.append(_name_10, "\t");
            _builder.append("\", this.NODE_COLLECTION.get(\"");
            String _name_11 = this.apro.getDescription().get(0).getCore().getIop().getName();
            _builder.append(_name_11, "\t");
            _builder.append("\").vsp()));");
            _builder.newLineIfNotEmpty();
          }
        }
      }
    }
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private String generateDescriptionResolution(final Description d, final int index, final List<AbstractInputPort> inputSet) {
    String code = "";
    Precondition _precond = d.getPrecond();
    boolean _tripleNotEquals = (_precond != null);
    if (_tripleNotEquals) {
      for (int i = 0; (i < d.getPrecond().getInternalcomf().size()); i++) {
        {
          String _code = code;
          CharSequence _generatePreconditionResolution = this.generatePreconditionResolution(d.getPrecond().getInternalcomf().get(i), this.precondNames.get(index).get(i));
          code = (_code + _generatePreconditionResolution);
          String _code_1 = code;
          code = (_code_1 + "\n");
        }
      }
    }
    this.codeHelp = "";
    this.operatorDefCodeHelp = "";
    this.operatorCallCodeHelp = "";
    Expression _expr = d.getCore().getExpr();
    boolean _tripleNotEquals_1 = (_expr != null);
    if (_tripleNotEquals_1) {
      String _code = code;
      CharSequence _generateCoreResolutionWithExpr = this.generateCoreResolutionWithExpr(d.getCore(), this.coreNames.get(index), inputSet);
      code = (_code + _generateCoreResolutionWithExpr);
    } else {
      CombinationAssignment _ca = d.getCore().getCa();
      boolean _tripleNotEquals_2 = (_ca != null);
      if (_tripleNotEquals_2) {
        String _code_1 = code;
        CharSequence _generateCoreResolutionWithCA = this.generateCoreResolutionWithCA(d.getCore(), this.coreNames.get(index), inputSet);
        code = (_code_1 + _generateCoreResolutionWithCA);
      }
    }
    return code;
  }

  private CharSequence generatePreconditionResolution(final InternalCOMF ic, final String name) {
    CharSequence _xblockexpression = null;
    {
      String wrapperName = "";
      String conversionName = "";
      EObject tmp = ic.getIip().getInternalportref();
      if ((tmp instanceof InputPort)) {
        wrapperName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(((InputPort)tmp).getOutputport().getVe())).get(0);
        conversionName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(((InputPort)tmp).getOutputport().getVe())).get(1);
      } else {
        if ((tmp instanceof InternalOutputPort)) {
          wrapperName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(((InternalOutputPort)tmp).getVe())).get(0);
          conversionName = Helpers.getWrapperAndConversionName(Helpers.getTypeFromVe(((InternalOutputPort)tmp).getVe())).get(1);
        }
      }
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("void ");
      _builder.append(name);
      _builder.append(" (List<Node> I) {");
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
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> toCheckVsp = I.get(0).vsp();");
      _builder.newLine();
      _builder.append("\t");
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
      CharSequence _generateCOMFValueFunction = this.generateCOMFValueFunction(ic, wrapperName, Helpers.getComparisonString(ic.getCo()));
      _builder.append(_generateCOMFValueFunction, "\t\t\t");
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
      _builder.newLine();
      _builder.append("\t");
      _builder.append("this.NODE_COLLECTION.put(\"");
      String _name = ic.getIop().getName();
      _builder.append(_name, "\t");
      _builder.append("\", new NodeObject(\"");
      String _name_1 = ic.getIop().getName();
      _builder.append(_name_1, "\t");
      _builder.append("\", ovsp));");
      _builder.newLineIfNotEmpty();
      _builder.append("} ");
      _builder.newLine();
      _xblockexpression = _builder;
    }
    return _xblockexpression;
  }

  private CharSequence generateCOMFValueFunction(final InternalCOMF ic, final String wrapperName, final String comparisonString) {
    StringConcatenation _builder = new StringConcatenation();
    EObject tmp = ic.getCo();
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
    return _builder;
  }

  private void generateHelper(final List<Integer> cdoi, final List<String> cdos, final Core c) {
    List<String> alreadyGenerated = new ArrayList<String>();
    List<String> tmp = Helpers.getSymbolsForComplexDo(c.getExpr().getExpr());
    for (final String i : tmp) {
      boolean _contains = alreadyGenerated.contains(i);
      boolean _not = (!_contains);
      if (_not) {
        int index = Helpers.getTh(i, this.inputSet);
        cdoi.add(Integer.valueOf(index));
        cdos.add(i);
        String _codeHelp = this.codeHelp;
        this.codeHelp = (_codeHelp + (("List<Object> " + i) + ";\n"));
        String _operatorDefCodeHelp = this.operatorDefCodeHelp;
        this.operatorDefCodeHelp = (_operatorDefCodeHelp + (",List<Object>" + i));
        String _operatorCallCodeHelp = this.operatorCallCodeHelp;
        this.operatorCallCodeHelp = (_operatorCallCodeHelp + ("," + i));
        alreadyGenerated.add(i);
      }
    }
  }

  private String generateHelper2(final List<Integer> cdoi, final List<String> cdos, final int i) {
    String code = null;
    String _get = cdos.get(0);
    String _plus = (_get + " = I.get(");
    String _plus_1 = (_plus + Integer.valueOf(i));
    String _plus_2 = (_plus_1 + ").vsp_2(cp.get(i).get(");
    String _plus_3 = (_plus_2 + Integer.valueOf(i));
    String _plus_4 = (_plus_3 + "));");
    code = _plus_4;
    cdoi.remove(0);
    cdos.remove(0);
    return code;
  }

  private CharSequence generateCoreResolutionWithExpr(final Core c, final String name, final List<AbstractInputPort> inputSet) {
    CharSequence _xblockexpression = null;
    {
      List<Integer> cdoi = new ArrayList<Integer>();
      List<String> cdos = new ArrayList<String>();
      this.generateHelper(cdoi, cdos, c);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("void ");
      _builder.append(name);
      _builder.append(" (List<Node> I) {");
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
      _builder.append(this.codeHelp, "\t");
      _builder.newLineIfNotEmpty();
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
      _builder.append("if (i instanceof NodeObjectList) {");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("for (int j = 0; j < i.vsp_2().size(); j++) {");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("tmp.add(j);");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("else if (i instanceof NodeObject) {");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("for (int j = 0; j < i.vsp().size(); j++) {");
      _builder.newLine();
      _builder.append("\t\t\t\t");
      _builder.append("tmp.add(j);");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("ir.add(tmp);");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("}");
      _builder.newLine();
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
      _builder.append("List<Object> valueList = new ArrayList<Object>();");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.newLine();
      {
        int _size = inputSet.size();
        int _minus = (_size - 1);
        IntegerRange _upTo = new IntegerRange(0, _minus);
        for(final Integer i : _upTo) {
          {
            if (((cdoi.size() > 0) && Objects.equal(cdoi.get(0), i))) {
              _builder.append("\t\t");
              _builder.newLine();
              _builder.append("\t\t");
              String _generateHelper2 = this.generateHelper2(cdoi, cdos, (i).intValue());
              _builder.append(_generateHelper2, "\t\t");
              _builder.newLineIfNotEmpty();
            } else {
              _builder.append("\t\t");
              _builder.append("valueList.add(I.get(");
              _builder.append(i, "\t\t");
              _builder.append(").vsp(cp.get(i).get(");
              _builder.append(i, "\t\t");
              _builder.append(")));");
              _builder.newLineIfNotEmpty();
            }
          }
        }
      }
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("if (isValidCombination(header)) {");
      _builder.newLine();
      _builder.append("\t\t\t");
      _builder.append("newValue = operator_");
      _builder.append(name, "\t\t\t");
      _builder.append("(valueList ");
      _builder.append(this.operatorCallCodeHelp, "\t\t\t");
      _builder.append(");");
      _builder.newLineIfNotEmpty();
      _builder.append("\t\t\t");
      _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(header, newValue));");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("\t");
      _builder.append("this.NODE_COLLECTION.put(\"");
      String _name = c.getIop().getName();
      _builder.append(_name, "\t");
      _builder.append("\", new NodeObject(\"");
      String _name_1 = c.getIop().getName();
      _builder.append(_name_1, "\t");
      _builder.append("\", ovsp));");
      _builder.newLineIfNotEmpty();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("Object operator_");
      _builder.append(name);
      _builder.append("(List<Object> valueList ");
      _builder.append(this.operatorDefCodeHelp);
      _builder.append(") {");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      String _generateExpressionCode = Helpers.generateExpressionCode(name, c.getExpr().getExpr(), inputSet);
      _builder.append(_generateExpressionCode, "\t");
      _builder.newLineIfNotEmpty();
      _builder.append("}");
      _builder.newLine();
      _xblockexpression = _builder;
    }
    return _xblockexpression;
  }

  private CharSequence generateCoreResolutionWithCA(final Core c, final String name, final List<AbstractInputPort> inputSet) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("void ");
    _builder.append(name);
    _builder.append(" (List<Node> I) {");
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
      EList<Combination> _combination = c.getCa().getCombination();
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
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("this.NODE_COLLECTION.put(\"");
    String _name = c.getIop().getName();
    _builder.append(_name, "\t");
    _builder.append("\", new NodeObject(\"");
    String _name_1 = c.getIop().getName();
    _builder.append(_name_1, "\t");
    _builder.append("\", ovsp));\t");
    _builder.newLineIfNotEmpty();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public String getCode() {
    return this.code;
  }
}
