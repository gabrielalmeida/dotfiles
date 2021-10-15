;; package setup
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

;; evil mode
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (setq evil-want-fine-undo t))
(use-package evil-collection
  :after (evil)
  :config
  (evil-collection-init))

;; which-key
(use-package which-key
  :config
  (which-key-mode))

;; ivy
(use-package counsel
  :config
  (ivy-mode 1)
  (setq ivy-wrap t))
(use-package ivy-hydra
  :after counsel)

;; magit
(use-package magit
  :commands (magit-status magit-blame magit-find-file))
(use-package evil-magit
  :after magit)
