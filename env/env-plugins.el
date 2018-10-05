;; TODO: split  -*- lexical-binding: t -*-

(defun package-upgrade-all ()
  "Upgrade all packages automatically without showing *Packages* buffer."
  (interactive)
  (package-refresh-contents)
  (let (upgrades)
    (cl-flet ((get-version (name where)
                           (let ((pkg (cadr (assq name where))))
                             (when pkg
                               (package-desc-version pkg)))))
      (dolist (package (mapcar #'car package-alist))
        (let ((in-archive (get-version package package-archive-contents)))
          (when (and in-archive
                     (version-list-< (get-version package package-alist)
                                     in-archive))
            (push (cadr (assq package package-archive-contents))
                  upgrades)))))
    (if upgrades
        (when (yes-or-no-p
               (format "Upgrade %d package%s (%s)? "
                       (length upgrades)
                       (if (= (length upgrades) 1) "" "s")
                       (mapconcat #'package-desc-full-name upgrades ", ")))
          (save-window-excursion
            (dolist (package-desc upgrades)
              (let ((old-package (cadr (assq (package-desc-name package-desc)
                                             package-alist))))
                (package-install package-desc)
                (package-delete  old-package)))))
      (message "All packages are up to date"))))

;; Project management
(use-package projectile
  :defer 1
  :config
  (projectile-global-mode t))

(use-package avy
  :defer t)

;; TODO: enable
;; (use-package backup-each-save
;;   :hook (after-save-hook . backup-each-save))

;; ;;TODO: ensure backups are being created
;; (use-package backup-walker
;;   :commands backup-walker-start)

;; Quickrun
(use-package quickrun
  :commands (quickrun
             quickrun-region
             quickrun-with-arg
             quickrun-shell
             quickrun-compile-only
             quickrun-replace-region))

;; Move region or line
(use-package drag-stuff
  :commands (drag-stuff-left drag-stuff-up drag-stuff-down drag-stuff-right))
;; :config (drag-stuff-global-mode 1))

;; Yasnippet
;; TODO:
;; (use-package yasnippet
;;   :config
;;   (yas-global-mode 1))

(defun elmax/set-no-fringes ()
  "Remove fringes in window. Mainly uses as hook."
  (when (display-graphic-p)
    (setq left-fringe-width 0)
    (setq right-fringe-width 0)))

(use-package treemacs
  :defer t
  :commands (treemacs)
  :config
  (setq-default treemacs-fringe-indicator-mode nil)

  ;; (pcase (cons (not (null (executable-find "git")))
  ;;              (not (null (executable-find "python3"))))
  ;;   (`(t . t)
  ;;    (treemacs-git-mode 'extended))
  ;;   (`(t . _)
  ;;    (treemacs-git-mode 'simple)))

  (setq treemacs-git-mode nil)

  (setq treemacs-show-hidden-files nil
        treemacs-width 30
        ;; treemacs-indentation 1
        ;; treemacs-indentation-string "  "
        ;; treemacs-indentation-string (propertize "|" 'face 'font-lock-comment-face)
        treemacs-follow-after-init t
        treemacs-filewatch-mode t
        treemacs-tag-follow-mode t
        treemacs-file-event-delay 1000)

  :general
  (general-define-key :keymaps 'treemacs-mode-map
                      :states  '(normal visual treemacs)
                      ;; "g j"  'treemacs-next-neighbour
                      ;; "g k"  'treemacs-previous-neighbour
                      "g j"  'treemacs-next-project
                      "g k"  'treemacs-previous-project
                      "M-h"  'evil-window-left
                      "M-j"  'evil-window-down
                      "M-k"  'evil-window-up
                      "M-l"  'evil-window-right))

;; Treemacs extensions
(use-package treemacs-evil
  :after (treemacs evil))

(use-package treemacs-projectile
  :after (treemacs projectile))


;; (use-package which-key
;;   :config
;;   (which-key-mode)
;;   (which-key-setup-side-window-bottom))

(use-package google-translate
  :defer t
  :config
  (use-package google-translate-smooth-ui
    :after google-translate
    :commands google-translate-smooth-translate)
  (setq google-translate-translation-directions-alist '(("en" . "ru"))))

(use-package imenu-list
  :hook (imenu-list-major-mode . elmax/set-no-fringes)
  :commands (imenu-list-smart-toggle)
  :config
  ;; (imenu-list-minor-mode t)
  (setq-default imenu-list-mode-line-format nil)
  (setq imenu-list-mode-line-format nil
        imenu-list-focus-after-activation t
        imenu-list-size 32))

;; TODO: server restart
(use-package restart-emacs
  :commands (restart-emacs))

(use-package deft
  :commands (deft)
  :config
  (setq deft-extensions '("txt" "tex" "org")
        deft-directory "~/Drive/org"
        deft-recursive t))

;; (use-package helpful
;;   :general
;;   (general-define-key :states 'normal
;;                       :prefix leader
;;                       "h k" 'helpful-key
;;                       "h v" 'helpful-variable
;;                       ;; "h f" 'helpful-function
;;                       "h f" 'helpful-callable
;;                       "h l" 'find-library
;;                       "h ." 'helpful-at-point))

;;; Libraries

(use-package anaphora      :defer t)
(use-package apiwrap       :defer t)
(use-package asoc          :defer t)
(use-package button-lock   :defer t)
(use-package ctable        :defer t)
(use-package dash          :defer t)
(use-package deferred      :defer t)
(use-package el-mock       :defer t)
(use-package elisp-refs    :defer t)
(use-package epc           :defer t)
(use-package epl           :defer t)
(use-package esxml         :defer t)
(use-package f             :defer t)
(use-package fn            :defer t)
(use-package fringe-helper :defer t)
(use-package fuzzy         :defer t)
(use-package ghub          :defer t)
(use-package ghub+         :defer t)
(use-package ht            :defer t)
(use-package kv            :defer t)
(use-package list-utils    :defer t)
(use-package logito        :defer t)
(use-package loop          :defer t)
(use-package m-buffer      :defer t)
(use-package makey         :defer t)
(use-package marshal       :defer t)
(use-package names         :defer t)
(use-package noflet        :defer t)
(use-package oauth2        :defer t)
(use-package ov            :defer t)
(use-package packed        :defer t)
(use-package parent-mode   :defer t)
(use-package parsebib      :defer t)
(use-package parsec        :defer t)
(use-package peval         :defer t)
(use-package pfuture       :defer t)
(use-package pkg-info      :defer t)
(use-package popup         :defer t)
(use-package popup-pos-tip :defer t)
(use-package popwin        :defer t)
(use-package pos-tip       :defer t)
(use-package request       :defer t)
(use-package rich-minority :defer t)
(use-package s             :defer t)
(use-package simple-httpd  :defer t)
(use-package spinner       :defer t)
(use-package tablist       :defer t)
(use-package uuidgen       :defer t)
(use-package web           :defer t)
(use-package web-server    :defer t)
(use-package websocket     :defer t)
(use-package with-editor   :defer t)
(use-package xml-rpc       :defer t)
(use-package zoutline      :defer t)

(provide 'env-plugins)
