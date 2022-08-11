package org.xtext.bb.generator;

@SuppressWarnings("all")
public class LispFunctions {
  public String generateGetDataFromFile() {
    StringBuilder code = new StringBuilder();
    code.append("String[] getDataFromFile(String searchForName) {\n");
    code.append("try{");
    code.append("FileInputStream fstream = new FileInputStream(\"smartSoftData.txt\");\n");
    code.append("DataInputStream in = new DataInputStream(fstream);\n");
    code.append("BufferedReader br = new BufferedReader(new InputStreamReader(in));\n");
    code.append("String strLine;\n");
    code.append("while ((strLine = br.readLine()) != null) {\n");
    code.append("String[] tokens = strLine.split(\":\");\n");
    code.append("if (tokens[0].equalsIgnoreCase(searchForName)) {\n");
    code.append("String[] tokens2 = tokens[1].split(\",\");\n");
    code.append("return tokens2;");
    code.append("//for (int i = 0; i < tokens2.length; i++) {\n");
    code.append("//System.out.println(tokens2[i]);\n");
    code.append("//}");
    code.append("//System.out.println(tokens[0]+\": \"+tokens[1]);\n");
    code.append("}\n");
    code.append("}\n");
    code.append("in.close();\n");
    code.append("}catch (Exception e){\n");
    code.append("System.err.println(\"Error: \" + e.getMessage());\n");
    code.append("}\n");
    code.append("return null;\n");
    code.append("}\n");
    return code.toString();
  }

  public String lispCodeWriteToFile() {
    StringBuilder sb = new StringBuilder();
    sb.append("(defun writeToFile (name valueList)\n");
    sb.append("(setf filename \"smartSoftData.txt\")\n");
    sb.append("    (with-open-file (str filename\n\t     :direction :output\n\t     :if-exists :append\n\t     :if-does-not-exist :create)\n");
    sb.append("(format str \"~s: \" name))\n");
    sb.append("(setf l (length valueList))\n");
    sb.append("(setf c 0)\n");
    sb.append("(loop for value in valueList\n");
    sb.append("do\n");
    sb.append("(cond (\n");
    sb.append("(< c (- l 1))\n");
    sb.append("(with-open-file (str filename\n\t\t\t\t     :direction :output\n\t\t\t\t     :if-exists :append\n\t\t\t\t     :if-does-not-exist :create)\n");
    sb.append("(format str \"~s, \" value))\n");
    sb.append(")\n");
    sb.append("(T \n");
    sb.append("(with-open-file (str filename\n\t\t\t\t     :direction :output\n\t\t\t\t     :if-exists :append\n\t\t\t\t     :if-does-not-exist :create)\n");
    sb.append("(format str \"~s\" value))\n");
    sb.append(")\n");
    sb.append(")\n");
    sb.append("(incf c)\n");
    sb.append(")\n");
    sb.append("(with-open-file (str filename\n\t     \t\t:direction :output\n\t     \t\t:if-exists :append\n\t     \t\t:if-does-not-exist :create)\n");
    sb.append("(format str \"~%\"))\n");
    sb.append(")\n");
    return sb.toString();
  }
}
