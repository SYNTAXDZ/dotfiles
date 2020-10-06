;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Miloudi Adel Hani"
      user-mail-address "miloudiadelhani@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;(setq doom-theme 'doom-one)
(setq doom-theme 'doom-outrun-electric)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq projectile-project-search-path '("~/Base/" "~/Base/Knowledge/learn_cpp/" ))
(setq lsp-rust-server 'rust-analyzer)
(windmove-default-keybindings 'ctrl)
(doom/set-frame-opacity 90)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! projectile
  (setq compilation-read-command nil)  ; no prompt in projectile-compile-project
  (projectile-register-project-type 'cmake '("CMakeLists.txt")
                                    :configure "cmake %s"
                                    :compile "cmake --build Debug"
                                    :test "ctest")

  (setq projectile-require-project-root t)
  (setq projectile-project-root-files-top-down-recurring
        (append '("compile_commands.json")
                projectile-project-root-files-top-down-recurring)))

(after! lsp
  (add-to-list 'lsp-file-watch-ignored "[/\\\\]build" )
  (setq +lsp-company-backend 'company-capf))

(after! lsp-ui
  (add-hook! 'lsp-ui-mode-hook #'lsp-ui-doc-mode)
  (setq
   lsp-ui-doc-use-webkit nil
   lsp-ui-doc-max-height 20
   lsp-ui-doc-max-width 50
   lsp-ui-sideline-enable nil
   lsp-ui-peek-always-show t)
  (map!
   :map lsp-ui-peek-mode-map
   "h" #'lsp-ui-peek--select-prev-file
   "j" #'lsp-ui-peek--select-next
   "k" #'lsp-ui-peek--select-prev
   "l" #'lsp-ui-peek--select-next-file))

;(after! ccls
 ; (setq ccls-initialization-options `(:cache (:directory ,(expand-file-name "~/Code/ccls_cache"))
  ;                                    :compilationDatabaseDirectory "build")
  ;(setq ccls-sem-highlight-method 'overlay)
  ;(evil-set-initial-state 'ccls-tree-mode 'emacs)))

;(setq ccls-sem-highlight-method 'font-lock)
;; alternatively, (setq ccls-sem-highlight-method 'overlay)
;; For rainbow semantic highlighting
;(ccls-use-default-rainbow-sem-highlight)
  ;(setq ccls-sem-highlight-method 'overlay)
(setq ccls-sem-highlight-method 'font-lock)
(evil-set-initial-state 'ccls-tree-mode 'emacs)

(add-hook 'pdf-view-mode-hook 'pdf-continuous-scroll-mode)
