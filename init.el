;;; init.el --- Crafted Emacs straight.el Example -*- lexical-binding: t; -*-

;; Copyright (C) 2023
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;;; Commentary:

;; Example init.el when using the straight.el package manager.

;;; Code:

;;; Initial phase
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

(load (expand-file-name "modules/crafted-init-config"
                        user-emacs-directory))

(setq user-full-name "Hadyn Youens"
      user-mail-address "hadyn.youens@educationperfect.com")

(customize-set-variable 'crafted-startup-screen-inhibit-startup-screen t)

(use-package exec-path-from-shell
  :straight t
  :ensure
  :init (exec-path-from-shell-initialize))


(require 'crafted-variables-config)

;;; Packages phase
(require 'crafted-completion-packages)
(require 'crafted-evil-packages)
(require 'crafted-lisp-packages)
(require 'crafted-ui-packages)
(require 'crafted-lsp-packages)
(require 'crafted-git-packages)
(require 'crafted-languages-packages)

;; Use the crafted-package helper
(crafted-package-install-selected-packages)

;;; Configuration phase
(require 'crafted-completion-config)
(require 'crafted-defaults-config)
(require 'crafted-startup-config)
(require 'crafted-evil-config)
(require 'crafted-lisp-config)
(require 'crafted-osx-config)
(require 'crafted-ui-config)
(require 'crafted-lsp-config)
(require 'crafted-git-config)
(require 'crafted-languages-config)

;;; _
(provide 'init)
;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
