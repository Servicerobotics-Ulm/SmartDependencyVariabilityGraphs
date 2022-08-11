//================================================================
//
//  Copyright (c) 2022 Technische Hochschule Ulm, Servicerobotics Ulm, Germany
//
//        Servicerobotik Ulm 
//        Christian Schlegel
//        Ulm University of Applied Sciences
//        Prittwitzstr. 10
//        89075 Ulm
//        Germany
//
//	  http://www.servicerobotik-ulm.de/
//
//  This file is part of the SmartDependencyVariabilityGraph feature.
//
//  Author:
//		Timo Blender
//
//  Licence:
//
//  BSD 3-Clause License
//  
//  Copyright (c) 2022, Technische Hochschule Ulm, Servicerobotics Ulm
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//  
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//  
//  * Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  https://opensource.org/licenses/BSD-3-Clause
//
//================================================================

package org.xtext.bb.generator

class LispFunctions {
	
		def String generateGetDataFromFile() {
		
		var StringBuilder code = new StringBuilder
		
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

	return code.toString
	
	}
	
	def String lispCodeWriteToFile() {
		var StringBuilder sb = new StringBuilder()
		
		sb.append("(defun writeToFile (name valueList)\n")
		sb.append("(setf filename \"smartSoftData.txt\")\n")
		sb.append("    (with-open-file (str filename
	     :direction :output
	     :if-exists :append
	     :if-does-not-exist :create)\n")
	     sb.append("(format str \"~s: \" name))\n")
	     sb.append("(setf l (length valueList))\n")
	     sb.append("(setf c 0)\n")
	     sb.append("(loop for value in valueList\n")
	     sb.append("do\n")
	     sb.append("(cond (\n")
	     sb.append("(< c (- l 1))\n")
	     sb.append("(with-open-file (str filename
				     :direction :output
				     :if-exists :append
				     :if-does-not-exist :create)\n")
		 sb.append("(format str \"~s, \" value))\n")
		 sb.append(")\n")
		 sb.append("(T \n")
		 sb.append("(with-open-file (str filename
				     :direction :output
				     :if-exists :append
				     :if-does-not-exist :create)\n")
		 sb.append("(format str \"~s\" value))\n")
		 sb.append(")\n")
		 sb.append(")\n")
		 sb.append("(incf c)\n")
		 sb.append(")\n")
		 sb.append("(with-open-file (str filename
	     		:direction :output
	     		:if-exists :append
	     		:if-does-not-exist :create)\n")
	     sb.append("(format str \"~%\"))\n")
	     sb.append(")\n")
		 
		return sb.toString
	} 
}
