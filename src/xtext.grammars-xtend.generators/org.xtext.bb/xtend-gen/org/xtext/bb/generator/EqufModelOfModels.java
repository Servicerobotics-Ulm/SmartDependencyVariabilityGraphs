package org.xtext.bb.generator;

import BbDvgTcl.AGGR;
import BbDvgTcl.DVG;
import BbDvgTcl.DVGPort;
import BbDvgTcl.InputPort;
import BbDvgTcl.MAGR;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class EqufModelOfModels {
  private String code = "";

  private String dvgName;

  private String outputName;

  private String magrName;

  private List<VariabilityInformation> variabilityInformationList;

  private int numberInputs;

  private List<String> dvgNames;

  private List<List<DVGPort>> inputSetAg;

  private Map<String, Integer> ACTIVE;

  private Map<String, Integer> PASSIVE;

  private boolean finalOperationIsMax;

  public Map<String, Integer> getActive() {
    return this.ACTIVE;
  }

  public Map<String, Integer> getPassive() {
    return this.PASSIVE;
  }

  public String getCode() {
    return this.code;
  }

  public String generateCallSequenceCode(final String name, final List<List<DVGPort>> inputSet, final List<String> dvgNames) {
    StringBuilder code = new StringBuilder();
    code.append("params_2d = new ArrayList<List<Node>>();\n");
    for (int i = 0; (i < inputSet.size()); i++) {
      {
        code.append("params = new ArrayList<Node>();\n");
        for (int j = 0; (j < inputSet.get(i).size()); j++) {
          {
            String _get = dvgNames.get(j);
            String _plus = (_get + " s_");
            String _string = Integer.valueOf(j).toString();
            String _plus_1 = (_plus + _string);
            String _plus_2 = (_plus_1 + " = new ");
            String _get_1 = dvgNames.get(j);
            String _plus_3 = (_plus_2 + _get_1);
            String _plus_4 = (_plus_3 + "();\n");
            code.append(_plus_4);
            String _string_1 = Integer.valueOf(j).toString();
            String instName = ("s_" + _string_1);
            String _get_2 = dvgNames.get(j);
            String magrName = ("MAGR_ALLOCATION_" + _get_2);
            code.append((instName + ".init();\n"));
            if ((this.variabilityInformationList.get(j).numberAllocations > 1)) {
              code.append("List<Node> tmp = new ArrayList<Node>();\n");
              code.append((("for (int i = 0; i < " + instName) + ".getAllocations(); i++) {\n"));
              String _name = inputSet.get(i).get(j).getName();
              String _plus_5 = ((("tmp.add(" + instName) + ".solve(\"") + _name);
              String _plus_6 = (_plus_5 + "\",i));\n");
              code.append(_plus_6);
              code.append("}\n");
              code.append((("params.add(AllocationAggr(tmp, \"" + magrName) + "\"));\n"));
            } else {
              String _name_1 = inputSet.get(i).get(j).getName();
              String _plus_7 = ((("params.add(" + instName) + ".solve(\"") + _name_1);
              String _plus_8 = (_plus_7 + "\",0));\n");
              code.append(_plus_8);
            }
          }
        }
        code.append("params_2d.add(params);\n");
      }
    }
    code.append((("resolve_" + name) + "(params_2d);\n"));
    return code.toString();
  }

  public String start(final DVG dvg, final List<VariabilityInformation> variabilityInformationList) {
    String _xblockexpression = null;
    {
      EObject tmp = dvg.getPattern().get(0);
      String _xifexpression = null;
      if ((tmp instanceof MAGR)) {
        String _xblockexpression_1 = null;
        {
          this.dvgName = dvg.getName();
          this.magrName = ((MAGR)tmp).getName();
          this.outputName = dvg.getOutputName();
          this.variabilityInformationList = variabilityInformationList;
          this.finalOperationIsMax = Helpers.GetFinalOperationIsMax(dvg.getFinalOperation());
          this.determineMAGRCallInformation(((MAGR)tmp));
          this.determineVariabilityInformation();
          String _code = this.code;
          CharSequence _generate = this.generate(((MAGR)tmp));
          _xblockexpression_1 = this.code = (_code + _generate);
        }
        _xifexpression = _xblockexpression_1;
      } else {
        System.err.println("ERROR: DVG of EQUF model of model does not contain MAGR as the only pattern!");
      }
      _xblockexpression = _xifexpression;
    }
    return _xblockexpression;
  }

  public void determineMAGRCallInformation(final MAGR magr) {
    ArrayList<List<DVGPort>> _arrayList = new ArrayList<List<DVGPort>>();
    this.inputSetAg = _arrayList;
    ArrayList<String> _arrayList_1 = new ArrayList<String>();
    this.dvgNames = _arrayList_1;
    this.numberInputs = 0;
    EList<AGGR> _aggr = magr.getAggr();
    for (final AGGR i : _aggr) {
      {
        List<DVGPort> tmp2 = new ArrayList<DVGPort>();
        this.numberInputs = i.getIp().size();
        EList<InputPort> _ip = i.getIp();
        for (final InputPort j : _ip) {
          {
            tmp2.add(j.getOutputport());
            EObject dvg2 = Helpers.getPattern(j.getOutputport());
            dvg2 = dvg2.eContainer();
            if ((dvg2 instanceof DVG)) {
              this.dvgNames.add(((DVG)dvg2).getName());
            }
          }
        }
        this.inputSetAg.add(tmp2);
      }
    }
  }

  public Integer determineVariabilityInformation() {
    Integer _xblockexpression = null;
    {
      HashMap<String, Integer> _hashMap = new HashMap<String, Integer>();
      this.ACTIVE = _hashMap;
      HashMap<String, Integer> _hashMap_1 = new HashMap<String, Integer>();
      this.PASSIVE = _hashMap_1;
      for (int i = 0; (i < this.variabilityInformationList.size()); i++) {
        if ((this.variabilityInformationList.get(i).numberAllocations > 1)) {
          String _get = this.dvgNames.get(i);
          String _plus = ("MAGR_ALLOCATION_" + _get);
          this.ACTIVE.put(_plus, Integer.valueOf(this.variabilityInformationList.get(i).numberAllocations));
        }
      }
      _xblockexpression = this.ACTIVE.put(this.magrName, Integer.valueOf(this.numberInputs));
    }
    return _xblockexpression;
  }

  public CharSequence generate(final MAGR magr) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("class ");
    _builder.append(this.dvgName);
    _builder.append(" {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("Node getNode(String name) {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("return NODE_COLLECTION.get(name);");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("private Map<String, Node> NODE_COLLECTION;");
    _builder.newLine();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    String _generateMAGR = this.generateMAGR(magr);
    _builder.append(_generateMAGR, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    String _generateGenericAllocationAggr = JavaFunctions.generateGenericAllocationAggr();
    _builder.append(_generateGenericAllocationAggr, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("void init() {");
    _builder.newLine();
    _builder.append("\t\t");
    _builder.append("this.NODE_COLLECTION = new HashMap<String, Node>();");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("\t");
    CharSequence _generateSolveCode = FinalEvaluation.generateSolveCode(this.outputName, this.finalOperationIsMax, this.generateCallSequenceCode(magr.getName(), this.inputSetAg, this.dvgNames), this.ACTIVE, this.PASSIVE);
    _builder.append(_generateSolveCode, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }

  public String generateMAGR(final MAGR magr) {
    String code = "";
    MAGRPattern magrp = new MAGRPattern(magr);
    magrp.generate();
    String _code = code;
    String _code_1 = magrp.getCode();
    code = (_code + _code_1);
    return code;
  }
}
