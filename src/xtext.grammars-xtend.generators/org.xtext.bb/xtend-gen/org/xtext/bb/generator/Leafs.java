package org.xtext.bb.generator;

import java.util.List;
import java.util.Map;
import java.util.Set;

@SuppressWarnings("all")
public class Leafs {
  public String generateLeafValuesInitBool(final String name, final List<Boolean> leafValues) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append("\n\t\t");
    for (final Boolean i : leafValues) {
      {
        code.append((("leafValues.add(" + i) + ");"));
        code.append("\n\t\t");
      }
    }
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("nodeObject.initLeaf(leafValues);");
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInitBool(final String name, final List<Boolean> leafValues, final int id) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append("\n\t\t");
    for (final Boolean i : leafValues) {
      {
        code.append((("leafValues.add(" + i) + ");"));
        code.append("\n\t\t");
      }
    }
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append((("nodeObject.initLeaf(leafValues, " + Integer.valueOf(id)) + ");"));
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInitInteger(final String name, final List<Integer> leafValues) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append("\n\t\t");
    for (final Integer i : leafValues) {
      {
        code.append((("leafValues.add(" + i) + ");"));
        code.append("\n\t\t");
      }
    }
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("nodeObject.initLeaf(leafValues);");
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInitInteger(final String name, final List<Integer> leafValues, final int id) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append("\n\t\t");
    for (final Integer i : leafValues) {
      {
        code.append((("leafValues.add(" + i) + ");"));
        code.append("\n\t\t");
      }
    }
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append((("nodeObject.initLeaf(leafValues, " + Integer.valueOf(id)) + ");"));
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInitReal(final String name, final List<Double> leafValues) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append("\n\t\t");
    for (final Double i : leafValues) {
      {
        code.append((("leafValues.add(" + i) + ");"));
        code.append("\n\t\t");
      }
    }
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("nodeObject.initLeaf(leafValues);");
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInitReal(final String name, final List<Double> leafValues, final int id) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append("\n\t\t");
    for (final Double i : leafValues) {
      {
        code.append((("leafValues.add(" + i) + ");"));
        code.append("\n\t\t");
      }
    }
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append((("nodeObject.initLeaf(leafValues, " + Integer.valueOf(id)) + ");"));
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInitString(final String name, final List<String> leafValues) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append("\n\t\t");
    for (final String i : leafValues) {
      {
        code.append((("leafValues.add(\"" + i) + "\");"));
        code.append("\n\t\t");
      }
    }
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("nodeObject.initLeaf(leafValues);");
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInitString(final String name, final List<String> leafValues, final int id) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append("\n\t\t");
    for (final String i : leafValues) {
      {
        code.append((("leafValues.add(\"" + i) + "\");"));
        code.append("\n\t\t");
      }
    }
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append((("nodeObject.initLeaf(leafValues, " + Integer.valueOf(id)) + ");"));
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateRandomIntegers(final String name, final int number, final int min, final int max) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append("\n\t\t");
    code.append("random = new Random();");
    code.append("\n\t\t");
    code.append((((((("leafValues = random.ints(" + Integer.valueOf(number)) + ",") + Integer.valueOf(min)) + ",") + Integer.valueOf(max)) + ").boxed().collect(Collectors.toList());"));
    code.append("\n\t\t");
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("nodeObject.initLeaf(leafValues);");
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateRandomReals(final String name, final int number, final double min, final double max) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append("\n\t\t");
    code.append("random = new Random();");
    code.append("\n\t\t");
    code.append((((((("leafValues = random.doubles(" + Integer.valueOf(number)) + ",") + Double.valueOf(min)) + ",") + Double.valueOf(max)) + ").boxed().collect(Collectors.toList());"));
    code.append("\n\t\t");
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("nodeObject.initLeaf(leafValues);");
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInit(final String name, final Map<String, Double> leafValues) {
    StringBuilder code = new StringBuilder();
    code.append("leafValuesPsMapList= new ArrayList<Map<String,Double>>();");
    code.append("leafValuesPsMap = new HashMap<String,Double>();");
    code.append("\n\t\t");
    Set<Map.Entry<String, Double>> _entrySet = leafValues.entrySet();
    for (final Map.Entry<String, Double> i : _entrySet) {
      {
        String _key = i.getKey();
        String _plus = ("leafValuesPsMap.put(\"" + _key);
        String _plus_1 = (_plus + "\",");
        Double _value = i.getValue();
        String _plus_2 = (_plus_1 + _value);
        String _plus_3 = (_plus_2 + ");");
        code.append(_plus_3);
        code.append("\n\t\t");
      }
    }
    code.append((("nodePs = new NodePs(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("leafValuesPsMapList.add(leafValuesPsMap);");
    code.append("\n\t\t");
    code.append("nodePs.initLeaf(leafValuesPsMapList);");
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodePs") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInit(final String name, final List<List<Object>> leafValues) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues_2 = new ArrayList<List<Object>>();");
    code.append("\n\t\t");
    for (final List<Object> i : leafValues) {
      {
        code.append("leafValues = new ArrayList<Object>();");
        for (final Object j : i) {
          {
            code.append((("leafValues.add(" + j) + ");"));
            code.append("\n\t\t");
          }
        }
        code.append("leafValues_2.add(leafValues);");
      }
    }
    code.append((("nodeObjectList = new NodeObjectList(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("nodeObjectList.initLeaf_2(leafValues_2);");
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObjectList") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInit(final String name, final List<List<Object>> leafValues, final int id) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues_2 = new ArrayList<List<Object>>();");
    code.append("\n\t\t");
    for (final List<Object> i : leafValues) {
      {
        code.append("leafValues = new ArrayList<Object>();");
        for (final Object j : i) {
          {
            code.append((("leafValues.add(" + j) + ");"));
            code.append("\n\t\t");
          }
        }
        code.append("leafValues_2.add(leafValues);");
      }
    }
    code.append((("nodeObjectList = new NodeObjectList(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append((("nodeObjectList.initLeaf_2(leafValues_2, " + Integer.valueOf(id)) + ");"));
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObjectList") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInitComplexTcl(final String name) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues_2 = new ArrayList<List<Object>>();");
    code.append("\n\t\t");
    code.append("leafValues = new ArrayList<Object>();");
    code.append((("dataFromFile = getDataFromFile(\"" + name) + "\");"));
    code.append("for (int i = 0; i < dataFromFile.length; i++) {");
    code.append("leafValues.add(Double.parseDouble(dataFromFile[i]));");
    code.append("}");
    code.append("leafValues_2.add(leafValues);");
    code.append((("nodeObjectList = new NodeObjectList(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("nodeObjectList.initLeaf_2(leafValues_2);");
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObjectList") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }

  public String generateLeafValuesInitTcl(final String name) {
    StringBuilder code = new StringBuilder();
    code.append("leafValues = new ArrayList<Object>();");
    code.append((("dataFromFile = getDataFromFile(\"" + name) + "\");"));
    code.append("for (int i = 0; i < dataFromFile.length; i++) {");
    code.append("leafValues.add(Double.parseDouble(dataFromFile[i]));");
    code.append("}");
    code.append((("nodeObject = new NodeObject(\"" + name) + "\");"));
    code.append("\n\t\t");
    code.append("nodeObject.initLeaf(leafValues);");
    code.append("\n\t\t");
    code.append(((("this.NODE_COLLECTION.put(\"" + name) + "\", nodeObject") + ");"));
    code.append("\n\t\t");
    code.append("\n\t\t");
    return code.toString();
  }
}
