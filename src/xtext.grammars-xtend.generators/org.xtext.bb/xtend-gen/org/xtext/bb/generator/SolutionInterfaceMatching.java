package org.xtext.bb.generator;

import BbDvgTcl.APRO;
import BbDvgTcl.AbstractOutputPort;
import BbDvgTcl.BuildingBlock;
import BbDvgTcl.BuildingBlockDescription;
import BbDvgTcl.DAGGR;
import BbDvgTcl.DMAGR;
import BbDvgTcl.DVG;
import BbDvgTcl.INIT;
import BbDvgTcl.Pattern;
import BbDvgTcl.SAPRO;
import BbDvgTcl.VariabilityEntity;
import com.google.common.base.Objects;
import dor.DataObjectDef;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.InputOutput;

@SuppressWarnings("all")
public class SolutionInterfaceMatching {
  private Map<Integer, List<Pattern>> solutionDVGPattern;

  public Map<Integer, List<Pattern>> getSolutionDVGPattern() {
    return this.solutionDVGPattern;
  }

  public void start(final DVG dvg, final Map<Integer, BuildingBlockDescription> solutionBB, final List<List<Integer>> allocations) {
    HashMap<Integer, List<Pattern>> _hashMap = new HashMap<Integer, List<Pattern>>();
    this.solutionDVGPattern = _hashMap;
    DMAGR dmagr = this.getDMAGR(dvg);
    List<VariabilityEntity> solutionInterface = this.determineSolutionInterface2(dmagr);
    if ((dmagr != null)) {
      List<String> determined = new ArrayList<String>();
      for (int i = 0; (i < allocations.size()); i++) {
        for (int j = 0; (j < allocations.get(i).size()); j++) {
          {
            String bbdesc = solutionBB.get(allocations.get(i).get(j)).getName();
            boolean _contains = determined.contains(bbdesc);
            boolean _not = (!_contains);
            if (_not) {
              determined.add(bbdesc);
              DVG _dvg = solutionBB.get(allocations.get(i).get(j)).getDvg();
              boolean _tripleNotEquals = (_dvg != null);
              if (_tripleNotEquals) {
                List<Pattern> resPattern = this.findMatchingOutputPorts2(solutionBB.get(allocations.get(i).get(j)).getDvg(), solutionInterface);
                this.solutionDVGPattern.put(allocations.get(i).get(j), resPattern);
              } else {
                InputOutput.<String>println("ERROR: No DVG reference of a capable resource!");
              }
            }
          }
        }
      }
    }
  }

  public DMAGR getDMAGR(final DVG dvg) {
    EList<Pattern> _pattern = dvg.getPattern();
    for (final Pattern i : _pattern) {
      if ((i instanceof DMAGR)) {
        return ((DMAGR)i);
      }
    }
    return null;
  }

  public List<AbstractMap.SimpleEntry<DataObjectDef, String>> determineSolutionInterface1(final DMAGR dmagr) {
    List<AbstractMap.SimpleEntry<DataObjectDef, String>> solutionInterface = new ArrayList<AbstractMap.SimpleEntry<DataObjectDef, String>>();
    EList<DAGGR> _daggr = dmagr.getDaggr();
    for (final DAGGR i : _daggr) {
      DataObjectDef _dor = i.getOp().getVe().getDor();
      String _bB = this.getBB(i.getOp().getVe());
      AbstractMap.SimpleEntry<DataObjectDef, String> _simpleEntry = new AbstractMap.SimpleEntry<DataObjectDef, String>(_dor, _bB);
      solutionInterface.add(_simpleEntry);
    }
    return solutionInterface;
  }

  public List<VariabilityEntity> determineSolutionInterface2(final DMAGR dmagr) {
    List<VariabilityEntity> solutionInterface = new ArrayList<VariabilityEntity>();
    EList<DAGGR> _daggr = dmagr.getDaggr();
    for (final DAGGR i : _daggr) {
      solutionInterface.add(i.getOp().getVe());
    }
    return solutionInterface;
  }

  public String getBB(final VariabilityEntity ve) {
    String _xblockexpression = null;
    {
      EObject obj = ve.eContainer().eContainer().eContainer();
      String _xifexpression = null;
      if ((obj instanceof BuildingBlock)) {
        return ((BuildingBlock)obj).getName();
      } else {
        _xifexpression = InputOutput.<String>println("getBB: Something did not work!");
      }
      _xblockexpression = _xifexpression;
    }
    return _xblockexpression;
  }

  public List<Pattern> findMatchingOutputPorts1(final DVG solutionDVG, final List<AbstractMap.SimpleEntry<DataObjectDef, String>> solutionInterface) {
    List<Pattern> resPattern = new ArrayList<Pattern>();
    for (final AbstractMap.SimpleEntry<DataObjectDef, String> i : solutionInterface) {
      {
        DataObjectDef reqDod = i.getKey();
        String reqBBName = i.getValue();
        DataObjectDef provDod = null;
        String provBBName = null;
        AbstractOutputPort aop = null;
        boolean ignore = false;
        EList<Pattern> _pattern = solutionDVG.getPattern();
        for (final Pattern j : _pattern) {
          if ((!ignore)) {
            if ((j instanceof INIT)) {
              provDod = ((INIT)j).getAinip().getVe().getDor();
              provBBName = this.getBB(((INIT)j).getAinip().getVe());
              aop = ((INIT)j).getAinip();
            } else {
              if ((j instanceof SAPRO)) {
                provDod = ((SAPRO)j).getOp().getVe().getDor();
                provBBName = this.getBB(((SAPRO)j).getOp().getVe());
                aop = ((SAPRO)j).getOp();
              } else {
                if ((j instanceof APRO)) {
                  provDod = ((APRO)j).getOp().getVe().getDor();
                  provBBName = this.getBB(((APRO)j).getOp().getVe());
                  aop = ((APRO)j).getOp();
                }
              }
            }
            if ((Objects.equal(reqDod, provDod) && Objects.equal(reqBBName, provBBName))) {
              resPattern.add(this.getPattern(aop));
              ignore = true;
            }
          }
        }
      }
    }
    int _size = solutionInterface.size();
    int _size_1 = resPattern.size();
    boolean _equals = (_size == _size_1);
    if (_equals) {
      InputOutput.<String>println("Successful match for all entries of the solutionInterface!");
    } else {
      InputOutput.<String>println("Unsuccessful match for the solutionInterface!");
    }
    InputOutput.<String>println("solutionInterface1: ");
    for (final AbstractMap.SimpleEntry<DataObjectDef, String> i_1 : solutionInterface) {
      DataObjectDef _key = i_1.getKey();
      String _plus = (_key + "/");
      String _value = i_1.getValue();
      String _plus_1 = (_plus + _value);
      InputOutput.<String>println(_plus_1);
    }
    InputOutput.<String>println("resPattern1: ");
    for (final Pattern i_2 : resPattern) {
      InputOutput.<String>println(i_2.getName());
    }
    return resPattern;
  }

  public List<Pattern> findMatchingOutputPorts2(final DVG solutionDVG, final List<VariabilityEntity> solutionInterface) {
    List<Pattern> resPattern = new ArrayList<Pattern>();
    for (final VariabilityEntity i : solutionInterface) {
      {
        VariabilityEntity reqVe = i;
        VariabilityEntity provVe = null;
        AbstractOutputPort aop = null;
        boolean ignore = false;
        EList<Pattern> _pattern = solutionDVG.getPattern();
        for (final Pattern j : _pattern) {
          if ((!ignore)) {
            if ((j instanceof INIT)) {
              provVe = ((INIT)j).getAinip().getVe();
              aop = ((INIT)j).getAinip();
            } else {
              if ((j instanceof SAPRO)) {
                provVe = ((SAPRO)j).getOp().getVe();
                aop = ((SAPRO)j).getOp();
              } else {
                if ((j instanceof APRO)) {
                  provVe = ((APRO)j).getOp().getVe();
                  aop = ((APRO)j).getOp();
                }
              }
            }
            boolean _equals = Objects.equal(reqVe, provVe);
            if (_equals) {
              resPattern.add(this.getPattern(aop));
              ignore = true;
            }
          }
        }
      }
    }
    int _size = solutionInterface.size();
    int _size_1 = resPattern.size();
    boolean _equals = (_size == _size_1);
    if (_equals) {
      InputOutput.<String>println("Successful match for all entries of the solutionInterface!");
    } else {
      InputOutput.<String>println("Unsuccessful match for the solutionInterface!");
    }
    InputOutput.<String>println("solutionInterface2: ");
    for (final VariabilityEntity i_1 : solutionInterface) {
      InputOutput.<VariabilityEntity>println(i_1);
    }
    InputOutput.<String>println("resPattern2: ");
    for (final Pattern i_2 : resPattern) {
      InputOutput.<String>println(i_2.getName());
    }
    return resPattern;
  }

  public Pattern getPattern(final AbstractOutputPort aon) {
    EObject obj = aon.eContainer();
    if ((obj instanceof Pattern)) {
      return ((Pattern)obj);
    }
    return null;
  }
}
