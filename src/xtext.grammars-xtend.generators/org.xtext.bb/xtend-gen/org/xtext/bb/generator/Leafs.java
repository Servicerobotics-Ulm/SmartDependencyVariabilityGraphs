package org.xtext.bb.generator;

import BbDvgTcl.AbstractInitPort;
import BbDvgTcl.InitCPort;
import BbDvgTcl.InitPort;
import BbDvgTcl.InitWSMPort;
import BbDvgTcl.StaticWeight;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtend2.lib.StringConcatenation;
import vi.BoolVSPInit;
import vi.ComplexVSPInit;
import vi.IntegerRandomGenerator;
import vi.IntegerVSPInit;
import vi.Real;
import vi.RealRandomGenerator;
import vi.RealVSPInit;
import vi.StringVSPInit;
import vi.Type;

@SuppressWarnings("all")
public class Leafs {
  public static String generateLeaf(final AbstractInitPort inn) {
    String res = "";
    if ((inn instanceof InitPort)) {
      EObject tmp = ((InitPort)inn).getVi();
      if ((tmp instanceof BoolVSPInit)) {
        String _res = res;
        CharSequence _generateLeafValuesBoolean = Leafs.generateLeafValuesBoolean(((InitPort)inn).getName(), ((BoolVSPInit)tmp).getVsp());
        res = (_res + _generateLeafValuesBoolean);
      } else {
        if ((tmp instanceof IntegerVSPInit)) {
          IntegerRandomGenerator _irg = ((IntegerVSPInit)tmp).getIrg();
          boolean _tripleNotEquals = (_irg != null);
          if (_tripleNotEquals) {
            String _res_1 = res;
            CharSequence _generateRandomIntegers = Leafs.generateRandomIntegers(((InitPort)inn).getName(), ((IntegerVSPInit)tmp).getIrg().getNumber(), ((IntegerVSPInit)tmp).getIrg().getMin(), ((IntegerVSPInit)tmp).getIrg().getMax());
            res = (_res_1 + _generateRandomIntegers);
          } else {
            String _res_2 = res;
            CharSequence _generateLeafValuesInteger = Leafs.generateLeafValuesInteger(((InitPort)inn).getName(), ((IntegerVSPInit)tmp).getVsp());
            res = (_res_2 + _generateLeafValuesInteger);
          }
        } else {
          if ((tmp instanceof RealVSPInit)) {
            RealRandomGenerator _rrg = ((RealVSPInit)tmp).getRrg();
            boolean _tripleNotEquals_1 = (_rrg != null);
            if (_tripleNotEquals_1) {
              String _res_3 = res;
              CharSequence _generateRandomReals = Leafs.generateRandomReals(((InitPort)inn).getName(), ((RealVSPInit)tmp).getRrg().getNumber(), ((RealVSPInit)tmp).getRrg().getMin(), ((RealVSPInit)tmp).getRrg().getMax());
              res = (_res_3 + _generateRandomReals);
            } else {
              String _res_4 = res;
              CharSequence _generateLeafValuesDouble = Leafs.generateLeafValuesDouble(((InitPort)inn).getName(), ((RealVSPInit)tmp).getVsp());
              res = (_res_4 + _generateLeafValuesDouble);
            }
          } else {
            if ((tmp instanceof StringVSPInit)) {
              String _res_5 = res;
              CharSequence _generateLeafValuesString = Leafs.generateLeafValuesString(((InitPort)inn).getName(), ((StringVSPInit)tmp).getVsp());
              res = (_res_5 + _generateLeafValuesString);
            } else {
              if ((tmp instanceof ComplexVSPInit)) {
                int _size = ((ComplexVSPInit)tmp).getVi().get(0).getE().size();
                boolean _greaterThan = (_size > 1);
                if (_greaterThan) {
                  Type ty = null;
                  List<List<Object>> vsp = new ArrayList<List<Object>>();
                  for (int i = 0; (i < ((ComplexVSPInit)tmp).getVi().size()); i++) {
                    {
                      List<Object> vi = new ArrayList<Object>();
                      for (int j = 0; (j < ((ComplexVSPInit)tmp).getVi().get(i).getE().size()); j++) {
                        {
                          ty = ((ComplexVSPInit)tmp).getVi().get(i).getE().get(j).getT();
                          if ((ty instanceof Real)) {
                            vi.add(Double.valueOf(((Real)ty).getRv().get(0).getValue()));
                          } else {
                            if ((ty instanceof vi.String)) {
                              vi.add(((vi.String)ty).getSv().get(0).getValue());
                            }
                          }
                        }
                      }
                      vsp.add(vi);
                      String _res_6 = res;
                      CharSequence _generateLeafValues = Leafs.generateLeafValues(((InitPort)inn).getName(), vsp);
                      res = (_res_6 + _generateLeafValues);
                    }
                  }
                } else {
                  int _size_1 = ((ComplexVSPInit)tmp).getVi().get(0).getE().size();
                  boolean _equals = (_size_1 == 1);
                  if (_equals) {
                    Type ty_1 = null;
                    List<List<Object>> vsp_1 = new ArrayList<List<Object>>();
                    for (int i = 0; (i < ((ComplexVSPInit)tmp).getVi().size()); i++) {
                      {
                        List<Object> vi = new ArrayList<Object>();
                        ty_1 = ((ComplexVSPInit)tmp).getVi().get(i).getE().get(0).getT();
                        if ((ty_1 instanceof Real)) {
                          for (int j = 0; (j < ((Real)ty_1).getRv().size()); j++) {
                            vi.add(Double.valueOf(((Real)ty_1).getRv().get(j).getValue()));
                          }
                          vsp_1.add(vi);
                        } else {
                          if ((ty_1 instanceof vi.String)) {
                            vi.add(((vi.String)ty_1).getSv().get(0).getValue());
                          }
                        }
                        String _res_6 = res;
                        CharSequence _generateLeafValues = Leafs.generateLeafValues(((InitPort)inn).getName(), vsp_1);
                        res = (_res_6 + _generateLeafValues);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } else {
      if ((inn instanceof InitCPort)) {
        EObject tmp_1 = ((InitCPort)inn).getVi();
        if ((tmp_1 instanceof BoolVSPInit)) {
          String _res_6 = res;
          CharSequence _generateLeafValuesBoolean_1 = Leafs.generateLeafValuesBoolean(((InitCPort)inn).getName(), ((BoolVSPInit)tmp_1).getVsp());
          res = (_res_6 + _generateLeafValuesBoolean_1);
        } else {
          if ((tmp_1 instanceof IntegerVSPInit)) {
            IntegerRandomGenerator _irg_1 = ((IntegerVSPInit)tmp_1).getIrg();
            boolean _tripleNotEquals_2 = (_irg_1 != null);
            if (_tripleNotEquals_2) {
              String _res_7 = res;
              CharSequence _generateRandomIntegers_1 = Leafs.generateRandomIntegers(((InitCPort)inn).getName(), ((IntegerVSPInit)tmp_1).getIrg().getNumber(), ((IntegerVSPInit)tmp_1).getIrg().getMin(), ((IntegerVSPInit)tmp_1).getIrg().getMax());
              res = (_res_7 + _generateRandomIntegers_1);
            } else {
              String _res_8 = res;
              CharSequence _generateLeafValuesInteger_1 = Leafs.generateLeafValuesInteger(((InitCPort)inn).getName(), ((IntegerVSPInit)tmp_1).getVsp());
              res = (_res_8 + _generateLeafValuesInteger_1);
            }
          } else {
            if ((tmp_1 instanceof RealVSPInit)) {
              RealRandomGenerator _rrg_1 = ((RealVSPInit)tmp_1).getRrg();
              boolean _tripleNotEquals_3 = (_rrg_1 != null);
              if (_tripleNotEquals_3) {
                String _res_9 = res;
                CharSequence _generateRandomReals_1 = Leafs.generateRandomReals(((InitCPort)inn).getName(), ((RealVSPInit)tmp_1).getRrg().getNumber(), ((RealVSPInit)tmp_1).getRrg().getMin(), ((RealVSPInit)tmp_1).getRrg().getMax());
                res = (_res_9 + _generateRandomReals_1);
              } else {
                String _res_10 = res;
                CharSequence _generateLeafValuesDouble_1 = Leafs.generateLeafValuesDouble(((InitCPort)inn).getName(), ((RealVSPInit)tmp_1).getVsp());
                res = (_res_10 + _generateLeafValuesDouble_1);
              }
            } else {
              if ((tmp_1 instanceof StringVSPInit)) {
                String _res_11 = res;
                CharSequence _generateLeafValuesString_1 = Leafs.generateLeafValuesString(((InitCPort)inn).getName(), ((StringVSPInit)tmp_1).getVsp());
                res = (_res_11 + _generateLeafValuesString_1);
              }
            }
          }
        }
      } else {
        if ((inn instanceof InitWSMPort)) {
          Map<String, Double> dwStruct = new HashMap<String, Double>();
          EList<StaticWeight> _sw = ((InitWSMPort)inn).getSws().getSw();
          for (final StaticWeight i : _sw) {
            dwStruct.put(i.getInputport().getOutputport().getName(), Double.valueOf(i.getWeight()));
          }
          String _res_12 = res;
          CharSequence _generateLeafValues = Leafs.generateLeafValues(((InitWSMPort)inn).getName(), dwStruct);
          res = (_res_12 + _generateLeafValues);
        }
      }
    }
    return res;
  }

  public static String generateLeaf(final AbstractInitPort inn, final String name) {
    String res = "";
    if ((inn instanceof InitPort)) {
      EObject tmp = ((InitPort)inn).getVi();
      if ((tmp instanceof BoolVSPInit)) {
        String _res = res;
        CharSequence _generateLeafValuesBoolean = Leafs.generateLeafValuesBoolean(name, ((BoolVSPInit)tmp).getVsp());
        res = (_res + _generateLeafValuesBoolean);
      } else {
        if ((tmp instanceof IntegerVSPInit)) {
          IntegerRandomGenerator _irg = ((IntegerVSPInit)tmp).getIrg();
          boolean _tripleNotEquals = (_irg != null);
          if (_tripleNotEquals) {
            String _res_1 = res;
            CharSequence _generateRandomIntegers = Leafs.generateRandomIntegers(name, ((IntegerVSPInit)tmp).getIrg().getNumber(), ((IntegerVSPInit)tmp).getIrg().getMin(), ((IntegerVSPInit)tmp).getIrg().getMax());
            res = (_res_1 + _generateRandomIntegers);
          } else {
            String _res_2 = res;
            CharSequence _generateLeafValuesInteger = Leafs.generateLeafValuesInteger(name, ((IntegerVSPInit)tmp).getVsp());
            res = (_res_2 + _generateLeafValuesInteger);
          }
        } else {
          if ((tmp instanceof RealVSPInit)) {
            RealRandomGenerator _rrg = ((RealVSPInit)tmp).getRrg();
            boolean _tripleNotEquals_1 = (_rrg != null);
            if (_tripleNotEquals_1) {
              String _res_3 = res;
              CharSequence _generateRandomReals = Leafs.generateRandomReals(name, ((RealVSPInit)tmp).getRrg().getNumber(), ((RealVSPInit)tmp).getRrg().getMin(), ((RealVSPInit)tmp).getRrg().getMax());
              res = (_res_3 + _generateRandomReals);
            } else {
              String _res_4 = res;
              CharSequence _generateLeafValuesDouble = Leafs.generateLeafValuesDouble(name, ((RealVSPInit)tmp).getVsp());
              res = (_res_4 + _generateLeafValuesDouble);
            }
          } else {
            if ((tmp instanceof StringVSPInit)) {
              String _res_5 = res;
              CharSequence _generateLeafValuesString = Leafs.generateLeafValuesString(name, ((StringVSPInit)tmp).getVsp());
              res = (_res_5 + _generateLeafValuesString);
            } else {
              if ((tmp instanceof ComplexVSPInit)) {
                int _size = ((ComplexVSPInit)tmp).getVi().get(0).getE().size();
                boolean _greaterThan = (_size > 1);
                if (_greaterThan) {
                  Type ty = null;
                  List<List<Object>> vsp = new ArrayList<List<Object>>();
                  for (int i = 0; (i < ((ComplexVSPInit)tmp).getVi().size()); i++) {
                    {
                      List<Object> vi = new ArrayList<Object>();
                      for (int j = 0; (j < ((ComplexVSPInit)tmp).getVi().get(i).getE().size()); j++) {
                        {
                          ty = ((ComplexVSPInit)tmp).getVi().get(i).getE().get(j).getT();
                          if ((ty instanceof Real)) {
                            vi.add(Double.valueOf(((Real)ty).getRv().get(0).getValue()));
                          } else {
                            if ((ty instanceof vi.String)) {
                              vi.add(((vi.String)ty).getSv().get(0).getValue());
                            }
                          }
                        }
                      }
                      vsp.add(vi);
                      String _res_6 = res;
                      CharSequence _generateLeafValues = Leafs.generateLeafValues(name, vsp);
                      res = (_res_6 + _generateLeafValues);
                    }
                  }
                } else {
                  int _size_1 = ((ComplexVSPInit)tmp).getVi().get(0).getE().size();
                  boolean _equals = (_size_1 == 1);
                  if (_equals) {
                    Type ty_1 = null;
                    List<List<Object>> vsp_1 = new ArrayList<List<Object>>();
                    for (int i = 0; (i < ((ComplexVSPInit)tmp).getVi().size()); i++) {
                      {
                        List<Object> vi = new ArrayList<Object>();
                        ty_1 = ((ComplexVSPInit)tmp).getVi().get(i).getE().get(0).getT();
                        if ((ty_1 instanceof Real)) {
                          for (int j = 0; (j < ((Real)ty_1).getRv().size()); j++) {
                            vi.add(Double.valueOf(((Real)ty_1).getRv().get(j).getValue()));
                          }
                          vsp_1.add(vi);
                        }
                        String _res_6 = res;
                        CharSequence _generateLeafValues = Leafs.generateLeafValues(name, vsp_1);
                        res = (_res_6 + _generateLeafValues);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } else {
      if ((inn instanceof InitCPort)) {
        EObject tmp_1 = ((InitCPort)inn).getVi();
        if ((tmp_1 instanceof BoolVSPInit)) {
          String _res_6 = res;
          CharSequence _generateLeafValuesBoolean_1 = Leafs.generateLeafValuesBoolean(name, ((BoolVSPInit)tmp_1).getVsp());
          res = (_res_6 + _generateLeafValuesBoolean_1);
        } else {
          if ((tmp_1 instanceof IntegerVSPInit)) {
            IntegerRandomGenerator _irg_1 = ((IntegerVSPInit)tmp_1).getIrg();
            boolean _tripleNotEquals_2 = (_irg_1 != null);
            if (_tripleNotEquals_2) {
              String _res_7 = res;
              CharSequence _generateRandomIntegers_1 = Leafs.generateRandomIntegers(name, ((IntegerVSPInit)tmp_1).getIrg().getNumber(), ((IntegerVSPInit)tmp_1).getIrg().getMin(), ((IntegerVSPInit)tmp_1).getIrg().getMax());
              res = (_res_7 + _generateRandomIntegers_1);
            } else {
              String _res_8 = res;
              CharSequence _generateLeafValuesInteger_1 = Leafs.generateLeafValuesInteger(name, ((IntegerVSPInit)tmp_1).getVsp());
              res = (_res_8 + _generateLeafValuesInteger_1);
            }
          } else {
            if ((tmp_1 instanceof RealVSPInit)) {
              RealRandomGenerator _rrg_1 = ((RealVSPInit)tmp_1).getRrg();
              boolean _tripleNotEquals_3 = (_rrg_1 != null);
              if (_tripleNotEquals_3) {
                String _res_9 = res;
                CharSequence _generateRandomReals_1 = Leafs.generateRandomReals(name, ((RealVSPInit)tmp_1).getRrg().getNumber(), ((RealVSPInit)tmp_1).getRrg().getMin(), ((RealVSPInit)tmp_1).getRrg().getMax());
                res = (_res_9 + _generateRandomReals_1);
              } else {
                String _res_10 = res;
                CharSequence _generateLeafValuesDouble_1 = Leafs.generateLeafValuesDouble(name, ((RealVSPInit)tmp_1).getVsp());
                res = (_res_10 + _generateLeafValuesDouble_1);
              }
            } else {
              if ((tmp_1 instanceof StringVSPInit)) {
                String _res_11 = res;
                CharSequence _generateLeafValuesString_1 = Leafs.generateLeafValuesString(name, ((StringVSPInit)tmp_1).getVsp());
                res = (_res_11 + _generateLeafValuesString_1);
              }
            }
          }
        }
      } else {
        if ((inn instanceof InitWSMPort)) {
          Map<String, Double> dwStruct = new HashMap<String, Double>();
          EList<StaticWeight> _sw = ((InitWSMPort)inn).getSws().getSw();
          for (final StaticWeight i : _sw) {
            dwStruct.put(i.getInputport().getOutputport().getName(), Double.valueOf(i.getWeight()));
          }
          String _res_12 = res;
          CharSequence _generateLeafValues = Leafs.generateLeafValues(name, dwStruct);
          res = (_res_12 + _generateLeafValues);
        }
      }
    }
    return res;
  }

  public static String generateLeaf(final AbstractInitPort inn, final String name, final int id) {
    String res = "";
    if ((inn instanceof InitPort)) {
      EObject tmp = ((InitPort)inn).getVi();
      if ((tmp instanceof BoolVSPInit)) {
        String _res = res;
        CharSequence _generateLeafValuesBoolean = Leafs.generateLeafValuesBoolean(name, ((BoolVSPInit)tmp).getVsp(), id);
        res = (_res + _generateLeafValuesBoolean);
      } else {
        if ((tmp instanceof IntegerVSPInit)) {
          IntegerRandomGenerator _irg = ((IntegerVSPInit)tmp).getIrg();
          boolean _tripleNotEquals = (_irg != null);
          if (_tripleNotEquals) {
            String _res_1 = res;
            CharSequence _generateRandomIntegers = Leafs.generateRandomIntegers(name, ((IntegerVSPInit)tmp).getIrg().getNumber(), ((IntegerVSPInit)tmp).getIrg().getMin(), ((IntegerVSPInit)tmp).getIrg().getMax());
            res = (_res_1 + _generateRandomIntegers);
          } else {
            String _res_2 = res;
            CharSequence _generateLeafValuesInteger = Leafs.generateLeafValuesInteger(name, ((IntegerVSPInit)tmp).getVsp(), id);
            res = (_res_2 + _generateLeafValuesInteger);
          }
        } else {
          if ((tmp instanceof RealVSPInit)) {
            RealRandomGenerator _rrg = ((RealVSPInit)tmp).getRrg();
            boolean _tripleNotEquals_1 = (_rrg != null);
            if (_tripleNotEquals_1) {
              String _res_3 = res;
              CharSequence _generateRandomReals = Leafs.generateRandomReals(name, ((RealVSPInit)tmp).getRrg().getNumber(), ((RealVSPInit)tmp).getRrg().getMin(), ((RealVSPInit)tmp).getRrg().getMax());
              res = (_res_3 + _generateRandomReals);
            } else {
              String _res_4 = res;
              CharSequence _generateLeafValuesDouble = Leafs.generateLeafValuesDouble(name, ((RealVSPInit)tmp).getVsp(), id);
              res = (_res_4 + _generateLeafValuesDouble);
            }
          } else {
            if ((tmp instanceof StringVSPInit)) {
              String _res_5 = res;
              CharSequence _generateLeafValuesString = Leafs.generateLeafValuesString(name, ((StringVSPInit)tmp).getVsp(), id);
              res = (_res_5 + _generateLeafValuesString);
            } else {
              if ((tmp instanceof ComplexVSPInit)) {
                int _size = ((ComplexVSPInit)tmp).getVi().get(0).getE().size();
                boolean _greaterThan = (_size > 1);
                if (_greaterThan) {
                  Type ty = null;
                  List<List<Object>> vsp = new ArrayList<List<Object>>();
                  for (int i = 0; (i < ((ComplexVSPInit)tmp).getVi().size()); i++) {
                    {
                      List<Object> vi = new ArrayList<Object>();
                      for (int j = 0; (j < ((ComplexVSPInit)tmp).getVi().get(i).getE().size()); j++) {
                        {
                          ty = ((ComplexVSPInit)tmp).getVi().get(i).getE().get(j).getT();
                          if ((ty instanceof Real)) {
                            vi.add(Double.valueOf(((Real)ty).getRv().get(0).getValue()));
                          }
                        }
                      }
                      vsp.add(vi);
                      String _res_6 = res;
                      CharSequence _generateLeafValues = Leafs.generateLeafValues(name, vsp, id);
                      res = (_res_6 + _generateLeafValues);
                    }
                  }
                } else {
                  int _size_1 = ((ComplexVSPInit)tmp).getVi().get(0).getE().size();
                  boolean _equals = (_size_1 == 1);
                  if (_equals) {
                    Type ty_1 = null;
                    List<List<Object>> vsp_1 = new ArrayList<List<Object>>();
                    for (int i = 0; (i < ((ComplexVSPInit)tmp).getVi().size()); i++) {
                      {
                        List<Object> vi = new ArrayList<Object>();
                        ty_1 = ((ComplexVSPInit)tmp).getVi().get(i).getE().get(0).getT();
                        if ((ty_1 instanceof Real)) {
                          for (int j = 0; (j < ((Real)ty_1).getRv().size()); j++) {
                            vi.add(Double.valueOf(((Real)ty_1).getRv().get(j).getValue()));
                          }
                          vsp_1.add(vi);
                        }
                        String _res_6 = res;
                        CharSequence _generateLeafValues = Leafs.generateLeafValues(name, vsp_1, id);
                        res = (_res_6 + _generateLeafValues);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } else {
      if ((inn instanceof InitCPort)) {
        EObject tmp_1 = ((InitCPort)inn).getVi();
        if ((tmp_1 instanceof BoolVSPInit)) {
          String _res_6 = res;
          CharSequence _generateLeafValuesBoolean_1 = Leafs.generateLeafValuesBoolean(name, ((BoolVSPInit)tmp_1).getVsp());
          res = (_res_6 + _generateLeafValuesBoolean_1);
        } else {
          if ((tmp_1 instanceof IntegerVSPInit)) {
            IntegerRandomGenerator _irg_1 = ((IntegerVSPInit)tmp_1).getIrg();
            boolean _tripleNotEquals_2 = (_irg_1 != null);
            if (_tripleNotEquals_2) {
              String _res_7 = res;
              CharSequence _generateRandomIntegers_1 = Leafs.generateRandomIntegers(name, ((IntegerVSPInit)tmp_1).getIrg().getNumber(), ((IntegerVSPInit)tmp_1).getIrg().getMin(), ((IntegerVSPInit)tmp_1).getIrg().getMax());
              res = (_res_7 + _generateRandomIntegers_1);
            } else {
              String _res_8 = res;
              CharSequence _generateLeafValuesInteger_1 = Leafs.generateLeafValuesInteger(name, ((IntegerVSPInit)tmp_1).getVsp());
              res = (_res_8 + _generateLeafValuesInteger_1);
            }
          } else {
            if ((tmp_1 instanceof RealVSPInit)) {
              RealRandomGenerator _rrg_1 = ((RealVSPInit)tmp_1).getRrg();
              boolean _tripleNotEquals_3 = (_rrg_1 != null);
              if (_tripleNotEquals_3) {
                String _res_9 = res;
                CharSequence _generateRandomReals_1 = Leafs.generateRandomReals(name, ((RealVSPInit)tmp_1).getRrg().getNumber(), ((RealVSPInit)tmp_1).getRrg().getMin(), ((RealVSPInit)tmp_1).getRrg().getMax());
                res = (_res_9 + _generateRandomReals_1);
              } else {
                String _res_10 = res;
                CharSequence _generateLeafValuesDouble_1 = Leafs.generateLeafValuesDouble(name, ((RealVSPInit)tmp_1).getVsp());
                res = (_res_10 + _generateLeafValuesDouble_1);
              }
            } else {
              if ((tmp_1 instanceof StringVSPInit)) {
                String _res_11 = res;
                CharSequence _generateLeafValuesString_1 = Leafs.generateLeafValuesString(name, ((StringVSPInit)tmp_1).getVsp());
                res = (_res_11 + _generateLeafValuesString_1);
              }
            }
          }
        }
      } else {
        if ((inn instanceof InitWSMPort)) {
          Map<String, Double> dwStruct = new HashMap<String, Double>();
          EList<StaticWeight> _sw = ((InitWSMPort)inn).getSws().getSw();
          for (final StaticWeight i : _sw) {
            dwStruct.put(i.getInputport().getOutputport().getName(), Double.valueOf(i.getWeight()));
          }
          String _res_12 = res;
          CharSequence _generateLeafValues = Leafs.generateLeafValues(name, dwStruct);
          res = (_res_12 + _generateLeafValues);
        }
      }
    }
    return res;
  }

  public static CharSequence generateLeafValuesBoolean(final String name, final List<Boolean> leafValues) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    {
      for(final Boolean i : leafValues) {
        _builder.append("leafValues.add(");
        _builder.append(i);
        _builder.append(");");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues);");
    _builder.newLine();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValuesBoolean(final String name, final List<Boolean> leafValues, final int id) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    {
      for(final Boolean i : leafValues) {
        _builder.append("leafValues.add(");
        _builder.append(i);
        _builder.append(");");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues, ");
    _builder.append(id);
    _builder.append(");");
    _builder.newLineIfNotEmpty();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValuesDouble(final String name, final List<Double> leafValues) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    {
      for(final Double i : leafValues) {
        _builder.append("leafValues.add(");
        _builder.append(i);
        _builder.append(");");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues);");
    _builder.newLine();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValuesDouble(final String name, final List<Double> leafValues, final int id) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    {
      for(final Double i : leafValues) {
        _builder.append("leafValues.add(");
        _builder.append(i);
        _builder.append(");");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues, ");
    _builder.append(id);
    _builder.append(");");
    _builder.newLineIfNotEmpty();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValuesInteger(final String name, final List<Integer> leafValues) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    {
      for(final Integer i : leafValues) {
        _builder.append("leafValues.add(");
        _builder.append(i);
        _builder.append(");");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues);");
    _builder.newLine();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValuesInteger(final String name, final List<Integer> leafValues, final int id) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    {
      for(final Integer i : leafValues) {
        _builder.append("leafValues.add(");
        _builder.append(i);
        _builder.append(");");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues, ");
    _builder.append(id);
    _builder.append(");");
    _builder.newLineIfNotEmpty();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValuesString(final String name, final List<String> leafValues) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    {
      for(final String i : leafValues) {
        _builder.append("leafValues.add(\"");
        _builder.append(i);
        _builder.append("\");");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues);");
    _builder.newLine();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValuesString(final String name, final List<String> leafValues, final int id) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    {
      for(final String i : leafValues) {
        _builder.append("leafValues.add(\"");
        _builder.append(i);
        _builder.append("\");");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues, ");
    _builder.append(id);
    _builder.append(");");
    _builder.newLineIfNotEmpty();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateRandomIntegers(final String name, final int number, final int min, final int max) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    _builder.append("random = new Random();");
    _builder.newLine();
    _builder.append("leafValues = random.ints(");
    _builder.append(number);
    _builder.append(", ");
    _builder.append(min);
    _builder.append(", ");
    _builder.append(max);
    _builder.append(").boxed().collect(Collectors.toList());");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues);");
    _builder.newLine();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateRandomReals(final String name, final int number, final double min, final double max) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    _builder.append("random = new Random();");
    _builder.newLine();
    _builder.append("leafValues = random.doubles(");
    _builder.append(number);
    _builder.append(", ");
    _builder.append(min);
    _builder.append(", ");
    _builder.append(max);
    _builder.append(").boxed().collect(Collectors.toList());");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues);");
    _builder.newLine();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValues(final String name, final Map<String, Double> leafValues) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValuesPsMapList= new ArrayList<Map<String,Double>>();");
    _builder.newLine();
    _builder.append("leafValuesPsMap = new HashMap<String,Double>();");
    _builder.newLine();
    {
      Set<Map.Entry<String, Double>> _entrySet = leafValues.entrySet();
      for(final Map.Entry<String, Double> i : _entrySet) {
        _builder.append("leafValuesPsMap.put(\"");
        String _key = i.getKey();
        _builder.append(_key);
        _builder.append("\",");
        Double _value = i.getValue();
        _builder.append(_value);
        _builder.append(");");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("nodePs = new NodePs(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("leafValuesPsMapList.add(leafValuesPsMap);");
    _builder.newLine();
    _builder.append("nodePs.initLeaf(leafValuesPsMapList);");
    _builder.newLine();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodePs);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValues(final String name, final List<List<Object>> leafValues) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues_2 = new ArrayList<List<Object>>();");
    _builder.newLine();
    {
      for(final List<Object> i : leafValues) {
        _builder.append("leafValues = new ArrayList<Object>();");
        _builder.newLine();
        {
          for(final Object j : i) {
            {
              if ((j instanceof String)) {
                _builder.append("leafValues.add(\"");
                _builder.append(((String)j));
                _builder.append("\");");
                _builder.newLineIfNotEmpty();
              } else {
                _builder.append("leafValues.add(");
                _builder.append(j);
                _builder.append(");");
                _builder.newLineIfNotEmpty();
              }
            }
            _builder.newLine();
          }
        }
        _builder.append("leafValues_2.add(leafValues);");
        _builder.newLine();
      }
    }
    _builder.newLine();
    _builder.append("nodeObjectList = new NodeObjectList(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObjectList.initLeaf_2(leafValues_2);");
    _builder.newLine();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObjectList);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValues(final String name, final List<List<Object>> leafValues, final int id) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues_2 = new ArrayList<List<Object>>();");
    _builder.newLine();
    {
      for(final List<Object> i : leafValues) {
        _builder.append("leafValues = new ArrayList<Object>();");
        _builder.newLine();
        {
          for(final Object j : i) {
            _builder.append("leafValues.add(");
            _builder.append(j);
            _builder.append(");");
            _builder.newLineIfNotEmpty();
          }
        }
        _builder.append("leafValues_2.add(leafValues);");
        _builder.newLine();
      }
    }
    _builder.newLine();
    _builder.append("nodeObjectList = new NodeObjectList(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObjectList.initLeaf_2(leafValues_2, ");
    _builder.append(id);
    _builder.append(");");
    _builder.newLineIfNotEmpty();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObjectList);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValuesComplexTcl(final String name) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues_2 = new ArrayList<List<Object>>();");
    _builder.newLine();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    _builder.append("dataFromFile = getDataFromFile(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("for (int i = 0; i < dataFromFile.length; i++) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("leafValues.add(Double.parseDouble(dataFromFile[i])); ");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    _builder.append("leafValues_2.add(leafValues);");
    _builder.newLine();
    _builder.newLine();
    _builder.append("nodeObjectList = new NodeObjectList(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObjectList.initLeaf_2(leafValues_2);");
    _builder.newLine();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObjectList);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }

  public static CharSequence generateLeafValuesTcl(final String name) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("leafValues = new ArrayList<Object>();");
    _builder.newLine();
    _builder.append("dataFromFile = getDataFromFile(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("for (int i = 0; i < dataFromFile.length; i++) {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("leafValues.add(Double.parseDouble(dataFromFile[i])); ");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    _builder.newLine();
    _builder.append("nodeObject = new NodeObject(\"");
    _builder.append(name);
    _builder.append("\");");
    _builder.newLineIfNotEmpty();
    _builder.append("nodeObject.initLeaf(leafValues);");
    _builder.newLine();
    _builder.append("this.NODE_COLLECTION.put(\"");
    _builder.append(name);
    _builder.append("\", nodeObject);");
    _builder.newLineIfNotEmpty();
    return _builder;
  }
}
