(setq gc-cons-threshold (* 50 1000 1000))

(add-to-list 'default-frame-alist '(undecorated-round . t))

(setq read-process-output-max (* 16 1024 1024))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
	"straight/repos/straight.el/bootstrap.el"
	(or (bound-and-true-p straight-base-dir)
	    user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq make-backup-files t ;; Explicitly setting it to t
      backup-directory-alist '(("." . "~/.emacs-backups"))) ;; It will save it in the file's location if it can't save it in  ~/.emacs-backups

(when (daemonp)
  (straight-use-package 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq hinata-font "Iosevka 14")

(set-face-attribute 'default nil :font hinata-font)

(add-hook 'after-make-frame-functions (lambda (frame)
					(select-frame frame)
					(set-frame-font hinata-font nil t)))

;; Install the package
(straight-use-package
 '(hanami
   :type git
   :host nil
   :repo "https://github.com/ridiculouswaffle/hanami-emacs.git"))

;; Emacs doesn't recognize this as a theme, so add it to themes load path
(add-to-list 'custom-theme-load-path
	     (expand-file-name "hanami" (straight--build-dir)))

;; Then load it.
(load-theme 'hanami t)

(use-package all-the-icons
  :straight t
  :demand)

(use-package dashboard
  :straight t
  :init
  ;; Loads this dashboard in new frames
  (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))

  ;; I believe these lines are self-explanatory!
  (setq dashboard-banner-logo-title "Welcome back, senpai!"
	dashboard-startup-banner 'logo
	dashboard-center-content t
	dashboard-vertically-center-content t
	dashboard-show-shortcuts nil)

  ;; Now comes the fun part: Footer messages!
  (setq dashboard-footer-messages '(;; Anime references
				    "Nah I'd win"
				    "Are you the strongest because you use Emacs, or are you using Emacs because you are the strongest?"
				    "Don't worry, senpai will notice you!"
				    "'Using Emacs feels good when both are comfortable with each other' - Makima, reflecting on config"
				    "'Ignorance is bliss, Chainsaw Man!'"
				    "'Wanna do it?' - Himeno, asking you to edit your config"
				    "'Nothing cheers up a man faster than editing his Emacs config' - Katana Man"
				    ;; Emacs Humor
				    "'One who uses Emacs is a true programmer' - Sun Tzu, probably"
				    "'Thou shalt not employ Evil in Emacs, for it is nefarious' - Joe Mama"
				    "As ancient as the runes, as powerful as the dragons: Emacs."
				    "EMACS: Eight Megabytes And Constantly Swapping"
				    ;; Minecraft references
				    "Steve! Help me! I'm stuck"
				    "Creeper! Aww man"))

  (setq dashboard-icon-type 'all-the-icons) ;; Use all-the-icons for icons in this dashboard.
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (dashboard-setup-startup-hook))

(use-package vertico
  :straight t
  :config
  (vertico-mouse-mode) ;; Not needed, but it enables mouse scrolling and clicking
  :init (vertico-mode))

(use-package marginalia
  :straight t
  :init (marginalia-mode))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package embark
  :straight t
  :bind (("C-." . embark-act)
	 ("C-;" . embark-dwim))
  :config
  ;; This hides the modeline for Embark windows
  (add-to-list 'display-buffer-alist
	       '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
		 nil
		 (window-parameters (mode-line-format . none)))))

(use-package corfu
  :straight t
  :custom
  (corfu-auto t) ;; Enables autocompletion. Not turned on by default...
  :init (global-corfu-mode))

(use-package kind-icon
  :straight t
  :after corfu
  :custom
  (kind-icon-blend-background t)
  (kind-icon-default-face 'corfu-default) ;; Only needed with blend-background
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package magit
  :straight t
  :defer t)

(use-package lsp-mode
  :straight t
  :defer t
  :commands lsp)

(use-package flycheck
  :straight t
  :defer t)

(use-package lsp-ui
  :straight t
  :defer t)

(use-package dap-mode
  :straight t
  :defer t)

(add-hook 'prog-mode-hook 'hl-line-mode) ;; Highlights the current line
(add-hook 'prog-mode-hook 'electric-pair-mode) ;; Autopairs ( with )

(use-package web-mode
  :straight t
  :defer t
  :mode (("\\.phtml\\'" . web-mode)
	 ("\\.tpl\\.php\\'" . web-mode)
	 ("\\.[agj]sp\\'" . web-mode)
	 ("\\.as[cp]x\\'" . web-mode)
	 ("\\.erb\\'" . web-mode)
	 ("\\.mustache\\'" . web-mode)
	 ("\\.djhtml\\'" . web-mode))
  :config
  :hook ((web-mode . lsp-deferred)))

(use-package python-mode
  :defer t
  :hook ((python-mode . lsp-deferred)))

(use-package ruby-mode
  :defer t
  :hook ((ruby-mode . lsp-deferred)))

(use-package rust-mode
  :straight t
  :defer t
  :hook ((rust-mode . lsp-deferred)))

(use-package clojure-mode
  :straight t
  :defer t
  :hook ((clojure-mode . lsp-deferred)
	 (clojurescript-mode . lsp-deferred)))

(use-package cider
  :straight t
  :defer t)
