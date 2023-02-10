package org.xtext.bb.generator;

import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class Import {
  public static CharSequence getImportCode() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("import java.util.List;");
    _builder.newLine();
    _builder.append("import java.util.ArrayList;");
    _builder.newLine();
    _builder.append("import java.util.AbstractMap.SimpleEntry;");
    _builder.newLine();
    _builder.append("import java.util.Map;");
    _builder.newLine();
    _builder.append("import java.util.HashMap;");
    _builder.newLine();
    _builder.append("import java.util.Collections;");
    _builder.newLine();
    _builder.append("import java.util.Random;");
    _builder.newLine();
    _builder.append("import java.util.stream.Collectors;");
    _builder.newLine();
    _builder.append("import java.util.Scanner;");
    _builder.newLine();
    _builder.append("import java.util.Set;");
    _builder.newLine();
    _builder.append("import java.util.HashSet;");
    _builder.newLine();
    _builder.append("import java.io.*;");
    _builder.newLine();
    return _builder;
  }
}
