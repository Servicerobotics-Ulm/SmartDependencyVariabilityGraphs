package org.xtext.bb.generator

class Import {
	static def getImportCode() {
		'''
		import java.util.List;
		import java.util.ArrayList;
		import java.util.AbstractMap.SimpleEntry;
		import java.util.Map;
		import java.util.HashMap;
		import java.util.Collections;
		import java.util.Random;
		import java.util.stream.Collectors;
		import java.util.Scanner;
		import java.util.Set;
		import java.util.HashSet;
		import java.io.*;
		'''
	}
}