(require 'package)
(add-to-list 'package-archives
  '("melpa" . "https://melpa.org/packages/") t);; リストの先頭にmelpaを追加するためのt
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; yes noで答えるのを y nにする
(fset 'yes-or-no-p 'y-or-n-p)

;; ホットリロード的なことをする
(use-package autorevert
  :init
  (setq auto-revert-mode-text "Auto-Reload")
  :config
  (global-auto-revert-mode t))

(use-package flycheck
  :ensure t
  :custom
  (flycheck-display-errors-delay 1.0)
  :hook
  ((typescript-mode . flycheck-mode)
   (ruby-mode . flycheck-mode)
   (csharp-mode . flycheck-mode)
   (web-mode . flycheck-mode)))

(use-package smooth-scrolling
  :ensure t
  :config
  (smooth-scrolling-mode 1)
  (setq smooth-scroll-margin 5))

(use-package emacs
  :custom
  (backup-inhibited t)
  (ring-bell-function 'ignore)
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
  (global-company-mode 1)
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

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
	 ("\\.tsx\\'" . web-mode)
         ("\\.phtml\\'" . web-mode)
         ("\\.tpl\\.php\\'" . web-mode)
         ("\\.jsp\\'" . web-mode)
         ("\\.as[cp]x\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-script-padding 2
        web-mode-block-padding 2
        web-mode-comment-style 2)

  ;; M-C-\で自動整形する場合に、スペース2でインデントするよう設定する
  (defun my-web-mode-hook ()
    (setq-local indent-tabs-mode nil)
    (setq-local tab-width 2)
    (setq-local web-mode-markup-indent-offset 2)
    (setq-local web-mode-code-indent-offset 2))

  (add-hook 'web-mode-hook 'my-web-mode-hook))

(use-package lsp-mode
  :ensure t
  :hook
  ((ruby-mode . lsp)
   (web-mode . lsp)
   (typescript-mode . lsp))
  :config
  (setq lsp-eslint-package-manager "npm")
  (setq lsp-eslint-server-command '("node" "/usr/local/bin/eslint-langserver"))
  (setq lsp-eslint-disable-diagnostics t)
  (setq lsp-eslint-configuration-sources '(".eslintrc.yml"))
  (setq lsp-enable-snippet t))

;; プロジェクトのEslintの設定を読み込む
(add-hook 'lsp-after-initialize-hook
          (lambda ()
            (lsp--set-configuration `(:eslintConfig ,(expand-file-name ".eslintrc" (projectile-project-root))))))

;; ;; ファイル保存時に自動で構文チェックを行う
;; (defun setup-tide-mode ()
;;   (interactive)
;;   (tide-setup)
;;   (flycheck

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook
  (lsp-mode . lsp-ui-mode)
  :bind (:map lsp-ui-mode-map
              ("C-x C-d" . lsp-ui-doc-glance))
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-doc-border "cyan")
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-alignment 'frame)
  (lsp-ui-doc-max-width 150)
  (lsp-ui-doc-max-height 80)
  (lsp-ui-doc-header t)
  (lsp-ui-doc-delay 1.0)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-use-webkit t)
  (lsp-ui-peek-enable t)
  (lsp-ui-peek-show-directory t)
  (lsp-ui-peek-peek-height 20)
  (lsp-ui-sideline-enable nil)
  :bind (:map lsp-ui-mode-map
         ("M-." . lsp-ui-peek-find-definitions)
         ("M-?" . lsp-ui-peek-find-references)
         ("C-." . lsp-ui-peek-jump-forward)
         ("C-," . lsp-ui-peek-jump-backward)))

(use-package flycheck-posframe
  :ensure t
  :hook (flycheck-mode . flycheck-posframe-mode)
  :config
  (setq flycheck-posframe-position 'point-max
        flycheck-posframe-background-color "white"
        flycheck-posframe-border-width 1
        flycheck-posframe-border-color "black"
        flycheck-posframe-parameters '((internal-border-width . 1)
                                       (font . "Monospace-10")
                                       (foreground-color . "#ffffff")
                                       (background-color . "#1f1f1f")
                                       (border-color . "#8b0000")
                                       (border-width . 2))))

