;;; crafted-variables-config.el --- Crafted Emacs functions and variables -*- lexical-binding: t; -*-

;; Copyright (C) 2023
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;;; Commentary:

;;  Variables and functions for use in config

;;; Code:


(defconst sys/macp
  (eq system-type 'darwin)
  "Are we running on a Mac system?")

(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(provide 'crafted-variables-config)
;;; crafted-variables-config.el ends here

