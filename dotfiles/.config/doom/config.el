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

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(global-set-key (kbd "C-l") 'mc/mark-next-like-this)

(global-set-key (kbd "C-c C-c C-A") 'cargo-android-run)
