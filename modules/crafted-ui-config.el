;;; crafted-ui-config.el --- Crafted UI Config -*- lexical-binding: t; -*-

;; Copyright (C) 2023
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;;; Commentary:

;; User interface customizations. Examples are icons, line numbers,
;; and how help buffers are displayed.

;; This package provides a basic, customized appearance for
;; Emacs. Specifically, it uses: Helpful to customize the information
;; and visual display of help buffers, such as that created by M-x
;; `describe-function'; All-the-icons, to provide font-based icons
;; (rather than raster or vector images); and includes some Emacs Lisp
;; demonstrations.

;;  Run `all-the-icons-install-fonts' to ensure the fonts necessary
;; for ALL THE ICONS are available on your system. You must run this
;; function if the "stop" icon at the beginning of this paragraph is
;; not displayed properly (it appears as a box with some numbers
;; and/or letters inside it).

;; Read the documentation for `all-the-icons'; on Windows,
;; `all-the-icons-install-fonts' only downloads fonts, they must be
;; installed manually. This is necessary if icons are not displaying
;; properly.

;;; Code:

;;; Enlight startup screen
(setopt initial-buffer-choice #'enlight)

;;; Help Buffers

;; Make `describe-*' screens more helpful
(when (require 'helpful nil :noerror)
  (keymap-set helpful-mode-map "<remap> <revert-buffer>" #'helpful-update)
  (keymap-global-set "<remap> <describe-command>"        #'helpful-command)
  (keymap-global-set "<remap> <describe-function>"       #'helpful-callable)
  (keymap-global-set "<remap> <describe-key>"            #'helpful-key)
  (keymap-global-set "<remap> <describe-symbol>"         #'helpful-symbol)
  (keymap-global-set "<remap> <describe-variable>"       #'helpful-variable)
  (keymap-global-set "C-h F"                             #'helpful-function))

;; Bind extra `describe-*' commands
(keymap-global-set "C-h K" #'describe-keymap)

;;; Line Numbers
(defcustom crafted-ui-line-numbers-enabled-modes
  '(conf-mode prog-mode)
  "Modes which should display line numbers."
  :type 'list
  :group 'crafted-ui)

(defcustom crafted-ui-line-numbers-disabled-modes
  '(org-mode)
  "Modes which should not display line numbers.

Modes derived from the modes defined in
`crafted-ui-line-number-enabled-modes', but should not display line numbers."
  :type 'list
  :group 'crafted-ui)

(defun crafted-ui--enable-line-numbers-mode ()
  "Turn on line numbers mode.

Used as hook for modes which should display line numbers."
  (display-line-numbers-mode 1))

(defun crafted-ui--disable-line-numbers-mode ()
  "Turn off line numbers mode.

Used as hook for modes which should not display line numebrs."
  (display-line-numbers-mode -1))

(defun crafted-ui--update-line-numbers-display ()
  "Update configuration for line numbers display."
  (if crafted-ui-display-line-numbers
      (progn
        (dolist (mode crafted-ui-line-numbers-enabled-modes)
          (add-hook (intern (format "%s-hook" mode))
                    #'crafted-ui--enable-line-numbers-mode))
        (dolist (mode crafted-ui-line-numbers-disabled-modes)
          (add-hook (intern (format "%s-hook" mode))
                    #'crafted-ui--disable-line-numbers-mode))
        (setq-default
         display-line-numbers-grow-only t
         display-line-numbers-type t
         display-line-numbers-width 2))
    (progn
      (dolist (mode crafted-ui-line-numbers-enabled-modes)
        (remove-hook (intern (format "%s-hook" mode))
                     #'crafted-ui--enable-line-numbers-mode))
      (dolist (mode crafted-ui-line-numbers-disabled-modes)
        (remove-hook (intern (format "%s-hook" mode))
                     #'crafted-ui--disable-line-numbers-mode)))))

(defcustom crafted-ui-display-line-numbers nil
  "Whether line numbers should be enabled."
  :type 'boolean
  :group 'crafted-ui
  :set (lambda (sym val)
         (set-default sym val)
         (crafted-ui--update-line-numbers-display)))

;;; Elisp-Demos

;; also add some examples
(when (require 'elisp-demos nil :noerror)
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

;; add visual pulse when changing focus, like beacon but built-in
;; from from https://karthinks.com/software/batteries-included-with-emacs/
(defun pulse-line (&rest _)
  "Pulse the current line."
  (pulse-momentary-highlight-one-line (point)))

(dolist (command '(scroll-up-command
                   scroll-down-command
                   recenter-top-bottom
                   other-window))
  (advice-add command :after #'pulse-line))

;;; Breadcrumbs
(when (require 'breadcrumb nil :noerror)
  (breadcrumb-mode))

;;; Set theme
(when (require 'doom-themes nil :noerror)
  (load-theme 'doom-dracula t))

;;; Mode line set Update
(when (require 'doom-modeline nil :noerror)
  (setq doom-modeline-buffer-file-name-style 'file-name-with-project)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-total-line-number nil)
  (setq doom-modeline-vcs-icon t)
  (setq doom-modeline-time nil)
  (setq doom-modeline-modal nil)
  (doom-modeline-mode 1))

;;; Set font
(defun crafted-setup-fonts ()
  "Setup fonts."
  (when (display-graphic-p)
    ;; Set default font
    (cl-loop for font in '("Hack Nerd Font" "VictorMono Nerd Font" "FiraCode Nerd Font"
                           "Fira Code" "Jetbrains Mono"
                           "SF Mono" "Hack" "Source Code Pro" "Menlo"
                           "Monaco" "DejaVu Sans Mono" "Consolas")
             when (font-installed-p font)
             return (set-face-attribute 'default nil
                                        :family font
                                        :height (cond (sys/macp 130)
                                                      (sys/win32p 110)
                                                      (t 100))))

    ;; Set mode-line font
    ;; (cl-loop for font in '("Menlo" "SF Pro Display" "Helvetica")
    ;;          when (font-installed-p font)
    ;;          return (progn
    ;;                   (set-face-attribute 'mode-line nil :family font :height 120)
    ;;                   (when (facep 'mode-line-active)
    ;;                     (set-face-attribute 'mode-line-active nil :family font :height 120))
    ;;                   (set-face-attribute 'mode-line-inactive nil :family font :height 120)))

    ;; Specify font for all unicode characters
    (cl-loop for font in '("Segoe UI Symbol" "Symbola" "Symbol")
             when (font-installed-p font)
             return (if (< emacs-major-version 27)
                        (set-fontset-font "fontset-default" 'unicode font nil 'prepend)
                      (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend)))

    ;; Emoji
    (cl-loop for font in '("Noto Color Emoji" "Apple Color Emoji" "Segoe UI Emoji")
             when (font-installed-p font)
             return (cond
                     ((< emacs-major-version 27)
                      (set-fontset-font "fontset-default" 'unicode font nil 'prepend))
                     ((< emacs-major-version 28)
                      (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend))
                     (t
                      (set-fontset-font t 'emoji (font-spec :family font) nil 'prepend))))))

(crafted-setup-fonts)
(add-hook 'window-setup-hook #'crafted-setup-fonts)
(add-hook 'server-after-make-frame-hook #'crafted-setup-fonts)

;; Treemacs
(when (require 'treemacs nil :noerror)
  (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
        treemacs-deferred-git-apply-delay        0.5
        treemacs-directory-name-transformer      #'identity
        treemacs-display-in-side-window          t
        treemacs-eldoc-display                   'simple
        treemacs-file-event-delay                2000
        treemacs-file-extension-regex            treemacs-last-period-regex-value
        treemacs-file-follow-delay               0.2
        treemacs-file-name-transformer           #'identity
        treemacs-follow-after-init               t
        treemacs-expand-after-init               t
        treemacs-find-workspace-method           'find-for-file-or-pick-first
        treemacs-git-command-pipe                ""
        treemacs-goto-tag-strategy               'refetch-index
        treemacs-header-scroll-indicators        '(nil . "^^^^^^")
        treemacs-hide-dot-git-directory          t
        treemacs-indentation                     2
        treemacs-indentation-string              " "
        treemacs-is-never-other-window           nil
        treemacs-max-git-entries                 5000
        treemacs-missing-project-action          'ask
        treemacs-move-files-by-mouse-dragging    t
        treemacs-move-forward-on-expand          nil
        treemacs-no-png-images                   nil
        treemacs-no-delete-other-windows         t
        treemacs-project-follow-cleanup          nil
        treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
        treemacs-position                        'right
        treemacs-read-string-input               'from-child-frame
        treemacs-recenter-distance               0.1
        treemacs-recenter-after-file-follow      nil
        treemacs-recenter-after-tag-follow       nil
        treemacs-recenter-after-project-jump     'always
        treemacs-recenter-after-project-expand   'on-distance
        treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
        treemacs-project-follow-into-home        nil
        treemacs-show-cursor                     nil
        treemacs-show-hidden-files               t
        treemacs-silent-filewatch                nil
        treemacs-silent-refresh                  nil
        treemacs-sorting                         'alphabetic-asc
        treemacs-select-when-already-in-treemacs 'move-back
        treemacs-space-between-root-nodes        t
        treemacs-tag-follow-cleanup              t
        treemacs-tag-follow-delay                1.5
        treemacs-text-scale                      nil
        treemacs-user-mode-line-format           nil
        treemacs-user-header-line-format         nil
        treemacs-wide-toggle-width               70
        treemacs-width                           45
        treemacs-width-increment                 1
        treemacs-width-is-initially-locked       t
        treemacs-workspace-switch-cleanup        nil)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (treemacs-git-mode 'deferred)
  (treemacs-git-commit-diff-mode t)
  (treemacs-resize-icons 16)
  )


(when (require 'flycheck nil :noerror)
  ;; keep flycheck on the right fringe
  (setq flycheck-indication-mode 'right-fringe)
  ;; A non-descript, left-pointing arrow
  (define-fringe-bitmap 'flycheck-fringe-bitmap-arrow
    [16 48 112 240 112 48 16] nil nil 'center)
  (flycheck-redefine-standard-error-levels "⏴" 'flycheck-fringe-bitmap-arrow)
  (global-flycheck-mode))

(provide 'crafted-ui-config)
;;; crafted-ui-config.el ends here
