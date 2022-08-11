package org.xtext.bb.generator;

@SuppressWarnings("all")
public class Import {
  public String getImportCode() {
    StringBuilder sb = new StringBuilder();
    sb.append("import java.util.List;");
    sb.append("\n");
    sb.append("import java.util.ArrayList;");
    sb.append("\n");
    sb.append("import java.util.AbstractMap.SimpleEntry;");
    sb.append("\n");
    sb.append("import java.util.Map;");
    sb.append("\n");
    sb.append("import java.util.HashMap;");
    sb.append("\n");
    sb.append("import java.util.Collections;");
    sb.append("\n");
    sb.append("import java.util.Random;");
    sb.append("\n");
    sb.append("import java.util.stream.Collectors;");
    sb.append("\n");
    sb.append("import java.util.Scanner;");
    sb.append("\n");
    sb.append("import java.util.Set;");
    sb.append("\n");
    sb.append("import java.util.HashSet;");
    sb.append("\n");
    sb.append("import java.io.*;");
    sb.append("\n");
    return sb.toString();
  }
}
