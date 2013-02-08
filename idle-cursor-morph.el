;;; Change cursor appearance when idle.

(defcustom idle-cursor-timeout 20
  "Seconds to wait before morphing the cursor.

After setting this, run `idle-cursor-activate' to apply the new
value."
  :type 'number
  :group 'idle-cursor-morph)

(defcustom idle-cursor-color "red"
  "Color of cursor when idle."
  :type 'string
  :group 'idle-cursor-morph)

(defcustom idle-cursor-non-idle-color "white"
  "Color of cursor when not idle."
  :type 'string
  :group 'idle-cursor-morph)

(defcustom idle-cursor-type 'box
  "Type of cursor when idle."
  :type '(choice (const t)
                 (const nil)
                 (const box)
                 (cons (const bar) number)
                 (const hbar)
                 (cons (const hbar) number))
  :group 'idle-cursor-morph)

(defcustom idle-cursor-non-idle-type 'bar
  "Type of cursor when not idle."
  :type '(choice (const t)
                 (const nil)
                 (const box)
                 (cons (const bar) number)
                 (const hbar)
                 (cons (const hbar) number))
  :group 'idle-cursor-morph)

(defun idle-cursor-morph ()
  "Set the cursor color and type to `idle-cursor-color' and
`idle-cursor-type', respectively."
  (set-cursor-color idle-cursor-color)
  (setq-default cursor-type idle-cursor-type)
  (add-hook 'post-command-hook 'idle-cursor-restore))

(defun idle-cursor-restore ()
  "Restore the cursor color and type to the values they had
before `idle-cursor-morph' changed them."
  (set-cursor-color idle-cursor-non-idle-color)
  (setq-default cursor-type idle-cursor-non-idle-type)
  (remove-hook 'post-command-hook 'idle-cursor-restore))

(defvar idle-cursor-morph-timer nil)

(defun idle-cursor-activate ()
  "Activate the idle-cursor-morphing functionality."
  (interactive)
  (if idle-cursor-morph-timer
      (idle-cursor-deactivate))
  (setq idle-cursor-morph-timer
        (run-with-idle-timer idle-cursor-timeout t 'idle-cursor-morph)))

(defun idle-cursor-deactivate ()
  "De-activate the idle-cursor-morphing functionality."
  (interactive)
  (if idle-cursor-morph-timer
      (cancel-timer idle-cursor-morph-timer)))

(idle-cursor-activate)

(provide 'idle-cursor-morph)
