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
(when (require 'catppuccin-theme nil :noerror)
 (load-theme 'catppuccin))

;;; Set font
(defun crafted-setup-fonts ()
  "Setup fonts."
  (when (display-graphic-p)
    ;; Set default font
    (cl-loop for font in '("VictorMono Nerd Font" "FiraCode Nerd Font" "Hack Nerd Font"
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

(provide 'crafted-ui-config)
;;; crafted-ui-config.el ends here
