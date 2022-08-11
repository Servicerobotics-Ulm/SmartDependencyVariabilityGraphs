package org.xtext.bb.generator;

import bbn.APRO;
import bbn.AbstractInputPort;
import bbn.AbstractOutputPort;
import bbn.BlockType;
import bbn.BuildingBlock;
import bbn.COMF;
import bbn.CONT;
import bbn.DMAGR;
import bbn.DVG;
import bbn.DVGPort;
import bbn.EPROD;
import bbn.ExtInputPort;
import bbn.INIT;
import bbn.InputPort;
import bbn.MAGR;
import bbn.PTCC;
import bbn.Pattern;
import bbn.PropertyInst;
import bbn.RPRO;
import bbn.SAPRO;
import bbn.TRAN;
import bbn.VariabilityEntity;
import com.google.common.base.Objects;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.InputOutput;

@SuppressWarnings("all")
public class DVGResolution {
  private Map<Pattern, Boolean> IS_RESOLVED_MAP;

  private Helpers he;

  private JavaFunctions jf;

  private StringBuilder code;

  private Pattern abortPattern;

  public Pattern getAbortPattern() {
    return this.abortPattern;
  }

  public String start(final DVG dvg) {
    InputOutput.<String>println("DVGResolution***************************************************************************************************************************************************");
    Helpers _helpers = new Helpers();
    this.he = _helpers;
    JavaFunctions _javaFunctions = new JavaFunctions();
    this.jf = _javaFunctions;
    HashMap<Pattern, Boolean> _hashMap = new HashMap<Pattern, Boolean>();
    this.IS_RESOLVED_MAP = _hashMap;
    StringBuilder _stringBuilder = new StringBuilder();
    this.code = _stringBuilder;
    EList<Pattern> _pattern = dvg.getPattern();
    for (final Pattern i : _pattern) {
      boolean _containsKey = this.IS_RESOLVED_MAP.containsKey(i);
      boolean _not = (!_containsKey);
      if (_not) {
        this.resolveNext(i);
      } else {
        Boolean _get = this.IS_RESOLVED_MAP.get(i);
        boolean _not_1 = (!(_get).booleanValue());
        if (_not_1) {
          this.resolveNext(i);
        }
      }
    }
    this.code.append(this.jf.generateGetCartesianProductFunction());
    this.code.append("\n");
    this.code.append("\n");
    return this.code.toString();
  }

  public Object resolveNext(final Pattern lp) {
    Object _xblockexpression = null;
    {
      String _name = lp.getName();
      String _plus = ("resolveNext, Pattern name: " + _name);
      System.out.println(_plus);
      List<DVGPort> inputSet = new ArrayList<DVGPort>();
      List<List<DVGPort>> inputSetAg = new ArrayList<List<DVGPort>>();
      List<AbstractInputPort> inputSetInputs = new ArrayList<AbstractInputPort>();
      List<List<AbstractMap.SimpleEntry<AbstractOutputPort, String>>> allocInputSet = new ArrayList<List<AbstractMap.SimpleEntry<AbstractOutputPort, String>>>();
      List<Boolean> isAlloc = new ArrayList<Boolean>();
      boolean abort = false;
      if ((lp instanceof INIT)) {
      } else {
        if ((lp instanceof RPRO)) {
        } else {
          if ((lp instanceof SAPRO)) {
            abort = this.abort(((SAPRO)lp).getIp());
            if (abort) {
              this.abortPattern = lp;
            }
            EList<InputPort> _ip = ((SAPRO)lp).getIp();
            for (final InputPort i : _ip) {
              {
                inputSetInputs.add(i);
                inputSet.add(i.getOutputport());
                if ((!abort)) {
                  Pattern lpr = this.he.getPattern(i.getOutputport());
                  boolean _containsKey = this.IS_RESOLVED_MAP.containsKey(lpr);
                  boolean _not = (!_containsKey);
                  if (_not) {
                    this.IS_RESOLVED_MAP.put(lpr, Boolean.valueOf(false));
                    this.resolveNext(lpr);
                  } else {
                    Boolean _get = this.IS_RESOLVED_MAP.get(lpr);
                    boolean _not_1 = (!(_get).booleanValue());
                    if (_not_1) {
                      this.resolveNext(lpr);
                    }
                  }
                }
              }
            }
          } else {
            if ((lp instanceof APRO)) {
            } else {
              if ((lp instanceof MAGR)) {
              } else {
                if ((lp instanceof DMAGR)) {
                } else {
                  if ((lp instanceof CONT)) {
                  } else {
                    if ((lp instanceof EPROD)) {
                    } else {
                      if ((lp instanceof TRAN)) {
                      } else {
                        if ((lp instanceof COMF)) {
                        } else {
                          if ((lp instanceof PTCC)) {
                          } else {
                            InputOutput.<String>println("Unknown Pattern!");
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      this.code.append(this.resolve(lp, inputSetInputs));
      this.IS_RESOLVED_MAP.put(lp, Boolean.valueOf(true));
      Object _xifexpression = null;
      if ((lp instanceof MAGR)) {
        _xifexpression = null;
      } else {
        Object _xifexpression_1 = null;
        if (((!(lp instanceof INIT)) && (!(lp instanceof DMAGR)))) {
          _xifexpression_1 = null;
        }
        _xifexpression = _xifexpression_1;
      }
      _xblockexpression = _xifexpression;
    }
    return _xblockexpression;
  }

  public String resolve(final Pattern lp, final List<AbstractInputPort> inputSet) {
    String _xifexpression = null;
    if ((lp instanceof COMF)) {
      _xifexpression = null;
    } else {
      String _xifexpression_1 = null;
      if ((lp instanceof RPRO)) {
        _xifexpression_1 = null;
      } else {
        String _xifexpression_2 = null;
        if ((lp instanceof SAPRO)) {
          SAPROPattern saprop = new SAPROPattern();
          return saprop.resolve(((SAPRO)lp), inputSet);
        } else {
          String _xifexpression_3 = null;
          if ((lp instanceof APRO)) {
            _xifexpression_3 = null;
          } else {
            String _xifexpression_4 = null;
            if ((lp instanceof MAGR)) {
              _xifexpression_4 = null;
            } else {
              String _xifexpression_5 = null;
              if ((lp instanceof TRAN)) {
                _xifexpression_5 = null;
              } else {
                String _xifexpression_6 = null;
                if ((lp instanceof CONT)) {
                  _xifexpression_6 = null;
                } else {
                  String _xifexpression_7 = null;
                  if ((lp instanceof EPROD)) {
                    _xifexpression_7 = null;
                  } else {
                    String _xifexpression_8 = null;
                    if ((lp instanceof PTCC)) {
                      _xifexpression_8 = null;
                    } else {
                      _xifexpression_8 = InputOutput.<String>println("Unknown Pattern!");
                    }
                    _xifexpression_7 = _xifexpression_8;
                  }
                  _xifexpression_6 = _xifexpression_7;
                }
                _xifexpression_5 = _xifexpression_6;
              }
              _xifexpression_4 = _xifexpression_5;
            }
            _xifexpression_3 = _xifexpression_4;
          }
          _xifexpression_2 = _xifexpression_3;
        }
        _xifexpression_1 = _xifexpression_2;
      }
      _xifexpression = _xifexpression_1;
    }
    return _xifexpression;
  }

  public boolean abort(final List<InputPort> ipl) {
    boolean abort = false;
    for (final InputPort i : ipl) {
      if ((i instanceof ExtInputPort)) {
        VariabilityEntity _ve = ((ExtInputPort)i).getOutputport().getVe();
        if ((_ve instanceof PropertyInst)) {
          EObject tmp = ((ExtInputPort)i).getOutputport().getVe().eContainer().eContainer().eContainer();
          if ((tmp instanceof BuildingBlock)) {
            BlockType _blocktype = ((BuildingBlock)tmp).getBlocktype();
            boolean _equals = Objects.equal(_blocktype, BlockType.ALLOCATABLE);
            if (_equals) {
              abort = true;
            }
          }
        }
      }
    }
    return abort;
  }
}
