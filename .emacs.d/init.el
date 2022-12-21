;; パッケージ追加
(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

;; load-path
(add-to-list 'load-path "~/.emacs.d/original")

;; sushi-bar-mode読み込み
(load "sushi_bar_mode")

;; $PATH読み込み
(load "shellenv")

;; command読み込み
(load "key_binds")

;; theme読み込み
(load-theme 'tango-dark t)

;; メニューバー、ツールバーを消去
(menu-bar-mode -1)
(tool-bar-mode 0)

; emacs終了時確認メッセージを出さないようにする
(setq confirm-kill-processes nil)

;; フルスクリーン
(set-frame-parameter nil 'fullscreen 'maximized)

;; LGモニター
(if (> (frame-width) 200)
    (set-face-attribute 'default (selected-frame) :height 200))

;; ARZOPAモニター
(if (eq (frame-width) 167)
    (set-face-attribute 'default (selected-frame) :height 160))

;; macbook air m2
(if (eq (frame-width) 119)
    (set-face-attribute 'default (selected-frame) :height 120))

;; 会社のモニター
(if (eq (frame-width) 157)
    (set-face-attribute 'default (selected-frame) :height 150))

;; 背景透けさせる
(set-frame-parameter (selected-frame) 'alpha '(80 . 50))
(add-to-list 'default-frame-alist '(alpha . (80 . 50)))

;; シンボル(private)
(set-face-foreground 'font-lock-builtin-face "#1E90FF")

;; クラス名
(set-face-foreground 'font-lock-type-face "#00FF7F")

;; シンボル(:)
(set-face-foreground 'font-lock-constant-face "#1E90FF")

;; コメント
(set-face-foreground 'font-lock-comment-face "green3")

;; 関数
(set-face-foreground 'font-lock-function-name-face "yellow2")

;; 変数
(set-face-foreground 'font-lock-variable-name-face "#87CEFA")

;; keyword(if while for などなど)
(set-face-foreground 'font-lock-keyword-face "#FF00FF")

;; 文字列定数に使われる
(set-face-foreground 'font-lock-string-face "orange")

;; コードないのドキュメント文字列に使われる
(set-face-foreground 'font-lock-doc-face "orange")

;; org-modeで表を整形するための設定
(set-fontset-font (frame-parameter nil 'font)
                  'japanese-jisx0208
                  (font-spec :family "Hiragino Kaku Gothic ProN"))
(add-to-list 'face-font-rescale-alist
             '(".*Hiragino Kaku Gothic ProN.*" . 1.2))

;; ls does not support --dired; see dired-use-ls-dire for more details. errorを消すため
(let ((gls "/usr/local/bin/gls"))
 (if (file-exists-p gls) (setq insert-directory-program gls)))

;; $PATH反映
(setq exec-path (parse-colon-path (getenv "PATH")))

;; welcome to gnu emacsを消去
(setq inhibit-startup-message t)

;; 起動時scratchバッファのメッセージを消去
(setq initial-scratch-message "")

;; 新規フレームのデフォルト設定
(setq default-frame-alist initial-frame-alist)

;; ~ がついたバックアップファイルを作成しないようにする
(setq make-backup-files nil)

;; .#* がついたバックアップファイルを作成しないようにする
(setq auto-save-default nil)

;; tabをスペース2個分になるようにする
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)


;; C-hをdelete keyにする
(bind-key "C-h" `delete-backward-char)

;; コメントアウト(実際はC-:と入力している)
(bind-key "C-;" 'comment-line)

;; バッファ選択のキーバインドを変更
(bind-key "C-x C-b" 'switch-to-buffer)

;; C-vの逆(scroll-down-command)
(bind-key "C-c" 'scroll-down-command)

;; バッファの移動を設定(Vim風)
(bind-key "C-x C-l" 'windmove-right)
(bind-key "C-x C-h" 'windmove-left)
(bind-key "C-x C-j" 'windmove-down)
(bind-key "C-x C-k" 'windmove-up)

(bind-key "<S-s-return>" (lambda ()
                           "vscodeのcmd + shift + returnで1行上に追加しつつインデントの動きを再現"
                           (interactive)
                           (beginning-of-line)
                           (newline-and-indent)
                           (previous-line)
                           (indent-for-tab-command)))


(bind-key "<s-return>" (lambda ()
                         "vscodeのcmd + returnで1行下に追加しつつインデント調整の動きを再現"
                         (interactive)
                         (end-of-line)
                         (newline)
                         (indent-for-tab-command)))

(bind-key "<S-return>" (lambda ()
                         "[]や{}の中でreturnを押した時に勝手にインデントしつつその行に移動する"
                         (interactive)
                         (indent-for-tab-command)
                         (newline-and-indent)
                         (previous-line)
                         (end-of-line)
                         (newline-and-indent)))

(defun insert-template (&optional diff)
  "現在年月日をカレントバッファに出力します。引数Nを与えるとN日前を出力します。"
  (interactive "P")
  (insert "* TODO ")
  (insert
   (shell-command-to-string
    (format
     "echo -n $(LC_ALL=ja_JP date -v-%dd +'*%%Y/%%m/%%d(%%a)*')"
     (or diff 0))))
  (insert "\n** タスク\n")
  (insert "\n")
   (insert "** 覚えたこと\n")
  (insert "\n")
  (insert "** その他"))

(bind-key "C-{" (lambda ()
                  "{ を入力した時に{ }と出力する"
                  (interactive)
                  (insert "{}")
                  (backward-char)
                  (just-one-space)
                  (insert "A")
                  (just-one-space)
                  (backward-char)
                  (delete-backward-char 1)))

(bind-key "{" (lambda ()
                "{ を入力した時に{}と出力する"
                (interactive)
                (insert "{}")
                (backward-char)))

(bind-key "\"" (lambda ()
                 "\" を入力した時に""と出力する"
                 (interactive)
                 (insert "\"\"")
                 (backward-char)))

(bind-key "\'" (lambda ()
                 "' を入力した時に''と出力する"
                 (interactive)
                 (insert "''")
                 (backward-char)))

(bind-key "[" (lambda ()
                "[ を入力した時に[]と出力する"
                (interactive)
                (insert "[]")
                (backward-char)))

(bind-key "(" (lambda ()
                "( を入力した時に()と出力する"
                (interactive)
                (insert "()")
                (backward-char)))

(bind-key "C-<" (lambda ()
                  "< を入力した時に<>と出力する"
                  (interactive)
                  (insert "<>")
                  (backward-char)))

(bind-key "C-<tab>" (lambda ()
                      "織家さん直伝のコマンド : バッファの移動が楽になる"
                      (interactive)
                      (when (one-window-p)
                        (split-window-horizontally))
                      (other-window 1)))
;; corsor変更
(add-to-list 'default-frame-alist '(cursor-type . bar))

;; nyan-mode
(use-package nyan-mode
  :ensure t
  :custom
  (nyan-animate-nyancat t)
  :config
  (nyan-mode t))

(use-package mode-icons
  :ensure t
  :config (mode-icons-mode))

(use-package all-the-icons-ivy
  :ensure t
  :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

;; ivy設定
(use-package ivy
  :ensure t
  :custom
  (ivy-use-virtual-buffers t)
  (enable-recursive-minibuffers t)
  (ivy-height 20)
  (ivy-extra-directories nil)
  (ivy-re-builders-alist '((t . ivy--regex-plus)))
  (ivy-count-format "(%d / %d) ")
  :config
  (ivy-mode 1))

;; M-xで操作する時に便利にする
(use-package counsel
  :ensure t
  ;; :custom (counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ;("C-x C-k" . counsel-ag)
         ("C-x C-i" . counsel-git))
  :config
  (define-key global-map [(super r)] 'counsel-recentf))

;; i-serchの拡張機能(swiper)
(use-package swiper
  :ensure t
  :custom (swiper-include-line-number-in-search t)
  :bind (("\C-s" . swiper)))

;; 自動補完
(use-package company
  :ensure t
  :bind (("M-C-i" . company-complete)
         :map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous)
         ("C-h" . nil)
         ("C-s" . company-filter-candidates)
         ("C-i" . company-complete-selection)
         ([tab] . company-complete-selection)
         ("C-f" . company-complete-selection)
         ("C-M-i" . company-complete))
  :custom
  (company-transformers '(company-sort-by-backend-importance))
  (company-idle-delay 0)
  (company-minimum-prefix-length 3)
  (company-selection-wrap-around t)
  (completion-ignore-case t)
  (company-dabbrev-downcase nil)
  :config
  (global-company-mode))

;; ファイル名で検索が可能になる
(use-package find-file-in-project
  :ensure t
  :bind (([(super shift i)] . find-file-in-project)))

;; 余分なメッセージを削除
(defmacro with-suppressed-message (&rest body)
  "Suppress new messages temporarily in the echo area and the `*Messages*' buffer while BODY is evaluated."
  (declare (indent 0))
  (let ((message-log-max nil))
    `(with-temp-message (or (current-message) "") ,@body)))

(use-package recentf
  :ensure t
  :custom
  (recentf-save-file "~/.emacs.d/.recentf")
  (recentf-max-saved-items 200)
  (recentf-exclude '(".recentf"))
  (recentf-auto-cleanup 'never)
  :config
  (run-with-idle-timer 30 t '(lambda () (with-suppressed-message (recentf-save-list)))))

(use-package recentf-ext
  :ensure t)

;; terminal使えるようにする
(use-package multi-term
  :ensure t
  :custom
  (multi-term-program "/bin/zsh")
  :bind (("C-x C-t" . multi-term))
  :hook
  (term-mode . (lambda ()
                      (define-key term-raw-map (kbd "C-h") 'term-send-backspace)
                      (define-key term-raw-map (kbd "C-p") 'term-send-up)
                      (define-key term-raw-map (kbd "C-n") 'term-send-down)
                      (define-key term-raw-map (kbd "s-v") 'term-paste)
                      (define-key term-raw-map (kbd "C-r") 'term-send-reverse-search-history))))

;; lsp-mode
(use-package lsp-mode
  :ensure t
  :hook
  ((ruby-mode . lsp)
   (typescript-mode . lsp)
   (web-mode . lsp)
   (csharp-mode . lsp)))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))

;; linum-mode
(use-package nlinum
  :ensure t
  :hook
  ((emacs-lisp-mode . nlinum-mode)
  (lisp-mode . nlinum-mode)
  (ruby-mode . nlinum-mode)
  (csharp-mode . nlinum-mode)
  (web-mode .nlinum-mode)
  (typescript-mode . nlinum-mode)
  (js-mode . nlinum-mode)
  (dockerfile-mode . nlinum-mode)
  (sh-mode . nlinum-mode)
  (python-mode . nlinum-mode)
  (yaml-mode . nlinum-mode)
  (markdown-mode . nlinum-mode)))

;; Ruby
(use-package ruby-mode
  :ensure t
  :bind ((:map ruby-mode-map
         ("C-c !". nil)))
  :mode
  ("\\.ruby?\\'" . ruby-mode)
  ("\\.rb?\\'" . ruby-mode))

;; C#
(use-package csharp-mode
  :ensure t
  :custom
  (c-basic-offset 4)
  (c-electric-flag nil)
  :mode
  ("\\.cs?\\'" . csharp-mode)
  :bind ((:map csharp-mode-map
               ("{" . nil)
               ("(" . nil)
               ("C-c" . nil))))

;; docker
(use-package dockerfile-mode
  :ensure t
  :mode
  ("[Dd]ockerfile" . dockerfile-mode))

;; yaml-mode
(use-package yaml-mode
  :ensure t
  :mode
  ("\\.yaml?\\'" . yaml-mode)
  ("\\.yml?\\'" . yaml-mode))

;;(defface my-face-r-1 '((t (:background "gray15"))) nil)
(defface my-face-b-1 '((t (:background "gray"))) nil) ; color of zenkaku-space
(defface my-face-b-2 '((t (:background "gray26"))) nil) ; color of tab
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
;;(defvar my-face-r-1 'my-face-r-1)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)

;; 無駄なスペースを可視化
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("\t" 0 my-face-b-2 append)
     ("　" 0 my-face-b-1 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     ;;("[\r]*\n" 0 my-face-r-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; neotree
(use-package neotree
  :ensure t
  :commands (neo-smart-open neo-create-file-auto-open)
  :custom
  (neo-keymap-style 'concise)
  (neo-smart-open t)
  (neo-create-file-auto-open t)
  (neo-persist-show t)
  (neo-theme (if (display-graphic-p) 'icons 'arrow))
  :bind (("M-o" . neotree-show)
         ("M-n" . neotree-hide)
         :map neotree-mode-map
         ("a" . neotree-hidden-file-toggle)
         ("<left>" . neotree-select-up-node)))

(defun neotree-text-scale ()
  "Text scale for neotree."
  (interactive)
  (text-scale-adjust 0)
  (text-scale-decrease 1)
  (message nil))
(add-hook 'neo-after-create-hook
	        (lambda (_)
	          (call-interactively 'neotree-text-scale)))

(use-package flycheck
  :ensure t
  :custom
  (flycheck-display-errors-delay 1.0)
  :hook
  ((typescript-mode . flycheck-mode)
   (ruby-mode . flycheck-mode)
   (csharp-mode . flycheck-mode)
   (web-mode . flycheck-mode)))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.js\\'" . web-mode)
         ("\\.json\\'" . web-mode)
         )
  :bind ((:map web-mode-map
               ("s-v" . nil)))
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-block-padding 2)
  (web-mode-comment-style 2)
  (web-mode-enable-css-colorization t)
  (web-mode-enable-auto-pairing t)
  (web-mode-enable-comment-keywords t)
  (web-mode-enable-current-element-highlight t)
  :config
  (set-face-foreground 'web-mode-html-tag-face "#00FF7F")
  (set-face-foreground 'web-mode-html-attr-name-face "#87CEFA")
  (set-face-foreground 'web-mode-current-element-highlight-face "#00FF7F"))

;; web-modeでペーストした時に自動インデントするのをやめる(汚いから修正する)
(add-hook 'web-mode-hook
          '(lambda ()
             (setq web-mode-enable-auto-indentation nil)))

(use-package typescript-mode
  :ensure t
  :custom
  (typescript-indent-level 2))

;; fontサイズを変更
(defun set-font-size (height)
  (interactive "nHeight:")
  (set-face-attribute 'default (selected-frame) :height height))

;; コマンドを覚える必要がなくなる
(use-package which-key
  :ensure t
  :custom
  (which-key-side-window-max-height 0.7)
  :diminish which-key-mode
  :hook (after-init . which-key-mode))

;; モードラインをいい感じにする
(use-package hide-mode-line
  :ensure t
  :hook
  ((neotree-mode) . hide-mode-line-mode))

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :custom
  (doom-modeline-gnus-timer 2)
  (doom-modeline-vcs-max-length 70)
  (doom-modeline-height 20)
  (progn
    (set-face-attribute 'doom-modeline-bar nil :background "#4169e1")
    (set-face-attribute 'doom-modeline-project-dir nil :foreground "black")
    (set-face-attribute 'doom-modeline-buffer-major-mode nil :background "#4169e1")
    (set-face-attribute 'doom-modeline-info nil :foreground "#4169e1"))
  :hook (after-init . doom-modeline-mode))

;; 複数の場所にある特定の単語周辺を同時に編集することができる
(use-package multiple-cursors
  :ensure t
  :bind (("C-x C-a" . mc/mark-all-like-this)
         ("C-x C-d" . mc/mark-all-like-this-in-defun)
         ("C-x C-e" . mc/edit-ends-of-lines)
         ("C-x C-r" . mc/mark-all-in-region-regexp)))

;; バッファ変更時カーソルを見失わないようにする
(use-package beacon
  :ensure t
  :custom
  (beacon-color "cyan")
  (beacon-blink-when-focused t)
  (beacon-blink-when-window-scrolls nil)
  :config
  (beacon-mode 1))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(rubocop lsp-pyright which-key web-mode use-package typescript-mode recentf-ext nyan-mode nlinum neotree multiple-cursors multi-term mode-icons lsp-mode hide-mode-line flycheck find-file-in-project doom-modeline dockerfile-mode docker-compose-mode csharp-mode counsel company-quickhelp company-box beacon all-the-icons-ivy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
