(require 'package)
(add-to-list 'package-archives
  '("melpa" . "https://melpa.org/packages/") t);; リストの先頭にmelpaを追加するためのt
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; ホットリロード的なことをする
(use-package autorevert
  :init
  (setq auto-revert-mode-text " Auto-Reload")
  :config
  (global-auto-revert-mode t))

(use-package smooth-scrolling
  :config
  (smooth-scrolling-mode 1)
  (setq smooth-scroll-margin 5))

(use-package emacs
  :custom
  (backup-inhibited t)
  :config
  (electric-pair-mode t))

(use-package modus-themes
  :ensure t
  :config
  (load-theme 'modus-vivendi t))

(use-package dired
  :custom
  (dired-use-ls-dired nil)
  :hook
  (dired-mode . (lambda () (display-line-numbers-mode -1))))

(use-package frame
  :config
  (toggle-frame-maximized)
  (set-frame-parameter nil 'alpha 85))

(use-package display-line-numbers
  :config
  (global-display-line-numbers-mode)
  :custom
  (cursor-type 'bar))

(use-package bind-key
  :ensure t
  :bind (("C-h" . 'backward-delete-char)))

(use-package tool-bar
  :if (display-graphic-p)
  :config
  (tool-bar-mode -1))

(use-package nyan-mode
  :ensure t
  :config
  (nyan-mode t))

(use-package recentf
  :config
  (recentf-mode 1)
  (setq recentf-max-menu-items 50)
  (setq recentf-max-saved-items 1000))

(use-package ivy
  :bind
  (("C-s" . swiper))
  :config
  (ivy-mode t)
  (setq ivy-use-vertual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 25))

(use-package ivy-rich
  :ensure t
  :init
  (ivy-rich-mode t))

(use-package swiper
  :ensure t)

(use-package counsel
  :ensure t
  :bind
  (("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("C-x b" . counsel-switch-buffer)
   ("C-x C-b" . counsel-recentf)
   ("C-x C-i" . counsel-git)))

(use-package company
  :ensure t
  :config
  (global-company-mode t)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.1)
  :bind
  (:map company-active-map
	("C-h" . 'backward-delete-char)))

(use-package ace-window
  :ensure t
  :bind (("C-x C-o" . ace-window))
  :init
  (setq aw-dispatch-always nil)
  (setq aw-dispatch-alist
        '((?x aw-delete-window " Ace - Delete Window")
          (?m delete-other-windows " Ace - Delete Other Windows")
          (?b balance-windows " Ace - Balance Windows")
          (?s ace-swap-window " Ace - Swap Window")
          (?n aw-flip-window)
          (?i aw-swap-iw " Ace - Swap with Ace-Window")
          (?o delete-other-windows)
          (?? aw-show-dispatch-help))))

(use-package ruby-mode
  :mode ("\\.rb\\'" . ruby-mode)
  :interpreter ("ruby" . ruby-mode)
  :config
  (setq lsp-solargraph-use-bundler nil)
  (setq lsp-solargraph-extra-options '("--plugin" "rubocop")))

(use-package lsp-mode
  :ensure t
  :commands lsp
  :hook
  ((ruby-mode . lsp)))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook
  (lsp-mode . lsp-ui-mode)
  :bind (:map lsp-ui-mode-map
              ("C-x C-d" . lsp-ui-doc-glance))
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-border "cyan")
  (setq lsp-ui-doc-position 'at-point)
  (setq lsp-ui-doc-alignment 'frame)
  (setq lsp-ui-doc-max-width 150)
  (setq lsp-ui-doc-max-height 80)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-delay 0.1)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-use-webkit t)
  (setq lsp-ui-peek-enable t)
  (setq lsp-ui-peek-show-directory t)
  (setq lsp-ui-peek-peek-height 20)
  :bind (:map lsp-ui-mode-map
         ("M-." . lsp-ui-peek-find-definitions)
         ("M-?" . lsp-ui-peek-find-references)
         ("C-." . lsp-ui-peek-jump-forward)
         ("C-," . lsp-ui-peek-jump-backward)))
