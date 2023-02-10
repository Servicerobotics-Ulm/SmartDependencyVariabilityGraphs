package org.xtext.bb.generator;

import BbDvgTcl.AbstractInputPort;
import BbDvgTcl.DVG;
import BbDvgTcl.DVGPort;
import BbDvgTcl.InputPort;
import BbDvgTcl.SAPRO;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class ParallelModelOfModels {
  private String code = "";

  private String dvgName;

  private String outputName;

  private String saproName;

  private List<List<VariabilityInformation>> variabilityInformationListList;

  private List<AbstractInputPort> inputSetInputs;

  private List<String> dvgNames;

  private List<DVGPort> inputSet;

  private Map<String, Integer> ACTIVE;

  private Map<String, Integer> PASSIVE;

  private boolean finalOperationIsMax;

  public String getCode() {
    return this.code;
  }

  public String start(final DVG dvg, final List<List<VariabilityInformation>> variabilityInformationListList) {
    String _xblockexpression = null;
    {
      EObject tmp = dvg.getPattern().get(0);
      String _xifexpression = null;
      if ((tmp instanceof SAPRO)) {
        String _xblockexpression_1 = null;
        {
          this.dvgName = dvg.getName();
          this.saproName = ((SAPRO)tmp).getName();
          this.outputName = dvg.getOutputName();
          this.variabilityInformationListList = variabilityInformationListList;
          this.finalOperationIsMax = Helpers.GetFinalOperationIsMax(dvg.getFinalOperation());
          this.determineSAPROCallInformation(((SAPRO)tmp));
          this.determineVariabilityInformation();
          String _code = this.code;
          CharSequence _generate = this.generate(((SAPRO)tmp));
          _xblockexpression_1 = this.code = (_code + _generate);
        }
        _xifexpression = _xblockexpression_1;
      } else {
        System.err.println("ERROR: DVG of Parallel model of model does not contain SAPRO as the only pattern!");
      }
      _xblockexpression = _xifexpression;
    }
    return _xblockexpression;
  }

  public void determineSAPROCallInformation(final SAPRO sapro) {
    ArrayList<DVGPort> _arrayList = new ArrayList<DVGPort>();
    this.inputSet = _arrayList;
    ArrayList<AbstractInputPort> _arrayList_1 = new ArrayList<AbstractInputPort>();
    this.inputSetInputs = _arrayList_1;
    ArrayList<String> _arrayList_2 = new ArrayList<String>();
    this.dvgNames = _arrayList_2;
    EList<InputPort> _ip = sapro.getIp();
    for (final InputPort i : _ip) {
      {
        this.inputSetInputs.add(i);
        this.inputSet.add(i.getOutputport());
        EObject dvg2 = Helpers.getPattern(i.getOutputport());
        dvg2 = dvg2.eContainer();
        if ((dvg2 instanceof DVG)) {
          this.dvgNames.add(((DVG)dvg2).getName());
        }
      }
    }
  }

  public void determineVariabilityInformation() {
    HashMap<String, Integer> _hashMap = new HashMap<String, Integer>();
    this.ACTIVE = _hashMap;
    HashMap<String, Integer> _hashMap_1 = new HashMap<String, Integer>();
    this.PASSIVE = _hashMap_1;
    for (int i = 0; (i < this.variabilityInformationListList.size()); i++) {
      for (int j = 0; (j < this.variabilityInformationListList.get(i).size()); j++) {
        {
          this.ACTIVE.putAll(this.variabilityInformationListList.get(i).get(j).active);
          this.PASSIVE.putAll(this.variabilityInformationListList.get(i).get(j).passive);
          if (((this.variabilityInformationListList.get(i).size() == 1) && (this.variabilityInformationListList.get(i).get(j).numberAllocations > 1))) {
            String _get = this.dvgNames.get(i);
            String _plus = ("MAGR_ALLOCATION_" + _get);
            this.ACTIVE.put(_plus, Integer.valueOf(this.variabilityInformationListList.get(i).get(j).numberAllocations));
          }
        }
      }
    }
  }

  public CharSequence generate(final SAPRO sapro) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("class ");
    _builder.append(this.dvgName);
    _builder.append(" {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("private Map<String, Node> NODE_COLLECTION;");
    _builder.newLine();
    _builder.append("\t");
    CharSequence _generateIsValidCombinationConsiderResource = JavaFunctions.generateIsValidCombinationConsiderResource();
    _builder.append(_generateIsValidCombinationConsiderResource, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    CharSequence _generateGetCartesianProduct = JavaFunctions.generateGetCartesianProduct();
    _builder.append(_generateGetCartesianProduct, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    String _generateSAPRO = this.generateSAPRO(sapro);
    _builder.append(_generateSAPRO, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    String _generateGenericAllocationAggr = JavaFunctions.generateGenericAllocationAggr();
    _builder.append(_generateGenericAllocationAggr, "\t");
    _builder.newLineIfNotEmpty();
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
    CharSequence _generateSolveCode = FinalEvaluation.generateSolveCode(this.outputName, this.finalOperationIsMax, this.generateCallSequenceCode(sapro.getName(), this.inputSet, this.dvgNames), this.ACTIVE, this.PASSIVE);
    _builder.append(_generateSolveCode, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("}\t");
    _builder.newLine();
    return _builder;
  }

  public String generateSAPRO(final SAPRO sapro) {
    String code = "";
    SAPROPattern saprop = new SAPROPattern(sapro, this.inputSetInputs);
    saprop.generate();
    String _code = code;
    String _code_1 = saprop.getCode();
    code = (_code + _code_1);
    return code;
  }

  public String generateCallSequenceCode(final String name, final List<DVGPort> inputSet, final List<String> dvgNames) {
    StringBuilder code = new StringBuilder();
    code.append("params = new ArrayList<Node>();\n");
    for (int i = 0; (i < this.dvgNames.size()); i++) {
      {
        String _get = this.dvgNames.get(i);
        String _plus = (_get + " dvg_");
        String _plus_1 = (_plus + Integer.valueOf(i));
        String _plus_2 = (_plus_1 + " = new ");
        String _get_1 = this.dvgNames.get(i);
        String _plus_3 = (_plus_2 + _get_1);
        String _plus_4 = (_plus_3 + "();\n");
        code.append(_plus_4);
        code.append((("dvg_" + Integer.valueOf(i)) + ".init();\n"));
        int _size = this.variabilityInformationListList.get(i).size();
        boolean _greaterThan = (_size > 1);
        if (_greaterThan) {
          code.append((("dvg_" + Integer.valueOf(i)) + ".solve();\n"));
          String _name = this.inputSet.get(i).getName();
          String _plus_5 = ((("params.add(dvg_" + Integer.valueOf(i)) + ".getNode(\"") + _name);
          String _plus_6 = (_plus_5 + "\"));\n");
          code.append(_plus_6);
        } else {
          if ((this.variabilityInformationListList.get(i).get(0).numberAllocations > 1)) {
            code.append("List<Node> tmp = new ArrayList<Node>();\n");
            code.append((("for (int i = 0; i < dvg_" + Integer.valueOf(i)) + ".getAllocations(); i++) {\n"));
            String _name_1 = this.inputSet.get(i).getName();
            String _plus_7 = ((("tmp.add(dvg_" + Integer.valueOf(i)) + ".solve(\"") + _name_1);
            String _plus_8 = (_plus_7 + "\",i));\n");
            code.append(_plus_8);
            code.append("}\n");
            String _get_2 = this.dvgNames.get(i);
            String _plus_9 = (("params.add(AllocationAggr(tmp, \"" + "MAGR_ALLOCATION_") + _get_2);
            String _plus_10 = (_plus_9 + "\"));\n");
            code.append(_plus_10);
          } else {
            String _name_2 = this.inputSet.get(i).getName();
            String _plus_11 = ((("params.add(dvg_" + Integer.valueOf(i)) + ".solve(\"") + _name_2);
            String _plus_12 = (_plus_11 + "\",0));\n");
            code.append(_plus_12);
          }
        }
      }
    }
    code.append((("resolve_" + this.saproName) + "(params);"));
    return code.toString();
  }
}
