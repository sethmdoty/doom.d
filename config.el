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
      doom-big-font (font-spec :family "JetBrains Mono" :size 24)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 13)
      doom-serif-font (font-spec :family "Source Sans Pro" :weight 'light))

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

;;General improvements

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 tab-width 4                                      ; Set width for tabs
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(delete-selection-mode 1)                         ; Replace selection when inserting text
(global-subword-mode 1)                           ; Iterate through CamelCase words

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
;;
;;Python Stuff
(after! lsp-python-ms
  (set-lsp-priority! 'mspyls 1))
(setq org-babel-python-command "python3")

(after! dired
  (setq dired-listing-switches "-aBhl  --group-directories-first"
        dired-dwim-target t
        dired-recursive-copies (quote always)
        dired-recursive-deletes (quote top)))

;; ORG
(setq org-agenda-files (list "~/org/org-files/")
      org-use-property-inheritance t
      org-log-done 'time
      org-list-allow-alphabetical t
      org-export-in-backgroup t
      org-catch-invisible-edits 'smart)
;;Org task keywords
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "IN PROGRESS(I)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))
;; Org clocking config
(setq org-log-done 'time
      org-log-into-drawer t
      org-log-state-notes-insert-after-drawers nil)
;;Org mode tag listing
(setq org-tag-alist '(("@errand" . ?e)
                      ("@office" . ?o)
                      ("@home" . ?h)
                      (:newline)
                      ("CANCELLED" . ?c)))
;;Org Roam Configuration
(use-package! org-roam
  :after org
  :commands (org-roam-insert org-roam-find-file org-roam-switch-to-buffer org-roam)
  :hook
  (after-init . org-roam-mode)
  :init
  (setq org-roam-directory "/Users/sethdoty/org/roam/"
        org-roam-db-location "/Users/sethdoty/org/roam/org-roam.db"
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
     :unnarrowed t))))
;; Org Journal Setup
(use-package! org-journal
  :after org
  :custom
  (org-journal-date-prefix "#+title: ")
  (org-journal-enable-agenda-integration t)
  (org-journal-dir (format "/Users/sethdoty/org/roam/" (format-time-string "%Y")))
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%A, %d %B %Y"))
;; Gotta get that sweet org-chef auto insert
(use-package! org-chef
  :after org
  :commands (org-chef-insert-recipe org-chef-get-recipe-from-url))
;;Org cite

(use-package! org-ref
   :after org
   :config
   (setq org-ref-completion-library 'org-ref-ivy-cite))
;;Org SuperAgenda
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
                                 :order 6)
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
                          (:name "Assignments"
                                 :tag "Assignment"
                                 :order 10)
                          (:name "Issues"
                                 :tag "Issue"
                                 :order 12)
                          (:name "Emacs"
                                 :tag "Emacs"
                                 :order 13)
                          (:name "Projects"
                                 :tag "Project"
                                 :order 14)
                          (:name "Research"
                                 :tag "Research"
                                 :order 15)
                          (:name "To read"
                                 :tag "Read"
                                 :order 30)
                          (:name "Waiting"
                                 :todo "WAITING"
                                 :order 20)
                          (:name "Trivial"
                                 :priority<= "E"
                                 :tag ("Trivial" "Unimportant")
                                 :todo ("SOMEDAY" )
                                 :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

;; Org Capture
(use-package! doct
  :after org
  :commands (doct))

(after! org-capture
  (defun org-capture-select-template-prettier (&optional keys)
    "Select a capture template, in a prettier way than default
  Lisp programs can force the template by setting KEYS to a string."
    (let ((org-capture-templates
           (or (org-contextualize-keys
                (org-capture-upgrade-templates org-capture-templates)
                org-capture-templates-contexts)
               '(("t" "Task" entry (file+headline "" "Tasks")
                  "* TODO %?\n  %u\n  %a")))))
      (if keys
          (or (assoc keys org-capture-templates)
              (error "No capture template referred to by \"%s\" keys" keys))
        (org-mks org-capture-templates
                 "Select a capture template\n━━━━━━━━━━━━━━━━━━━━━━━━━"
                 "Template key: "
                 `(("q" ,(concat (all-the-icons-octicon "stop" :face 'all-the-icons-red :v-adjust 0.01) "\tAbort")))))))
  (advice-add 'org-capture-select-template :override #'org-capture-select-template-prettier)

  (defun org-mks-pretty (table title &optional prompt specials)
    (save-window-excursion
      (let ((inhibit-quit t)
      (buffer (org-switch-to-buffer-other-window "*Org Select*"))
      (prompt (or prompt "Select: "))
      case-fold-search
      current)
        (unwind-protect
      (catch 'exit
        (while t
          (erase-buffer)
          (insert title "\n\n")
          (let ((des-keys nil)
          (allowed-keys '("\C-g"))
          (tab-alternatives '("\s" "\t" "\r"))
          (cursor-type nil))
      ;; Populate allowed keys and descriptions keys
      ;; available with CURRENT selector.
      (let ((re (format "\\`%s\\(.\\)\\'"
            (if current (regexp-quote current) "")))
            (prefix (if current (concat current " ") "")))
        (dolist (entry table)
          (pcase entry
            ;; Description.
            (`(,(and key (pred (string-match re))) ,desc)
             (let ((k (match-string 1 key)))
         (push k des-keys)
         ;; Keys ending in tab, space or RET are equivalent.
         (if (member k tab-alternatives)
             (push "\t" allowed-keys)
           (push k allowed-keys))
         (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) (propertize "›" 'face 'font-lock-comment-face) "  " desc "…" "\n")))
            ;; Usable entry.
            (`(,(and key (pred (string-match re))) ,desc . ,_)
             (let ((k (match-string 1 key)))
         (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) "   " desc "\n")
         (push k allowed-keys)))
            (_ nil))))
      ;; Insert special entries, if any.
      (when specials
        (insert "─────────────────────────\n")
        (pcase-dolist (`(,key ,description) specials)
          (insert (format "%s   %s\n" (propertize key 'face '(bold all-the-icons-red)) description))
          (push key allowed-keys)))
      ;; Display UI and let user select an entry or
      ;; a sub-level prefix.
      (goto-char (point-min))
      (unless (pos-visible-in-window-p (point-max))
        (org-fit-window-to-buffer))
      (let ((pressed (org--mks-read-key allowed-keys prompt)))
        (setq current (concat current pressed))
        (cond
         ((equal pressed "\C-g") (user-error "Abort"))
         ;; Selection is a prefix: open a new menu.
         ((member pressed des-keys))
         ;; Selection matches an association: return it.
         ((let ((entry (assoc current table)))
            (and entry (throw 'exit entry))))
         ;; Selection matches a special entry: return the
         ;; selection prefix.
         ((assoc current specials) (throw 'exit current))
         (t (error "No entry available")))))))
    (when buffer (kill-buffer buffer))))))
  (advice-add 'org-mks :override #'org-mks-pretty)
  (setq +org-capture-recipies  "~/org/org-files/cookbook.org")
  (setq +org-capture-todo-file "~/org/org-files/todo.org")
  (setq +org-capture-central-project-notes-file "~/org/org-files/projects.org")
  (setq +org-capture-central-project-todo-file "~/org/org-files/projects.org")
  (setq +org-capture-links-file "~/org/org-files/links.org")

  (defun +doct-icon-declaration-to-icon (declaration)
    "Convert :icon declaration to icon"
    (let ((name (pop declaration))
          (set  (intern (concat "all-the-icons-" (plist-get declaration :set))))
          (face (intern (concat "all-the-icons-" (plist-get declaration :color))))
          (v-adjust (or (plist-get declaration :v-adjust) 0.01)))
      (apply set `(,name :face ,face :v-adjust ,v-adjust))))

  (defun +doct-iconify-capture-templates (groups)
    "Add declaration's :icon to each template group in GROUPS."
    (let ((templates (doct-flatten-lists-in groups)))
      (setq doct-templates (mapcar (lambda (template)
                                     (when-let* ((props (nthcdr (if (= (length template) 4) 2 5) template))
                                                 (spec (plist-get (plist-get props :doct) :icon)))
                                       (setf (nth 1 template) (concat (+doct-icon-declaration-to-icon spec)
                                                                      "\t"
                                                                      (nth 1 template))))
                                     template)
                                   templates))))

  (setq doct-after-conversion-functions '(+doct-iconify-capture-templates))

  (add-transient-hook! 'org-capture-select-template
    (setq org-capture-templates
          (doct `(("Personal todo" :keys "t"
                   :icon ("checklist" :set "octicon" :color "green")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Inbox"
                   :type entry
                   :template ("* TODO %?"
                              "%i %a")
                   )
                  ("Personal note" :keys "n"
                   :icon ("sticky-note-o" :set "faicon" :color "green")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Inbox"
                   :type entry
                   :template ("* %?"
                              "%i %a")
                   )
                  ("Cliplink" :keys "l"
                   :icon ("sticky-note-o" :set "faicon" :color "blue")
                   :file +org-capture-links-file
                   :prepend t
                   :headline "Links"
                   :type entry
                   :template ("* TODO %(org-cliplink-capture) \n
                              %i %a")
                   )

                  ("Tasks" :keys "k"
                   :icon ("inbox" :set "octicon" :color "yellow")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Tasks"
                   :type entry
                   :template ("* TODO %? %^G%{extra}"
                              "%i %a")
                   :children (("General Task" :keys "k"
                               :icon ("inbox" :set "octicon" :color "yellow")
                               :extra ""
                               )
                              ("Task with deadline" :keys "d"
                               :icon ("timer" :set "material" :color "orange" :v-adjust -0.1)
                               :extra "\nDEADLINE: %^{Deadline:}t"
                               )
                              ("Scheduled Task" :keys "s"
                               :icon ("calendar" :set "octicon" :color "orange")
                               :extra "\nSCHEDULED: %^{Start time:}t"
                               )
                              ))
                  ("Cookbook" :keys "b"
                   :icon ("checklist" :set "octicon" :color "blue")
                   :file +org-capture-recipies
                   :prepend t
                   :type entry
                   :template ("%(org-chef-get-recipe-from-url)")
                   )
                ("Project" :keys "p"
                 :icon ("repo" :set "octicon" :color "silver")
                   :prepend t
                   :type entry
                   :headline "Inbox"
                   :template ("* %{time-or-todo} %?"
                              "%i"
                              "%a")
                   :file ""
                   :custom (:time-or-todo "")
                   :children (("Project-local todo" :keys "t"
                               :icon ("checklist" :set "octicon" :color "green")
                               :time-or-todo "TODO"
                               :file +org-capture-project-todo-file)
                              ("Project-local note" :keys "n"
                               :icon ("sticky-note" :set "faicon" :color "yellow")
                               :time-or-todo "%U"
                               :file +org-capture-project-notes-file))
                   ))))))
