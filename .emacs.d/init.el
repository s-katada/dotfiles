(require 'package)
(add-to-list 'package-archives
  '("melpa" . "https://melpa.org/packages/") t);; リストの先頭にmelpaを追加するためのt
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

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
  :ensure 
  :bind (("C-h" . 'backward-delete-char)))

(use-package tool-bar
  :if (display-graphic-p)
  :config
  (tool-bar-mode -1))

(use-package ivy
  :bind
  (("C-s" . swiper))
  :config
  (ivy-mode t))

(use-package ivy-rich
  :ensure t
  :init
  (ivy-rich-mode t))

(use-package swiper
  :ensure t)

(use-package counsel
  :ensure t
  :bind
  (("C-x C-b" . counsel-switch-buffer)))

(use-package company
  :ensure t
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  :config
  (global-company-mode t)
  :bind
  (:map company-active-map
	("C-h" . 'backward-delete-char)))

(use-package company-quickhelp
  :after company
  :ensure t
  :config
  (company-quickhelp-mode t))

(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

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

