package org.xtext.bb.generator;

import BbDvgTcl.AGGR;
import BbDvgTcl.AbstractInitPort;
import BbDvgTcl.AbstractInputPort;
import BbDvgTcl.AbstractOutputPort;
import BbDvgTcl.Accuracy;
import BbDvgTcl.BBContainer;
import BbDvgTcl.BuildingBlock;
import BbDvgTcl.ComparisonCOp;
import BbDvgTcl.Container;
import BbDvgTcl.DAGGR;
import BbDvgTcl.DMAGR;
import BbDvgTcl.DVG;
import BbDvgTcl.Equal;
import BbDvgTcl.FinalOperation;
import BbDvgTcl.GreaterThan;
import BbDvgTcl.INIT;
import BbDvgTcl.InitCPort;
import BbDvgTcl.InitPort;
import BbDvgTcl.InputCPort;
import BbDvgTcl.InputPort;
import BbDvgTcl.InputWSMPort;
import BbDvgTcl.InternalInputPort;
import BbDvgTcl.InternalOutputPort;
import BbDvgTcl.InternalPortRef;
import BbDvgTcl.LessThan;
import BbDvgTcl.MAGR;
import BbDvgTcl.PortElement;
import BbDvgTcl.RT;
import BbDvgTcl.ResourceGroupId;
import BbDvgTcl.SAPRO;
import BbDvgTcl.VT;
import BbDvgTcl.VariabilityEntity;
import com.google.common.base.Objects;
import dor.BoolDef;
import dor.DataObjectDef;
import dor.ElementRelationship;
import dor.IntegerDef;
import dor.RealDef;
import dor.StringDef;
import dor.TypeDef;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.InputOutput;
import vi.BoolVSPInit;
import vi.ComplexVSPInit;
import vi.IntegerRandomGenerator;
import vi.IntegerVSPInit;
import vi.RealRandomGenerator;
import vi.RealVSPInit;
import vi.StringVSPInit;

@SuppressWarnings("all")
public class Helpers {
  public static int getVSPInitSize(final AbstractInitPort in) {
    if ((in instanceof InitPort)) {
      EObject tmp = ((InitPort)in).getVi();
      if ((tmp instanceof BoolVSPInit)) {
        return ((BoolVSPInit)tmp).getVsp().size();
      } else {
        if ((tmp instanceof IntegerVSPInit)) {
          IntegerRandomGenerator _irg = ((IntegerVSPInit)tmp).getIrg();
          boolean _tripleNotEquals = (_irg != null);
          if (_tripleNotEquals) {
            return ((IntegerVSPInit)tmp).getIrg().getNumber();
          } else {
            return ((IntegerVSPInit)tmp).getVsp().size();
          }
        } else {
          if ((tmp instanceof RealVSPInit)) {
            RealRandomGenerator _rrg = ((RealVSPInit)tmp).getRrg();
            boolean _tripleNotEquals_1 = (_rrg != null);
            if (_tripleNotEquals_1) {
              return ((RealVSPInit)tmp).getRrg().getNumber();
            } else {
              return ((RealVSPInit)tmp).getVsp().size();
            }
          } else {
            if ((tmp instanceof StringVSPInit)) {
              return ((StringVSPInit)tmp).getVsp().size();
            } else {
              if ((tmp instanceof ComplexVSPInit)) {
                return ((ComplexVSPInit)tmp).getVi().size();
              }
            }
          }
        }
      }
    } else {
      if ((in instanceof InitCPort)) {
        EObject tmp_1 = ((InitCPort)in).getVi();
        if ((tmp_1 instanceof BoolVSPInit)) {
          return ((BoolVSPInit)tmp_1).getVsp().size();
        } else {
          if ((tmp_1 instanceof IntegerVSPInit)) {
            IntegerRandomGenerator _irg_1 = ((IntegerVSPInit)tmp_1).getIrg();
            boolean _tripleNotEquals_2 = (_irg_1 != null);
            if (_tripleNotEquals_2) {
              return ((IntegerVSPInit)tmp_1).getIrg().getNumber();
            } else {
              return ((IntegerVSPInit)tmp_1).getVsp().size();
            }
          } else {
            if ((tmp_1 instanceof RealVSPInit)) {
              RealRandomGenerator _rrg_1 = ((RealVSPInit)tmp_1).getRrg();
              boolean _tripleNotEquals_3 = (_rrg_1 != null);
              if (_tripleNotEquals_3) {
                return ((RealVSPInit)tmp_1).getRrg().getNumber();
              } else {
                return ((RealVSPInit)tmp_1).getVsp().size();
              }
            } else {
              if ((tmp_1 instanceof StringVSPInit)) {
                return ((StringVSPInit)tmp_1).getVsp().size();
              } else {
                if ((tmp_1 instanceof ComplexVSPInit)) {
                  return ((ComplexVSPInit)tmp_1).getVi().size();
                }
              }
            }
          }
        }
      }
    }
    return 0;
  }

  public static List<String> getSymbolsForMinOperators(final String expr) {
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

  public static List<String> getSymbolsForMaxOperators(final String expr) {
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

  public static List<String> getSymbolsForComplexDo(final String expr) {
    Pattern p = Pattern.compile("(\\$[a-zA-Z0-9_\\[]*\\]\\$)");
    Matcher m = p.matcher(expr);
    List<String> matches = new ArrayList<String>();
    while (m.find()) {
      {
        String tmp = "";
        int c = 1;
        while ((m.group().codePointAt(c) != 91)) {
          {
            String _tmp = tmp;
            char _charAt = m.group().charAt(c);
            tmp = (_tmp + Character.valueOf(_charAt));
            c++;
          }
        }
        matches.add(tmp);
      }
    }
    return matches;
  }

  public static int getTh(final String name, final List<AbstractInputPort> inputSet) {
    int cnt = 0;
    for (final AbstractInputPort i : inputSet) {
      {
        String _name = i.getName();
        boolean _equals = Objects.equal(name, _name);
        if (_equals) {
          return cnt;
        }
        cnt++;
      }
    }
    return (-1);
  }

  public static AbstractInputPort getNode(final String name, final List<AbstractInputPort> inputSet) {
    for (final AbstractInputPort i : inputSet) {
      String _name = i.getName();
      boolean _equals = Objects.equal(name, _name);
      if (_equals) {
        return i;
      }
    }
    return null;
  }

  public static boolean isComplexDo(final VariabilityEntity ve) {
    DataObjectDef _dor = ve.getDor();
    boolean _tripleNotEquals = (_dor != null);
    if (_tripleNotEquals) {
      ElementRelationship _er = ve.getDor().getEr();
      boolean _tripleEquals = (_er == ElementRelationship.XOR);
      if (_tripleEquals) {
        return false;
      }
      if (((ve.getDor().getEd().size() > 1) || Objects.equal(ve.getDor().getEd().get(0).getTd().getCardinality(), "*"))) {
        return true;
      }
    } else {
      DataObjectDef _doc = ve.getDoc();
      boolean _tripleNotEquals_1 = (_doc != null);
      if (_tripleNotEquals_1) {
        ElementRelationship _er_1 = ve.getDoc().getEr();
        boolean _tripleEquals_1 = (_er_1 == ElementRelationship.XOR);
        if (_tripleEquals_1) {
          return false;
        }
        if (((ve.getDoc().getEd().size() > 1) || Objects.equal(ve.getDoc().getEd().get(0).getTd().getCardinality(), "*"))) {
          return true;
        }
      }
    }
    return false;
  }

  public static TypeDef getTypeFromVe(final VariabilityEntity ve) {
    if ((ve instanceof PortElement)) {
      return ((PortElement)ve).getE().getTd();
    } else {
      DataObjectDef _dor = ve.getDor();
      boolean _tripleNotEquals = (_dor != null);
      if (_tripleNotEquals) {
        return ve.getDor().getEd().get(0).getTd();
      } else {
        DataObjectDef _doc = ve.getDoc();
        boolean _tripleNotEquals_1 = (_doc != null);
        if (_tripleNotEquals_1) {
          return ve.getDoc().getEd().get(0).getTd();
        }
      }
    }
    return null;
  }

  public VT getOutputVTFromInputs(final List<AbstractInputPort> inl) {
    List<VT> VTList = new ArrayList<VT>();
    for (final AbstractInputPort i : inl) {
      if ((inl instanceof InputPort)) {
        VTList.add(((InputPort)inl).getOutputport().getVt());
      } else {
        if ((inl instanceof InternalInputPort)) {
          InternalPortRef tmp = ((InternalInputPort)inl).getInternalportref();
          if ((tmp instanceof InputPort)) {
            VTList.add(((InputPort)tmp).getOutputport().getVt());
          } else {
            if ((tmp instanceof InternalOutputPort)) {
              VTList.add(((InternalOutputPort)tmp).getVt());
            }
          }
        } else {
          if ((inl instanceof InputCPort)) {
            VTList.add(((InputCPort)inl).getOutputcport().getVt());
          } else {
            if ((inl instanceof InputWSMPort)) {
              VTList.add(((InputWSMPort)inl).getOutputwsmport().getVt());
            }
          }
        }
      }
    }
    int numberConstant = 0;
    int numberActive = 0;
    for (final VT i_1 : VTList) {
      {
        boolean _equals = Objects.equal(i_1, VT.CONSTANT);
        if (_equals) {
          numberConstant++;
        }
        boolean _equals_1 = Objects.equal(i_1, VT.ACTIVE);
        if (_equals_1) {
          numberActive++;
        }
      }
    }
    if ((numberActive > 0)) {
      return VT.ACTIVE;
    } else {
      int _size = inl.size();
      boolean _equals = (numberConstant == _size);
      if (_equals) {
        return VT.CONSTANT;
      } else {
        return VT.PASSIVE;
      }
    }
  }

  public static String generateExpressionCode(final String name, final String expr, final List<AbstractInputPort> inputSet) {
    String modifiedExpr = expr;
    Pattern p = Pattern.compile("(\\$[a-zA-Z0-9_\\[\\]]*\\$)");
    Matcher m = p.matcher(expr);
    List<String> matches = new ArrayList<String>();
    while (m.find()) {
      matches.add(m.group());
    }
    String escaped = null;
    for (final String i : matches) {
      {
        int _length = i.length();
        int _minus = (_length - 1);
        int index = Helpers.getTh(i.substring(1, _minus), inputSet);
        int _length_1 = i.length();
        int _minus_1 = (_length_1 - 1);
        AbstractInputPort node = Helpers.getNode(i.substring(1, _minus_1), inputSet);
        int _length_2 = i.length();
        int _minus_2 = (_length_2 - 1);
        String _substring = i.substring(0, _minus_2);
        String _plus = ("\\" + _substring);
        String _plus_1 = (_plus + "\\$");
        escaped = _plus_1;
        if (((index == (-1)) && Objects.equal(escaped, "\\$OUT\\$"))) {
          modifiedExpr = modifiedExpr.replaceAll(escaped, "OUT");
        } else {
          if ((node instanceof InputPort)) {
            boolean _isComplexDo = Helpers.isComplexDo(((InputPort)node).getOutputport().getVe());
            boolean _not = (!_isComplexDo);
            if (_not) {
              if ((Objects.equal(((InputPort)node).getOutputport().getRt(), RT.RELATIVE) || (Objects.equal(((InputPort)node).getOutputport().getRt(), RT.ABSOLUTE) && (Helpers.getTypeFromVe(((InputPort)node).getOutputport().getVe()) instanceof RealDef)))) {
                String _string = Integer.valueOf(index).toString();
                String _plus_2 = ("((Number) valueList.get(" + _string);
                String _plus_3 = (_plus_2 + ")).doubleValue()");
                modifiedExpr = modifiedExpr.replaceAll(escaped, _plus_3);
              } else {
                if ((Objects.equal(((InputPort)node).getOutputport().getRt(), RT.ABSOLUTE) && ((Helpers.getTypeFromVe(((InputPort)node).getOutputport().getVe()) instanceof IntegerDef) || (Helpers.getTypeFromVe(((InputPort)node).getOutputport().getVe()) == null)))) {
                  String _string_1 = Integer.valueOf(index).toString();
                  String _plus_4 = ("((Number) valueList.get(" + _string_1);
                  String _plus_5 = (_plus_4 + ")).intValue()");
                  modifiedExpr = modifiedExpr.replaceAll(escaped, _plus_5);
                } else {
                  if ((Objects.equal(((InputPort)node).getOutputport().getRt(), RT.ABSOLUTE) && (Helpers.getTypeFromVe(((InputPort)node).getOutputport().getVe()) instanceof BoolDef))) {
                    String _string_2 = Integer.valueOf(index).toString();
                    String _plus_6 = ("((Boolean) valueList.get(" + _string_2);
                    String _plus_7 = (_plus_6 + ")).booleanValue()");
                    modifiedExpr = modifiedExpr.replaceAll(escaped, _plus_7);
                  } else {
                    if ((Objects.equal(((InputPort)node).getOutputport().getRt(), RT.ABSOLUTE) && (Helpers.getTypeFromVe(((InputPort)node).getOutputport().getVe()) instanceof StringDef))) {
                      String _string_3 = Integer.valueOf(index).toString();
                      String _plus_8 = ("valueList.get(" + _string_3);
                      String _plus_9 = (_plus_8 + ").toString()");
                      modifiedExpr = modifiedExpr.replaceAll(escaped, _plus_9);
                    }
                  }
                }
              }
            } else {
              int _length_3 = escaped.length();
              int _minus_3 = (_length_3 - 2);
              modifiedExpr = modifiedExpr.replaceAll(escaped, escaped.substring(2, _minus_3));
            }
          } else {
            int _length_4 = i.length();
            int _minus_4 = (_length_4 - 2);
            int _length_5 = i.length();
            int _minus_5 = (_length_5 - 1);
            String _substring_1 = i.substring(_minus_4, _minus_5);
            boolean _equals = Objects.equal(_substring_1, "]");
            if (_equals) {
              int _length_6 = i.length();
              int c = (_length_6 - 2);
              String istr = "";
              while ((!Objects.equal(i.substring((c - 1), c), "["))) {
                {
                  String _istr = istr;
                  String _substring_2 = i.substring((c - 1), c);
                  istr = (_istr + _substring_2);
                  c--;
                }
              }
              String olds = "";
              c = 0;
              int num = 0;
              while ((!Objects.equal(escaped.substring(c, (c + 1)), "["))) {
                {
                  String _olds = olds;
                  String _substring_2 = escaped.substring(c, (c + 1));
                  olds = (_olds + _substring_2);
                  c++;
                  num++;
                }
              }
              String _string_4 = new StringBuilder(istr).reverse().toString();
              String _plus_10 = ((olds + "\\[") + _string_4);
              String _plus_11 = (_plus_10 + "\\]\\$");
              escaped = _plus_11;
              String nodename = escaped.substring(2, num);
              String _string_5 = new StringBuilder(istr).reverse().toString();
              String _plus_12 = ((("((Number) " + nodename) + ".get(") + _string_5);
              String _plus_13 = (_plus_12 + ")).doubleValue()");
              modifiedExpr = modifiedExpr.replaceAll(escaped, _plus_13);
            } else {
              System.err.println("Error in parsing Expression!");
            }
          }
        }
      }
    }
    p = Pattern.compile("(\\$MIN\\([a-zA-Z0-9_]*\\)\\$)");
    m = p.matcher(modifiedExpr);
    ArrayList<String> _arrayList = new ArrayList<String>();
    matches = _arrayList;
    while (m.find()) {
      matches.add(m.group());
    }
    for (final String i_1 : matches) {
      String _quote = Pattern.quote(i_1);
      int _length = i_1.length();
      int _minus = (_length - 2);
      String _substring = i_1.substring(5, _minus);
      String _plus = ("min_" + _substring);
      modifiedExpr = modifiedExpr.replaceAll(_quote, _plus);
    }
    p = Pattern.compile("(\\$MAX\\([a-zA-Z0-9_]*\\)\\$)");
    m = p.matcher(modifiedExpr);
    ArrayList<String> _arrayList_1 = new ArrayList<String>();
    matches = _arrayList_1;
    while (m.find()) {
      matches.add(m.group());
    }
    for (final String i_2 : matches) {
      String _quote_1 = Pattern.quote(i_2);
      int _length_1 = i_2.length();
      int _minus_1 = (_length_1 - 2);
      String _substring_1 = i_2.substring(5, _minus_1);
      String _plus_1 = ("max_" + _substring_1);
      modifiedExpr = modifiedExpr.replaceAll(_quote_1, _plus_1);
    }
    StringBuilder code = new StringBuilder();
    code.append("\n\t\t");
    code.append(modifiedExpr);
    code.append("\n\t\t");
    code.append("return OUT;");
    return code.toString();
  }

  public static String generateExpressionCodePs(final String name, final String expr, final List<AbstractInputPort> inputSet) {
    String modifiedExpr = expr;
    Pattern p = Pattern.compile("(\\$[a-zA-Z0-9_]*\\$)");
    Matcher m = p.matcher(expr);
    List<String> matches = new ArrayList<String>();
    while (m.find()) {
      matches.add(m.group());
    }
    String escaped = null;
    for (final String i : matches) {
      {
        int _length = i.length();
        int _minus = (_length - 1);
        int index = Helpers.getTh(i.substring(1, _minus), inputSet);
        int _length_1 = i.length();
        int _minus_1 = (_length_1 - 1);
        AbstractInputPort node = Helpers.getNode(i.substring(1, _minus_1), inputSet);
        int _length_2 = i.length();
        int _minus_2 = (_length_2 - 1);
        String _substring = i.substring(0, _minus_2);
        String _plus = ("\\" + _substring);
        String _plus_1 = (_plus + "\\$");
        escaped = _plus_1;
        if (((index == (-1)) && Objects.equal(escaped, "\\$OUT\\$"))) {
          modifiedExpr = modifiedExpr.replaceAll(escaped, "OUT");
        } else {
          if ((node instanceof InputPort)) {
            if ((Objects.equal(((InputPort)node).getOutputport().getRt(), RT.RELATIVE) || (Objects.equal(((InputPort)node).getOutputport().getRt(), RT.ABSOLUTE) && (Helpers.getTypeFromVe(((InputPort)node).getOutputport().getVe()) instanceof RealDef)))) {
              String _string = Integer.valueOf(index).toString();
              String _plus_2 = ("((Number) valueList.get(" + _string);
              String _plus_3 = (_plus_2 + ")).doubleValue()");
              modifiedExpr = modifiedExpr.replaceAll(escaped, _plus_3);
            } else {
              if ((Objects.equal(((InputPort)node).getOutputport().getRt(), RT.ABSOLUTE) && (Helpers.getTypeFromVe(((InputPort)node).getOutputport().getVe()) instanceof IntegerDef))) {
                String _string_1 = Integer.valueOf(index).toString();
                String _plus_4 = ("((Number) valueList.get(" + _string_1);
                String _plus_5 = (_plus_4 + ")).intValue()");
                modifiedExpr = modifiedExpr.replaceAll(escaped, _plus_5);
              } else {
                if ((Objects.equal(((InputPort)node).getOutputport().getRt(), RT.ABSOLUTE) && (Helpers.getTypeFromVe(((InputPort)node).getOutputport().getVe()) instanceof BoolDef))) {
                  String _string_2 = Integer.valueOf(index).toString();
                  String _plus_6 = ("((Boolean) valueList.get(" + _string_2);
                  String _plus_7 = (_plus_6 + ")).booleanValue()");
                  modifiedExpr = modifiedExpr.replaceAll(escaped, _plus_7);
                } else {
                  if ((Objects.equal(((InputPort)node).getOutputport().getRt(), RT.ABSOLUTE) && (Helpers.getTypeFromVe(((InputPort)node).getOutputport().getVe()) instanceof StringDef))) {
                    String _string_3 = Integer.valueOf(index).toString();
                    String _plus_8 = ("valueList.get(" + _string_3);
                    String _plus_9 = (_plus_8 + ").toString()");
                    modifiedExpr = modifiedExpr.replaceAll(escaped, _plus_9);
                  }
                }
              }
            }
          }
        }
      }
    }
    List<String> lis = new ArrayList<String>();
    p = Pattern.compile("(\\$OUT.[a-zA-Z0-9_]*\\$)");
    m = p.matcher(modifiedExpr);
    ArrayList<String> _arrayList = new ArrayList<String>();
    matches = _arrayList;
    while (m.find()) {
      matches.add(m.group());
    }
    for (final String i_1 : matches) {
      {
        int _length = i_1.length();
        int _minus = (_length - 1);
        modifiedExpr = modifiedExpr.replaceAll(Pattern.quote(i_1), i_1.substring(5, _minus));
        int _length_1 = i_1.length();
        int _minus_1 = (_length_1 - 1);
        lis.add(i_1.substring(5, _minus_1));
      }
    }
    StringBuilder code = new StringBuilder();
    code.append("Map<String,Double> outMap = new HashMap<String,Double>();");
    code.append("\n\t\t");
    code.append(modifiedExpr);
    for (final String i_2 : lis) {
      {
        code.append((((("outMap.put(\"" + i_2) + "\",") + i_2) + ");"));
        code.append("\n\t\t");
      }
    }
    code.append("\n\t\t");
    code.append("return outMap;");
    return code.toString();
  }

  public static boolean isSAM(final List<String> sl) {
    List<String> sln = new ArrayList<String>();
    for (final String i : sl) {
      boolean _contains = sln.contains(i);
      boolean _not = (!_contains);
      if (_not) {
        sln.add(i);
      } else {
        return true;
      }
    }
    return false;
  }

  public static BbDvgTcl.Pattern getPattern(final AbstractOutputPort aon) {
    EObject obj = aon.eContainer();
    if ((obj instanceof BbDvgTcl.Pattern)) {
      return ((BbDvgTcl.Pattern)obj);
    } else {
      if ((obj instanceof AGGR)) {
        obj = ((AGGR)obj).eContainer();
        if ((obj instanceof MAGR)) {
          return ((BbDvgTcl.Pattern)obj);
        }
      } else {
        if ((obj instanceof DAGGR)) {
          obj = ((DAGGR)obj).eContainer();
          if ((obj instanceof DMAGR)) {
            return ((BbDvgTcl.Pattern)obj);
          }
        }
      }
    }
    return null;
  }

  public boolean isDaggr(final AbstractOutputPort aon) {
    EObject obj = aon.eContainer();
    if ((obj instanceof DAGGR)) {
      return true;
    } else {
      return false;
    }
  }

  public DVG getDVG(final BbDvgTcl.Pattern p) {
    EObject obj = p.eContainer();
    if ((obj instanceof DVG)) {
      return ((DVG)obj);
    }
    return null;
  }

  public static AGGR getAGGR(final AbstractOutputPort aon) {
    EObject obj = aon.eContainer();
    if ((obj instanceof AGGR)) {
      return ((AGGR)obj);
    }
    return null;
  }

  public DAGGR getDAGGR(final AbstractOutputPort aon) {
    EObject obj = aon.eContainer();
    if ((obj instanceof DAGGR)) {
      return ((DAGGR)obj);
    }
    return null;
  }

  public static VariabilityEntity getVeFromPattern(final BbDvgTcl.Pattern pattern) {
    if ((pattern instanceof INIT)) {
      return ((INIT)pattern).getAinip().getVe();
    }
    return null;
  }

  public static int getResGroupOfPattern(final BbDvgTcl.Pattern p) {
    EObject bbc = p.eContainer();
    if ((bbc instanceof BBContainer)) {
      Container _container = ((BBContainer)bbc).getContainer();
      boolean _tripleNotEquals = (_container != null);
      if (_tripleNotEquals) {
        ResourceGroupId _resourcegroupid = ((BBContainer)bbc).getContainer().getResourcegroupid();
        boolean _tripleNotEquals_1 = (_resourcegroupid != null);
        if (_tripleNotEquals_1) {
          ResourceGroupId _resourcegroupid_1 = ((BBContainer)bbc).getContainer().getResourcegroupid();
          String _plus = ("return resourcegroupid: " + _resourcegroupid_1);
          InputOutput.<String>println(_plus);
          return ((BBContainer)bbc).getContainer().getResourcegroupid().getNumber();
        } else {
          InputOutput.<String>println("ERROR: No resourcegroupid!");
          return (-1);
        }
      } else {
        InputOutput.<String>println("ERROR No Container ref!");
        return (-1);
      }
    } else {
      return (-1);
    }
  }

  public ExternalInformation getExternalInformation(final BbDvgTcl.Pattern p) {
    List<String> dvgs = new ArrayList<String>();
    List<String> outputs = new ArrayList<String>();
    String oName = null;
    if ((p instanceof SAPRO)) {
      oName = ((SAPRO)p).getOp().getName();
      EList<InputPort> _ip = ((SAPRO)p).getIp();
      for (final InputPort i : _ip) {
        {
          EObject tmp = Helpers.getPattern(i.getOutputport());
          outputs.add(i.getOutputport().getName());
          tmp = tmp.eContainer();
          if ((tmp instanceof DVG)) {
            dvgs.add(((DVG)tmp).getName());
          }
        }
      }
    }
    ExternalInformation ei = new ExternalInformation();
    ei.pName = p.getName();
    ei.oName = oName;
    ei.dvgs = dvgs;
    ei.outputs = outputs;
    return ei;
  }

  public static List<String> getWrapperAndConversionName(final TypeDef td) {
    List<String> names = new ArrayList<String>(2);
    if ((td instanceof BoolDef)) {
      names.add("Boolean");
      names.add("booleanValue");
    } else {
      if ((td instanceof IntegerDef)) {
        names.add("Integer");
        names.add("intValue");
      } else {
        if ((td instanceof RealDef)) {
          names.add("Double");
          names.add("doubleValue");
        } else {
          if ((td instanceof StringDef)) {
            names.add("String");
            names.add("toString");
          } else {
            System.err.println("getConversionName(TypeDef): Wrong type!");
          }
        }
      }
    }
    return names;
  }

  public static String getComparisonString(final ComparisonCOp cop) {
    String c = null;
    if ((cop instanceof LessThan)) {
      boolean _isInclusive = ((LessThan)cop).isInclusive();
      if (_isInclusive) {
        c = "<=";
      } else {
        c = "<";
      }
    } else {
      if ((cop instanceof GreaterThan)) {
        boolean _isInclusive_1 = ((GreaterThan)cop).isInclusive();
        if (_isInclusive_1) {
          c = ">=";
        } else {
          c = ">";
        }
      } else {
        if ((cop instanceof Equal)) {
          Accuracy _accuracy = ((Equal)cop).getAccuracy();
          boolean _tripleEquals = (_accuracy == null);
          if (_tripleEquals) {
            boolean _isInverse = ((Equal)cop).isInverse();
            if (_isInverse) {
              c = "!=";
            } else {
              c = "==";
            }
          } else {
            boolean _isInverse_1 = ((Equal)cop).isInverse();
            if (_isInverse_1) {
              Accuracy _accuracy_1 = ((Equal)cop).getAccuracy();
              String _plus = ("> " + _accuracy_1);
              c = _plus;
            } else {
              Accuracy _accuracy_2 = ((Equal)cop).getAccuracy();
              String _plus_1 = ("< " + _accuracy_2);
              c = _plus_1;
            }
          }
        } else {
          System.err.println("getComparisonString(ComparisonCOp): Wrong type!");
        }
      }
    }
    return c;
  }

  public static String GetBBFromVE(final VariabilityEntity ve) {
    EObject tmp = ve.eContainer().eContainer().eContainer();
    if ((tmp instanceof BuildingBlock)) {
      return ((BuildingBlock)tmp).getName();
    } else {
      System.err.println("GetBBFromVE(VariabilityEntity): This should not happen!");
      return null;
    }
  }

  public static boolean GetFinalOperationIsMax(final FinalOperation fo) {
    if ((fo != null)) {
      boolean _equals = Objects.equal(fo, FinalOperation.MAX);
      if (_equals) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
