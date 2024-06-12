;;; crafted-lsp-config.el --- Provides lsp features  -*- lexical-binding: t; -*-

;; Copyright (C) 2023
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;;; Commentary:

;;; Code:

;;; LSP mode
(when (require 'lsp-mode nil :noerror)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (customize-set-variable 'lsp-keymap-prefix "C-c l")
  (add-hook 'csharp-ts-mode-hook #'lsp-deferred)
  (add-hook 'typescript-ts-mode-hook #'lsp-deferred)
  (add-hook 'tsx-ts-mode-hook #'lsp-deferred)
  (add-hook 'go-ts-mode-hook #'lsp-deferred))

;;; Consult LSP
;; Remap xref bindings
(when (require 'consult-lsp nil :noerror)
  (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols))

;;; DAP mode
(when (require 'dap-mode nil :noerror)
  (require 'dap-netcore)
  (require 'dap-dlv-go))

;;; Treesit auto
;; Automatically install treesitter parsers
(when (require 'treesit-auto nil :noerror)
  (customize-set-variable 'treesit-auto-install t)
  (customize-set-variable 'treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;;; Lsp-UI

(provide 'crafted-lsp-config)
;;; crafted-lsp-config.el ends here
