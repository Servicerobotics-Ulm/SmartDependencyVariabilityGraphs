package org.xtext.bb.generator;

import bbn.AGGR;
import bbn.BuildingBlockDescription;
import bbn.Container;
import bbn.DVG;
import bbn.DVGPort;
import bbn.Decomposition;
import bbn.EquivalenceFork;
import bbn.InputPort;
import bbn.MAGR;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.InputOutput;

@SuppressWarnings("all")
public class EqufModelOfModels {
  private Helpers he;

  private List<MatchingAndGenerationData> matchingAndGenerationDataList;

  private DVG problemDVG;

  private Map<String, Integer> equfActives;

  public Map<String, Integer> getEqufActives() {
    return this.equfActives;
  }

  public List<MatchingAndGenerationData> getMatchingAndGenerationDataList() {
    return this.matchingAndGenerationDataList;
  }

  private boolean firstFinished = false;

  public String start(final Decomposition d, final DVG problemDVG, final boolean ff) {
    HashMap<String, Integer> _hashMap = new HashMap<String, Integer>();
    this.equfActives = _hashMap;
    this.problemDVG = problemDVG;
    this.firstFinished = ff;
    InputOutput.<String>println("START EqufModelOfModels");
    if ((d instanceof EquivalenceFork)) {
      StringBuilder code = new StringBuilder();
      ArrayList<MatchingAndGenerationData> _arrayList = new ArrayList<MatchingAndGenerationData>();
      this.matchingAndGenerationDataList = _arrayList;
      EList<Container> _c = ((EquivalenceFork)d).getC();
      for (final Container i : _c) {
        {
          MatchingAndGeneration mag = new MatchingAndGeneration();
          EObject bbd = i.getBbr().eContainer();
          boolean hasDVGRef = false;
          if ((bbd instanceof BuildingBlockDescription)) {
            DVG _dvg = ((BuildingBlockDescription)bbd).getDvg();
            boolean _tripleNotEquals = (_dvg != null);
            if (_tripleNotEquals) {
              if ((!this.firstFinished)) {
                code.append(mag.start(i.getBbr(), ((BuildingBlockDescription)bbd).getDvg(), true, true, true));
                this.firstFinished = true;
              } else {
                code.append(mag.start(i.getBbr(), ((BuildingBlockDescription)bbd).getDvg(), true, false, true));
              }
            } else {
              mag.start(i.getBbr(), ((BuildingBlockDescription)bbd).getDvg(), false, false, true);
            }
            MatchingAndGenerationData magd = new MatchingAndGenerationData();
            magd.numberAllocations = mag.getAllocations();
            magd.active = mag.getActive();
            magd.passive = mag.getPassive();
            this.matchingAndGenerationDataList.add(magd);
          }
        }
      }
      code.append(this.generateEvaluation());
      return code.toString();
    }
    return null;
  }

  public String resolve(final MAGR p) {
    Helpers _helpers = new Helpers();
    this.he = _helpers;
    StringBuilder code = new StringBuilder();
    StringBuilder lcode = new StringBuilder();
    code.append("void");
    code.append(" ");
    String _name = p.getName();
    String _plus = ("resolve_" + _name);
    code.append(_plus);
    code.append("(");
    code.append("List<List<Node>>");
    code.append(" ");
    code.append("I");
    code.append(") {");
    code.append("\n\t");
    for (int i = 0; (i < p.getAggr().size()); i++) {
      {
        String _name_1 = p.getName();
        String _plus_1 = ("resolve_" + _name_1);
        String _plus_2 = (_plus_1 + "_");
        String _string = Integer.valueOf(i).toString();
        String name = (_plus_2 + _string);
        code.append((((name + "(I.get(") + Integer.valueOf(i)) + "));"));
        code.append("\n\t");
        lcode.append(this.resolveAGGR(p.getName(), name, p.getAggr().get(i)));
        lcode.append("\n");
      }
    }
    code.append("\n");
    code.append("}");
    StringBuilder res = new StringBuilder();
    res.append(code);
    res.append("\n\n");
    res.append(lcode);
    res.append("\n\n");
    return res.toString();
  }

  public String resolveAGGR(final String pname, final String fname, final AGGR la) {
    StringBuilder code = new StringBuilder();
    String vsp = null;
    String obj = null;
    boolean _isComplexDo = this.he.isComplexDo(la.getOp().getVe());
    if (_isComplexDo) {
      vsp = "vsp_2";
      obj = "List<Object>";
    } else {
      vsp = "vsp";
      obj = "Object";
    }
    code.append("void");
    code.append(" ");
    code.append(fname);
    code.append("(");
    code.append("List<Node>");
    code.append(" ");
    code.append("I");
    code.append(") {");
    code.append("\n\t");
    code.append((((("List<SimpleEntry<List<List<SimpleEntry<String,Integer>>>," + obj) + ">> ovsp = new ArrayList<SimpleEntry<List<List<SimpleEntry<String,Integer>>>,") + obj) + ">>();"));
    code.append("\n\t");
    code.append((obj + " newValue;"));
    code.append("\n\t");
    code.append("List<List<Integer>> ir = new ArrayList<List<Integer>>();");
    code.append("\n\t");
    code.append("NodeObjectList nodeObjectList;");
    code.append("\n\t");
    code.append("for (int i = 0; i < I.size(); i++) {");
    code.append("\n\t\t");
    code.append((("SimpleEntry<String, Integer> fid = new SimpleEntry<String, Integer>(\"" + pname) + "\", i);"));
    code.append((("for (int j = 0; j < I.get(i)." + vsp) + "().size(); j++) {"));
    code.append("\n\t\t\t");
    code.append("List<List<SimpleEntry<String,Integer>>> header = new ArrayList<List<SimpleEntry<String,Integer>>>();");
    code.append("\n\t\t\t");
    code.append("List<SimpleEntry<String,Integer>> headerRow = new ArrayList<SimpleEntry<String,Integer>>();");
    code.append("\n\t\t\t");
    code.append("headerRow.add(fid);");
    code.append("\n\t\t\t");
    code.append("headerRow.add(new SimpleEntry<String, Integer>(I.get(i).name(), j));");
    code.append("\n\t\t\t");
    code.append("if (I.get(i).header(j) != null) {");
    code.append("\n\t\t\t\t");
    code.append("List<List<SimpleEntry<String,Integer>>> htmp = I.get(i).header(j);");
    code.append("\n\t\t\t\t");
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
    code.append("\n\t\t\t");
    code.append((("newValue = I.get(i)." + vsp) + "(j);"));
    code.append((("ovsp.add(new SimpleEntry<List<List<SimpleEntry<String,Integer>>>, " + obj) + ">(header, newValue));"));
    code.append("\n\t\t");
    code.append("}");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    boolean _isComplexDo_1 = this.he.isComplexDo(la.getOp().getVe());
    if (_isComplexDo_1) {
      String _name = la.getOp().getName();
      String _plus = ("nodeObjectList = new NodeObjectList(\"" + _name);
      String _plus_1 = (_plus + "\");");
      code.append(_plus_1);
      code.append("nodeObjectList.assignVSP_2(ovsp);");
      String _name_1 = la.getOp().getName();
      String _plus_2 = ("this.NODE_COLLECTION.put(\"" + _name_1);
      String _plus_3 = (_plus_2 + "\", nodeObjectList);");
      code.append(_plus_3);
    } else {
      String _name_2 = la.getOp().getName();
      String _plus_4 = ("this.NODE_COLLECTION.put(\"" + _name_2);
      String _plus_5 = (_plus_4 + "\", new NodeObject(\"");
      String _name_3 = la.getOp().getName();
      String _plus_6 = (_plus_5 + _name_3);
      String _plus_7 = (_plus_6 + "\", ovsp));");
      code.append(_plus_7);
    }
    code.append("}");
    return code.toString();
  }

  public String generateCallSequenceCode(final String name, final List<List<DVGPort>> inputSet, final List<String> dvgNames) {
    StringBuilder code = new StringBuilder();
    code.append("List<Node> params;");
    code.append("\n\t\t");
    code.append("List<List<Node>> params_2d;");
    code.append("\n\t\t");
    code.append("params_2d = new ArrayList<List<Node>>();");
    code.append("\n\t\t");
    for (int i = 0; (i < inputSet.size()); i++) {
      {
        code.append("params = new ArrayList<Node>();");
        code.append("\n\t\t");
        for (int j = 0; (j < inputSet.get(i).size()); j++) {
          {
            code.append("\n\t\t");
            String _get = dvgNames.get(j);
            String _plus = (_get + " s_");
            String _string = Integer.valueOf(j).toString();
            String _plus_1 = (_plus + _string);
            String _plus_2 = (_plus_1 + " = new ");
            String _get_1 = dvgNames.get(j);
            String _plus_3 = (_plus_2 + _get_1);
            String _plus_4 = (_plus_3 + "();");
            code.append(_plus_4);
            String _string_1 = Integer.valueOf(j).toString();
            String instName = ("s_" + _string_1);
            String _get_2 = dvgNames.get(j);
            String magrName = ("MAGR_ALLOCATION_" + _get_2);
            code.append("\n\t\t");
            code.append((instName + ".init();"));
            if ((this.matchingAndGenerationDataList.get(j).numberAllocations > 1)) {
              code.append("\n\t\t");
              code.append("List<Node> tmp = new ArrayList<Node>();");
              code.append("\n\t\t");
              code.append((("for (int i = 0; i < " + instName) + ".getAllocations(); i++) {"));
              code.append("\n\t\t\t");
              String _name = inputSet.get(i).get(j).getName();
              String _plus_5 = ((("tmp.add(" + instName) + ".solve(\"") + _name);
              String _plus_6 = (_plus_5 + "\",i));");
              code.append(_plus_6);
              code.append("\n\t\t");
              code.append("}");
              code.append((("params.add(AllocationAggr(tmp, \"" + magrName) + "\"));"));
              code.append("\n\t\t");
            } else {
              code.append("\n\t\t");
              String _name_1 = inputSet.get(i).get(j).getName();
              String _plus_7 = ((("params.add(" + instName) + ".solve(\"") + _name_1);
              String _plus_8 = (_plus_7 + "\",0));");
              code.append(_plus_8);
              code.append("\n\t\t");
              code.append("\n\t\t");
              code.append("\n\t\t");
            }
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

  public String generateEvaluation() {
    StringBuilder code = new StringBuilder();
    code.append("\n\t");
    String _name = this.problemDVG.getName();
    String _plus = ("class " + _name);
    String _plus_1 = (_plus + "{");
    code.append(_plus_1);
    code.append("\n\t");
    code.append("\n\t");
    code.append("Node getNode(String name) {");
    code.append("\n\t");
    code.append("return NODE_COLLECTION.get(name);");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("private Map<String, Node> NODE_COLLECTION;");
    code.append("\n\t");
    EObject tmp = this.problemDVG.getPattern().get(0);
    List<List<DVGPort>> inputSetAg = new ArrayList<List<DVGPort>>();
    List<String> aggrOutputNames = new ArrayList<String>();
    List<String> dvgNames = new ArrayList<String>();
    String magrName = null;
    int numberInputs = 0;
    if ((tmp instanceof MAGR)) {
      magrName = ((MAGR)tmp).getName();
      code.append(this.resolve(((MAGR)tmp)));
      EList<AGGR> _aggr = ((MAGR)tmp).getAggr();
      for (final AGGR i : _aggr) {
        {
          aggrOutputNames.add(i.getOp().getName());
          List<DVGPort> tmp2 = new ArrayList<DVGPort>();
          numberInputs = i.getIp().size();
          EList<InputPort> _ip = i.getIp();
          for (final InputPort j : _ip) {
            {
              tmp2.add(j.getOutputport());
              EObject dvg2 = j.getOutputport().eContainer().eContainer();
              if ((dvg2 instanceof DVG)) {
                dvgNames.add(((DVG)dvg2).getName());
              }
            }
          }
          inputSetAg.add(tmp2);
        }
      }
    }
    code.append("\n\t");
    code.append(this.he.generateGenericAllocationAggr());
    code.append("\n\t");
    code.append("void init() {");
    code.append("\n\t");
    code.append("this.NODE_COLLECTION = new HashMap<String, Node>();");
    code.append("\n\t");
    code.append("}");
    code.append("void solve() {");
    code.append("\n\t");
    code.append(this.generateCallSequenceCode(magrName, inputSetAg, dvgNames));
    code.append("\n\t");
    Map<String, Integer> active = new HashMap<String, Integer>();
    Map<String, Integer> passive = new HashMap<String, Integer>();
    for (int i_1 = 0; (i_1 < this.matchingAndGenerationDataList.size()); i_1++) {
      {
        if ((this.matchingAndGenerationDataList.get(i_1).numberAllocations > 1)) {
          String _get = dvgNames.get(i_1);
          String _plus_2 = ("MAGR_ALLOCATION_" + _get);
          active.put(_plus_2, Integer.valueOf(this.matchingAndGenerationDataList.get(i_1).numberAllocations));
          String _get_1 = dvgNames.get(i_1);
          String _plus_3 = ("MAGR_ALLOCATION_" + _get_1);
          this.equfActives.put(_plus_3, Integer.valueOf(this.matchingAndGenerationDataList.get(i_1).numberAllocations));
        }
        InputOutput.<String>println(("magdl(i): " + this.matchingAndGenerationDataList.get(i_1).active));
      }
    }
    active.put(magrName, Integer.valueOf(numberInputs));
    this.equfActives.put(magrName, Integer.valueOf(numberInputs));
    code.append(FinalEvaluation.getEQUFCode(aggrOutputNames.get(0), active, passive));
    code.append("\n\t");
    code.append("}");
    code.append("}");
    code.append("\n\t");
    return code.toString();
  }
}
