;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Miloudi Adel Hani"
      user-mail-address "miloudiadelhani@gmail.com.com")

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
(setq doom-font (font-spec :family "monospace" :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 15))

;; (set-fontset-font t 'arabic "Noto Sans Arabic UI")
(set-fontset-font t 'arabic "DejaVu Sans Mono")
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Nextcloud/org/")

;;(add-hook 'prog-mode-hook 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
;;(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;;(add-hook 'prog-mode-hook 'color-identifiers-mode)

;;(add-hook 'c-mode-hook 'my-c-mode-hook)
;;(defun my-c-mode-hook ()
 ;; (rainbow-mode 1))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(windmove-default-keybindings 'ctrl)
(doom/set-frame-opacity 90)
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

(after! ccls
  (setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t))))

;;(setq ccls-sem-highlight-method 'overlay)
;;(evil-set-initial-state 'ccls-tree-mode 'emacs)
(setq lsp-enable-semantic-highlight 'rainbow)
;;(setq lsp-semantic-highlight-method 'font-lock)
; vhdl lsp support
(setq lsp-vhdl-server-path "vhdl-tool")
; Prefer vhdl_ls over other VHDL language servers
;(custom-set-variables
;  '(lsp-vhdl-server 'vhdl-ls))
(use-package lsp-mode
         :config
         (add-hook 'vhdl-mode-hook 'lsp))


;;(setq lsp-enable-semantic-highlight 'rainbow)
;; For rainbow semantic highlighting
;;(setq ccls-semantic-highlight-method 'overlay)
;; lsp read from build dir to get the compile-commands.json
(defun maybe-lsp ()
  (cond ((file-exists-p
            (expand-file-name "compile_commands.json" (projectile-project-root)))
            (lsp))
    ((file-exists-p
      (expand-file-name "build/compile_commands.json" (projectile-project-root)))
     (setq-local ccls-initialization-options
                 '(:compilationDatabaseDirectory "build"
                                                 :cache (:directory "build/.ccls-cache")))
     (lsp))))
;(after! lsp-mode
;  (set-lsp-priority! 'clangd 1))  ; ccls has priority 0
;; clangd setup
(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
;;                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))
(setq lsp-enable-semantic-highlighting 't)
;; org-roam config
(setq org-roam-directory (file-truename "~/Nextcloud/org_roam"))

(setq org-roam-v2-ack t)
;; (setq org-roam-capture-templates '(("d" "default" plain (function org-roam--capture-get-point)
;;           "%?"
;;            :file-name "%<%Y-%m-%d-%H%M%S>_${slug}"
;;            :head "#+TITLE: ${title} "
;;            :unnarrowed t)
;;           ))

;; org-roam-ui setup
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(org-roam-db-autosync-mode)

;; org-journal the DOOM way
(use-package org-journal
  :init
  (setq org-journal-dir "~/Nextcloud/org_journal"
        org-journal-date-prefix "#+TITLE: "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-date-format "%A, %d %B %Y")
  :config
  (setq org-journal-find-file #'find-file-other-window )
  (map! :map org-journal-mode-map
        "C-c n s" #'evil-save-modified-and-close )
  )

;; (setq org-journal-enable-agenda-integration t)
;;(use-package! org-fancy-priorities
;;; :ensure t
;;  :hook
;;  (org-mode . org-fancy-priorities-mode)
;;  :config
;;   (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))
(use-package! org-super-agenda
  :commands (org-super-agenda-mode))
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-tags-column 100 ;; from testing this seems to be a good value
      org-agenda-compact-blocks t)
;; (setq org-agenda-files "~/NextCloud/org_agenda/")
(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                           :todo "NEXT"
                           :order 1)
                          (:name "Important"
                           :tag "Important"
                           :priority "A"
                           :order 1)
                          (:name "Due Today"
                           :deadline today
                           :order 2)
                          (:name "Due Soon"
                           :deadline future
                           :order 8)
                          (:name "Overdue"
                           :deadline past
                           :face error
                           :order 7)
                          (:name "Work"
                           :tag  "Work"
                           :order 3)
                          (:name "Dissertation"
                           :tag "Dissertation"
                           :order 7)
                          (:name "Emacs"
                           :tag "Emacs"
                           :order 13)
                          (:name "Projects"
                           :tag "Project"
                           :order 14)
                          (:name "Essay 1"
                           :tag "Essay1"
                           :order 2)
                          (:name "Reading List"
                           :tag "Read"
                           :order 8)
                          (:name "Work In Progress"
                           :tag "WIP"
                           :order 5)
                          (:name "Blog"
                           :tag "Blog"
                           :order 12)
                          (:name "Essay 2"
                           :tag "Essay2"
                           :order 3)
                          (:name "Trivial"
                           :priority<= "E"
                           :tag ("Trivial" "Unimportant")
                           :todo ("SOMEDAY" )
                           :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))


(defun kym/dired-copy-images-links ()
  "Works only in dired-mode, put in kill-ring,
ready to be yanked in some other org-mode file,
the links of marked image files using file-name-base as #+CAPTION.
If no file marked then do it on all images files of directory.
No file is moved nor copied anywhere.
This is intended to be used with org-redisplay-inline-images."
  (interactive)
  (if (derived-mode-p 'dired-mode)                           ; if we are in dired-mode
      (let* ((marked-files (dired-get-marked-files))         ; get marked file list
             (number-marked-files                            ; store number of marked files
              (string-to-number                              ; as a number
               (dired-number-of-marked-files))))             ; for later reference
        (when (= number-marked-files 0)                      ; if none marked then
          (dired-toggle-marks)                               ; mark all files
          (setq marked-files (dired-get-marked-files)))      ; get marked file list
        (message "Files marked for copy")                    ; info message
        (dired-number-of-marked-files)                       ; marked files info
        (kill-new "\n")                                      ; start with a newline
        (dolist (marked-file marked-files)                   ; walk the marked files list
          (when (org-file-image-p marked-file)               ; only on image files
            (kill-append                                     ; append image to kill-ring
             (concat "#+CAPTION: "                           ; as caption,
                     (file-name-base marked-file)            ; use file-name-base
                     "\n[[file:" marked-file "]]\n\n") nil))) ; link to marked-file
        (when (= number-marked-files 0)                      ; if none were marked then
          (dired-toggle-marks)))                             ; unmark all
    (message "Error: Does not work outside dired-mode")      ; can't work not in dired-mode
    (ding)))                                                 ; error sound

;; latexpdf
(setq +latex-viewers '(zathura))
(use-package! org-fragtog
:after org
:hook (org-mode . org-fragtog-mode) ; this auto-enables it when you enter an org-buffer, remove if you do not want this
:config
;; whatever you want
)

;; changing html color in org mode
(org-add-link-type
 "color"
 (lambda (path)
   (message (concat "color "
                    (progn (add-text-properties
                            0 (length path)
                            (list 'face `((t (:foreground ,path))))
                            path) path))))
 (lambda (path desc format)
   (cond
    ((eq format 'html)
     (format "<span style=\"color:%s;\">%s</span>" path desc))
    ((eq format 'latex)
     (format "{\\color{%s}%s}" path desc)))))

(defun my/fix-inline-images ()
  (when org-inline-image-overlays
    (org-redisplay-inline-images)))

(add-hook 'org-babel-after-execute-hook 'my/fix-inline-images)

;; langtool configuration
(setq langtool-default-language "en-US")
(setq langtool-java-user-arguments '("-Dfile.encoding=UTF-8"))
(setq langtool-bin "/usr/bin/languagetool")
(setq langtool-java-bin "/usr/bin/java")
(defun langtool-autoshow-detail-popup (overlays)
  (when (require 'popup nil t)
    ;; Do not interrupt current popup
    (unless (or popup-instances
                ;; suppress popup after type `C-g` .
                (memq last-command '(keyboard-quit)))
      (let ((msg (langtool-details-error-message overlays)))
        (popup-tip msg)))))
(setq langtool-autoshow-message-function
      'langtool-autoshow-detail-popup)
;; (global-set-key (kbd "C-c l c") 'languagetool-check)
;; (global-set-key (kbd "C-c l d") 'languagetool-clear-buffer)
;; (global-set-key (kbd "C-c l p") 'languagetool-correct-at-point)
;; (global-set-key (kbd "C-c l b") 'languagetool-correct-buffer)
;; (global-set-key (kbd "C-c l l") 'languagetool-set-language)
;; (global-set-key "\C-x4w" 'langtool-check)
;; (global-set-key "\C-x4W" 'langtool-check-done)
;; (global-set-key "\C-x4l" 'langtool-switch-default-language)
;; (global-set-key "\C-x44" 'langtool-show-message-at-point)
;; (global-set-key "\C-x4c" 'langtool-correct-buffer)

;; (use-package! vlf-setup
  ;; :defer-incrementally vlf-tune vlf-base vlf-write vlf-search vlf-occur vlf-follow vlf-ediff vlf)

(defun org-babel-execute:vhdl (body params)
  "Execute a block of Nim code with org-babel."
  (let ((in-file (org-babel-temp-file "n" ".vhd"))
        (verbosity (or (cdr (assq :verbosity params)) 0)))
    (with-temp-file in-file
      (insert body))
    (org-babel-eval
     (format "ghdl -c %s" verbosity
             (org-babel-process-file-name in-file))
     "")))

;; (setq browse-url-browser-function 'eaf-open-browser)
;; (defalias 'browse-web #'eaf-open-browser)
;; (setq eaf-browser-enable-adblocker "true")
;; (setq eaf-browser-continue-where-left-off t)
;; (setq eaf-browser-default-search-engine "duckduckgo")
;; ;; (setq eaf-browse-blank-page-url "https://duckduckgo.com")
;; (setq eaf-browse-blank-page-url "https://google.com")
;; (setq eaf-browser-default-zoom "3")
;; (require 'eaf-org)
;; (defun eaf-org-open-file (file &optional link)
;; (add-to-list 'org-file-apps '("\.pdf\'" . eaf-org-open-file))
;; (require 'eaf-mermaid)
;; (require 'eaf-video-player)
;; (require 'eaf-markdown-previewer)
;; (require 'eaf-airshare)
;; (require 'eaf-mindmap)
;; (require 'eaf-pdf-viewer)
;; (require 'eaf-file-manager)
;; (require 'eaf-image-viewer)
;; (require 'eaf-vue-demo)
;; (require 'eaf-terminal)
;; (require 'eaf-git)
;; (require 'eaf-org-previewer)
;; (require 'eaf-system-monitor)
;; (require 'eaf-file-browser)
;; (require 'eaf-demo)
;; (require 'eaf-browser)
(with-eval-after-load 'evil
  (evil-set-initial-state 'vterm-mode 'insert))
(use-package pdf-view
  :hook (pdf-tools-enabled . pdf-view-midnight-minor-mode)
  :hook (pdf-tools-enabled . hide-mode-line-mode)
  :config
  (setq pdf-view-midnight-colors '("#ABB2BF" . "#282C35")))
(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
;; for auto-tangle to work add to your org file this header at the top #+auto_tangle: t
  (setq org-auto-tangle-default t)) ;; and don't forget that the org file is tangable by using #+PROPERTY: tangle filename.extension
(setq counsel-dash-docsets-path "/home/syntax/.local/share/Zeal/Zeal/docsets")
(setq counsel-dash-docsets-url "https://raw.github.com/Kapeli/feeds/master")
(setq counsel-dash-min-length 3)
(setq counsel-dash-candidate-format "%d %n (%t)")
(setq counsel-dash-enable-debugging nil)
(setq counsel-dash-browser-func 'browse-url)
(setq counsel-dash-ignored-docsets nil)
(setq counsel-dash-common-docsets '("C++" "LateX" "C" "Arduino" "NumPy" "CMake" "Python_3" "SciPy"))

;; Optionally:
(setq guess-language-languages '(en ar))
(setq guess-language-min-paragraph-length 35)
