(require 'package)
(setq package-enable-at-startup nil) ; dont do it immediately
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(package-initialize)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Always download if not available
(setq use-package-always-ensure t)

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
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; Wakatime
(global-wakatime-mode)
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

;; prettier-eslint
(add-to-list 'load-path "~/.emacs.d/prettier-eslint-emacs")
(require 'prettier-eslint)

(add-hook 'js2-mode-hook (lambda () (add-hook 'after-save-hook 'prettier-eslint nil t)))
(add-hook 'react-mode-hook (lambda () (add-hook 'after-save-hook 'prettier-eslint nil t)))
(add-hook 'typescript-mode-hook (lambda () (add-hook 'after-save-hook 'prettier-eslint nil t)))
(add-hook 'rjsx-mode-hook (lambda () (add-hook 'after-save-hook 'prettier-eslint nil t)))

;; Indentation
(use-package indent-guide
  :config
  (indent-guide-global-mode 1))

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
  )

(my-setup-indent 2) ; indent 2 spaces width


(use-package exotica-theme 
  :ensure t
  :load-path "themes"
  :config
  (load-theme 'exotica t))

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

;; (use-package evil-collection
;;   :after evil
;;   :ensure t
;;   :config
;;   (evil-collection-init)

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

(use-package counsel-projectile
  :general
  (general-define-key
   :keymaps 'normal
   "SPC p d" 'counsel-projectile-find-dir
   "SPC p f" 'counsel-projectile-find-file
   "SPC p b" 'counsel-projectile-switch-buffer
   "SPC p p" 'counsel-projectile-switch-project)
  (general-define-key :keymaps 'projectile-mode-map
		      "SPC p" 'projectile-command-map))


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

(use-package ivy-rich
  :after ivy
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

  (setq flycheck-check-syntax-automatically '(save idle-change new-line mode-enabled))
  (setq flycheck-display-errors-delay 0)
  (setq flycheck-idle-change-delay 0)
  (setq-default flycheck-emacs-lisp-load-path 'inherit)

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
	which-key-idle-delay 0.1)
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

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Notes"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package evil-magit
  :after (evil magit)
  :config
  (with-eval-after-load 'magit
    (require 'evil-magit))
  ;; :general
  ;; ('normal magit-mode-map "SPC" leader-map)
  )

;; Set default font
(set-face-attribute 'default nil
                    :family "Operator Mono"
                    :height 110
                    :weight 'normal
                    :width 'normal)

(use-package js2-mode)
(use-package web-mode)

(defun setup-tide-mode ()
  "Set up Tide mode."
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (eldoc-mode +1)
  (setq company-tooltip-align-annotations t)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

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
;; enable typescript-tslint checker
    (flycheck-add-mode 'typescript-tide 'javascript-eslint)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3263bd17a7299449e6ffe118f0a14b92373763c4ccb140f4a30c182a85516d7f" default))
 '(debug-on-error nil)
 '(ivy-use-selectable-prompt t)
 '(max-specpdl-size 500000)
 '(package-selected-packages
   '(wakatime-mode org-appear org-superstar olivetti deft emacsql org-roam indent-guide diminish osx-clipboard exec-path-from-shell evil-escape evil-surround prettier prettier-js evil-magit transient magit golden-ratio smooth-scrolling smooth-scrooling exotica-theme web-mode js2-mode smartparens which-key company use-package tide ivy-rich general evil counsel bug-hunter all-the-icons))
 '(wakatime-api-key "e7abc5cc-6ed3-4085-a84a-a7f0f3d9300e")
 '(wakatime-cli-path "/usr/local/bin/wakatime"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
