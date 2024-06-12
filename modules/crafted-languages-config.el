;;;; crafted-languages-config.el --- Configuration for programming languages  -*- lexical-binding: t; -*-

;; Copyright (C) 2024
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;;; Commentary:

;; 

;;; Code:

;; Typescript
;;; Tide
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (corfu-mode +1))

(when (require 'tide nil :noerror)
  (add-hook 'typescript-ts-mode #'setup-tide-mode)
  (add-hook 'tsx-ts-mode #'setup-tide-mode)
  (add-hook 'typescript-ts-mode #'tide-hl-identifier-mode)
  (add-hook 'before-save #'tide-format-before-save)
  (add-to-list 'auto-mode-alist '("\\.ts$" . typescript-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx$" . tsx-ts-mode)))

;; Csharp
;;; sharper
(when (require 'sharper nil :noerror)
  (global-set-key (kbd "C-c n") 'sharper-main-transient))

;; CSS
;;; Tailwind
(when (require 'lsp-tailwindcss nil :noerror)
  (customize-set-variable 'lsp-tailwindcss-add-on-mode t)
  (customize-set-variable 'lsp-tailwindcss-emmet-completions t)
  (customize-set-variable 'lsp-tailwindcss-skip-config-check t)
  (add-to-list 'lsp-tailwindcss-major-modes 'typescript-ts-mode :append)
  (add-to-list 'lsp-tailwindcss-major-modes 'tsx-ts-mode :append))
;; TODO: Try to use locally installed servers
;;  (lsp-install-server nil 'tailwindcss))

;; Nix
(when (require 'nix-mode nil :noerror)
  (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode)))

;; Go
 (add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))

(provide 'crafted-languages-config)
;;; crafted-languages-config.el ends here
