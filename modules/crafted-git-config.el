;;; crafted-git-config.el --- Provides git features  -*- lexical-binding: t; -*-

;; Copyright (C) 2023
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;;; Commentary:

;;; Code:

;;; diff-hl
(add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
(global-diff-hl-mode)

;;; magit
(customize-set-variable 'magit-refresh-status-buffer nil)
(customize-set-variable 'magit-define-global-key-bindings t)

(provide 'crafted-git-config)
;;; crafted-git-config.el ends here
