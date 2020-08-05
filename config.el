;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Seth Doty"
      user-mail-address "sethmdoty@icloud.com")
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
(setq doom-font (font-spec :family "JetBrains Mono" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


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
(after! lsp-python-ms
  (set-lsp-priority! 'mspyls 1))

(after! dired
  (setq dired-listing-switches "-aBhl  --group-directories-first"
        dired-dwim-target t
        dired-recursive-copies (quote always)
        dired-recursive-deletes (quote top)))

;; ORG
(setq org-agenda-files (list "~/org/org-files/"))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))

(setq org-log-done 'time
      org-log-into-drawer t
      org-log-state-notes-insert-after-drawers nil)

(setq org-tag-alist '(("@errand" . ?e)
                      ("@office" . ?o)
                      ("@home" . ?h)
                      (:newline)
                      ("CANCELLED" . ?c)))

(use-package! org-roam
  :commands (org-roam-insert org-roam-find-file org-roam-switch-to-buffer org-roam)
  :hook
  (after-init . org-roam-mode)
  :init
  (setq org-roam-directory "/Users/sethdoty/org/roam/"
        org-roam-db-location "/Users/sethdoty/org/roamorg-roam.db"
        org-roam-db-gc-threshold most-positive-fixnum
        org-roam-graph-exclude-matcher "private"
        org-roam-tag-sources '(prop last-directory)
        org-id-link-to-org-use-id t)
  :config
  (setq org-roam-capture-templates
             '(("d" "default" plain (function org-roam--capture-get-point)
     "\n-tags::\n%?"
     :file-name "%<%Y%m%d%H%M%S>-${slug}"
     :head "#+TITLE: ${title}"
     :unnarrowed t)))
      :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n c" . org-roam-capture)
               ("C-c n g" . org-roam-show-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))))

(use-package! org-journal
  :after org
  :custom
  (org-journal-date-format "%e %b %Y (%A)")
  (org-journal-enable-agenda-integration t)
  (org-journal-dir (format "/Users/sethdoty/org/journal/" (format-time-string "%Y")))
  (org-journal-file-format "%Y%m%d")
  (org-journal-time-format ""))
