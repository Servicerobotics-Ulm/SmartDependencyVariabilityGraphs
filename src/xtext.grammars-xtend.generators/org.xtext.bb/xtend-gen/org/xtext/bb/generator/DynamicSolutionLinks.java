package org.xtext.bb.generator;

import bbn.APRO;
import bbn.BBContainer;
import bbn.COMF;
import bbn.CONT;
import bbn.DVG;
import bbn.EPROD;
import bbn.InputPort;
import bbn.MAGR;
import bbn.OutputPort;
import bbn.PTCC;
import bbn.Pattern;
import bbn.RPRO;
import bbn.SAPRO;
import bbn.TRAN;
import java.util.AbstractMap;
import java.util.HashSet;
import java.util.Set;
import org.eclipse.emf.common.util.EList;

@SuppressWarnings("all")
public class DynamicSolutionLinks {
  private Helpers he;

  private Set<AbstractMap.SimpleEntry<Pattern, OutputPort>> depToDaggr;

  public Set<AbstractMap.SimpleEntry<Pattern, OutputPort>> getDepToDaggr() {
    return this.depToDaggr;
  }

  public void determineDMAGRReferences(final DVG dvg) {
    Helpers _helpers = new Helpers();
    this.he = _helpers;
    HashSet<AbstractMap.SimpleEntry<Pattern, OutputPort>> _hashSet = new HashSet<AbstractMap.SimpleEntry<Pattern, OutputPort>>();
    this.depToDaggr = _hashSet;
    EList<Pattern> _pattern = dvg.getPattern();
    for (final Pattern i : _pattern) {
      this.detDAGGRDep(i);
    }
    EList<BBContainer> _bbcontainer = dvg.getBbcontainer();
    for (final BBContainer i_1 : _bbcontainer) {
      this.determineDMAGRReferences(i_1);
    }
  }

  public void determineDMAGRReferences(final BBContainer bbc) {
    EList<Pattern> _pattern = bbc.getPattern();
    for (final Pattern i : _pattern) {
      this.detDAGGRDep(i);
    }
    EList<BBContainer> _bbcontainer = bbc.getBbcontainer();
    for (final BBContainer i_1 : _bbcontainer) {
      this.determineDMAGRReferences(i_1);
    }
  }

  public Object detDAGGRDep(final Pattern p) {
    Object _xifexpression = null;
    if ((p instanceof RPRO)) {
      EList<InputPort> _ip = ((RPRO)p).getIp();
      for (final InputPort i : _ip) {
        OutputPort _outputport = i.getOutputport();
        boolean _tripleNotEquals = (_outputport != null);
        if (_tripleNotEquals) {
          boolean _isDaggr = this.he.isDaggr(i.getOutputport());
          if (_isDaggr) {
            OutputPort _outputport_1 = i.getOutputport();
            AbstractMap.SimpleEntry<Pattern, OutputPort> _simpleEntry = new AbstractMap.SimpleEntry<Pattern, OutputPort>(p, _outputport_1);
            this.depToDaggr.add(_simpleEntry);
          }
        }
      }
    } else {
      Object _xifexpression_1 = null;
      if ((p instanceof SAPRO)) {
        EList<InputPort> _ip_1 = ((SAPRO)p).getIp();
        for (final InputPort i_1 : _ip_1) {
          OutputPort _outputport_2 = i_1.getOutputport();
          boolean _tripleNotEquals_1 = (_outputport_2 != null);
          if (_tripleNotEquals_1) {
            boolean _isDaggr_1 = this.he.isDaggr(i_1.getOutputport());
            if (_isDaggr_1) {
              OutputPort _outputport_3 = i_1.getOutputport();
              AbstractMap.SimpleEntry<Pattern, OutputPort> _simpleEntry_1 = new AbstractMap.SimpleEntry<Pattern, OutputPort>(p, _outputport_3);
              this.depToDaggr.add(_simpleEntry_1);
            }
          }
        }
      } else {
        Object _xifexpression_2 = null;
        if ((p instanceof APRO)) {
          EList<InputPort> _ip_2 = ((APRO)p).getIp();
          for (final InputPort i_2 : _ip_2) {
            OutputPort _outputport_4 = i_2.getOutputport();
            boolean _tripleNotEquals_2 = (_outputport_4 != null);
            if (_tripleNotEquals_2) {
              boolean _isDaggr_2 = this.he.isDaggr(i_2.getOutputport());
              if (_isDaggr_2) {
                OutputPort _outputport_5 = i_2.getOutputport();
                AbstractMap.SimpleEntry<Pattern, OutputPort> _simpleEntry_2 = new AbstractMap.SimpleEntry<Pattern, OutputPort>(p, _outputport_5);
                this.depToDaggr.add(_simpleEntry_2);
              }
            }
          }
        } else {
          Object _xifexpression_3 = null;
          if ((p instanceof MAGR)) {
            _xifexpression_3 = null;
          } else {
            Object _xifexpression_4 = null;
            if ((p instanceof CONT)) {
              _xifexpression_4 = null;
            } else {
              Object _xifexpression_5 = null;
              if ((p instanceof EPROD)) {
                _xifexpression_5 = null;
              } else {
                Object _xifexpression_6 = null;
                if ((p instanceof TRAN)) {
                  _xifexpression_6 = null;
                } else {
                  Object _xifexpression_7 = null;
                  if ((p instanceof COMF)) {
                    _xifexpression_7 = null;
                  } else {
                    Object _xifexpression_8 = null;
                    if ((p instanceof PTCC)) {
                      _xifexpression_8 = null;
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
}
