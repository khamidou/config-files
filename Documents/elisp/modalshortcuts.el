;; modalshortcuts.el - a simple minor mode to use modal shortcuts.

(setq modal-mode-keymap (make-sparse-keymap))

(global-set-key (kbd "<S-f9>") modal-mode-keymap)

(define-key modal-mode-keymap "i" 'indent-region)
(define-key modal-mode-keymap "v" 'info)
(define-key modal-mode-keymap "w" 'save-buffer)
(define-key modal-mode-keymap "t" 'find-tag)
(define-key modal-mode-keymap "q" 'save-buffers-kill-emacs)
(define-key modal-mode-keymap "d" 'delete-other-windows)
(define-key modal-mode-keymap "u" 'advertised-undo)
(define-key modal-mode-keymap "a" 'ffap)
(define-key modal-mode-keymap "g" 'keyboard-quit)
(define-key modal-mode-keymap "c" 'compile)
(define-key modal-mode-keymap "m" 'man)
(define-key modal-mode-keymap "f" 'find-file)
(define-key modal-mode-keymap "b" 'ido-switch-buffer)
(define-key modal-mode-keymap "k" 'kill-buffer)
(define-key modal-mode-keymap "o" 'other-window)
(define-key modal-mode-keymap "e" 'kmacro-end-and-call-macro)
(define-key modal-mode-keymap "(" 'kmacro-start-macro)
(define-key modal-mode-keymap ")" 'kmacro-end-macro)
