(setq org-capture-templates
        '(("h" "Habit" entry (file+olp"~/Google Drive/org/gtd/agenda/habits.org" "Habit Tracker")
           "* TODO %?\nSCHEDULED: <%<%Y-%m-%d %a +1d>>\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: TODO\n:LOGGING: DONE(!)\n:END:")
          ("g" "Get Shit Done" entry (file+headline org-default-notes-file "Inbox")
           "* TODO %? %^g %^{CATEGORY}p")
          ("r" "Resources" entry (file+olp"~/Google Drive/org/gtd/Resources.org" "Resources")
           "* [[%^{URL}][%^{DESCRIPTION}]] %^{CATEGORY}p %^{SUBJECT}p")
          ("e" "Elfeed" entry (file+olp"~/.doom.d/setup/elfeed.org" "Dump")
           "* [[%x]]")
          ("J" "Journal" entry (file+olp+datetree "~/Google Drive/org/gtd/journal.org")
           "** [%<%H:%M>] %? %^g %^{ACCOUNT}p %^{TOPIC}p %^{WHO}p\n:LOGBOOK:\n:END:" :tree-type week :clock-in t :clock-resume t)))