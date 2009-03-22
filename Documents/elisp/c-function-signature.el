;;;; c parameter hints
(require 'eldoc)
(require 'etags)

;; make 'function-synopsis a new thing for thing-at-point
(put 'function-synopsis 'beginning-op
     (lambda () 
       (if (bolp) (forward-line -1) (beginning-of-line))
       (skip-chars-forward "^{")
       (dotimes (i 3) (backward-sexp))))

(put 'function-synopsis 'end-op
     (lambda () (skip-chars-forward "^{")))

;; override eldoc-mode's doc printer thingy
(defadvice eldoc-print-current-symbol-info
    (around eldoc-show-c-tag activate)
  (if (eq major-mode 'c-mode)
      (show-tag-in-minibuffer)
      ad-do-it))

(defun cleanup-function-synopsis (f)
  ;; nuke newlines
  (setq f (replace-regexp-in-string "\n" " " f))
  ;; nuke comments (note non-greedy *? instead of *)
  (setq f (replace-regexp-in-string "/\\*.*?\\*/" " " f))
  ;; (just-one-space)
  (setq f (replace-regexp-in-string "[ \t]+" " " f))
  f)

;; fetch a tag, jump to it, grab what looks like a function synopsis,
;; and output it in the minibuffer.
(defun show-tag-in-minibuffer ()
  (when tags-table-list
    (save-excursion
      ;; shadow some etags globals so they won't be modified
      (let ((tags-location-ring (make-ring find-tag-marker-ring-length))
            (find-tag-marker-ring (make-ring find-tag-marker-ring-length))
            (last-tag nil))
        (let* ((tag (funcall 
                     (or find-tag-default-function
                         (get major-mode 'find-tag-default-function)
                         'find-tag-default)))
               ;; we try to keep M-. from matching any old tag all the
               ;; time
               (tag-regex (format "\\(^\\|[ \t\n*]\\)%s\\($\\|(\\)" 
                                  (regexp-quote tag))))
          (set-buffer (find-tag-noselect tag-regex nil t))
          (let ((synopsis (or (thing-at-point 'function-synopsis)
                              (thing-at-point 'line))))
            (when synopsis
              (eldoc-message "%s" 
                             (cleanup-function-synopsis synopsis)))))))))

;; turn it on
(add-hook 'c-mode 'turn-on-eldoc-mode)
;;;; end c parameter hints
