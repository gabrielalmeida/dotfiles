(require 'package)
(setq package-enable-at-startup nil) ; dont do it immediately
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(package-refresh-contents)
(package-initialize)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Always download if not available
(setq use-package-always-ensure t)
;; quelpa (download from source)
(use-package quelpa)

;; quelpa-use-package extensions to use quelpa w/ use-package
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

;; utf-8 default everywhere
(setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
  (set-language-environment 'utf-8)
  (set-keyboard-coding-system 'utf-8) ; For old Carbon emacs on OS X only
  (setq locale-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-selection-coding-system
    (if (eq system-type 'windows-nt)
        'utf-16-le  ;; https://rufflewind.com/2014-07-20/pasting-unicode-in-emacs-on-windows
      'utf-8))

(prefer-coding-system       'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; general settings
(setq delete-old-versions -1 ) ; delete excess backups silently
(setq version-control t )
(setq vc-make-backup-files t )
(setq vc-follow-symlinks t )
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) )
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) )
(setq inhibit-startup-screen t )
(setq ring-bell-function 'ignore ) ; silent bell on mistakes
(setq coding-system-for-read 'utf-8 )
(setq coding-system-for-write 'utf-8)
(setq sentence-end-double-space nil)
(setq-default fill-column 80)
(setq initial-scratch-message "Hello World" )
(setq max-specpdl-size 50000)
(global-display-line-numbers-mode t )
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Wakatime
(use-package wakatime-mode
 :config
(global-wakatime-mode +1))

;; XTerm title
;; (setq frame-title-format "%b")
(setq frame-title-format
 '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))



 (defun xterm-title-update ()
    (interactive)
    (setq xterm-set-window-title t)
    (defadvice! fix-xterm-set-window-title (&optional terminal)
      :before-while #'xterm-set-window-title
      (not (display-graphic-p terminal)))
    (send-string-to-terminal (concat "\033]1; Emacs: " (buffer-name) "\007"))
    (if buffer-file-name
        (send-string-to-terminal (concat "\033]2; " (buffer-file-name) "\007"))
      (send-string-to-terminal (concat "\033]2; " (buffer-name) "\007"))))

  (add-hook 'post-command-hook 'xterm-title-update)

;; Save recentf every 5min so we don't lose history when Emacs is not
;; gracefully exited
(run-at-time " 5min" 300 'recentf-save-list)

;; KILL all other buffers except the currently selected one
;; TODO: Automaatically kill all other buffers except the last X recently visited buffers
(defun kill-other-buffers ()
  "Kill all buffers but current buffer and special buffers"
  (interactive)
  (dolist (buffer (delq (current-buffer) (buffer-list)))
    (let ((name (buffer-name buffer)))
      (when (and name (not (string-equal name ""))
             (/= (aref name 0) ?\s)
             (string-match "^[^\*]" name))
        (funcall 'kill-buffer buffer)))))

;; Sync Emacs PATH to OSX PATH env var values
(use-package exec-path-from-shell
  :config 
  (setq exec-path-from-shell-check-startup-files t)
  (when (eq system-type 'darwin)
    (exec-path-from-shell-initialize)))

(use-package diminish)

;; Enable OSX Clipboard integration
(use-package osx-clipboard
  :config
  (progn
    (osx-clipboard-mode +1)
    (diminish 'osx-clipboard-mode)))

;; Prettier package
(use-package apheleia
  :quelpa (apheleia :fetcher github :repo "raxod502/apheleia")
  :config
  (apheleia-global-mode +1))


;; Tailwind autocomplete
(use-package lsp-tailwindcss
  :quelpa (lsp-tailwindcss :fetcher github :repo "merrickluo/lsp-tailwindcss"))

;; Indentation
(use-package highlight-indentation
  :config
  (highlight-indentation-mode 1))

;; Show 80-column marker globally
;; (define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
;; (global-fci-mode 1)

(defun my-setup-indent (n)
  ;; java/c/c++
  (setq c-basic-offset n)
  ;; web development
  (setq coffee-tab-width n) ; coffeescript
  (setq javascript-indent-level n) ; javascript-mode
  (setq js-indent-level n) ; js-mode
  (setq js2-basic-offset n) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
  (setq web-mode-markup-indent-offset n) ; web-mode, html tag in html file
  (setq web-mode-css-indent-offset n) ; web-mode, css in html file
  (setq web-mode-code-indent-offset n) ; web-mode, js code in html file
  (setq css-indent-offset n) ; css-mode
  (setq typescript-indent-level n) ; ts
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  (setq-default evil-shift-width 2)
  (setq evil-shift-width 2))

(my-setup-indent 2) ; indent 2 spaces width

;; Codespaces TRAMP integration
(use-package use-package-ensure-system-package :ensure t)
(use-package codespaces
  :ensure-system-package gh
  :config (codespaces-setup))

(use-package color-identifiers-mode
  :config 
  (add-hook 'after-init-hook 'global-color-identifiers-mode))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package kaolin-themes
  :ensure t
  :load-path "themes"
  :config
  (load-theme 'kaolin-eclipse t))

;; icons
(use-package all-the-icons)

;; general key-binding
(use-package general
  :ensure t
  :config
  (general-evil-setup)
  (setq general-default-keymaps 'evil-normal-state-map)
  ;; unbind space from dired map to allow for git status
  (general-define-key :keymaps 'dired-mode-map
		      "-" 'dired-up-directory
		      "SPC" nil)
  ;; use ls-dired binary because OS X built-in ls has no --dired flag
  (when (string= system-type "darwin")       
    (setq dired-use-ls-dired nil))
  (general-define-key
   :keymaps 'motion
   "RET"   nil)
  (general-define-key
   :keymaps 'visual
   "SPC ;"   'comment-or-uncomment-region)
  (general-define-key
   :keymaps 'normal
   "SPC b d" 'kill-this-buffer
   "SPC f d" 'gbr/find-user-init-file
   "SPC f R" 'gbr/reload-user-init-file
   "SPC q"   'save-buffers-kill-terminal
   "SPC a d" 'dired
   "SPC TAB" 'gbr/switch-to-previous-buffer
   "-" 'dired-jump
   "SPC t f" 'display-fill-column-indicator-mode
   "C-+" 'text-scale-increase
   "C--" 'text-scale-decrease
   "C-=" '(lambda () (interactive) (text-scale-set 0))))

(defun gbr/find-user-init-file ()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file-other-window user-init-file))

(defun gbr/reload-user-init-file ()
  "Reload the `user-init-file' by evaluating it."
  (interactive)
  (load-file user-init-file))


(defun gbr/switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(use-package undo-tree
  :ensure t
  :config (global-undo-tree-mode)
  :init
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  :diminish undo-tree-mode)

;; load evil
(use-package evil
  :ensure t ;; install the evil package if not installed
  :init ;; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-undo-system 'undo-tree)
  (setq evil-declare-change-repeat 'company-complete)
  (setq evil-want-C-u-scroll t)
  ;; (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  ;; (setq evil-want-keybinding nil)

  :config (evil-mode));; tweak evil after loading it

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-surround
  :ensure t
  :init
  (progn
    (global-evil-surround-mode 1)
    (evil-define-key 'visual evil-surround-mode-map "s" 'evil-surround-region)
    (evil-define-key 'visual evil-surround-mode-map "S" 'evil-substitute)))

;; escape on quick fd
(use-package evil-escape :ensure t
  :diminish evil-escape-mode
  :config
  (evil-escape-mode))

;; example how to map a command in normal mode (called 'normal state' in evil)
;; (define-key evil-normal-state-map (kbd ", w") 'evil-window-vsplit)
;; (define-key evil-normal-state-map (kbd "<escape>") 'keyboard-escape-quit))

;; Ivy Related settings
(use-package counsel
  :after ivy
  :config (counsel-mode)
  :general

  (general-define-key :keymaps 'visual
		      "SPC SPC" 'counsel-M-x
		      "SPC s e" 'iedit-mode)

  (general-define-key :keymaps 'normal
		      "SPC SPC" 'counsel-M-x
		      "SPC f f" 'counsel-find-file
		      "SPC b d" 'kill-this-buffer
		      "SPC s s" 'counsel-rg
		      "SPC s y" 'counsel-yank-pop
		      "SPC s a" 'counsel-ag
		      "SPC s c" 'evil-ex-nohighlight
		      "SPC s p" 'counsel-projectile-rg
		      "SPC b b" 'counsel-buffer-or-recentf)
  
  (general-define-key :keymaps 'ivy-minibuffer-map
		      "[escape]"        #'keyboard-escape-quit)
  :bind* ; load when pressed
  (("M-x"     . counsel-M-x)
   ("C-s"     . swiper)
   ("C-x C-f" . counsel-find-file)
   ("C-x C-r" . counsel-recentf)  ; search for recently edited
   ("C-c g"   . counsel-git)      ; search for files in git repo
   ("C-c j"   . counsel-git-grep) ; search for regexp in git repo
   ("C-c /"   . counsel-ag)       ; Use ag for regexp
   ("C-x l"   . counsel-locate)
   ("C-x C-f" . counsel-find-file)
   ("<f1> f"  . counsel-describe-function)
   ("<f1> v"  . counsel-describe-variable)
   ("<f1> l"  . counsel-find-library)
   ("<f2> i"  . counsel-info-lookup-symbol)
   ("<f2> u"  . counsel-unicode-char)
   ("C-c C-r" . ivy-resume)))     ; Resume last Ivy-based completion

(use-package wgrep)
;; (use-package project :ensure t
;;   :general
;;   (general-define-key
;;    :keymaps 'normal
;;    "SPC p p" 'project-switch-project
;;    "SPC p f" 'project-find-file))

(use-package projectile)

(use-package counsel-projectile
  :general
  (general-define-key
   :keymaps 'normal
   "SPC p d" 'counsel-projectile-find-dir
   "SPC p f" 'counsel-projectile-find-file
   "SPC p b" 'counsel-projectile-switch-buffer
   "SPC p p" 'counsel-projectile-switch-project)
  
  (general-define-key :keymaps 'projectile-mode-map
		                  "SPC p" 'projectile-command-map)
  :config
  (setq projectile-project-search-path '("~/Dev/Whats/Meta" "~/Dev/Personal")))


;; (define-key projectile-mode-map (kbd "SPC p") 'projectile-command-map)

(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode)
  (general-define-key :keymaps 'ivy-minibuffer-map "[escape]" 'minibuffer-keyboard-quit)
  ;; Occur
  (evil-set-initial-state 'ivy-occur-grep-mode 'normal)
  (evil-make-overriding-map ivy-occur-mode-map 'normal)
  )

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :ensure t
  :init (ivy-rich-mode 1)
  :custom
  (ivy-virtual-abbreviate 'full
                          ivy-rich-switch-buffer-align-virtual-buffer t
                          ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)))


(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (general-define-key
   :keymaps '(flycheck-mode-map)
   :states '(normal visual)
   :prefix "SPC"
   :infix "e"
   "c" 'flycheck-buffer
   "e" 'flycheck-explain-error-at-point
   "h" 'flycheck-display-error-at-point
   "j" 'flycheck-next-error
   "k" 'flycheck-previous-error
   "l" 'flycheck-list-errors
   "n" 'flycheck-next-error
   "p" 'flycheck-previous-error
   "y" 'flycheck-copy-errors-as-kill)

  (setq flycheck-check-syntax-automatically '(save idle-change idle-buffer-switch mode-enabled))
  (setq flycheck-buffer-switch-check-intermediate-buffers t)
  (setq flycheck-idle-buffer-switch-delay 0.9)
  (setq flycheck-display-errors-delay 0.9)
  (setq flycheck-idle-change-delay 0.9)
  (setq-default flycheck-emacs-lisp-load-path 'inherit)

  (add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.20)))

  (setq flycheck-error-list-format
        `[("File" 12)
          ("Line" 5 flycheck-error-list-entry-< :right-align t)
          ("Col" 3 nil :right-align t)
          ("Level" 25 flycheck-error-list-entry-level-<)
          ("ID" 5 t)
          (,(flycheck-error-list-make-last-column "Message" 'Checker) 0 t)])
  (setq flycheck--error-list-msg-offset (+ (-sum (mapcar (lambda (x) (nth 1 x))
                                                         flycheck-error-list-format))
                                           (- (length flycheck-error-list-format)
                                              2)))

(add-hook 'prog-mode-hook #'flycheck-mode))

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package which-key
  :init
  (which-key-mode)
  :config
  (which-key-setup-minibuffer)
  (setq which-key-sort-order 'which-key-key-order-alpha
	which-key-side-window-max-width 0.33
	which-key-idle-delay 0.5)
  :diminish which-key-mode)

(use-package smartparens
  :config
  (require 'smartparens-config)
  (add-hook 'lisp-mode-hook #'smartparens-strict-mode))

(use-package golden-ratio
  :init (golden-ratio-mode 1)
  :config (setq golden-ratio-auto-scale t)
  (setq golden-ratio-extra-commands
	'(evil-window-next
	  evil-window-prev
	  evil-window-right
	  evil-window-left
	  evil-window-up
	  evil-window-down
	  )))

;; Enable desktop-mode (auto save session/restore when re-opening Emacs)
(setq desktop-path '("~/"))
(desktop-save-mode 1) 

(use-package better-jumper
  :after 'evil-maps
  :general
  (general-define-key
   :keymaps 'motion
   "C-o" 'better-jumper-jump-backward
   "C-i" 'better-jumper-jump-forward
   "<tab>" 'better-jumper-jump-forward)
  :config
  (setq better-jumper-context 'buffer) ;; defaults to 'window
  (better-jumper-mode +1))

(use-package smooth-scrolling
  :init (smooth-scrolling-mode 1))

;; magit dep
(use-package transient
  :commands (define-transient-command))

;; magit
(use-package magit
  :commands (magit-status
	     magit-blame
	     magit-find-file
	     magit-name-local-branch)
  :general
  (general-define-key :keymaps 'normal
		      "SPC g s" 'magit-status))

;; Org-mode settings
(with-eval-after-load 'org       
  (setq org-startup-indented t) ; Enable `org-indent-mode' by default

;; Org indent/visual-line-mode (visually jump to next line automatically as you type)
  (add-hook 'org-mode-hook #'visual-line-mode)

   (setenv "NODE_PATH"
      (concat
       (getenv "HOME") "/org/node_modules"  ":"
       (getenv "NODE_PATH")
      )
    )

;; Active Babel languages
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((emacs-lisp . t)
       (ditaa      . t)
       (shell      . t)
       (R          . t)
       (org        . t)
       (js         . t)
       (latex      . t)
       (python     . t)
       (sql        . t)
       (dot        . t)))

    ;; It's really annoying to enter 'yes' every time I export a org-file
    ;; with ditaa diagrams. It's dangerous on Shell script for example,
    ;; should be used with caution.
    (setq org-confirm-babel-evaluate nil)

  ;; Live refresh of inline images with org-display-inline-images
  (add-hook 'org-babel-after-execute-hook
            (lambda () (org-redisplay-inline-images)))

  (add-hook 'org-mode-hook 'org-display-inline-images))

;; Org-Roam basic configuration
(setq org-roam-directory (concat (getenv "HOME") "/Notes/"))
(setq org-roam-v2-ack t)

(setq org-startup-indented t
          org-pretty-entities t
          org-hide-emphasis-markers t
          org-startup-with-inline-images t
          org-image-actual-width '(300))

  ;; Nice bullets
  (use-package org-superstar
      :config
      (setq org-superstar-special-todo-items t)
      (add-hook 'org-mode-hook (lambda ()
                                 (org-superstar-mode 1))))

(use-package org-appear
   :config
   (add-hook 'org-mode-hook 'org-appear-mode)
   (setq org-appear-autolinks t))

(setq browse-url-browser-function 'browse-url-default-windows-browser)
(setq browse-url-browser-function 'browse-url-default-macosx-browser)

;; Drag-and-drop to `dired`
(use-package org-download
  :config
  (add-hook 'dired-mode-hook 'org-download-enable))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename org-roam-directory))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n G" . org-roam-graph)
         ("C-c n g" . org-id-get-create)
         ("C-c n t" . org-roam-tag-add)
         ("C-c n a" . org-roam-alias-add)
         ("C-c n r" . org-roam-ref-add)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n R" . org-roam-node-random)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)
         ("C-c n d" . org-roam-dailies-goto-today))
  :config
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :general
  (general-define-key :keymaps 'normal
		      "-" 'org-ctrl-c-minus
		      "|" 'org-table-goto-column
		      "M-o" (evil-org-define-eol-command org-insert-heading)
		      "M-t" (evil-org-define-eol-command org-insert-todo))
  :config
  (setq evil-want-C-i-jump nil)
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; Distraction-free screen
  (use-package olivetti
    :init
    (setq olivetti-body-width 0.7)
    :config
    (defun distraction-free ()
      "Distraction-free writing environment"
      (interactive)
      (if (equal olivetti-mode nil)
          (progn
            (window-configuration-to-register 1)
            (delete-other-windows)
            (text-scale-increase 2)
            (olivetti-mode t))
        (progn
          (jump-to-register 1)
          (olivetti-mode 0)
          (text-scale-decrease 2))))
    :bind
    (("<f9>" . distraction-free)))

(use-package deft
    :config
    (setq deft-directory org-roam-directory
          deft-recursive t
          deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
          deft-use-filename-as-title t)
    :bind
    ("C-c n s" . deft))

;; set proper language (fixes cyrillic letters in ansi-term)
(setenv "LANG" "pt_BR.UTF-8")
;; Set default font

(set-face-attribute 'default nil
                    :family "Operator Mono"
                    :height 175
                    :weight 'bold
                    :width 'normal)

;; font for all unicode characters
;;(set-fontset-font t 'unicode "Symbola" nil 'prepend)

;; override font for cyrillic characters
;;(set-fontset-font t 'cyrillic "Droid Sans Mono")

;; https://fakedrake.github.io/teaching-emacs-to-copy-utf-8-on-mac-os-x.html
(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil)
        (lang (getenv "LANG"))
        (default-directory "~"))
    (setenv "LANG" "en_US.UTF-8")
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))
    (setenv "LANG" lang)))
(setq interprogram-cut-function 'paste-to-osx)


(use-package js2-mode)
(use-package web-mode)

(defun setup-tide-mode ()
  "Set up Tide mode."
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1)
  (setq company-tooltip-align-annotations t))

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . #'setup-tide-mode))
  :config
    (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-mode))
    (add-hook 'typescript-mode-hook
	      (lambda ()
		(when (string-match-p "tsx?" (file-name-extension buffer-file-name))
		  (setup-tide-mode))))
    (flycheck-add-mode 'typescript-tide 'typescript-tslint)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("9cd57dd6d61cdf4f6aef3102c4cc2cfc04f5884d4f40b2c90a866c9b6267f2b3" "c95813797eb70f520f9245b349ff087600e2bd211a681c7a5602d039c91a6428" "d9a28a009cda74d1d53b1fbd050f31af7a1a105aa2d53738e9aa2515908cac4c" "f00a605fb19cb258ad7e0d99c007f226f24d767d01bf31f3828ce6688cbdeb22" "6128465c3d56c2630732d98a3d1c2438c76a2f296f3c795ebda534d62bb8a0e3" "d516f1e3e5504c26b1123caa311476dc66d26d379539d12f9f4ed51f10629df3" "3c7a784b90f7abebb213869a21e84da462c26a1fda7e5bd0ffebf6ba12dbd041" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "a44bca3ed952cb0fd2d73ff3684bda48304565d3eb9e8b789c6cca5c1d9254d1" "3263bd17a7299449e6ffe118f0a14b92373763c4ccb140f4a30c182a85516d7f" default))
 '(debug-on-error nil)
 '(evil-want-C-i-jump nil)
 '(ivy-use-selectable-prompt t)
 '(max-specpdl-size 500000)
 '(olivetti-lighter " Olv")
 '(olivetti-minimum-body-width 80)
 '(package-selected-packages
   '(codespaces use-package-ensure-system-package yaml-mode flycheck-yamllint flymake-yaml evil-collection highlight-indentation dap-mode lsp-tailwindcss lsp-mode markdown-mode ht emacs-everywhere edit-server kaolin-themes ag org-download better-jumper rainbow-delimiters color-identifiers-mode colors-identifiers-mode color-theme-sanityinc-tomorrow leuven-theme all-the-icons-ivy-rich apheleia aphelia ivy-rich alphelia quelpa-use-package quelpa typescript-mode wakatime-mode org-appear org-superstar olivetti deft emacsql org-roam indent-guide diminish osx-clipboard exec-path-from-shell evil-escape evil-surround prettier prettier-js evil-magit transient magit golden-ratio smooth-scrolling smooth-scrooling exotica-theme web-mode js2-mode smartparens which-key company use-package tide general evil counsel bug-hunter all-the-icons))
 '(wakatime-api-key "e7abc5cc-6ed3-4085-a84a-a7f0f3d9300e")
 '(wakatime-cli-path "/usr/local/bin/wakatime-cli"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
