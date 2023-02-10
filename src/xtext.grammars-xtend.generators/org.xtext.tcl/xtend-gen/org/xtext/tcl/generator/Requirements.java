package org.xtext.tcl.generator;

import BbDvgTcl.AbstractInitPort;
import BbDvgTcl.BuildingBlock;
import BbDvgTcl.BuildingBlockDescription;
import BbDvgTcl.DVG;
import BbDvgTcl.INIT;
import BbDvgTcl.InitCPort;
import BbDvgTcl.InitWSMPort;
import BbDvgTcl.Pattern;
import java.util.ArrayList;
import java.util.List;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;

@SuppressWarnings("all")
public class Requirements {
  private List<String> constraintRequirements;

  private List<String> preferenceRequirements;

  private boolean alreadyDetermined;

  private DVG dvg;

  public Requirements() {
    this.alreadyDetermined = false;
    ArrayList<String> _arrayList = new ArrayList<String>();
    this.constraintRequirements = _arrayList;
    ArrayList<String> _arrayList_1 = new ArrayList<String>();
    this.preferenceRequirements = _arrayList_1;
  }

  public boolean determine(final BuildingBlock bb) {
    if ((!this.alreadyDetermined)) {
      EObject tmp = bb.eContainer();
      if ((tmp instanceof BuildingBlockDescription)) {
        this.dvg = ((BuildingBlockDescription)tmp).getDvg();
        EList<Pattern> _pattern = this.dvg.getPattern();
        for (final Pattern i : _pattern) {
          if ((i instanceof INIT)) {
            AbstractInitPort _ainip = ((INIT)i).getAinip();
            if ((_ainip instanceof InitCPort)) {
              this.constraintRequirements.add(((INIT)i).getAinip().getName());
            } else {
              AbstractInitPort _ainip_1 = ((INIT)i).getAinip();
              if ((_ainip_1 instanceof InitWSMPort)) {
                this.preferenceRequirements.add(((INIT)i).getAinip().getName());
              }
            }
          }
        }
        this.alreadyDetermined = true;
      }
      return true;
    }
    return false;
  }

  public String generateTclCode() {
    String code = "";
    for (int i = 0; (i < this.constraintRequirements.size()); i++) {
      String _code = code;
      String _get = this.constraintRequirements.get(i);
      String _plus = ("?" + _get);
      String _plus_1 = (_plus + " ");
      code = (_code + _plus_1);
    }
    for (int i = 0; (i < this.preferenceRequirements.size()); i++) {
      String _code = code;
      String _get = this.preferenceRequirements.get(i);
      String _plus = ("?" + _get);
      String _plus_1 = (_plus + " ");
      code = (_code + _plus_1);
    }
    return code;
  }

  public String getDVGName() {
    if ((this.dvg != null)) {
      return this.dvg.getName();
    } else {
      return "solver";
    }
  }

  public List<String> getConstraintRequirements() {
    return this.constraintRequirements;
  }

  public List<String> getPreferenceRequirements() {
    return this.preferenceRequirements;
  }
}
