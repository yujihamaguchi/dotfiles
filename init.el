;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq cider-required-middleware-version "0.22-beta5")
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

(require 'package)
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/") t)

(package-initialize)

(set-fontset-font t 'japanese-jisx0208 "TakaoPGothic")

(setq split-width-threshold nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(org-todo-keyword-faces '(("TODO" . "red") ("DONE" . "gray") ("WAIT" . "blue")))
 '(org-todo-keywords '((sequence "TODO" "WAIT" "|" "DONE")))
 '(package-selected-packages
   '(org-tree-slide clj-refactor markdown-mode ac-cider company multi-term helm-descbinds helm spinner queue clojure-mode))
 '(safe-local-variable-values
   '((cider-refresh-after-fn . "integrant.repl/resume")
     (cider-refresh-before-fn . "integrant.repl/suspend")
     (cider-ns-refresh-after-fn . "integrant.repl/resume")
     (cider-ns-refresh-before-fn . "integrant.repl/suspend"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "IBM Plex Mono" :foundry "IBM " :slant normal :weight normal :height 102 :width normal)))))

(require 'paredit)
(add-hook 'clojure-mode-hook 'paredit-mode)

(require 'mozc)
;; (set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

(require 'helm)
(helm-mode 1)
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)

(cua-mode t)
(setq cua-enable-cua-keys nil)

(require 'ac-cider)
(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)
(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

(require 'clj-refactor)

(defun my-clojure-mode-hook ()
    (clj-refactor-mode 1)
    (yas-minor-mode 1) ; for adding require/use/import statements
    (subword-mode 1)
    (cljr-add-keybindings-with-prefix "C-c C-m")
    ;; This choice of keybinding leaves cider-macroexpand-1 unbound
    )

(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)

(setq company-idle-delay nil) ; never start completions automatically
(global-set-key (kbd "M-TAB") #'company-complete) ; use M-TAB, a.k.a. C-M-i, as manual trigger

(add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)

(setq ring-bell-function 'ignore)
(setq cider-repl-buffer-size-limit 1)

(define-key key-translation-map (kbd "<next>") (kbd "<M-down>"))
(define-key key-translation-map (kbd "<prior>") (kbd "<M-up>"))
(global-set-key "\C-h" `delete-backward-char)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(require 'org-tree-slide)
(with-eval-after-load "org-tree-slide"
  (define-key org-tree-slide-mode-map (kbd "<f9>") 'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<f10>") 'org-tree-slide-move-next-tree))
(define-key org-mode-map (kbd "<f8>") 'org-tree-slide-mode)
(define-key org-mode-map (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle)

(setq default-frame-alist
      '((width . 1712)
        (height . 853)))
