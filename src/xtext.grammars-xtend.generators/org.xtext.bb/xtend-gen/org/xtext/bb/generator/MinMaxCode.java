package org.xtext.bb.generator;

import BbDvgTcl.AbstractInputPort;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@SuppressWarnings("all")
public class MinMaxCode {
  private StringBuilder minMaxCodeForPatternResolution;

  private StringBuilder minMaxCodeForValueFunctionDefinition;

  private StringBuilder minMaxCodeForValueFunctionCall;

  private List<AbstractInputPort> inputSet;

  private String expr;

  public MinMaxCode(final List<AbstractInputPort> inputSet, final String expr) {
    this.inputSet = inputSet;
    this.expr = expr;
    StringBuilder _stringBuilder = new StringBuilder();
    this.minMaxCodeForPatternResolution = _stringBuilder;
    StringBuilder _stringBuilder_1 = new StringBuilder();
    this.minMaxCodeForValueFunctionDefinition = _stringBuilder_1;
    StringBuilder _stringBuilder_2 = new StringBuilder();
    this.minMaxCodeForValueFunctionCall = _stringBuilder_2;
  }

  public void generateCode() {
    List<String> processedMin = new ArrayList<String>();
    List<String> processedMax = new ArrayList<String>();
    this.minMaxCodeForPatternResolution.append("List<Object> vtmp;");
    this.minMaxCodeForPatternResolution.append("\n\t");
    List<String> tmp = this.getSymbolsForMinOperators(this.expr);
    for (final String i : tmp) {
      boolean _contains = processedMin.contains(i);
      boolean _not = (!_contains);
      if (_not) {
        int index = Helpers.getTh(i, this.inputSet);
        this.minMaxCodeForPatternResolution.append((("vtmp = I.get(" + Integer.valueOf(index)) + ").values();"));
        this.minMaxCodeForPatternResolution.append("\n\t");
        this.minMaxCodeForPatternResolution.append((("double min_" + i) + " = min(vtmp);"));
        this.minMaxCodeForPatternResolution.append("\n\t");
        this.minMaxCodeForValueFunctionDefinition.append((", double min_" + i));
        this.minMaxCodeForValueFunctionCall.append((",min_" + i));
        processedMin.add(i);
      }
    }
    tmp = this.getSymbolsForMaxOperators(this.expr);
    for (final String i_1 : tmp) {
      boolean _contains_1 = processedMax.contains(i_1);
      boolean _not_1 = (!_contains_1);
      if (_not_1) {
        int index_1 = Helpers.getTh(i_1, this.inputSet);
        this.minMaxCodeForPatternResolution.append((("vtmp = I.get(" + Integer.valueOf(index_1)) + ").values();"));
        this.minMaxCodeForPatternResolution.append("\n\t");
        this.minMaxCodeForPatternResolution.append((("double max_" + i_1) + " = max(vtmp);"));
        this.minMaxCodeForPatternResolution.append("\n\t");
        this.minMaxCodeForValueFunctionDefinition.append((", double max_" + i_1));
        this.minMaxCodeForValueFunctionCall.append((",max_" + i_1));
        processedMax.add(i_1);
      }
    }
  }

  public List<String> getSymbolsForMinOperators(final String expr) {
    Pattern p = Pattern.compile("(\\$MIN\\([a-zA-Z0-9_]*\\)\\$)");
    Matcher m = p.matcher(expr);
    List<String> matches = new ArrayList<String>();
    while (m.find()) {
      {
        String _group = m.group();
        int _length = m.group().length();
        int _minus = (_length - 2);
        String tmp = _group.substring(5, _minus);
        matches.add(tmp);
      }
    }
    return matches;
  }

  public List<String> getSymbolsForMaxOperators(final String expr) {
    Pattern p = Pattern.compile("(\\$MAX\\([a-zA-Z0-9_]*\\)\\$)");
    Matcher m = p.matcher(expr);
    List<String> matches = new ArrayList<String>();
    while (m.find()) {
      {
        String _group = m.group();
        int _length = m.group().length();
        int _minus = (_length - 2);
        String tmp = _group.substring(5, _minus);
        matches.add(tmp);
      }
    }
    return matches;
  }

  public String getMinMaxCodeForPatternResolution() {
    return this.minMaxCodeForPatternResolution.toString();
  }

  public String getMinMaxCodeForValueFunctionDefinition() {
    return this.minMaxCodeForValueFunctionDefinition.toString();
  }

  public String getMinMaxCodeForValueFunctionCall() {
    return this.minMaxCodeForValueFunctionCall.toString();
  }
}
