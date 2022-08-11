package org.xtext.bb.generator;

import bbn.AbstractOutputPort;
import bbn.DVGPort;
import bbn.Direction;
import bbn.LinearNormalization;
import bbn.NormalizationCOp;
import com.google.common.base.Objects;
import java.util.AbstractMap;
import java.util.List;
import org.eclipse.xtext.xbase.lib.InputOutput;

@SuppressWarnings("all")
public class JavaFunctions {
  public String generateGetCartesianProductFunction() {
    StringBuilder code = new StringBuilder();
    code.append("List<List<Integer>> getCartesianProduct(ArrayList<Integer> arg, int cnt, List<List<Integer>> input, List<List<Integer>> output) {");
    code.append("\n\t");
    code.append("for (int j = 0; j < input.get(cnt).size(); j++) {");
    code.append("\n\t\t");
    code.append("List<Integer> tmp = new ArrayList<Integer>();");
    code.append("\n\t\t");
    code.append("for (int i = 0; i < cnt; i++) {");
    code.append("\n\t\t\t");
    code.append("tmp.add(arg.get(i));");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("arg.clear();");
    code.append("\n\t\t");
    code.append("arg.addAll(tmp);");
    code.append("\n\t\t");
    code.append("arg.add(input.get(cnt).get(j));");
    code.append("\n\t\t");
    code.append("if (cnt == input.size()-1) {");
    code.append("\n\t\t\t");
    code.append("output.add(new ArrayList<Integer>());");
    code.append("\n\t\t\t");
    code.append("output.get(output.size()-1).addAll(arg);");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("else {");
    code.append("\n\t\t\t");
    code.append("getCartesianProduct(arg, cnt+1, input, output);");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("return output;");
    code.append("\n");
    code.append("}");
    return code.toString();
  }

  public String generateIsSAM() {
    StringBuilder code = new StringBuilder();
    code.append("boolean isSAM(List<List<List<SimpleEntry<String,Integer>>>> headerList) {");
    code.append("\n\t");
    code.append("List<String> sln = new ArrayList<String>();");
    code.append("\n\t");
    code.append("for (List<List<SimpleEntry<String,Integer>>> i : headerList) {");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> j : i) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> k : j) {");
    code.append("\n\t\t\t\t");
    code.append("if (!sln.contains(k.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("sln.add(k.getKey());");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("else {");
    code.append("\n\t\t\t\t\t");
    code.append("return true;");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("return false;");
    code.append("\n");
    code.append("}");
    return code.toString();
  }

  public String generateIsValidCombinationIgnoreResource() {
    StringBuilder code = new StringBuilder();
    code.append("boolean isValidCombination(List<List<SimpleEntry<String,Integer>>> header) {");
    code.append("\n\t\t");
    code.append("Map<String,Integer> M = new HashMap<String,Integer>();");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> row : header) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> entry : row) {");
    code.append("\n\t\t\t\t");
    code.append("if (!M.containsKey(entry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("M.put(entry.getKey(), entry.getValue());");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("else {");
    code.append("\n\t\t\t\t\t");
    code.append("if (entry.getValue() != M.get(entry.getKey()) && entry.getKey() != \"UNIQUE_RESOURCE_ID\") {");
    code.append("\n\t\t\t\t\t\t");
    code.append("return false;");
    code.append("\n\t\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("return true;");
    code.append("\n");
    code.append("}");
    return code.toString();
  }

  public String generateIsValidCombinationConsiderResource() {
    StringBuilder code = new StringBuilder();
    code.append("boolean isValidCombination(List<List<SimpleEntry<String,Integer>>> header) {");
    code.append("\n\t\t");
    code.append("List<List<Integer>> indicesLL = new ArrayList<List<Integer>>();");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> row : header) {");
    code.append("\n\t\t\t");
    code.append("List<Integer> indicesL = new ArrayList<Integer>();");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> entry : row) {");
    code.append("\n\t\t\t\t");
    code.append("if (entry.getKey() == \"UNIQUE_RESOURCE_ID\") {");
    code.append("\n\t\t\t\t\t");
    code.append("if (!indicesL.contains(entry.getValue())) {");
    code.append("\n\t\t\t\t\t");
    code.append("indicesL.add(entry.getValue());");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("indicesLL.add(indicesL);");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("for (int i = 0; i < indicesLL.size(); i++) {");
    code.append("\n\t\t\t");
    code.append("for (int j = 0; j < indicesLL.size(); j++) {");
    code.append("\n\t\t\t\t");
    code.append("if (i != j) {");
    code.append("\n\t\t\t\t\t");
    code.append("for (int k = 0; k < indicesLL.get(i).size(); k++) {");
    code.append("\n\t\t\t\t\t\t");
    code.append("for (int l = 0; l < indicesLL.get(j).size(); l++) {");
    code.append("\n\t\t\t\t\t\t\t");
    code.append("if (indicesLL.get(i).get(k) == indicesLL.get(j).get(l)) {");
    code.append("\n\t\t\t\t\t\t\t\t");
    code.append("return false;");
    code.append("\n\t\t\t\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("return true;");
    code.append("\n\t\t");
    code.append("}");
    return code.toString();
  }

  public String generateIsValidCombinationInverse() {
    StringBuilder code = new StringBuilder();
    code.append("boolean isValidCombinationInverse(List<List<SimpleEntry<String,Integer>>> header, String name) {");
    code.append("\n\t\t");
    code.append("int rowc = 0;");
    code.append("\n\t\t");
    code.append("Map<String,Integer> M = new HashMap<String,Integer>();");
    code.append("\n\t\t");
    code.append("Map<String,Integer> M2 = new HashMap<String,Integer>();");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> row : header) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> entry : row) {");
    code.append("\n\t\t\t\t");
    code.append("if (!M.containsKey(entry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("M.put(entry.getKey(), entry.getValue());");
    code.append("\n\t\t\t\t\t");
    code.append("M2.put(entry.getKey(), rowc);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("else {");
    code.append("\n\t\t\t\t\t");
    code.append("if (M2.get(entry.getKey()) != rowc) {");
    code.append("if (name != entry.getKey() && entry.getValue() != M.get(entry.getKey())) {");
    code.append("\n\t\t\t\t\t\t");
    code.append("return false;");
    code.append("\n\t\t\t\t\t");
    code.append("}");
    code.append("else if (name == entry.getKey() && entry.getValue() == M.get(entry.getKey())) {");
    code.append("\n\t\t\t\t\t\t");
    code.append("return false;");
    code.append("\n\t\t\t\t\t");
    code.append("}");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("rowc++;");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("return true;");
    code.append("\n");
    code.append("}");
    return code.toString();
  }

  public String generateIsValidCombinationMerge() {
    StringBuilder code = new StringBuilder();
    code.append("boolean isValidCombinationMerge(List<List<SimpleEntry<String,Integer>>> header) {");
    code.append("\n\t\t");
    code.append("int rowc = 0;");
    code.append("\n\t\t");
    code.append("Map<String,Set<Integer>> M = new HashMap<String,Set<Integer>>();");
    code.append("\n\t\t");
    code.append("Map<String,Integer> M2 = new HashMap<String,Integer>();");
    code.append("\n\t\t");
    code.append("Map<String,List<Integer>> M3 = new HashMap<String,List<Integer>>();");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> row : header) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> entry : row) {");
    code.append("\n\t\t\t\t");
    code.append("if (!M.containsKey(entry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("Set<Integer> set = new HashSet<Integer>();");
    code.append("set.add(entry.getValue());");
    code.append("M.put(entry.getKey(), set);");
    code.append("M2.put(entry.getKey(), rowc);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("else {");
    code.append("\n\t\t\t\t\t");
    code.append("Set<Integer> set2 = M.get(entry.getKey());");
    code.append("if (M2.get(entry.getKey()) == rowc) {");
    code.append("\n\t\t\t\t\t\t");
    code.append("set2.add(entry.getValue());");
    code.append("M.put(entry.getKey(), set2);");
    code.append("\n\t\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t\t");
    code.append("else {");
    code.append("\n\t\t\t\t\t\t");
    code.append("if (!set2.contains(entry.getValue())) {");
    code.append("\n\t\t\t\t\t\t");
    code.append("return false;");
    code.append("\n\t\t\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("rowc++;");
    code.append("\n\t\t");
    code.append("}");
    code.append("return true;");
    code.append("}");
    return code.toString();
  }

  public String generateIsValidCombinationIgnore() {
    StringBuilder code = new StringBuilder();
    code.append("boolean isValidCombinationIgnore(List<List<SimpleEntry<String,Integer>>> header) {");
    code.append("\n\t\t");
    code.append("int rowc = 0;");
    code.append("\n\t\t");
    code.append("Map<String,Integer> M = new HashMap<String,Integer>();");
    code.append("\n\t\t");
    code.append("Map<String,Integer> M2 = new HashMap<String,Integer>();");
    code.append("\n\t\t");
    code.append("for (List<SimpleEntry<String,Integer>> row : header) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> entry : row) {");
    code.append("\n\t\t\t\t");
    code.append("if (!M.containsKey(entry.getKey())) {");
    code.append("\n\t\t\t\t\t");
    code.append("M.put(entry.getKey(), entry.getValue());");
    code.append("M2.put(entry.getKey(), rowc);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("else {");
    code.append("\n\t\t\t\t\t");
    code.append("if (M2.get(entry.getKey()) != rowc) {");
    code.append("\n\t\t\t\t\t\t");
    code.append("if (entry.getValue() != M.get(entry.getKey())) {");
    code.append("\n\t\t\t\t\t\t");
    code.append("return false;");
    code.append("\n\t\t\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("rowc++;");
    code.append("\n\t\t");
    code.append("}");
    code.append("return true;");
    code.append("\n\t");
    code.append("}");
    return code.toString();
  }

  public String generateIsDominated() {
    StringBuilder code = new StringBuilder();
    code.append("\n\t");
    code.append("Boolean isDominated(List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> F, List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> S, List<Boolean> Max) {");
    code.append("\n\t\t");
    code.append("for (int i = 0; i < F.size(); i++) {");
    code.append("\n\t\t\t");
    code.append("if (Max.get(i)) {");
    code.append("\n\t\t\t\t");
    code.append("if (((Number)F.get(i).getValue()).doubleValue() > ((Number)S.get(i).getValue()).doubleValue()) {");
    code.append("\n\t\t\t\t\t");
    code.append("return false;");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("else {");
    code.append("\n\t\t\t\t");
    code.append("if (((Number)F.get(i).getValue()).doubleValue() < ((Number)S.get(i).getValue()).doubleValue()) {");
    code.append("\n\t\t\t\t\t");
    code.append("return false;");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("return true;");
    code.append("\n\t");
    code.append("}");
    return code.toString();
  }

  public String generateMaxFunction() {
    StringBuilder code = new StringBuilder();
    code.append("double max(List<Object> list) {");
    code.append("\n\t\t");
    code.append("double max = Double.NEGATIVE_INFINITY;");
    code.append("\n\t\t\t");
    code.append("for (int i = 0; i < list.size(); i++) {");
    code.append("\n\t\t\t\t");
    code.append("if (((Number)list.get(i)).doubleValue() > max) {");
    code.append("\n\t\t\t\t\t");
    code.append("max = ((Number)list.get(i)).doubleValue();");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("return max;");
    code.append("\n\t\t");
    code.append("}");
    return code.toString();
  }

  public String generateMinFunction() {
    StringBuilder code = new StringBuilder();
    code.append("double min(List<Object> list) {");
    code.append("\n\t\t");
    code.append("double min = Double.POSITIVE_INFINITY;");
    code.append("\n\t\t\t");
    code.append("for (int i = 0; i < list.size(); i++) {");
    code.append("\n\t\t\t\t");
    code.append("if (((Number)list.get(i)).doubleValue() < min) {");
    code.append("\n\t\t\t\t\t");
    code.append("min = ((Number)list.get(i)).doubleValue();");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("return min;");
    code.append("\n\t\t");
    code.append("}");
    return code.toString();
  }

  public String generateHeaderRow() {
    StringBuilder code = new StringBuilder();
    code.append("\n\t\t\t");
    code.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();");
    code.append("\n\t\t\t");
    code.append("headerRow.add(new SimpleEntry<String,Integer>(I.get(j).name(),cp.get(i).get(j)));");
    code.append("\n\t\t\t");
    code.append("if (I.get(j).header(cp.get(i).get(j)) != null) {");
    code.append("\n\t\t\t\t");
    code.append("List<List<SimpleEntry<String,Integer>>> htmp = I.get(j).header(cp.get(i).get(j));");
    code.append("for (List<SimpleEntry<String,Integer>> row : htmp) {");
    code.append("\n\t\t\t\t\t");
    code.append("for (SimpleEntry<String,Integer> entry : row) {");
    code.append("\n\t\t\t\t\t\t");
    code.append("headerRow.add(entry);");
    code.append("\n\t\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("header.add(headerRow);");
    return code.toString();
  }

  public String generateHeaderRow(final int nodeIndex, final int slotIndex) {
    StringBuilder code = new StringBuilder();
    code.append("\n\t");
    code.append("headerRow = new ArrayList<SimpleEntry<String,Integer>>();");
    code.append("\n\t");
    code.append((((("headerRow.add(new SimpleEntry<String,Integer>(I.get(" + Integer.valueOf(nodeIndex)) + ").name(),") + Integer.valueOf(slotIndex)) + "));"));
    code.append("\n\t");
    code.append((((("if (I.get(" + Integer.valueOf(nodeIndex)) + ").header(") + Integer.valueOf(slotIndex)) + ") != null) {"));
    code.append("\n\t\t");
    code.append((((("htmp = I.get(" + Integer.valueOf(nodeIndex)) + ").header(") + Integer.valueOf(slotIndex)) + ");"));
    code.append("for (List<SimpleEntry<String,Integer>> row : htmp) {");
    code.append("\n\t\t\t");
    code.append("for (SimpleEntry<String,Integer> entry : row) {");
    code.append("\n\t\t\t\t");
    code.append("headerRow.add(entry);");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("header.add(headerRow);");
    return code.toString();
  }

  public String resolveParetoFilter(final String name, final List<Boolean> max, final boolean check) {
    StringBuilder code = new StringBuilder();
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>>");
    code.append(" ");
    code.append(name);
    code.append("(");
    code.append("List<Node>");
    code.append(" ");
    code.append("I");
    code.append(") {");
    code.append("\n\t");
    if (check) {
      code.append("List<List<List<SimpleEntry<String,Integer>>>> headerList = new ArrayList<List<List<SimpleEntry<String,Integer>>>>();");
      code.append("\n\t");
      code.append("for (int i = 0; i < I.size(); i++) {");
      code.append("\n\t\t");
      code.append("if (I.get(i).header(0) != null) {");
      code.append("\n\t\t\t");
      code.append("headerList.add(I.get(i).header(0));");
      code.append("\n\t\t");
      code.append("}");
      code.append("\n\t");
      code.append("}");
      code.append("\n\t");
      code.append("if (headerList.size() > 0 && !isSAM(headerList)) {");
      code.append("\n\t\t");
      code.append((("System.err.println(\"ERROR: There is no SAM-Situation for Contradiction pattern " + name) + "!\");"));
      code.append("\n\t");
      code.append("}");
      code.append("\n\t");
    }
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
    code.append("\n\t");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcomb = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>>();");
    code.append("\n\t");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>> vcombpf = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>>();");
    code.append("\n\t");
    code.append("double newValue = 0.0;");
    code.append("\n\t");
    code.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();");
    code.append("\n\t");
    code.append("for (Node i : I) {");
    code.append("\n\t\t");
    code.append("List<Integer> tmp = new ArrayList<Integer>();");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < i.vsp().size(); j++) {");
    code.append("\n\t\t\t");
    code.append("tmp.add(j);");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("ir.add(tmp);");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("List<List<Integer>> cp = getCartesianProduct(new ArrayList<Integer>(), 0, ir, new ArrayList<List<Integer>>());");
    code.append("\n\t");
    code.append("for (int i = 0; i < cp.size(); i++) {");
    code.append("\n\t\t");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> T = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
    code.append("\n\t\t");
    code.append("newValue = 0.0;");
    code.append("\n\t\t");
    code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < cp.get(i).size(); j++) {");
    code.append(this.generateHeaderRow());
    code.append("\n\t\t");
    code.append("T.add(I.get(j).slot(cp.get(i).get(j)));");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("if (isValidCombination(header)) {");
    code.append("\n\t\t\t");
    code.append("vcomb.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>,List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>>(header,T));");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("List<Boolean> max = new ArrayList<Boolean>();");
    code.append("\n\t");
    for (int i = 0; (i < max.size()); i++) {
      {
        Boolean _get = max.get(i);
        String _plus = ("max.add(" + _get);
        String _plus_1 = (_plus + ");");
        code.append(_plus_1);
        code.append("\n\t");
      }
    }
    code.append("List<Boolean> isDominated = new ArrayList<Boolean>();");
    code.append("\n\t");
    code.append("for (int i = 0; i < vcomb.size(); i++) {");
    code.append("\n\t\t");
    code.append("isDominated.add(false);");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("for (int i = 0; i < vcomb.size(); i++) {");
    code.append("\n\t\t");
    code.append("for (int j = 0; j < vcomb.size(); j++) {");
    code.append("\n\t\t\t");
    code.append("if (i != j && !isDominated.get(i)) {");
    code.append("\n\t\t\t\t");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> tmp_1 = new ArrayList<>(vcomb.get(i).getValue());");
    code.append("\n\t\t\t\t");
    code.append("tmp_1.remove(tmp_1.size()-1);");
    code.append("\n\t\t\t\t");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> tmp_2 = new ArrayList<>(vcomb.get(j).getValue());");
    code.append("\n\t\t\t\t");
    code.append("tmp_2.remove(tmp_2.size()-1);");
    code.append("\n\t\t\t\t");
    code.append("if (isDominated(tmp_1,tmp_2,max)) {");
    code.append("\n\t\t\t\t\t");
    code.append("isDominated.set(i,true);");
    code.append("\n\t\t\t\t");
    code.append("}");
    code.append("\n\t\t\t");
    code.append("}");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("for (int i = 0; i < isDominated.size(); i++) {");
    code.append("\n\t\t");
    code.append("if (!isDominated.get(i)) {");
    code.append("\n\t\t\t");
    code.append("vcombpf.add(vcomb.get(i));");
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("return vcombpf;");
    code.append("\n\t");
    code.append("\n");
    code.append("}");
    return code.toString();
  }

  public String resolveTransformation(final String name, final NormalizationCOp nf) {
    StringBuilder code = new StringBuilder();
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>");
    code.append(" ");
    code.append(name);
    code.append("(");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>");
    code.append(" ");
    code.append("I");
    code.append(") {");
    code.append("\n\t");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>>();");
    code.append("\n\t");
    code.append("Object newValue = 0.0;");
    code.append("\n\t");
    code.append("List<Double> s = new ArrayList<Double>();");
    code.append("\n\t");
    code.append("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,Object>> vsptmp = I;");
    code.append("\n\t");
    code.append("for (int i = 0; i < vsptmp.size(); i++) {");
    code.append("\n\t\t");
    code.append("s.add(((Number)vsptmp.get(i).getValue()).doubleValue());");
    code.append("\n\t");
    code.append("}");
    code.append("for (int i = 0; i < vsptmp.size(); i++) {");
    code.append("\n\t\t");
    if ((nf instanceof LinearNormalization)) {
      if (((((LinearNormalization)nf).getMin() == null) && (((LinearNormalization)nf).getMax() == null))) {
        code.append("double num = Collections.max(s)-((Number)vsptmp.get(i).getValue()).doubleValue();");
        code.append("\n\t\t\t");
        code.append("double den = Collections.max(s)-Collections.min(s);");
        code.append("\n\t\t\t");
      } else {
        if (((((LinearNormalization)nf).getMin() != null) && (((LinearNormalization)nf).getMax() == null))) {
          code.append("double num = Collections.max(s)-((Number)vsptmp.get(i).getValue()).doubleValue();");
          code.append("\n\t\t\t");
          String _string = Double.valueOf(((LinearNormalization)nf).getMin().getValue()).toString();
          String _plus = ("double den = Collections.max(s)-" + _string);
          String _plus_1 = (_plus + ";");
          code.append(_plus_1);
          code.append("\n\t\t\t");
        } else {
          if (((((LinearNormalization)nf).getMin() == null) && (((LinearNormalization)nf).getMax() != null))) {
            String _string_1 = Double.valueOf(((LinearNormalization)nf).getMax().getValue()).toString();
            String _plus_2 = ("double num = " + _string_1);
            String _plus_3 = (_plus_2 + "-((Number)vsptmp.get(i).getValue()).doubleValue();");
            code.append(_plus_3);
            code.append("\n\t\t\t");
            String _string_2 = Double.valueOf(((LinearNormalization)nf).getMax().getValue()).toString();
            String _plus_4 = ("double den = " + _string_2);
            String _plus_5 = (_plus_4 + "-Collections.min(s);");
            code.append(_plus_5);
            code.append("\n\t\t\t");
          } else {
            String _string_3 = Double.valueOf(((LinearNormalization)nf).getMax().getValue()).toString();
            String _plus_6 = ("double num = " + _string_3);
            String _plus_7 = (_plus_6 + "-((Number)vsptmp.get(i).getValue()).doubleValue();");
            code.append(_plus_7);
            code.append("\n\t\t\t");
            String _string_4 = Double.valueOf(((LinearNormalization)nf).getMax().getValue()).toString();
            String _plus_8 = ("double den = " + _string_4);
            String _plus_9 = (_plus_8 + "-");
            String _string_5 = Double.valueOf(((LinearNormalization)nf).getMin().getValue()).toString();
            String _plus_10 = (_plus_9 + _string_5);
            String _plus_11 = (_plus_10 + ";");
            code.append(_plus_11);
            code.append("\n\t\t\t");
          }
        }
      }
      Direction _direction = ((LinearNormalization)nf).getDirection();
      boolean _equals = Objects.equal(_direction, Direction.DEC);
      if (_equals) {
        code.append("newValue = num/den;");
      } else {
        code.append("newValue = 1-(num/den);");
      }
    }
    code.append("\n\t\t\t");
    code.append("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, Object>(null, newValue));");
    code.append("\n\t");
    code.append("}");
    code.append("return ovsp;");
    code.append("\n");
    code.append("}");
    return code.toString();
  }

  public String generateCallSequenceCode(final String name, final List<DVGPort> inputSet) {
    StringBuilder code = new StringBuilder();
    code.append("\n\t\t");
    code.append("params = new ArrayList<Node>();");
    code.append("\n\t\t");
    for (int i = 0; (i < inputSet.size()); i++) {
      {
        String _name = inputSet.get(i).getName();
        String _plus = ("params.add(this.NODE_COLLECTION.get(\"" + _name);
        String _plus_1 = (_plus + "\"));");
        code.append(_plus_1);
        code.append("\n\t\t");
      }
    }
    code.append((("resolve_" + name) + "(params);"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateCallSequenceCode(final String name, final List<DVGPort> inputSet, final List<List<AbstractMap.SimpleEntry<AbstractOutputPort, String>>> allocInputSet, final List<Boolean> isAlloc) {
    for (int i = 0; (i < allocInputSet.size()); i++) {
      for (int j = 0; (j < allocInputSet.get(i).size()); j++) {
        String _plus = (Integer.valueOf(i) + ",");
        String _plus_1 = (_plus + Integer.valueOf(j));
        String _plus_2 = (_plus_1 + ": ");
        AbstractMap.SimpleEntry<AbstractOutputPort, String> _get = allocInputSet.get(i).get(j);
        String _plus_3 = (_plus_2 + _get);
        InputOutput.<String>println(_plus_3);
      }
    }
    StringBuilder code = new StringBuilder();
    int _size = allocInputSet.size();
    boolean _equals = (_size == 0);
    if (_equals) {
      code.append("\n\t\t");
      code.append("params = new ArrayList<Node>();");
      code.append("\n\t\t");
      for (int i = 0; (i < inputSet.size()); i++) {
        {
          String _name = inputSet.get(i).getName();
          String _plus = ("params.add(this.NODE_COLLECTION.get(\"" + _name);
          String _plus_1 = (_plus + "\"));");
          code.append(_plus_1);
          code.append("\n\t\t");
        }
      }
      code.append((("resolve_" + name) + "(params);"));
      code.append("\n\t\t");
      code.append("\n\t\t");
    } else {
      for (int l = 0; (l < allocInputSet.get(0).size()); l++) {
        {
          String _string = Integer.valueOf(l).toString();
          String _plus = ("if (allocation == " + _string);
          String _plus_1 = (_plus + ") {");
          code.append(_plus_1);
          code.append("\n\t\t");
          int inputSetCounter = 0;
          int allocInputSetCounter = 0;
          code.append("\n\t\t");
          code.append("params = new ArrayList<Node>();");
          code.append("\n\t\t");
          for (final Boolean i : isAlloc) {
            if ((i).booleanValue()) {
              String _value = allocInputSet.get(allocInputSetCounter).get(l).getValue();
              String _plus_2 = ("params.add(this.NODE_COLLECTION.get(\"" + _value);
              String _plus_3 = (_plus_2 + "\"));");
              code.append(_plus_3);
              code.append("\n\t\t");
              allocInputSetCounter++;
            } else {
              String _name = inputSet.get(inputSetCounter).getName();
              String _plus_4 = ("params.add(this.NODE_COLLECTION.get(\"" + _name);
              String _plus_5 = (_plus_4 + "\"));");
              code.append(_plus_5);
              code.append("\n\t\t");
              inputSetCounter++;
            }
          }
          code.append((("resolve_" + name) + "(params);"));
          code.append("\n\t\t");
          code.append("\n\t\t }");
          code.append("\n\t\t");
        }
      }
    }
    return code.toString();
  }

  public String generateCallSequenceCodeAg(final String name, final List<List<DVGPort>> inputSet) {
    StringBuilder code = new StringBuilder();
    code.append("params_2d = new ArrayList<List<Node>>();");
    code.append("\n\t\t");
    for (int i = 0; (i < inputSet.size()); i++) {
      {
        code.append("params = new ArrayList<Node>();");
        for (int j = 0; (j < inputSet.get(i).size()); j++) {
          {
            String _name = inputSet.get(i).get(j).getName();
            String _plus = ("params.add(this.NODE_COLLECTION.get(\"" + _name);
            String _plus_1 = (_plus + "\"));");
            code.append(_plus_1);
            code.append("\n\t\t");
          }
        }
        code.append("params_2d.add(params);");
        code.append("\n\t\t");
      }
    }
    code.append((("resolve_" + name) + "(params_2d);"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }
}
