package org.xtext.bb.generator;

import bbn.BlockType;
import bbn.BuildingBlock;
import bbn.BuildingBlockDescription;
import bbn.BuildingBlockInst;
import bbn.Container;
import bbn.DMAGR;
import bbn.DVG;
import bbn.Decomposition;
import bbn.Pattern;
import bbn.ResourceGroupId;
import bbn.VariabilityEntity;
import com.google.common.base.Objects;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtext.xbase.lib.InputOutput;

@SuppressWarnings("all")
public class MatchingAndGeneration {
  private Map<Integer, Set<String>> bReq;

  private Map<Integer, Set<String>> bProv;

  private Map<Integer, List<Integer>> capableResource;

  private Set<Integer> allocations;

  private Map<Integer, Set<Integer>> allocationsMap;

  private List<Set<Integer>> allocationsListSet;

  private List<List<Integer>> allocationsListList;

  private List<List<Integer>> allocationsListListNoDuplicates;

  private BuildingBlock problemBB;

  private DVG problemDVG;

  private Map<Integer, BuildingBlockDescription> solutionBB;

  private Map<Integer, List<Pattern>> solutionDVGPattern;

  private SolutionInterfaceMatching sim;

  private BdvgDslGenerator bdvg;

  private boolean generateStaticCode = true;

  private boolean sos = false;

  public int getAllocations() {
    return this.allocationsListListNoDuplicates.size();
  }

  public Map<String, Integer> getActive() {
    return this.bdvg.getActive();
  }

  public Map<String, Integer> getPassive() {
    return this.bdvg.getPassive();
  }

  public String start(final BuildingBlock b, final DVG d, final boolean hasDVGRef, final boolean gsc, final boolean sos) {
    String _xblockexpression = null;
    {
      this.problemBB = b;
      this.problemDVG = d;
      this.generateStaticCode = gsc;
      this.sos = sos;
      HashMap<Integer, Set<String>> _hashMap = new HashMap<Integer, Set<String>>();
      this.bReq = _hashMap;
      HashMap<Integer, Set<String>> _hashMap_1 = new HashMap<Integer, Set<String>>();
      this.bProv = _hashMap_1;
      HashMap<Integer, List<Integer>> _hashMap_2 = new HashMap<Integer, List<Integer>>();
      this.capableResource = _hashMap_2;
      HashMap<Integer, Set<Integer>> _hashMap_3 = new HashMap<Integer, Set<Integer>>();
      this.allocationsMap = _hashMap_3;
      SolutionInterfaceMatching _solutionInterfaceMatching = new SolutionInterfaceMatching();
      this.sim = _solutionInterfaceMatching;
      this.determineBReq(b);
      HashMap<Integer, BuildingBlockDescription> _hashMap_4 = new HashMap<Integer, BuildingBlockDescription>();
      this.solutionBB = _hashMap_4;
      for (int i = 0; (i < b.getAllocationCandidates().size()); i++) {
        {
          this.solutionBB.put(Integer.valueOf(i), b.getAllocationCandidates().get(i));
          this.determineBProv(b.getAllocationCandidates().get(i), i);
        }
      }
      this.determineCapableResources();
      InputOutput.<String>println("capableResources: ");
      Set<Map.Entry<Integer, List<Integer>>> _entrySet = this.capableResource.entrySet();
      for (final Map.Entry<Integer, List<Integer>> i : _entrySet) {
        Integer _key = i.getKey();
        String _plus = (_key + " : ");
        List<Integer> _value = i.getValue();
        String _plus_1 = (_plus + _value);
        InputOutput.<String>println(_plus_1);
      }
      ArrayList<List<Integer>> _arrayList = new ArrayList<List<Integer>>();
      this.allocationsListList = _arrayList;
      ArrayList<List<Integer>> _arrayList_1 = new ArrayList<List<Integer>>();
      this.allocationsListListNoDuplicates = _arrayList_1;
      ArrayList<Integer> _arrayList_2 = new ArrayList<Integer>();
      this.cartesianProduct(_arrayList_2, 0);
      for (int i_1 = 0; (i_1 < this.allocationsListList.size()); i_1++) {
        boolean _hasDuplicates = this.hasDuplicates(this.allocationsListList.get(i_1));
        boolean _not = (!_hasDuplicates);
        if (_not) {
          this.allocationsListListNoDuplicates.add(this.allocationsListList.get(i_1));
        }
      }
      InputOutput.println();
      InputOutput.<String>println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      String _name = this.problemBB.getName();
      String _plus_2 = ("Possible Allocations for <<ALLOCATABLE>> " + _name);
      InputOutput.<String>println(_plus_2);
      InputOutput.<String>println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      for (int i_1 = 0; (i_1 < this.allocationsListListNoDuplicates.size()); i_1++) {
        {
          InputOutput.<String>println("\t---------------------------------------------------------------------");
          InputOutput.<String>println((("\tAllocation " + Integer.valueOf(i_1)) + ":"));
          for (int j = 0; (j < this.allocationsListListNoDuplicates.get(i_1).size()); j++) {
            {
              String _name_1 = this.solutionBB.get(this.allocationsListListNoDuplicates.get(i_1).get(j)).getName();
              String _plus_3 = ((("\t" + Integer.valueOf(j)) + "-th resource group by resource: ") + _name_1);
              InputOutput.<String>print(_plus_3);
              InputOutput.<String>print("\t");
            }
          }
          InputOutput.println();
          InputOutput.<String>println("\t---------------------------------------------------------------------");
        }
      }
      String _xifexpression = null;
      if (hasDVGRef) {
        String _xblockexpression_1 = null;
        {
          HashMap<Integer, List<Pattern>> _hashMap_5 = new HashMap<Integer, List<Pattern>>();
          this.solutionDVGPattern = _hashMap_5;
          BdvgDslGenerator _bdvgDslGenerator = new BdvgDslGenerator();
          this.bdvg = _bdvgDslGenerator;
          DMAGR dmagr = this.sim.getDMAGR(this.problemDVG);
          List<VariabilityEntity> solutionInterface = this.sim.determineSolutionInterface2(dmagr);
          String _xifexpression_1 = null;
          if ((dmagr != null)) {
            List<String> determined = new ArrayList<String>();
            for (int i_1 = 0; (i_1 < this.allocationsListListNoDuplicates.size()); i_1++) {
              for (int j = 0; (j < this.allocationsListListNoDuplicates.get(i_1).size()); j++) {
                {
                  String bbdesc = this.solutionBB.get(this.allocationsListListNoDuplicates.get(i_1).get(j)).getName();
                  boolean _contains = determined.contains(bbdesc);
                  boolean _not = (!_contains);
                  if (_not) {
                    determined.add(bbdesc);
                    DVG _dvg = this.solutionBB.get(this.allocationsListListNoDuplicates.get(i_1).get(j)).getDvg();
                    boolean _tripleNotEquals = (_dvg != null);
                    if (_tripleNotEquals) {
                      List<Pattern> resPattern = this.sim.findMatchingOutputPorts2(this.solutionBB.get(this.allocationsListListNoDuplicates.get(i_1).get(j)).getDvg(), solutionInterface);
                      this.solutionDVGPattern.put(this.allocationsListListNoDuplicates.get(i_1).get(j), resPattern);
                    } else {
                      InputOutput.<String>println("ERROR: No DVG reference of a capable resource!");
                    }
                  }
                }
              }
            }
            return this.bdvg.root(this.problemDVG, this.allocationsListListNoDuplicates, this.solutionDVGPattern, this.generateStaticCode, this.sos);
          } else {
            _xifexpression_1 = InputOutput.<String>println("ERROR: No DMAGR found!");
          }
          _xblockexpression_1 = _xifexpression_1;
        }
        _xifexpression = _xblockexpression_1;
      } else {
        _xifexpression = InputOutput.<String>println("Problem model has no DVG reference!");
      }
      _xblockexpression = _xifexpression;
    }
    return _xblockexpression;
  }

  public void determineBReq(final BuildingBlock b) {
    this.iterateProblem(b.getDt(), this.bReq);
    InputOutput.<String>println("bReq: ");
    Set<Map.Entry<Integer, Set<String>>> _entrySet = this.bReq.entrySet();
    for (final Map.Entry<Integer, Set<String>> i : _entrySet) {
      Integer _key = i.getKey();
      String _plus = (_key + " : ");
      Set<String> _value = i.getValue();
      String _plus_1 = (_plus + _value);
      InputOutput.<String>println(_plus_1);
    }
  }

  public void determineBProv(final BuildingBlockDescription bd, final int sysId) {
    String _name = bd.getName();
    String _plus = ("bbdescp: " + _name);
    InputOutput.<String>println(_plus);
    EList<BuildingBlock> _bb = bd.getBb();
    for (final BuildingBlock i : _bb) {
      {
        String _name_1 = i.getName();
        String _plus_1 = ("candidates bb: " + _name_1);
        InputOutput.<String>println(_plus_1);
        this.addEntry(sysId, i.getName(), this.bProv);
        this.iterateSolution(i.getDt(), sysId, this.bProv);
      }
    }
    EList<Container> _c = bd.getC();
    for (final Container i_1 : _c) {
      {
        String _name_1 = i_1.getBbr().getName();
        String _plus_1 = ("candidates bb: " + _name_1);
        InputOutput.<String>println(_plus_1);
        this.addEntry(sysId, i_1.getBbr().getName(), this.bProv);
        this.iterateSolution(i_1.getBbr().getDt(), sysId, this.bProv);
      }
    }
    InputOutput.<String>println("bProv: ");
    Set<Map.Entry<Integer, Set<String>>> _entrySet = this.bProv.entrySet();
    for (final Map.Entry<Integer, Set<String>> i_2 : _entrySet) {
      Integer _key = i_2.getKey();
      String _plus_1 = (_key + " : ");
      Set<String> _value = i_2.getValue();
      String _plus_2 = (_plus_1 + _value);
      InputOutput.<String>println(_plus_2);
    }
  }

  public void iterateProblem(final List<Decomposition> dl, final Map<Integer, Set<String>> data) {
    for (final Decomposition i : dl) {
      EList<Container> _c = i.getC();
      for (final Container j : _c) {
        BuildingBlock _bbc = j.getBbc();
        boolean _tripleNotEquals = (_bbc != null);
        if (_tripleNotEquals) {
          BlockType _blocktype = j.getBbc().getBlocktype();
          boolean _equals = Objects.equal(_blocktype, BlockType.CONCRETE);
          if (_equals) {
            ResourceGroupId _resourcegroupid = j.getBbc().getResourcegroupid();
            boolean _tripleNotEquals_1 = (_resourcegroupid != null);
            if (_tripleNotEquals_1) {
              this.addEntry(j.getBbc().getResourcegroupid().getNumber(), j.getBbc().getName(), data);
              this.iterateProblem(j.getBbc().getDt(), j.getBbc().getResourcegroupid().getNumber(), data);
            } else {
              this.addEntry(0, j.getBbc().getName(), data);
              this.iterateProblem(j.getBbc().getDt(), data);
            }
          } else {
            BlockType _blocktype_1 = j.getBbc().getBlocktype();
            boolean _equals_1 = Objects.equal(_blocktype_1, BlockType.ABSTRACT);
            if (_equals_1) {
              ResourceGroupId _resourcegroupid_1 = j.getBbc().getResourcegroupid();
              boolean _tripleNotEquals_2 = (_resourcegroupid_1 != null);
              if (_tripleNotEquals_2) {
                this.iterateProblem(j.getBbc().getDt(), j.getBbc().getResourcegroupid().getNumber(), data);
              } else {
                this.iterateProblem(j.getBbc().getDt(), data);
              }
            }
          }
        } else {
          BuildingBlock _bbr = j.getBbr();
          boolean _tripleNotEquals_3 = (_bbr != null);
          if (_tripleNotEquals_3) {
            BlockType _blocktype_2 = j.getBbr().getBlocktype();
            boolean _equals_2 = Objects.equal(_blocktype_2, BlockType.CONCRETE);
            if (_equals_2) {
              ResourceGroupId _resourcegroupid_2 = j.getBbr().getResourcegroupid();
              boolean _tripleNotEquals_4 = (_resourcegroupid_2 != null);
              if (_tripleNotEquals_4) {
                this.addEntry(j.getBbr().getResourcegroupid().getNumber(), j.getBbr().getName(), data);
                this.iterateProblem(j.getBbr().getDt(), j.getBbr().getResourcegroupid().getNumber(), data);
              } else {
                this.addEntry(0, j.getBbr().getName(), data);
                this.iterateProblem(j.getBbr().getDt(), data);
              }
            } else {
              BlockType _blocktype_3 = j.getBbr().getBlocktype();
              boolean _equals_3 = Objects.equal(_blocktype_3, BlockType.ABSTRACT);
              if (_equals_3) {
                ResourceGroupId _resourcegroupid_3 = j.getBbr().getResourcegroupid();
                boolean _tripleNotEquals_5 = (_resourcegroupid_3 != null);
                if (_tripleNotEquals_5) {
                  this.iterateProblem(j.getBbr().getDt(), j.getBbr().getResourcegroupid().getNumber(), data);
                } else {
                  this.iterateProblem(j.getBbr().getDt(), data);
                }
              }
            }
          } else {
            BuildingBlockInst _bbi = j.getBbi();
            boolean _tripleNotEquals_6 = (_bbi != null);
            if (_tripleNotEquals_6) {
            }
          }
        }
      }
    }
  }

  public void iterateProblem(final List<Decomposition> dl, final int resGroupId, final Map<Integer, Set<String>> data) {
    for (final Decomposition i : dl) {
      EList<Container> _c = i.getC();
      for (final Container j : _c) {
        BuildingBlock _bbc = j.getBbc();
        boolean _tripleNotEquals = (_bbc != null);
        if (_tripleNotEquals) {
          BlockType _blocktype = j.getBbc().getBlocktype();
          boolean _equals = Objects.equal(_blocktype, BlockType.CONCRETE);
          if (_equals) {
            this.addEntry(resGroupId, j.getBbc().getName(), data);
            this.iterateProblem(j.getBbc().getDt(), data);
          } else {
            BlockType _blocktype_1 = j.getBbc().getBlocktype();
            boolean _equals_1 = Objects.equal(_blocktype_1, BlockType.ABSTRACT);
            if (_equals_1) {
              this.iterateProblem(j.getBbc().getDt(), j.getBbc().getResourcegroupid().getNumber(), data);
            }
          }
        } else {
          BuildingBlock _bbr = j.getBbr();
          boolean _tripleNotEquals_1 = (_bbr != null);
          if (_tripleNotEquals_1) {
            BlockType _blocktype_2 = j.getBbr().getBlocktype();
            boolean _equals_2 = Objects.equal(_blocktype_2, BlockType.CONCRETE);
            if (_equals_2) {
              this.addEntry(resGroupId, j.getBbr().getName(), data);
              this.iterateProblem(j.getBbr().getDt(), data);
            } else {
              BlockType _blocktype_3 = j.getBbr().getBlocktype();
              boolean _equals_3 = Objects.equal(_blocktype_3, BlockType.ABSTRACT);
              if (_equals_3) {
                this.iterateProblem(j.getBbr().getDt(), j.getBbr().getResourcegroupid().getNumber(), data);
              }
            }
          } else {
            BuildingBlockInst _bbi = j.getBbi();
            boolean _tripleNotEquals_2 = (_bbi != null);
            if (_tripleNotEquals_2) {
            }
          }
        }
      }
    }
  }

  public void iterateSolution(final List<Decomposition> dl, final int sysId, final Map<Integer, Set<String>> data) {
    for (final Decomposition i : dl) {
      EList<Container> _c = i.getC();
      for (final Container j : _c) {
        BuildingBlock _bbc = j.getBbc();
        boolean _tripleNotEquals = (_bbc != null);
        if (_tripleNotEquals) {
          BlockType _blocktype = j.getBbc().getBlocktype();
          boolean _equals = Objects.equal(_blocktype, BlockType.CONCRETE);
          if (_equals) {
            ResourceGroupId _resourcegroupid = j.getBbc().getResourcegroupid();
            boolean _tripleNotEquals_1 = (_resourcegroupid != null);
            if (_tripleNotEquals_1) {
            } else {
              this.addEntry(sysId, j.getBbc().getName(), data);
              this.iterateSolution(j.getBbc().getDt(), sysId, data);
            }
          } else {
            BlockType _blocktype_1 = j.getBbc().getBlocktype();
            boolean _equals_1 = Objects.equal(_blocktype_1, BlockType.ABSTRACT);
            if (_equals_1) {
              ResourceGroupId _resourcegroupid_1 = j.getBbc().getResourcegroupid();
              boolean _tripleNotEquals_2 = (_resourcegroupid_1 != null);
              if (_tripleNotEquals_2) {
              } else {
              }
            }
          }
        } else {
          BuildingBlock _bbr = j.getBbr();
          boolean _tripleNotEquals_3 = (_bbr != null);
          if (_tripleNotEquals_3) {
            BlockType _blocktype_2 = j.getBbr().getBlocktype();
            boolean _equals_2 = Objects.equal(_blocktype_2, BlockType.CONCRETE);
            if (_equals_2) {
              ResourceGroupId _resourcegroupid_2 = j.getBbr().getResourcegroupid();
              boolean _tripleNotEquals_4 = (_resourcegroupid_2 != null);
              if (_tripleNotEquals_4) {
              } else {
                this.addEntry(sysId, j.getBbr().getName(), data);
                this.iterateSolution(j.getBbr().getDt(), sysId, data);
              }
            } else {
              BlockType _blocktype_3 = j.getBbr().getBlocktype();
              boolean _equals_3 = Objects.equal(_blocktype_3, BlockType.ABSTRACT);
              if (_equals_3) {
                ResourceGroupId _resourcegroupid_3 = j.getBbr().getResourcegroupid();
                boolean _tripleNotEquals_5 = (_resourcegroupid_3 != null);
                if (_tripleNotEquals_5) {
                } else {
                }
              }
            }
          } else {
            BuildingBlockInst _bbi = j.getBbi();
            boolean _tripleNotEquals_6 = (_bbi != null);
            if (_tripleNotEquals_6) {
            }
          }
        }
      }
    }
  }

  public Set<String> addEntry(final int id, final String name, final Map<Integer, Set<String>> data) {
    Set<String> _xifexpression = null;
    boolean _containsKey = data.containsKey(Integer.valueOf(id));
    if (_containsKey) {
      Set<String> _xblockexpression = null;
      {
        Set<String> strSet = data.get(Integer.valueOf(id));
        strSet.add(name);
        _xblockexpression = data.put(Integer.valueOf(id), strSet);
      }
      _xifexpression = _xblockexpression;
    } else {
      Set<String> _xblockexpression_1 = null;
      {
        Set<String> strSet = new LinkedHashSet<String>();
        strSet.add(name);
        _xblockexpression_1 = data.put(Integer.valueOf(id), strSet);
      }
      _xifexpression = _xblockexpression_1;
    }
    return _xifexpression;
  }

  public void determineCapableResources() {
    Map<String, Integer> tmp = null;
    Set<Map.Entry<Integer, Set<String>>> _entrySet = this.bProv.entrySet();
    for (final Map.Entry<Integer, Set<String>> i : _entrySet) {
      {
        HashMap<String, Integer> _hashMap = new HashMap<String, Integer>();
        tmp = _hashMap;
        Set<String> _value = i.getValue();
        for (final String j : _value) {
          tmp.put(j, Integer.valueOf(0));
        }
        Set<Map.Entry<Integer, Set<String>>> _entrySet_1 = this.bReq.entrySet();
        for (final Map.Entry<Integer, Set<String>> j_1 : _entrySet_1) {
          {
            boolean isCapable = true;
            Set<String> _value_1 = j_1.getValue();
            for (final String k : _value_1) {
              boolean _containsKey = tmp.containsKey(k);
              boolean _not = (!_containsKey);
              if (_not) {
                isCapable = false;
              }
            }
            if (isCapable) {
              this.addSolutionEntry((j_1.getKey()).intValue(), (i.getKey()).intValue(), this.capableResource);
            }
          }
        }
      }
    }
    InputOutput.<String>println("capableResources: ");
    Set<Map.Entry<Integer, List<Integer>>> _entrySet_1 = this.capableResource.entrySet();
    for (final Map.Entry<Integer, List<Integer>> i_1 : _entrySet_1) {
      Integer _key = i_1.getKey();
      String _plus = (_key + " : ");
      List<Integer> _value = i_1.getValue();
      String _plus_1 = (_plus + _value);
      InputOutput.<String>println(_plus_1);
    }
  }

  public List<Integer> addSolutionEntry(final int group, final int resource, final Map<Integer, List<Integer>> data) {
    List<Integer> _xifexpression = null;
    boolean _containsKey = data.containsKey(Integer.valueOf(group));
    if (_containsKey) {
      List<Integer> _xblockexpression = null;
      {
        List<Integer> l = data.get(Integer.valueOf(group));
        l.add(Integer.valueOf(resource));
        _xblockexpression = data.put(Integer.valueOf(group), l);
      }
      _xifexpression = _xblockexpression;
    } else {
      List<Integer> _xblockexpression_1 = null;
      {
        List<Integer> l = new ArrayList<Integer>();
        l.add(Integer.valueOf(resource));
        _xblockexpression_1 = data.put(Integer.valueOf(group), l);
      }
      _xifexpression = _xblockexpression_1;
    }
    return _xifexpression;
  }

  public void cartesianProduct(final List<Integer> arg, final int cnt) {
    for (int j = 0; (j < this.capableResource.get(Integer.valueOf(cnt)).size()); j++) {
      {
        List<Integer> tmp = new ArrayList<Integer>();
        for (int i = 0; (i < cnt); i++) {
          tmp.add(arg.get(i));
        }
        arg.clear();
        arg.addAll(tmp);
        arg.add(this.capableResource.get(Integer.valueOf(cnt)).get(j));
        int _size = this.capableResource.size();
        int _minus = (_size - 1);
        boolean _equals = (cnt == _minus);
        if (_equals) {
          ArrayList<Integer> _arrayList = new ArrayList<Integer>();
          this.allocationsListList.add(_arrayList);
          int _size_1 = this.allocationsListList.size();
          int _minus_1 = (_size_1 - 1);
          this.allocationsListList.get(_minus_1).addAll(arg);
        } else {
          this.cartesianProduct(arg, (cnt + 1));
        }
      }
    }
  }

  public boolean hasDuplicates(final List<Integer> param) {
    Set<Integer> tmp = new LinkedHashSet<Integer>();
    for (final Integer i : param) {
      boolean _add = tmp.add(i);
      boolean _not = (!_add);
      if (_not) {
        return true;
      }
    }
    return false;
  }
}
