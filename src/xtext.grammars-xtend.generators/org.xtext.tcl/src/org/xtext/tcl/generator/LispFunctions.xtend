package org.xtext.tcl.generator

class LispFunctions {
	
	static def generateReadDecodeAndWriteToKB() {
		'''
		(define-tcb (readDecodeAndWriteToKb ?json-file)
			(action (
				(let ((in-string nil)(json-res nil)(module-insts-list nil))
					(setf in-string (with-open-file (in-stream ?json-file :direction :input)
				    	(let ((contents (make-string (file-length in-stream))))
				        	(read-sequence contents in-stream)
				              contents
				        )))
					(let ((parsed-msg nil))
					    (format t "Decode msg: ~a~%" in-string)
					    (format t "Typeof msg: ~a~%" (type-of in-string))

					    (handler-case
					      (with-input-from-string (s in-string)
					        (let ((cl-json:*json-symbols-package* nil))
					          (setf parsed-msg (cl-json:decode-json s))))
					      (t (c)
					        (format t "[decode-json-msg] ERROR decode msg json invalid : ~a~%" c)
					        (setf parsed-msg nil)
					        (values nil c)))

						(format t "Parsed result ~s~%" parsed-msg)
						
						(setf dvg-configuration-list (cdr (assoc 'dvg-configuration parsed-msg)))
						(dolist (dvg-configuration dvg-configuration-list)
							(let* ((building-block (cdr (assoc 'building-block dvg-configuration)))
					          	   (instance-index (cdr (assoc 'instance-index dvg-configuration)))
					         	   (variability-entity (cdr (assoc 'variability-entity dvg-configuration)))
					         	   (value (cdr (assoc 'value dvg-configuration)))
					         	  )
					         
								(tcl-kb-update :key '(is-a building-block instance-index variability-entity) :value `((is-a dvg-configuration)
									(building-block ,building-block) (instance-index ,instance-index) (variability-entity ,variability-entity) (value ,value))
								)
					   		)
						)
					)
				)
			))
		)
		'''
	}
}