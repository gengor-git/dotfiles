;; Config based on https://www.youtube.com/watch?v=74zOY-vgkyw
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)          ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)
;; Line Numbers are (mostly) important
(column-number-mode)
(global-display-line-numbers-mode t)
;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Font settings
;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 120)
(defvar efs/default-variable-font-size 120)
(set-face-attribute 'default nil :font "Cascadia Code PL" :height efs/default-font-size)

;; Theme
(load-theme 'tango-dark)   ; superceded by doom themes later!

;; Keys
;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Packaging
;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; For screencasts
(use-package command-log-mode)

;; Themes and nicer mode line
(use-package doom-themes
  :init (load-theme 'doom-dracula t)) ;; doom-one, doom-palenight, doom-moonlight, doom-dracula
;; on first install: M-x all-the-icons-install-fonts
(use-package all-the-icons)
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; Spacemacs like display of key options
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; Ivy for file selection
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; Better keys for buffer switching
(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

;; Extra infos using ivy
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :init
  :demand t
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         ;; ("C-M-j" . counsel-switch-buffer)
         ("C-M-l" . counsel-imenu)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

;; Easier reading of paranthesis, esp. in LISP
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
;; HTML colors become the background of the text
(use-package rainbow-mode
  :defer t
  :hook (org-mode
         emacs-lisp-mode
         web-mode
         typescript-mode
         js2-mode))
 
;; More helpful help texts for emacs
;; We need to remap to replace the standard help functions.
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))


;; Editing rules
(setq-default tab-width 2)
;;(setq-default evil-shift-width tab-width)
(setq-default indent-tabs-mode nil)
;; Easier commenting
(use-package evil-nerd-commenter
  :init
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; Custom key bindings
(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer mcp/leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "C-SPC"
    :global-prefix: "C-SPC")
  (mcp/leader-key-def
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "tz" '(hydra-zoom/body :which-key "change zoom")
    "f"  '(:ignore t :which-key "files")
    "ff" 'counsel-find-file
    "fs" 'save-buffer))

;; Evil stuff here
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :init
  (setq evil-collection-company-use-tng nil)  ;; Is this a bug in evil-collection?
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  (setq evil-collection-mode-list
        (remove 'lispy evil-collection-mode-list))
  (evil-collection-init))


;; Custom shortcuts
(use-package hydra)

(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))


;; dev stuff » find, build and manage project folders
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :demand t
  :bind ("C-M-p" . projectile-find-file)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "C:/Users/palm07/Documents/git")
    (setq projectile-project-search-path '("C:/Users/palm07/Documents/git")))
  (setq projectile-switch-project-action #'projectile-dired))

;; better counsel support, check with ALT+o
(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))
;; C-c p s r » search with Ripgrep (written in Rust), Use C-c C-o for permanent buffer

;; Version control with git, requires evil-collection to play nice
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(mcp/leader-key-def
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"   '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gr"  'magit-rebase)

;; Enhancement to Magit
;;(use-package forge)
;; Had problems with Windows install.
