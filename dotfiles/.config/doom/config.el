;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq lsp-elixir-server-command '("elixir-ls"))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(setq display-line-numbers-type t)

(use-package forge
  :after magit)
(setq auth-sources '("~/.authinfo"))

(defvar *true-visual* nil)

(defun helix-visual-mode ()
  (interactive)
  (setq *true-visual* t)
  (evil-visual-char))

(defun helix-exit-visual-mode ()
  (interactive)
  (setq *true-visual* nil)
  (evil-exit-visual-state))

(defun helix-highlight-line ()
  (interactive)
  (setq *true-visual* t)
  (evil-visual-line)
  (evil-end-of-line))

(defun helix-highlight-next (movement)
  (interactive)
  (if (equal *true-visual* nil)
      (helix-exit-visual-mode))
  (evil-visual-char)
  (call-interactively movement))

(defun helix-highlight-next-word ()
  (interactive)
  (helix-highlight-next 'evil-forward-word-begin))

(defun helix-highlight-next-word-end ()
  (interactive)
  (helix-highlight-next 'evil-forward-word-end))

(defun helix-highlight-previous-word ()
  (interactive)
  (helix-highlight-next 'evil-backward-word-begin))

(defun helix-previous-line ()
  (interactive)
  (if (equal *true-visual* nil)
      (helix-exit-visual-mode))
  (evil-previous-line))

(defun helix-next-line ()
  (interactive)
  (if (equal *true-visual* nil)
      (helix-exit-visual-mode))
  (evil-next-line))

(defun helix-delete-char ()
  (interactive)
  (evil-delete-char 0 1))

(defun define-key-movement (key func)
  (define-key evil-normal-state-map key func)
  (define-key evil-visual-state-map key func))

(defun helix-visual-change ()
  (interactive)
  (call-interactively 'evil-delete-char)
  (call-interactively 'evil-insert))

(defun cargo-android-run ()
  (interactive)
  (vterm)
  (display-buffer vterm-buffer-name t)
                                        ;  (switch-to-buffer-other-window vterm-buffer-name)
  (vterm--goto-line -1)
  (message "cargo android run")
  (vterm-send-string "cargo android run")
  (vterm-send-return))

(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "zsh"))

                                        ;(define-key evil-normal-state-map (kbd "x") 'helix-highlight-line)
                                        ;(define-key evil-normal-state-map (kbd "c") 'helix-visual-change)
                                        ;(define-key evil-visual-state-map (kbd ";") 'helix-exit-visual-mode)
                                        ;(define-key evil-visual-state-map [escape] 'helix-exit-visual-mode)
                                        ;(define-key evil-visual-state-map (kbd "k") 'helix-previous-line)
                                        ;(define-key evil-visual-state-map (kbd "j") 'helix-next-line)
                                        ;(define-key evil-visual-state-map (kbd "i") 'evil-insert)
                                        ;(define-key evil-visual-state-map (kbd "a") 'evil-append)
                                        ;(define-key-movement (kbd "v") 'helix-visual-mode)
                                        ;(define-key-movement (kbd "w") 'helix-highlight-next-word)
                                        ;(define-key-movement (kbd "e") 'helix-highlight-next-word-end)
                                        ;(define-key evil-normal-state-map (kbd "b") 'helix-highlight-previous-word)
                                        ;(define-key-movement (kbd "g l") 'evil-end-of-line-or-visual-line)
                                        ;(define-key-movement (kbd "g l") 'evil-end-of-line-or-visual-line)
                                        ;(define-key-movement (kbd "g h") 'evil-beginning-of-visual-line)
                                        ;(define-key-movement (kbd "g m") 'evil-jump-item)
                                        ;(define-key-movement (kbd "g e") 'evil-goto-line)
;;(use-package! copilot
;;  :hook (prog-mode . copilot-mode)
;;  :bind (:map copilot-completion-map
;;              ("<tab>" . 'copilot-accept-completion)
;;              ("TAB" . 'copilot-accept-completion)
;;              ("C-TAB" . 'copilot-accept-completion-by-word)
;;              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(global-set-key (kbd "C-l") 'mc/mark-next-like-this)

(global-set-key (kbd "C-c C-c C-A") 'cargo-android-run)

  ;;; slint-mode.el --- Major-mode for the Slint UI language -*- lexical-binding: t; -*-

;; Copyright (C) 2023   Niklas Cathor

;; Author: Niklas Cathor <niklas.cathor@gmx.de>
;; Keywords: languages
;; Version: 0
;; Package-Requires: ((emacs "24.4"))
;; Homepage: https://github.com/nilclass/slint-mode

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;;; Commentary:
;; LSP-based major mode for the Slint UI language

;;; Code:

(defgroup slint nil
  "Major mode for Slint UI files."
  :tag "Slint"
  :group 'languages)

(defcustom slint-indent-level 4
  "Number of spaces for indentation of blocks."
  :tag "Slint"
  :type 'integer
  :safe 'integerp
  :group 'slint)

(defvar slint-mode-hook nil)
(defvar slint-mode-map
  (let ((map (make-keymap)))
    map)
  "Key bindings for Slint mode.")

(defvar slint-mode-syntax-table
  (let ((st (make-syntax-table)))
                                        ; Treat underscore ('_') as part of word
    (modify-syntax-entry ?_ "w" st)
                                        ; Treat dash ('-') as part of word
    (modify-syntax-entry ?- "w" st)
                                        ; Comments
    (modify-syntax-entry ?/ ". 124b" st)
    (modify-syntax-entry ?* ". 23" st)
    (modify-syntax-entry ?\n "> b" st)
    st)
  "Syntax table for Slint mode.")

(defconst slint-keywords
  '("import" "export" "from" "component" "inherits"
    "in-out" "property" "callback" "as" "in" "out"
    "animate" "struct" "for" "self" "parent" "pure"
    "function" "public" "return"))

(defconst slint-builtin-types
  '("angle" "bool" "brush" "color" "duration" "easing"
    "float" "image" "int" "length" "percent" "physical-length"
    "relative-font-size" "string"))

(defconst slint-font-lock-keywords
  (list
   ;; Property key
   '("\\(\\w+\\):" 1 font-lock-variable-name-face)
   ;; Component names (starting with capital letter)
   '("\\([A-Z]\\w*\\)" . font-lock-type-face)
   ;; Function call, function signature, @image-url syntax
   '("\\(@?\\w+\\)(" 1 font-lock-function-name-face)
   ;; Callback
   '("\\(\\w+\\)\\s-*=>" 1 font-lock-function-name-face)
   ;; Property declaration w/o values (for those with values, the "Property Key" rules applies)
   '("\\(?:in\\|out\\|in-out\\)?\\s-+property.*?\\s-\\(\\w+\\)\\s-*;\\s-*$" 1 font-lock-variable-name-face)
   ;; Colors
   '("\\(#[0-9a-zA-Z]+\\)" . font-lock-preprocessor-face)
   ;; Numbers, with or without unit
   '("\\([0-9]+\\(?:ph?x\\|rem\\|[mu]?s\\)?\\)" . font-lock-preprocessor-face)
   ;; Builtin types
   `(,(concat "\\b" (regexp-opt slint-builtin-types t) "\\b") . font-lock-type-face)
   ;; Keywords
   `(,(concat "\\b" (regexp-opt slint-keywords t) "\\b") . font-lock-keyword-face)))

(defun slint-indent-line ()
  "Indent Slint UI file line."
  (let ((position (point))
        (indent-pos))
    (save-excursion
      (back-to-indentation)
      (let ((level (car (syntax-ppss))))
        (when (looking-at "\\s-*\\s)") ; this line starts with the closing brace or bracket
          (setq level (1- level)))
        (indent-line-to (* slint-indent-level level))
        (setq indent-pos (point))))
    (when (< position indent-pos)
      (goto-char indent-pos))))

;;;###autoload
(define-derived-mode slint-mode prog-mode "Slint"
  "A major mode for editing Slint UI files."
  (setq-local comment-start "// ")
  (setq-local indent-line-function #'slint-indent-line)
  (set-syntax-table slint-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults) '(slint-font-lock-keywords)))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
               '(slint-mode . "slint"))

  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "slint-lsp")
                    :activation-fn (lsp-activate-on "slint")
                    :server-id 'slint)))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(slint-mode . ("slint-lsp"))))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.slint\\'" . slint-mode))

(provide 'slint-mode)

;;; slint-mode.el ends here
