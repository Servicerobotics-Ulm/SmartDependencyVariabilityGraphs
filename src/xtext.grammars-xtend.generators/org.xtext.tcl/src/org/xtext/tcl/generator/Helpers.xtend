package org.xtext.tcl.generator

class Helpers {
	static def generateWriteToFileFunction() {
		'''
		(defun writeToFile (name valueList)
			(setf filename "dataForSolver.txt")
			(with-open-file (str filename :direction :output :if-exists :append :if-does-not-exist :create)
				(format str "~s: " name)
			)
			(setf l (length valueList))
			(setf c 0)
			(loop for value in valueList do
				(cond 
					(
			     		(< c (- l 1))
			     			(with-open-file (str filename :direction :output :if-exists :append :if-does-not-exist :create)
				 				(format str "~s, " value)
				 			)
				 	)
			 		(T
						 (with-open-file (str filename :direction :output :if-exists :append :if-does-not-exist :create)
						 	(format str "~s" value)
						 )
			 		)
			 	)
			 	(incf c)
			 )
			 (with-open-file (str filename :direction :output :if-exists :append :if-does-not-exist :create)
			 (format str "~%"))
		 )
		'''
	}
}