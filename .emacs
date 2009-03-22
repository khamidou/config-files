; EMACS configuration file
; Copyright (c) 2007 Karim Hamidou. 

; load the libraries in Documents/emacs
; Each library name must end with ".el"
; Created : Fri Jan 11 20:34:06 2008

(if (= emacs-major-version 22)
    (dolist 
	(file (directory-files "~karim/Documents/elisp" t ".el"))
      (load-file file)))


(global-font-lock-mode 1)
(transient-mark-mode 1)
(column-number-mode 1)
(display-time-mode 1)
(ido-mode 1)
(setq inhibit-startup-message t)

(eval-after-load "dabbrev" '(defalias 'dabbrev-expand 'hippie-expand))

(setq hippie-expand-try-functions-list 
      '(try-complete-file-name
	try-expand-dabbrev-all-buffers
	try-expand-dabbrev-from-kill
	try-expand-whole-kill
	))

(if (= emacs-major-version 22)
    (progn
     (require 'anything)
     (require 'descbinds-anything)
     (descbinds-anything-install)

     (require 'color-theme)
     (color-theme-gray30)             ; (color-theme-pierson)

					; Other good color themes are :
					; clarity, high-contrast, midnight
     (require 'cparen)))

; get rid of the annoying startup message - jeu-07/31/08
(setq inhibit-startup-message t)

(put 'downcase-region 'disabled nil)

; A simple function to insert the current date and time.
; Note : Inserts dates in the american format (month/day/year)
; Created : Wed Dec 26 10:28:17 2007
; Edited to use new time format : Fri-01/11/08
(defun insert-date ()
  (interactive)
  (insert (format-time-string "%a-%D" (current-time))))

; I've seen that I spend much time adding "Created : %date% " each time I start
; a new project. Better create a function to do it.
; This way, I save _nine_ keystrokes every time I add a "Created :" field.
; Created : Fri-01/11/08
(defun creation-date ()
  (interactive)
  (insert "Created : ")
  (insert-date))

; Transpose chars, the gosmacs way.
; Created : Fri Jan 11 20:10:13 2008
(defun gosmacs-transpose-chars ()
(interactive)
(save-excursion
  (backward-char)
  (transpose-chars 1))
(forward-char 2))

(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

; Switch to the last used buffer.
; Created : jeu-03/05/09
(defun previous-buf ()
  (interactive)
  (switch-to-buffer (other-buffer)))


; Courtesy of pgas.

(eval-after-load 'find-tag
  (progn
    (defun find-tags-file-recursive (&optional tag-file-name)
      "recursively searches each parent directory for a file
named `TAGS' and returns the path to that file or nil if a tags
file is not found. Returns nil if the buffer is not visiting a
file"
      (let ((tag-file-name (or tag-file-name "TAGS"))
	        (current-dir (file-name-directory (buffer-file-name)))
		    found)
	(while (not (or (equal current-dir "/")
			(setq found 
			            (if (file-exists-p 
					    (concat current-dir tag-file-name))
					  (concat current-dir tag-file-name)))))
	    (setq current-dir (file-name-directory 
			            (substring current-dir 0 -1))))
	(if found
	        found
	    (message "no tags file found")
	      nil)))

    (defun set-tags-file-name () 
      (unless (and tags-file-name 
		      (let ((file-dir (file-name-directory (buffer-file-name)))
			     (tag-file-dir (file-name-directory tags-file-name)))
			     (and (> (length file-dir) (length tag-file-dir))
				    (equal (substring file-dir 0 (length tag-file-dir))
					    tag-file-dir))))
	(setq tags-file-name  (find-tags-file-recursive))))

    (defadvice find-tag (before set-tags-file-name-before 
				(tagname &optional next-p regexp-p))
      "search for a tag file in the parent directories"
      (set-tags-file-name))
    (ad-activate 'find-tag)
    (setq tags-add-tables nil)))

; [bsd-linux]-c-mode : adjusted code styles.
; Creation : Lost to history

(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8))

(defun  bsd-c-mode ()
  "C mode with adjusted defaults for use with karim's code."
  (interactive)
  (c-mode)
  (c-set-style "bsd")
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8))

; Set bsd style as the default one : 
(setq c-default-style "bsd")

; Set up our "slave" lisp program (launch the current file with M-x run-lisp)
(setq inferior-lisp-program "/usr/bin/clisp")
(setq scheme-program-name "mzscheme")

;; FIXME : make it work
;; Created : ven-01/09/09
;; (defun switch-buffer-of-file (name)
;;   (dolist (buf buffer-list)
;;     (if
;; 	(string= (buffer-file-name) name)
;; 	(switch-buffer 
	
;c-mode  - courtesy of pgas - Created : dim-10/26/08
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

; (add-hook 'c-mode-common-hook   (lambda () (which-function-mode t)))

(eval-after-load 'cc-vars
  (progn 
    (require 'dabbrev)
    (defun th-complete-or-indent (arg)
      "If preceding character is a word character and the following
character is a whitespace character, then `dabbrev-expand', else
indent according to mode."
      (interactive "*P")
      (cond ((and
	            (= (char-syntax (preceding-char)) ?w)
		          (looking-at (rx (or word-end (any ".,;:#=?()[]{}")))))
	          (require 'sort)
		       (let ((case-fold-search t))
			        (dabbrev-expand arg)))
	        (t
		      (indent-according-to-mode))))

    (defun switch-c-to-h ()
      "Switch from *.<impl> to *.<head> and vice versa"
      (interactive)
      (when (string-match "\\(.*\\)\\(\\..*\\)\\'" buffer-file-name)
	(let ((other-file 
	              (file-expand-wildcards
		       (concat (match-string 1 buffer-file-name)
			       (if (string-match  
				         "\\.c\\(c\\|pp\\|xx\\|\\+\\+\\)?\\|\\.CC?\\'"
					      (match-string 2 buffer-file-name))
				       ".[hH]*"
				   ".[cC]*"))
		       t)))
	    (if other-file (find-file (car other-file))))))

    (add-hook 'c-mode-common-hook
	            (lambda ()
		      (local-set-key (kbd "TAB") 'th-complete-or-indent)
		      (local-set-key (kbd "<f4>") 'switch-c-to-h)
		      ))))

; (require 'linum)           ; turn on line number mode

;(global-linum-mode)

; Bind the following keys
(global-set-key "\C-l" 'goto-line)
(global-set-key "\C-t" 'gosmacs-transpose-chars)
;(global-set-key "\C-\\%" 'goto-match-paren)

; Bind our special key : C-! (previously bound to delete-char-untabify
; Created : Sat-01/12/08
(defvar karim-map (make-sparse-keymap)
  "Keymap for characters following the C-! key.")

; Set up the prefix key C-* (on the µ key)
(global-set-key "\C-\\" karim-map)


; set a few keys
(define-key karim-map "\C-c" 'compile)
(define-key karim-map "\C-r" 'ruby-mode)
(define-key karim-map "\C-l" 'linux-c-mode)
(define-key karim-map "\C-b" 'bsd-c-mode)

(global-set-key [(tab)] 'smart-tab)
(setq c-hungry-delete-key 't)
(global-set-key (kbd "DEL") 'backward-kill-word)
(global-set-key (kbd "<f3>") 'previous-buf)
(global-set-key (kbd "<f2>") 'anything)
(global-set-key (kbd "<f5>") 'run-scheme)
(global-set-key (kbd "<f6>") 'ielm)
(add-hook 'python-mode-hook (lambda () (local-set-key (kbd "TAB") 'smart-tab)))

; motion key modifications : 
; swap C-arrow and arrow.
(global-set-key (kbd "<left>") 'backward-word)
(global-set-key (kbd "<right>") 'forward-word)
(global-set-key (kbd "<C-left>") 'backward-char)
(global-set-key (kbd "<C-right>") 'forward-char)
(add-hook 'c-mode-common-hook (lambda ()
				(global-set-key (kbd "DEL") 'backward-kill-word)))