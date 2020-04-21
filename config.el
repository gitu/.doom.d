(after! org (setq org-hide-emphasis-markers nil
                  org-bullets-bullet-list '("◉" "⚫" "○")
                  org-list-demote-modify-bullet '(("+" . "-") ("1." . "a.") ("-" . "+"))
                  org-ellipsis "▼"))

(setq doom-theme 'doom-vibrant)

(setq user-full-name "Florian Schrag"
      user-mail-address "f@schr.ag")
;(display-time-mode 1)
;(setq display-time-day-and-date t)

(load-library "find-lisp")
(defvar my-org-dir "~/org/")
(defvar my-projectile-search-path '("~/org/" "~/Projects/"))
(defvar org-gtd-tasks-file "~/org/workload/tasks.org")
(defvar org-gtd-archive-file "~/org/workload/archive.org")
(defvar org-gtd-files (find-lisp-find-files "~/org/" "\.org$"))
(defvar org-gtd-notes-files (find-lisp-find-files "~/org/notes/" "\.org$"))
(defvar my-task-files '("~/org/workload/tasks.org" "~/org/workload/tickler.org" "~/org/workload/cnfi.org" "~/org/workload/priv.org"))
(defvar my-diary "~/org/diary.org")
(defvar my-deft-directory "~/org/notes/")
(defvar my-elfeed-org-files "~/.elfeed/elfeed.org")
(defvar my-org-export-directory "~/.export/")
(defvar my-org-archive-location "~/org/workload/archive.org::datetree/")
(defvar my-org-default-notes-files "~/org/workload/inbox.org")
(defvar my-org-archive-directory "~/org/archives/")
(setq org-journal-dir my-deft-directory)

(map! :after org
      :map org-mode-map
      :localleader
      :desc "Toggle Narrowing" "!" #'org-toggle-narrow-to-subtree
      :prefix ("R" . "Rifle")
      "b" #'helm-org-rifle-current-buffer
      "a" #'helm-org-rifle-agenda-files
      "o" #'helm-org-rifle-org-directory
      "d" #'helm-org-rifle-directories
      :prefix ("l" . "+links")
      "o" #'org-open-at-point
      :prefix ("g" . "+goto")
      "q" #'orgql-search)

(map! :leader
      :desc "Set Bookmark" "!" #'my/goto-bookmark-location
      :prefix ("s" . "search")
      :desc "Deadgrep Directory" "d" #'deadgrep
      :desc "Swiper All" "@" #'swiper-all
      :prefix ("o" . "open")
      :desc "Elfeed" "e" #'elfeed
      :desc "Deft" "w" #'deft)

(after! org (set-popup-rule! "^Capture.*\\.org$" :side 'right :size .50 :select t :vslot 2 :ttl 3))
(after! org (set-popup-rule! "Dictionary" :side 'bottom :size .30 :select t :vslot 3 :ttl 3))
(after! org (set-popup-rule! "*helm*" :side 'bottom :size .30 :select t :vslot 5 :ttl 3))
(after! org (set-popup-rule! "*eww*" :side 'right :size .30 :slect t :vslot 5 :ttl 3))
(after! org (set-popup-rule! "*deadgrep" :side 'bottom :height .40 :select t :vslot 4 :ttl 3))
(after! org (set-popup-rule! "\\Swiper" :side 'bottom :size .30 :select t :vslot 4 :ttl 3))
(after! org (set-popup-rule! "*Ledger Report*" :side 'right :size .30 :select t :vslot 4 :ttl 3))
(after! org (set-popup-rule! "*xwidget" :side 'right :size .50 :select t :vslot 5 :ttl 3))
(after! org (set-popup-rule! "*Org Agenda*" :side 'right :size .40 :select t :vslot 2 :ttl 3))
(after! org (set-popup-rule! "*Org ql" :side 'right :size .50 :select t :vslot 2 :ttl 3))

(global-auto-revert-mode t)

(setq display-line-numbers-type 'relative)

;(custom-set-faces! '(doom-modeline-evil-insert-state :weight bold :foreground "#339CDB"))

(setq deft-directory my-deft-directory)
(setq deft-current-sort-method 'title)

(after! org (setq org-agenda-files my-task-files))
(after! org (setq org-agenda-diary-file my-diary
                  org-agenda-dim-blocked-tasks t
                  org-agenda-use-time-grid t
                  org-agenda-hide-tags-regexp ":\\w+:"
                  org-agenda-compact-blocks t
                  org-agenda-block-separator nil
;                  org-agenda-prefix-format " %(my-agenda-prefix) "
                  org-agenda-skip-scheduled-if-done t
                  org-agenda-skip-deadline-if-done t
                  org-enforce-todo-checkbox-dependencies nil
                  org-habit-show-habits t))

(load-library "find-lisp")
(after! org (setq org-agenda-files
                  (find-lisp-find-files my-org-dir "\.org$")))

;(after! org (setq org-capture-templates
;                  '(("a" "Append")
;                    ("c" "Captures"))))

(after! org (add-to-list 'org-capture-templates
                         '("h" "Append Headline" entry (file+function org-capture-file-selector org-capture-templates-append-headline)
                           "%(format \"%s\" org-capture-templates-dynamic-opt1)%?")))

(after! org (add-to-list 'org-capture-templates
                         '("l" "Append List" plain (file+function org-capture-file-selector org-capture-templates-append-notes)
                           "%(format \"%s\" org-capture-templates-dynamic-opt2)%?")))

(after! org (add-to-list 'org-capture-templates
             '("t" "Task" entry (file+headline org-gtd-tasks-file "INBOX")
               "* TODO %^{taskname}%? %^{CATEGORY}p
:PROPERTIES:
:CREATED: %U
:END:
")))

(after! org (add-to-list 'org-capture-templates
             '("r" "Reference" entry (file "~/org/workload/references.org")
"* TODO %u %^{reference}%?")))

(defun my/generate-org-note-name ()
  (setq my-org-note--name (read-string "Name: "))
  (expand-file-name (format "%s.org" my-org-note--name) "~/org/notes/"))

(after! org (add-to-list 'org-capture-templates
                         '("n" "New Note" plain (file my/generate-org-note-name)
                           "%(format \"#+TITLE: %s\n\" my-org-note--name)
%?")))

(defun org-capture-file-selector ()
  "test file selector"
  (interactive)
  (setq org-notes-directory my-deft-directory)
  (concat (read-file-name "Select file: " org-notes-directory)))
(after! org (add-to-list 'org-capture-templates
                         '("fnh" "New Headline to Note" entry (file org-capture-file-selector)
                           "* %?")))

(defun org-capture-file-selector ()
  "test file selector"
  (interactive)
  (setq org-notes-directory my-deft-directory)
  (concat (read-file-name "Select file: " org-notes-directory)))
(after! org (add-to-list 'org-capture-templates
                         '("fni" "New Item to Headline" plain (file+function org-capture-file-selector org-capture-headline-finder)
                           "+ %u %?")))

(after! org (add-to-list 'org-capture-templates
             '("fti" "+Task Item" plain (file+function "~/org/workload/tasks.org" org-capture-headline-finder)
"+ %u %?")))

(after! org (add-to-list 'org-capture-templates
             '("ftc" "Child Task" entry (file+function "~/org/workload/tasks.org" org-find-task-headline)
"* TODO %u %^{task}%? %^G")))

(after! org (add-to-list 'org-capture-templates
             '("bt" "Task" entry (file+function buffer-name org-find-task-headline)
"* TODO %u %^{task} %^G
%?")))

(after! org (add-to-list 'org-capture-templates
                         '("d" "Daily Task" plain (file+headline "~/org/workload/tasks.org" "Daily Items")
                           "- [ ] %t %?")))

(after! org (add-to-list 'org-capture-templates
             '("x" "Time Tracker" entry (file+olp+datetree "~/org/workload/timetracking.org")
               "* [%\\1] %\\7 for %\\5
:PROPERTIES:
:CASENUMBER: %^{Case or SVCTAG}
:ACCOUNT:  %^{account}
:AUDIENCE: %^{audience}
:SOURCE:   %^{source|Phone|Email|IM|Computer|Onsite|OOO|Meeting}
:PERSON:   %^{Whose asking for help?}
:TASK:     %^{task}
:DESCRIPTION: %^{description}
:CREATED:  %u
:END:
:LOGBOOK:
:END:
%?" :tree-type week :clock-in t :clock-resume t)))

(after! org (setq org-directory my-org-dir
                  org-image-actual-width nil
                  +org-export-directory my-org-export-directory
                  org-archive-location my-org-archive-location
                  org-default-notes-file my-org-default-notes-files
                  projectile-project-search-path my-projectile-search-path))

(after! org (setq org-html-head-include-scripts t
                  org-export-with-toc t
                  org-export-with-author t
                  org-export-headline-levels 5
                  org-export-with-drawers nil
                  org-export-with-email t
                  org-export-with-footnotes t
                  org-export-with-sub-superscripts nil
                  org-export-with-latex t
                  org-export-with-section-numbers nil
                  org-export-with-properties t
                  org-export-with-smart-quotes t
                  org-export-backends '(pdf ascii html latex odt md pandoc)))

(after! org (setq org-todo-keyword-faces
      '(("TODO" :foreground "OrangeRed" :weight bold)
        ("NEXT" :foreground "SteelBlue" :weight bold)
        ("SOMEDAY" :foreground "gold" :weight bold)
        ("ACTIVE" :foreground "DeepPink" :weight bold)
        ("NEXT" :foreground "spring green" :weight bold)
        ("DONE" :foreground "slategrey" :weight bold :strike-through t))))

(after! org (setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n!)" "SOMEDAY(s!)" "HOLDING(h!)" "DELEGATED(e!)" "|" "DONE(d!)"))))

(after! org (setq org-log-state-notes-insert-after-drawers nil
                  org-log-into-drawer t
                  org-log-done 'time
                  org-log-repeat 'time
                  org-log-redeadline 'note
                  org-log-reschedule 'note))

(setq org-use-property-inheritance t ; We like to inhert properties from their parents
      org-catch-invisible-edits 'smart) ; Catch invisible edits

(after! org (setq org-refile-targets '((org-agenda-files . (:maxlevel . 6)))
                  org-outline-path-complete-in-steps nil
                  org-refile-allow-creating-parent-nodes 'confirm))

(after! org (setq org-startup-indented t
                  org-src-tab-acts-natively t))
;(add-hook 'org-mode-hook (lambda () (org-autolist-mode)))
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'turn-off-auto-fill)

(after! org (setq org-tags-column -80))

(use-package helm-org-rifle
  :after (helm org)
  :preface
  (autoload 'helm-org-rifle-wiki "helm-org-rifle")
  :config
  ;; Define Helm actions to insert a link.
  ;; Note that these actions are effective only in org-mode and its
  ;; derived modes.
  (add-to-list 'helm-org-rifle-actions
               '("Insert link"
                 . helm-org-rifle--insert-link)
               t)
  (add-to-list 'helm-org-rifle-actions
               '("Insert link with custom ID"
                 . helm-org-rifle--insert-link-with-custom-id)
               t)
  (add-to-list 'helm-org-rifle-actions
               '("Store link"
                 . helm-org-rifle--store-link)
               t)
  (add-to-list 'helm-org-rifle-actions
               '("Store link with custom ID"
                 . helm-org-rifle--store-link-with-custom-id)
               t)
  (add-to-list 'helm-org-rifle-actions
               '("Add org-edna dependency on this entry (with ID)"
                 . akirak/helm-org-rifle-add-edna-blocker-with-id)
               t)
  (defun helm-org-rifle--store-link (candidate &optional use-custom-id)
    "Store a link to CANDIDATE."
    (-let (((buffer . pos) candidate))
      (with-current-buffer buffer
        (org-with-wide-buffer
         (goto-char pos)
         (when (and use-custom-id
                    (not (org-entry-get nil "CUSTOM_ID")))
           (org-set-property "CUSTOM_ID"
                             (read-string (format "Set CUSTOM_ID for %s: "
                                                  (substring-no-properties
                                                   (org-format-outline-path
                                                    (org-get-outline-path t nil))))
                                          (helm-org-rifle--make-default-custom-id
                                           (nth 4 (org-heading-components))))))
         (call-interactively 'org-store-link)))))
  (defun helm-org-rifle--store-link-with-custom-id (candidate)
    "Store a link to CANDIDATE with a custom ID.."
    (helm-org-rifle--store-link candidate 'use-custom-id))
  (defun helm-org-rifle--insert-link (candidate &optional use-custom-id)
    "Insert a link to CANDIDATE."
    (unless (derived-mode-p 'org-mode)
      (user-error "Cannot insert a link into a non-org-mode"))
    (let ((orig-marker (point-marker)))
      (helm-org-rifle--store-link candidate use-custom-id)
      (-let (((dest label) (pop org-stored-links)))
        (org-goto-marker-or-bmk orig-marker)
        (org-insert-link nil dest label)
        (message "Inserted a link to %s" dest))))
  (defun helm-org-rifle--make-default-custom-id (title)
    (downcase (replace-regexp-in-string "[[:space:]]" "-" title)))
  (defun helm-org-rifle--insert-link-with-custom-id (candidate)
    "Insert a link to CANDIDATE with a custom ID."
    (helm-org-rifle--insert-link candidate t))
  ;; Based on the definition of helm-org-rifle-files in helm-org-rifle.el
  (helm-org-rifle-define-command
   "wiki" ()
   "Search in \"~/lib/notes/writing\" and `plain-org-wiki-directory' or create a new wiki entry"
   :sources `(,(helm-build-sync-source "Exact wiki entry"
                 :candidates (plain-org-wiki-files)
                 :action #'plain-org-wiki-find-file)
              ,@(--map (helm-org-rifle-get-source-for-file it) files)
              ,(helm-build-dummy-source "Wiki entry"
                 :action #'plain-org-wiki-find-file))
   :let ((files (let ((directories (list "~/lib/notes/writing"
                                         plain-org-wiki-directory
                                         "~/lib/notes")))
                  (-flatten (--map (f-files it
                                            (lambda (file)
                                              (s-matches? helm-org-rifle-directories-filename-regexp
                                                          (f-filename file))))
                                   directories))))
         (helm-candidate-separator " ")
         (helm-cleanup-hook (lambda ()
                              ;; Close new buffers if enabled
                              (when helm-org-rifle-close-unopened-file-buffers
                                (if (= 0 helm-exit-status)
                                    ;; Candidate selected; close other new buffers
                                    (let ((candidate-source (helm-attr 'name (helm-get-current-source))))
                                      (dolist (source helm-sources)
                                        (unless (or (equal (helm-attr 'name source)
                                                           candidate-source)
                                                    (not (helm-attr 'new-buffer source)))
                                          (kill-buffer (helm-attr 'buffer source)))))
                                  ;; No candidates; close all new buffers
                                  (dolist (source helm-sources)
                                    (when (helm-attr 'new-buffer source)
                                      (kill-buffer (helm-attr 'buffer source))))))))))
  :general
  (:keymaps 'org-mode-map
            "M-s r" #'helm-org-rifle-current-buffer)
  :custom
  (helm-org-rifle-directories-recursive nil)
  (helm-org-rifle-show-path t)
  (helm-org-rifle-test-against-path t))

(provide 'setup-helm-org-rifle)

;(after! org-journal
  (setq org-journal-date-prefix "#+TITLE: "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-time-format "<%Y-%m-%d %H:%M> "
        org-journal-date-format "%Y-%m-%d"
        org-journal-dir my-deft-directory
        org-journal-time-prefix "* "
        org-journal-cache-file (concat doom-cache-dir "org-journal")
        org-journal-file-pattern (org-journal-dir-and-format->regex
                                  org-journal-dir org-journal-file-format))
    (add-to-list 'auto-mode-alist (cons org-journal-file-pattern 'org-journal-mode))
;)

(org-super-agenda-mode t)
(setq org-agenda-custom-commands
      '(("k" "Tasks"
         ((agenda ""
                  ((org-agenda-overriding-header "Agenda")
                   (org-agenda-span '1)
                   (org-agenda-start-day (org-today))
                   (org-agenda-files my-task-files)))
          (todo ""
                ((org-agenda-overriding-header "Tasks")
                 (org-agenda-skip-function
                  '(or
                    (and
                     (org-agenda-skip-entry-if 'notregexp "#[A-C]")
                     (org-agenda-skip-entry-if 'notregexp ":@\\w+"))
                    (org-agenda-skip-if nil '(scheduled deadline))
                    (org-agenda-skip-if 'todo '("SOMEDAY"))))
                 (org-agenda-files my-task-files)
                 (org-super-agenda-groups
                  '((:name "Priority Items"
                           :priority>= "B")
                    (:auto-parent t)))))
          (todo ""
                ((org-agenda-overriding-header "Delegated Tasks")
                 (org-agenda-files my-task-files)
                 (org-tags-match-list-sublevels t)
                 (org-agenda-skip-function
                  '(or
                    (org-agenda-skip-subtree-if 'nottodo '("DELEGATED"))))
                 (org-super-agenda-groups
                  '((:auto-property "WHO"))))))
		nil ("~/org/ax/tasks.html" "~/org/ax/tasks.txt"))
        ("n" "Notes"
         ((todo ""
                ((org-agenda-overriding-header "Note Actions")
                 (org-agenda-files '(my-deft-directory))
                 (org-super-agenda-groups
                  '((:auto-category t)))))))
        ("i" "Inbox"
         ((todo ""
                ((org-agenda-overriding-header "Inbox")
                 (org-agenda-skip-function
                  '(or
                    (org-agenda-skip-entry-if 'regexp ":@\\w+")
                    (org-agenda-skip-entry-if 'regexp "\[#[A-E]\]")
                    (org-agenda-skip-if 'nil '(scheduled deadline))
                    (org-agenda-skip-entry-if 'todo '("SOMEDAY"))
                    (org-agenda-skip-entry-if 'todo '("DELEGATED"))))
                 (org-agenda-files my-task-files)
                 (org-super-agenda-groups
                  '((:auto-ts t)))))))
        ("s" "Someday"
         ((todo ""
                ((org-agenda-overriding-header "Someday")
                 (org-agenda-skip-function
                  '(or
                    (org-agenda-skip-entry-if 'nottodo '("SOMEDAY"))))
                 (org-agenda-files my-task-files)
                 (org-super-agenda-groups
                  '((:auto-parent t)))))))))

(defun my-agenda-prefix ()
  (format "%s" (my-agenda-indent-string (org-current-level))))

(defun my-agenda-indent-string (level)
  (if (= level 1)
      ""
    (let ((str ""))
      (while (> level 2)
        (setq level (1- level)
              str (concat str "──")))
      (concat str "►"))))

;;; my-goto.el --- go to things quickly -*- lexical-binding: t; -*-

;; This is free and unencumbered software released into the public domain.

;; Author: Bas Alberts <bas@anti.computer>
;; URL: https://github.com/anticomputer/my-goto.el

;; Version: 0.1
;; Package-Requires: ((emacs "25") (cl-lib "0.5"))

;; Keywords: bookmark

;;; Commentary:

;;; This lets you define custom dispatch bookmarks
;;; You can think of it as a lightweight `bookmark+'

;;; Code:
(require 'bookmark)
(require 'cl-lib)

;; add any custom classes to this list
(defvar my/goto-classes '(:uri :file))

;; define a generic (xristos-fu)
(cl-defgeneric my/goto-dispatch (class goto)
  "Visit GOTO based on CLASS.")

;; specialize the generic for the cases we want to handle
(cl-defmethod my/goto-dispatch ((class (eql :uri)) goto)
  "Visit GOTO based on CLASS."
  (browse-url goto))

(cl-defmethod my/goto-dispatch ((class (eql :file)) goto)
  "Visit GOTO based on CLASS."
  (find-file goto))

;; fall-through method
(cl-defmethod my/goto-dispatch (class goto)
  "Visit GOTO based on CLASS."
  (message "goto: no handler for %s" class))

(defun my/goto-bookmark-handler (bookmark)
  "Handle goto BOOKMARK through goto dispatchers."
  (let* ((v (read (cdr (assq 'filename bookmark))))
         (class (car v))
         (goto (cadr v)))
    (my/goto-dispatch class goto)))

;;;###autoload
(defun my/goto-bookmark-location (class location &optional label)
  "Bookmark LOCATION of CLASS under optional LABEL."
  (interactive
   (let* ((class (read (completing-read "class: " my/goto-classes)))
          (location (if (eq class :file)
                        (read-file-name "location: ")
                      (read-string "location: ")))
          (label (read-string "label: " nil nil location)))
     (list class location label)))
  (unless (equal label "")
    (let ((label (or label location)))
      (bookmark-store
       label
       `((filename . ,(format "%S" `(,class ,location)))
         (handler . my/goto-bookmark-handler))
       nil))))

(provide 'my-goto)
;;; my-goto.el ends here

(defvar org-archive-directory my-org-archive-directory)
(defun org-archive-file ()
  "Moves the current buffer to the archived folder"
  (interactive)
  (let ((old (or (buffer-file-name) (user-error "Not visiting a file")))
        (dir (read-directory-name "Move to: " org-archive-directory)))
    (write-file (expand-file-name (file-name-nondirectory old) dir) t)
    (delete-file old)))
(provide 'org-archive-file)

(defun org-capture-templates-append-headline ()
  "A guided walk-through to capturing"
  (interactive)
  (let ((org-agenda-files (list (buffer-file-name (current-buffer)))))
    (if (null (car org-agenda-files))
        (error "%s is not visiting a faile" (buffer-name (current-buffer)))
      (counsel-org-agenda-headlines)))
  (org-back-to-heading-or-point-min)
  (if (eq (count-lines (point-min) (point-max)) (count-lines (point-min) (point)))
      (newline-and-indent))
  (let ((var1 '("TODO" "Headline"))
        (var2 '("None" "Active" "In-Active")))
    (let ((selection (ivy-completing-read "Choose an option: " option1))
          (date1 (ivy-completing-read "Choose 2nd option: " option2)))
      (setq org-capture-templates-dynamic-opt1 (concat
                                                (or
                                                 (if (equal selection (nth 0 var11))
                                                     (concat "* TODO "))
                                                 (if (equal selection (nth 1 var1))
                                                     (concat "* ")))
                                                (or
                                                 (if (equal date1 (nth 0 var2))
                                                     (concat ""))
                                                 (if (equal date1 (nth 1 var2))
                                                     (concat (format-time-string "<%Y-%m-%d %a>")))
                                                 (if (equal date1 (nth 2 var2))
                                                     (concat (format-time-string "[%Y-%m-%d %a]")))))))))

(defun org-capture-templates-append-notes ()
  "A guided walk-through to capturing"
  (interactive)
  (let ((org-agenda-files (list (buffer-file-name (current-buffer)))))
    (if (null (car org-agenda-files))
        (error "%s is not visiting a faile" (buffer-name (current-buffer)))
      (counsel-org-agenda-headlines)))
  (next-line)
  (org-end-of-subtree)
  (if (eq (count-lines (point-min) (point-max)) (count-lines (point-min) (point)))
      (newline-and-indent))
  (let ((var1 '("Checklist" "List" "None"))
        (var2 '("None" "Inactive" "Active")))
    (let
        ((selection (ivy-completing-read "Choose Line: " var1))
         (date1 (ivy-completing-read "Choose timestamp: " var2)))
      (setq org-capture-templates-dynamic-opt2 (concat
                                                (or
                                                 (if (equal selection (nth 0 var1))
                                                     (concat "- [ ] "))
                                                 (if (equal selection (nth 1 var1))
                                                     (concat "- "))
                                                 (if (equal selection (nth 2 var1))
                                                     (concat "")))
                                                (or
                                                 (if (equal date1 (nth 0 var2))
                                                     (concat ""))
                                                 (if (equal date1 (nth 1 var2))
                                                     (concat (format-time-string "[%Y-%m-%d %a]")))
                                                 (if (equal date1 (nth 2 var2))
                                                     (concat (format-time-string "<%Y-%m-%d %a>")))))))))

(defun org-capture-file-selector ()
  "test file selector"
  (interactive)
  (concat (read-file-name "Select file: " org-directory)))

(defun org-capture-headline-finder (&optional arg)
  "Like `org-todo-list', but using only the current buffer's file."
  (interactive "P")
  (let ((org-agenda-files (list (buffer-file-name (current-buffer)))))
    (if (null (car org-agenda-files))
        (error "%s is not visiting a file" (buffer-name (current-buffer)))
      (counsel-org-agenda-headlines)))
  (goto-char (org-end-of-subtree)))

(defun org-update-cookies-after-save()
  (interactive)
  (let ((current-prefix-arg '(4)))
    (org-update-statistics-cookies "ALL")))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'org-update-cookies-after-save nil 'make-it-local)))
(provide 'org-update-cookies-after-save)

(setq-default truncate-lines t)

(defun jethro/truncate-lines-hook ()
  (setq truncate-lines nil))

(add-hook 'text-mode-hook 'jethro/truncate-lines-hook)
