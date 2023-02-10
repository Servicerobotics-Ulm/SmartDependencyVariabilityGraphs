package org.xtext.bb.generator;

import BbDvgTcl.Direction;
import BbDvgTcl.LinearNormalization;
import BbDvgTcl.NormalizationCOp;
import BbDvgTcl.PTCC;
import com.google.common.base.Objects;
import java.util.ArrayList;
import java.util.List;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.IntegerRange;

@SuppressWarnings("all")
public class PTCCPattern {
  private final String PARETO_PREFIX = "resolve_ptcc_pf_";

  private final String TRAN_PREFIX = "resolve_ptcc_tran_";

  private String paretoName;

  private List<String> tranNames;

  private PTCC ptcc;

  private String code;

  public PTCCPattern(final PTCC ptcc) {
    this.ptcc = ptcc;
    String _name = this.ptcc.getName();
    String _plus = (this.PARETO_PREFIX + _name);
    this.paretoName = _plus;
    ArrayList<String> _arrayList = new ArrayList<String>();
    this.tranNames = _arrayList;
    for (int i = 0; (i < this.ptcc.getNo().size()); i++) {
      String _name_1 = this.ptcc.getIp().get(i).getName();
      String _plus_1 = (this.TRAN_PREFIX + _name_1);
      this.tranNames.add(_plus_1);
    }
  }

  public String generate() {
    String _xblockexpression = null;
    {
      this.code = "";
      String _code = this.code;
      CharSequence _generateParetoFilterResolution = this.generateParetoFilterResolution();
      this.code = (_code + _generateParetoFilterResolution);
      String _code_1 = this.code;
      this.code = (_code_1 + "\n");
      for (int i = 0; (i < this.ptcc.getNo().size()); i++) {
        String _code_2 = this.code;
        CharSequence _generateTransformation = this.generateTransformation(this.tranNames.get(i), this.ptcc.getNo().get(i));
        this.code = (_code_2 + _generateTransformation);
      }
      String _code_2 = this.code;
      this.code = (_code_2 + "\n");
      String _code_3 = this.code;
      CharSequence _generatePatternResolution = this.generatePatternResolution();
      _xblockexpression = this.code = (_code_3 + _generatePatternResolution);
    }
    return _xblockexpression;
  }

  private CharSequence generateParetoFilterResolution() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> ");
    String _name = this.ptcc.getName();
    _builder.append(_name);
    _builder.append(" (List<Node> I) {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("if (check) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (int i = 0; i < I.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("if (I.get(i).header(0) != null) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("headerList.add(I.get(i).header(0));");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("if (headerList.size() > 0 && !isSAM(headerList)) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("System.err.println(\"ERROR: There is no SAM-Situation for PTCC pattern ");
    String _name_1 = this.ptcc.getName();
    _builder.append(_name_1, "\t\t\t");
    _builder.append("!\");");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcomb = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcombpf = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("double newValue = 0.0;");
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
    _builder.append("r.add(tmp);");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < cp.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> T = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
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
    _builder.append("\t\t\t");
    _builder.append("T.add(I.get(j).slot(cp.get(i).get(j)));");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("if (isValidCombination(header)) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("vcomb.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>(header,T));");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<Boolean> max = new ArrayList<Boolean>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    {
      int _size = this.ptcc.getMax().size();
      int _minus = (_size - 1);
      IntegerRange _upTo = new IntegerRange(0, _minus);
      for(final Integer i : _upTo) {
        _builder.append("\t");
        _builder.append("max.add(");
        Boolean _get = this.ptcc.getMax().get((i).intValue());
        _builder.append(_get, "\t");
        _builder.append(");");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<Boolean> isDominated = new ArrayList<Boolean>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < vcomb.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("isDominated.add(false);");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < vcomb.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (int j = 0; j < vcomb.size(); j++) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("if (i != j && !isDominated.get(i)) {");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> tmp_1 = new ArrayList<>(vcomb.get(i).getValue());");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("tmp_1.remove(tmp_1.size()-1);");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> tmp_2 = new ArrayList<>(vcomb.get(j).getValue());");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("tmp_2.remove(tmp_2.size()-1);");
    _builder.newLine();
    _builder.append("\t\t\t\t");
    _builder.append("if (isDominated(tmp_1,tmp_2,max)) {");
    _builder.newLine();
    _builder.append("\t\t\t\t\t");
    _builder.append("isDominated.set(i,true);");
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
    _builder.append("for (int i = 0; i < isDominated.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("if (!isDominated.get(i)) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("vcombpf.add(vcomb.get(i));");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return vcombpf;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generateTransformation(final String name, final NormalizationCOp nf) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ");
    _builder.append(name);
    _builder.append(" (List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> I) {");
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
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsptmp = I;");
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
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < vsptmp.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    CharSequence _generateValueFunction = this.generateValueFunction(nf);
    _builder.append(_generateValueFunction, "\t\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t\t");
    _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(null, newValue));");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("return ovsp;");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  private CharSequence generateValueFunction(final NormalizationCOp nf) {
    StringConcatenation _builder = new StringConcatenation();
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

  private CharSequence generatePatternResolution() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("void resolve_");
    String _name = this.ptcc.getName();
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
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcombpf = ");
    _builder.append(this.paretoName, "\t");
    _builder.append("(I);");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("List<List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>> R = new ArrayList<List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> S;");
    _builder.newLine();
    {
      int _size = this.ptcc.getNo().size();
      int _minus = (_size - 1);
      IntegerRange _upTo = new IntegerRange(0, _minus);
      for(final Integer i : _upTo) {
        _builder.append("\t");
        _builder.append("S = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("for (int j = 0; j < vcombpf.size(); j++) {");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t");
        _builder.append("S.add(vcombpf.get(j).getValue().get(");
        _builder.append(i, "\t\t");
        _builder.append("));");
        _builder.newLineIfNotEmpty();
        _builder.append("\t");
        _builder.append("}");
        _builder.newLine();
        _builder.append("\t");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("R.add(");
        String _get = this.tranNames.get((i).intValue());
        _builder.append(_get, "\t");
        _builder.append("(S));");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("\t");
    _builder.append("Map<String,Double> valueList = new HashMap<String,Double>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("Map<String, Double> psm = new HashMap<String, Double>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("for (int i = 0; i < vcombpf.size(); i++) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("newValue = 0.0;");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (int j = 0; j < R.size(); j++) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("valueList.put(I.get(j).name(),((Number)R.get(j).get(i).getValue()).doubleValue());");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("int key = vcombpf.get(i).getKey().get(I.size()-1).get(0).getValue();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Map<String,Double>>> psVsp = I.get(I.size()-1).vsp();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("psm = psVsp.get(key).getValue();");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("for (Map.Entry<String, Double> entry : psm.entrySet()) {");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.append("newValue += psm.get(entry.getKey()) * valueList.get(entry.getKey());");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>(vcombpf.get(i).getKey(),newValue));");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("this.NODE_COLLECTION.put(\"");
    String _name_1 = this.ptcc.getOp().getName();
    _builder.append(_name_1, "\t");
    _builder.append("\", new NodeObject(\"");
    String _name_2 = this.ptcc.getOp().getName();
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
