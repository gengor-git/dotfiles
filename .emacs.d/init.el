;; Config based on https://www.youtube.com/watch?v=74zOY-vgkyw&list=PLEoMzSkcN8oPH1au7H6B7bBJ4ZO7BXjSZ

;; User paths and custom variables
(setq mcp-base-path (expand-file-name (concat (getenv "USERPROFILE") "/Documents")))
(setq mcp-repo-path (expand-file-name (concat (getenv "USERPROFILE") "/Documents/git")))

(setq mcp-org-tasks (expand-file-name (concat mcp-base-path "/Aufgaben.org")))
(setq mcp-org-journal (expand-file-name (concat mcp-base-path "/Journal.org")))

(message (concat "Using base path " mcp-base-path))

;; Basics
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)          ; Disable the menu bar

(set-default-coding-systems 'utf-8)

;; Set up the visible bell
(setq visible-bell t)
;; Line Numbers are (mostly) important
(column-number-mode)

(global-display-line-numbers-mode t)
;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                markdown-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Font settings
;; You will most likely need to adjust this font size for your system!
(defvar mcp/default-font-size 130)
(defvar mcp/default-variable-font-size 130)
(set-face-attribute 'default nil :font "Cascadia Code PL" :height mcp/default-font-size)
(set-face-attribute 'font-lock-comment-face nil :font "Cascadia Code PL" :height mcp/default-font-size)

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
  :init (load-theme 'doom-monokai-octagon t)) ;; doom-one, doom-palenight, doom-moonlight, doom-dracula
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
         markdown-mode
         gfm-mode
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

;; better identation, especially for YAML
(use-package indent-tools)

;; Easier commenting
(use-package evil-nerd-commenter
  :init
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))


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


(use-package undo-tree)
(global-undo-tree-mode t)

;; Custom key bindings
(use-package general
  :after which-key
  :config
  (general-evil-setup t)
  (general-create-definer mcp/leader-key-def
    :keymaps '(normal visual)
    :prefix "SPC"
    :non-normal-prefix "C-SPC")
  (mcp/leader-key-def
    "b"  '(:ignore t :which-key "buffer")
    "bd" '(kill-this-buffer :which-key "kill this buffer")
    "bb" '(counsel-switch-buffer :which-key "switch buffer")
    "bn" '(evil-buffer-new :which-key "new file")
    "bj" '(switch-to-next-buffer :which-key "switch to next buffer")
    "bk" '(switch-to-prev-buffer :which-key "switch to prev buffer")
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "tz" '(hydra-zoom/body :which-key "change zoom")
    "f"  '(:ignore t :which-key "files")
    "ff" 'counsel-find-file
    "fs" 'save-buffer
    "q" '(:ignore t :which-key "quit")
    "qq" 'evil-quit-all
    "i"  '(indent-tools-hydra/body :which-key "ident menu")
    )

  (general-iemap
    :prefix "M-SPC"
    "f"  '(:ignore t :which-key "files")
    "fs" 'save-buffer
    ))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;; Custom toggle shortcuts
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
  ;; (when (file-directory-p mcp-repo-path)
  ;;   (setq projectile-project-search-path mcp-repo-path))
  ;; (setq projectile-switch-project-action #'projectile-dired)
  (when (file-directory-p mcp-repo-path)
    (setq projectile-project-search-path '(""))
    (add-to-list 'projectile-project-search-path mcp-repo-path))
  (setq projectile-switch-project-action #'projectile-dired)
)

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
  "gl"  '(:ignore t :which-key "log")
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

(use-package git-gutter)
(global-git-gutter-mode 1)
(global-company-mode 1)

;; Snippets and other enhancements
(use-package yasnippet)
;; (yas-reload-all)
;; (add-hook 'prog-mode-hook #'yas-minor-mode)
(yas-global-mode 1)
(use-package yasnippet-snippets)

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

;; PlantUM
(use-package plantuml-mode
  :config
  ;; (setq plantuml-jar-path "C:/ProgramData/chocolatey/lib/plantuml/tools/plantuml.jar")
  (setq plantuml-default-exec-mode 'jar)
  ;; Enable plantuml-mode for PlantUML files
  (add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))
  )

;; Org settings » stay organized
(setq org-plantuml-jar-path 'plantuml-jar-path)

(file-exists-p plantuml-jar-path)

(defun mcp/org-font-setup ()
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 2.0)
                  (org-level-2 . 1.6)
                  (org-level-3 . 1.4)
                  (org-level-4 . 1.2)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  ;; (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  ;; (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  ;; (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  ;; (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  ;; (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  ;; (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
)


(defun mcp/org-mode-setup ()
  (org-indent-mode 1)
  (variable-pitch-mode 0)
  (visual-line-mode 1)
  (auto-fill-mode 1))

(use-package org
  :hook (org-mode . mcp/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-capture-templates
        '(("t" "Aufgabe" entry (file+headline mcp-org-tasks "Inbox")
           "* TODO %?")
          ("z" "Zeiteintrag in Aufgaben.org" entry (file+headline mcp-org-tasks "Inbox")
           "* ZKTO %? \n  %i" :clock-in t :clock-resume t)
          ("j" "Journal" entry (file+datetree mcp-org-journal)
           "* %?\nEntered on %U\n  %i")))

  ;; Ein "!" bedeutet Zeitstempel
  ;; Ein "@" bedeutet Notiz
  (setq org-todo-keywords
        '((sequence "TODO(t)" "STARTED(s!)" "WAITING(w@/!)" "DELEGATED(g@/!)" "|" "DONE(d!)" "CANCELLED(c@)")
          ))
  ;; Einen Zeitstempel eintragen, wenn eine Aufgabe als erledigt markiert wird
  (setq org-log-done 'time)

  ;; Einen eigenen Drawer benutzen
  (setq org-log-into-drawer t)

  ;; deutsch as export language
  (setq org-export-default-language "de")

  ;; 
  (setq org-agenda-start-with-log-mode t)

  ;; deutscher Kalender:
  (setq calendar-week-start-day 1
        calendar-day-name-array
          ["Sonntag" "Montag" "Dienstag" "Mittwoch"
          "Donnerstag" "Freitag" "Samstag"]
        calendar-month-name-array
          ["Januar" "Februar" "März" "April" "Mai"
          "Juni" "Juli" "August" "September"
          "Oktober" "November" "Dezember"])

  ;; Farben anpassen
  (setq org-todo-keyword-faces
        '(("TODO"  . (:foreground "#ff79a6" :weight bold))
          ("ROUTINE"  . (:foreground "#00ced1" :weight bold))
          ("IDEA"  . (:foreground "#B8860b" :weight bold))
          ("PROJ"  . (:foreground "#8fbc8f" :weight bold))
          ("SOLUTION"  . (:foreground "#00bfff" :weight bold))
          ("STARTED"  . (:foreground "#ffa0a0" :weight bold))
          ("WAITING"  . (:foreground "#bfbfbf" :weight bold))
          ("DELEGATED"  . (:foreground "#bfbfbf" :weight bold))
          ("DONE"  . (:foreground "#50fa7b"))
          ("ROUTINE"  . (:foreground "#00ced1" :weight bold))
          ("COMM"  . (:foreground "##Ffb90f" :weight bold))
          ("MEET"  . (:foreground "#8470ff" :weight bold))
          ("CANNED"  . shadow)
          ("CANCELLED"  . shadow)))


  ;; Call the font setup
  (mcp/org-font-setup)
  )

;; Org Keybindings
(mcp/leader-key-def 'normal org-mode-map
  "a" 'org-agenda
  "d" 'org-cut-subtree
  "p" 'org-paste-subtree
  "RET" "C-c C-c"
  )

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("✪" "○" "●" "○" "●" "○" "●"))) ;;◉

;; Markdown settings
(defun mcp/markdown-font-setup ()
  ;; Set faces for heading levels
  (dolist (face '((markdown-header-face-1 . 2.0)
                  (markdown-header-face-2 . 1.6)
                  (markdown-header-face-3 . 1.4)
                  (markdown-header-face-4 . 1.1)
                  (markdown-header-face-5 . 1.1)
                  (markdown-header-face-6 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))
)
(use-package markdown-mode
    :ensure t
    :commands (markdown-mode gfm-mode)
    :mode (("README\\.md\\'" . gfm-mode)
            ("\\.md\\'" . markdown-mode)
            ("\\.markdown\\'" . markdown-mode))
    :init
    (setq markdown-command "multimarkdown")
    :config
    ;; (set-face-attribute 'markdown-header-face nil :font "Cantarell" :weight 'regular)
    ;; (setq markdown-header-scaling t)
    (mcp/markdown-font-setup)
)



(mcp/leader-key-def 'normal markdown-mode-map
  "i" '(:ignore t :which-key "insert")
  "il" 'markdown-insert-link
  "ii" 'markdown-insert-image
  )

;; set margin for all modes writing documents
(defun mcp/write-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook
  (org-mode . mcp/write-mode-visual-fill)
  (markdown-mode . mcp/write-mode-visual-fill)
  )


;; Powershell stuff
(use-package powershell)
(defun run-powershell ()
  "Run powershell"
  (interactive)
  (async-shell-command "c:/windows/system32/WindowsPowerShell/v1.0/powershell.exe -Command -"
               nil
               nil))
