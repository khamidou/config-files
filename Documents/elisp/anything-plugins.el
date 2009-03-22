;; some extensions to anything.el

;; websearch
;; Created : mar-01/20/09
(defun make-anything-c-source-websearch (name url &rest extra)
  (anything-c-define-dummy-source
   (concat "Websearch for " name)
   #'anything-c-dummy-candidate
   `(action . ,(eval `(lambda (args) 
			(browse-url (apply 'concat ,url anything-pattern (quote ,extra))))))))

(make-anything-c-source-websearch "Stack overflow"
				    "http://stackoverflow.com/questions/tagged/")
