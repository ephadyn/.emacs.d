;;; crafted-lsp-packages.el --- Provides packages for LSP features  -*- lexical-binding: t; -*-

;; Copyright (C) 2023
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;;; Commentary:

;;; Code:
(add-to-list 'package-selected-packages 'lsp-mode)
(add-to-list 'package-selected-packages 'lsp-ui)
(add-to-list 'package-selected-packages 'dap-mode)
(add-to-list 'package-selected-packages 'consult-lsp)
(add-to-list 'package-selected-packages 'treesit-auto)

(provide 'crafted-lsp-packages)
;;; crafted-lsp-packages.el ends here
