package org.xtext.bb.generator;

import BbDvgTcl.BlockType;
import BbDvgTcl.BuildingBlock;
import BbDvgTcl.BuildingBlockDescription;
import BbDvgTcl.BuildingBlockInst;
import BbDvgTcl.Container;
import BbDvgTcl.DVG;
import BbDvgTcl.Decomposition;
import BbDvgTcl.ResourceGroupId;
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
public class BuildingBlockMatching {
  private Map<Integer, Set<String>> bReq;

  private Map<Integer, Set<String>> bProv;

  private Map<Integer, List<Integer>> capableResource;

  private List<List<Integer>> allocationsListList;

  private List<List<Integer>> allocationsListListNoDuplicates;

  public int getAllocationsNumber() {
    return this.allocationsListListNoDuplicates.size();
  }

  public List<List<Integer>> getAllocations() {
    return this.allocationsListListNoDuplicates;
  }

  public void start(final BuildingBlock b, final DVG d) {
    HashMap<Integer, Set<String>> _hashMap = new HashMap<Integer, Set<String>>();
    this.bReq = _hashMap;
    HashMap<Integer, Set<String>> _hashMap_1 = new HashMap<Integer, Set<String>>();
    this.bProv = _hashMap_1;
    HashMap<Integer, List<Integer>> _hashMap_2 = new HashMap<Integer, List<Integer>>();
    this.capableResource = _hashMap_2;
    this.determineBReq(b);
    for (int i = 0; (i < b.getAllocationCandidates().size()); i++) {
      this.determineBProv(b.getAllocationCandidates().get(i), i);
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
        {
          int resourcegroupid = (-1);
          ResourceGroupId _resourcegroupid = j.getResourcegroupid();
          boolean _tripleNotEquals = (_resourcegroupid != null);
          if (_tripleNotEquals) {
            resourcegroupid = j.getResourcegroupid().getNumber();
          }
          BuildingBlock _bbc = j.getBbc();
          boolean _tripleNotEquals_1 = (_bbc != null);
          if (_tripleNotEquals_1) {
            if ((Objects.equal(j.getBbc().getBlocktype(), null) || Objects.equal(j.getBbc().getBlocktype(), BlockType.IDENTIFYING))) {
              if ((resourcegroupid != (-1))) {
                this.addEntry(resourcegroupid, j.getBbc().getName(), data);
                this.iterateProblem(j.getBbc().getDt(), resourcegroupid, data);
              } else {
                this.addEntry(0, j.getBbc().getName(), data);
                this.iterateProblem(j.getBbc().getDt(), data);
              }
            } else {
              BlockType _blocktype = j.getBbc().getBlocktype();
              boolean _equals = Objects.equal(_blocktype, BlockType.COMPOSED);
              if (_equals) {
                if ((resourcegroupid != (-1))) {
                  this.iterateProblem(j.getBbc().getDt(), resourcegroupid, data);
                } else {
                  this.iterateProblem(j.getBbc().getDt(), data);
                }
              } else {
                BlockType _blocktype_1 = j.getBbc().getBlocktype();
                boolean _equals_1 = Objects.equal(_blocktype_1, BlockType.SUPER_IDENTIFYING);
                if (_equals_1) {
                  if ((resourcegroupid != (-1))) {
                    this.addEntry(resourcegroupid, j.getBbc().getName(), data);
                  } else {
                    this.addEntry(0, j.getBbc().getName(), data);
                  }
                }
              }
            }
          } else {
            BuildingBlock _bbr = j.getBbr();
            boolean _tripleNotEquals_2 = (_bbr != null);
            if (_tripleNotEquals_2) {
              if ((Objects.equal(j.getBbr().getBlocktype(), null) || Objects.equal(j.getBbr().getBlocktype(), BlockType.IDENTIFYING))) {
                if ((resourcegroupid != (-1))) {
                  this.addEntry(resourcegroupid, j.getBbr().getName(), data);
                  this.iterateProblem(j.getBbr().getDt(), resourcegroupid, data);
                } else {
                  this.addEntry(0, j.getBbr().getName(), data);
                  this.iterateProblem(j.getBbr().getDt(), data);
                }
              } else {
                BlockType _blocktype_2 = j.getBbr().getBlocktype();
                boolean _equals_2 = Objects.equal(_blocktype_2, BlockType.COMPOSED);
                if (_equals_2) {
                  if ((resourcegroupid != (-1))) {
                    this.iterateProblem(j.getBbr().getDt(), resourcegroupid, data);
                  } else {
                    this.iterateProblem(j.getBbr().getDt(), data);
                  }
                } else {
                  BlockType _blocktype_3 = j.getBbr().getBlocktype();
                  boolean _equals_3 = Objects.equal(_blocktype_3, BlockType.SUPER_IDENTIFYING);
                  if (_equals_3) {
                    if ((resourcegroupid != (-1))) {
                      this.addEntry(resourcegroupid, j.getBbr().getName(), data);
                    } else {
                      this.addEntry(0, j.getBbr().getName(), data);
                    }
                  }
                }
              }
            } else {
              BuildingBlockInst _bbi = j.getBbi();
              boolean _tripleNotEquals_3 = (_bbi != null);
              if (_tripleNotEquals_3) {
              }
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
        {
          int resourcegroupid = (-1);
          ResourceGroupId _resourcegroupid = j.getResourcegroupid();
          boolean _tripleNotEquals = (_resourcegroupid != null);
          if (_tripleNotEquals) {
            resourcegroupid = j.getResourcegroupid().getNumber();
          }
          BuildingBlock _bbc = j.getBbc();
          boolean _tripleNotEquals_1 = (_bbc != null);
          if (_tripleNotEquals_1) {
            if ((Objects.equal(j.getBbc().getBlocktype(), null) || Objects.equal(j.getBbc().getBlocktype(), BlockType.IDENTIFYING))) {
              this.addEntry(resGroupId, j.getBbc().getName(), data);
              this.iterateProblem(j.getBbc().getDt(), data);
            } else {
              BlockType _blocktype = j.getBbc().getBlocktype();
              boolean _equals = Objects.equal(_blocktype, BlockType.COMPOSED);
              if (_equals) {
                if ((resourcegroupid != (-1))) {
                  this.iterateProblem(j.getBbc().getDt(), resourcegroupid, data);
                }
              } else {
                BlockType _blocktype_1 = j.getBbc().getBlocktype();
                boolean _equals_1 = Objects.equal(_blocktype_1, BlockType.SUPER_IDENTIFYING);
                if (_equals_1) {
                  this.addEntry(resGroupId, j.getBbc().getName(), data);
                }
              }
            }
          } else {
            BuildingBlock _bbr = j.getBbr();
            boolean _tripleNotEquals_2 = (_bbr != null);
            if (_tripleNotEquals_2) {
              if ((Objects.equal(j.getBbr().getBlocktype(), null) || Objects.equal(j.getBbr().getBlocktype(), BlockType.IDENTIFYING))) {
                this.addEntry(resGroupId, j.getBbr().getName(), data);
                this.iterateProblem(j.getBbr().getDt(), data);
              } else {
                BlockType _blocktype_2 = j.getBbr().getBlocktype();
                boolean _equals_2 = Objects.equal(_blocktype_2, BlockType.COMPOSED);
                if (_equals_2) {
                  if ((resourcegroupid != (-1))) {
                    this.iterateProblem(j.getBbr().getDt(), resourcegroupid, data);
                  }
                } else {
                  BlockType _blocktype_3 = j.getBbr().getBlocktype();
                  boolean _equals_3 = Objects.equal(_blocktype_3, BlockType.SUPER_IDENTIFYING);
                  if (_equals_3) {
                    this.addEntry(resGroupId, j.getBbr().getName(), data);
                  }
                }
              }
            } else {
              BuildingBlockInst _bbi = j.getBbi();
              boolean _tripleNotEquals_3 = (_bbi != null);
              if (_tripleNotEquals_3) {
              }
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
        {
          int resourcegroupid = (-1);
          ResourceGroupId _resourcegroupid = j.getResourcegroupid();
          boolean _tripleNotEquals = (_resourcegroupid != null);
          if (_tripleNotEquals) {
            resourcegroupid = j.getResourcegroupid().getNumber();
          }
          BuildingBlock _bbc = j.getBbc();
          boolean _tripleNotEquals_1 = (_bbc != null);
          if (_tripleNotEquals_1) {
            if ((Objects.equal(j.getBbc().getBlocktype(), null) || Objects.equal(j.getBbc().getBlocktype(), BlockType.IDENTIFYING))) {
              if ((resourcegroupid != (-1))) {
              } else {
                this.addEntry(sysId, j.getBbc().getName(), data);
                this.iterateSolution(j.getBbc().getDt(), sysId, data);
              }
            } else {
              BlockType _blocktype = j.getBbc().getBlocktype();
              boolean _equals = Objects.equal(_blocktype, BlockType.COMPOSED);
              if (_equals) {
                if ((resourcegroupid != (-1))) {
                } else {
                }
              }
            }
          } else {
            BuildingBlock _bbr = j.getBbr();
            boolean _tripleNotEquals_2 = (_bbr != null);
            if (_tripleNotEquals_2) {
              if ((Objects.equal(j.getBbr().getBlocktype(), null) || Objects.equal(j.getBbr().getBlocktype(), BlockType.IDENTIFYING))) {
                if ((resourcegroupid != (-1))) {
                } else {
                  this.addEntry(sysId, j.getBbr().getName(), data);
                  this.iterateSolution(j.getBbr().getDt(), sysId, data);
                }
              } else {
                BlockType _blocktype_1 = j.getBbr().getBlocktype();
                boolean _equals_1 = Objects.equal(_blocktype_1, BlockType.COMPOSED);
                if (_equals_1) {
                  if ((resourcegroupid != (-1))) {
                  } else {
                  }
                }
              }
            } else {
              BuildingBlockInst _bbi = j.getBbi();
              boolean _tripleNotEquals_3 = (_bbi != null);
              if (_tripleNotEquals_3) {
              }
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
