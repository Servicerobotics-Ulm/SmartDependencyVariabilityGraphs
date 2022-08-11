package org.xtext.bb.generator;

import bbn.BuildingBlockDescription;
import bbn.Container;
import bbn.DVG;
import bbn.Decomposition;
import bbn.EquivalenceFork;
import bbn.Parallel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.InputOutput;

@SuppressWarnings("all")
public class ParallelModelOfModels {
  private DVG problemDVG;

  private List<List<MatchingAndGenerationData>> matchingAndGenerationDataList;

  private ExternalInformation ei;

  private Helpers he;

  private JavaFunctions jf;

  private List<Boolean> isEQUF;

  private Map<String, Integer> equfActives;

  public String start(final Decomposition d, final DVG problemDVG) {
    Helpers _helpers = new Helpers();
    this.he = _helpers;
    JavaFunctions _javaFunctions = new JavaFunctions();
    this.jf = _javaFunctions;
    this.problemDVG = problemDVG;
    ArrayList<Boolean> _arrayList = new ArrayList<Boolean>();
    this.isEQUF = _arrayList;
    HashMap<String, Integer> _hashMap = new HashMap<String, Integer>();
    this.equfActives = _hashMap;
    InputOutput.<String>println("START ParallelModelOfModels");
    if ((d instanceof Parallel)) {
      StringBuilder code = new StringBuilder();
      boolean firstFinished = false;
      ArrayList<List<MatchingAndGenerationData>> _arrayList_1 = new ArrayList<List<MatchingAndGenerationData>>();
      this.matchingAndGenerationDataList = _arrayList_1;
      EList<Container> _c = ((Parallel)d).getC();
      for (final Container i : _c) {
        {
          MatchingAndGeneration mag = new MatchingAndGeneration();
          EObject bbd = i.getBbr().eContainer();
          boolean hasDVGRef = false;
          if ((bbd instanceof BuildingBlockDescription)) {
            DVG _dvg = ((BuildingBlockDescription)bbd).getDvg();
            boolean _tripleNotEquals = (_dvg != null);
            if (_tripleNotEquals) {
              boolean _isEQUF = this.isEQUF(i);
              if (_isEQUF) {
                this.isEQUF.add(Boolean.valueOf(true));
                EqufModelOfModels emom = new EqufModelOfModels();
                if ((!firstFinished)) {
                  code.append(emom.start(i.getBbr().getDt().get(0), ((BuildingBlockDescription)bbd).getDvg(), false));
                  firstFinished = true;
                } else {
                  code.append(emom.start(i.getBbr().getDt().get(0), ((BuildingBlockDescription)bbd).getDvg(), true));
                }
                List<MatchingAndGenerationData> lmagd = emom.getMatchingAndGenerationDataList();
                this.matchingAndGenerationDataList.add(lmagd);
                this.equfActives = emom.getEqufActives();
              } else {
                this.isEQUF.add(Boolean.valueOf(false));
                if ((!firstFinished)) {
                  code.append(mag.start(i.getBbr(), ((BuildingBlockDescription)bbd).getDvg(), true, true, true));
                  firstFinished = true;
                } else {
                  code.append(mag.start(i.getBbr(), ((BuildingBlockDescription)bbd).getDvg(), true, false, true));
                }
                MatchingAndGenerationData magd = new MatchingAndGenerationData();
                magd.numberAllocations = mag.getAllocations();
                magd.active = mag.getActive();
                magd.passive = mag.getPassive();
                List<MatchingAndGenerationData> tmp = new ArrayList<MatchingAndGenerationData>();
                tmp.add(magd);
                this.matchingAndGenerationDataList.add(tmp);
              }
            } else {
              mag.start(i.getBbr(), ((BuildingBlockDescription)bbd).getDvg(), false, false, true);
            }
          }
        }
      }
      String dvgCode = this.generateDVG();
      code.append(this.generateEvaluation(dvgCode));
      return code.toString();
    }
    return null;
  }

  public boolean isEQUF(final Container c) {
    Decomposition _get = c.getBbr().getDt().get(0);
    if ((_get instanceof EquivalenceFork)) {
      return true;
    } else {
      return false;
    }
  }

  public String generateDVG() {
    DVGResolution dvgres = new DVGResolution();
    String code = dvgres.start(this.problemDVG);
    this.ei = this.he.getExternalInformation(dvgres.getAbortPattern());
    return code;
  }

  public String generateEvaluation(final String dvgCode) {
    Map<String, Integer> active = new HashMap<String, Integer>();
    Map<String, Integer> passive = new HashMap<String, Integer>();
    StringBuilder code = new StringBuilder();
    code.append("\n\t");
    String _name = this.problemDVG.getName();
    String _plus = ("class " + _name);
    String _plus_1 = (_plus + "{");
    code.append(_plus_1);
    code.append("\n\t");
    code.append("private Map<String, Node> NODE_COLLECTION;");
    code.append("\n\t");
    code.append(this.jf.generateIsValidCombinationConsiderResource());
    code.append("\n\t");
    code.append(dvgCode);
    code.append("\n\t");
    code.append(this.he.generateGenericAllocationAggr());
    code.append("\n\t");
    code.append("void init() {");
    code.append("\n\t");
    code.append("this.NODE_COLLECTION = new HashMap<String, Node>();");
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("\n\t");
    code.append("void solve() {");
    code.append("\n\t");
    code.append("List<Node> params = new ArrayList<Node>();");
    code.append("\n\t");
    for (int i = 0; (i < this.ei.dvgs.size()); i++) {
      {
        String _get = this.ei.dvgs.get(i);
        String _plus_2 = (_get + " ei_");
        String _plus_3 = (_plus_2 + Integer.valueOf(i));
        String _plus_4 = (_plus_3 + " = new ");
        String _get_1 = this.ei.dvgs.get(i);
        String _plus_5 = (_plus_4 + _get_1);
        String _plus_6 = (_plus_5 + "();");
        code.append(_plus_6);
        code.append("\n\t");
        code.append((("ei_" + Integer.valueOf(i)) + ".init();"));
        code.append("\n\t");
        Boolean _get_2 = this.isEQUF.get(i);
        if ((_get_2).booleanValue()) {
          code.append((("ei_" + Integer.valueOf(i)) + ".solve();"));
          code.append("\n\t");
          String _get_3 = this.ei.outputs.get(i);
          String _plus_7 = ((("params.add(ei_" + Integer.valueOf(i)) + ".getNode(\"") + _get_3);
          String _plus_8 = (_plus_7 + "\"));");
          code.append(_plus_8);
        } else {
          if ((this.matchingAndGenerationDataList.get(i).get(0).numberAllocations > 1)) {
            code.append("\n\t\t");
            code.append("List<Node> tmp = new ArrayList<Node>();");
            code.append("\n\t\t");
            code.append((("for (int i = 0; i < ei_" + Integer.valueOf(i)) + ".getAllocations(); i++) {"));
            code.append("\n\t\t\t");
            String _get_4 = this.ei.outputs.get(i);
            String _plus_9 = ((("tmp.add(ei_" + Integer.valueOf(i)) + ".solve(\"") + _get_4);
            String _plus_10 = (_plus_9 + "\",i));");
            code.append(_plus_10);
            code.append("\n\t\t");
            code.append("}");
            String _get_5 = this.ei.dvgs.get(i);
            String _plus_11 = (("params.add(AllocationAggr(tmp, \"" + "MAGR_ALLOCATION_") + _get_5);
            String _plus_12 = (_plus_11 + "\"));");
            code.append(_plus_12);
            code.append("\n\t\t");
            code.append("\n\t\t");
            String _get_6 = this.ei.dvgs.get(i);
            String _plus_13 = ("MAGR_ALLOCATION_" + _get_6);
            active.put(_plus_13, Integer.valueOf(this.matchingAndGenerationDataList.get(i).get(0).numberAllocations));
          } else {
            code.append("\n\t\t");
            String _get_7 = this.ei.outputs.get(i);
            String _plus_14 = ((("params.add(ei_" + Integer.valueOf(i)) + ".solve(\"") + _get_7);
            String _plus_15 = (_plus_14 + "\",0));");
            code.append(_plus_15);
            code.append("\n\t\t");
          }
        }
        code.append("\n\t");
      }
    }
    code.append("\n\t");
    code.append("\n\t");
    code.append((("resolve_" + this.ei.pName) + "(params);"));
    for (final List<MatchingAndGenerationData> i : this.matchingAndGenerationDataList) {
      for (final MatchingAndGenerationData j : i) {
        {
          active.putAll(j.active);
          passive.putAll(j.passive);
        }
      }
    }
    active.putAll(this.equfActives);
    code.append("System.out.println(\"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\");");
    code.append(FinalEvaluation.getEQUFCode(this.ei.oName, active, passive));
    code.append("\n\t");
    code.append("}");
    code.append("\n\t");
    code.append("}");
    return code.toString();
  }
}
