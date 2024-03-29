(defun open-link-in-new-window ()
  "Open the file link under the cursor in a new window, ensuring the filename ends with '.md'."
  (interactive)
  (let* ((link-regex "\\[\\[\\(.*?\\)\\]\\]")
         (bounds (bounds-of-thing-at-point 'line))
         (line (buffer-substring-no-properties (car bounds) (cdr bounds)))
         (match (string-match link-regex line)))
    (when match
      (let* ((file-name (match-string 1 line))
             (file-name (if (string-suffix-p ".md" file-name)
                            file-name
                          (concat file-name ".md"))))
        (if (file-exists-p file-name)
            (progn
              (split-window-right) ; or `split-window-below` for horizontal split
              (other-window 1)
              (find-file file-name))
          (message "File does not exist: %s" file-name))))))

(global-set-key (kbd "C-c o") 'open-link-in-new-window)

(require 'evil)
(evil-mode 1)
(direnv-mode)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agena)
(global-set-key (kbd "C-c c") #'org-capture)

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
