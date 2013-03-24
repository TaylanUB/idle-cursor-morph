;;; idle-cursor-morph.el --- Morph cursor when idle.

;; Copyright (C) 2013  Taylan Ulrich B.

;; Author: Taylan Ulrich B. <taylanbayirli@gmail.com>
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Change the cursor-appearance after a certain time of inactivity, so it is
;; easier to find after losing focus from the screen and later coming back.

;;; Code:

(defgroup idle-cursor-morph nil
  "Morph cursor when idle."
  :group 'convenience)

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

(defcustom idle-cursor-non-idle-type cursor-type
  "Type of cursor when not idle."
  :type '(choice (const t)
                 (const nil)
                 (const box)
                 (cons (const bar) number)
                 (const hbar)
                 (cons (const hbar) number))
  :group 'idle-cursor-morph)

(defcustom idle-cursor-blinking (not no-blinking-cursor)
  "Whether the cursor should blink when idle."
  :type 'boolean
  :group 'idle-cursor-morph)

(defcustom idle-cursor-non-idle-blinking (not no-blinking-cursor)
  "Whether the cursor should blink when not idle.")

(defun idle-cursor-morph ()
  "Set the cursor color and type to `idle-cursor-color' and
`idle-cursor-type', respectively."
  (set-cursor-color idle-cursor-color)
  (setq-default cursor-type idle-cursor-type)
  (setq no-blinking-cursor (not idle-cursor-blinking))
  (add-hook 'post-command-hook 'idle-cursor-restore))

(defun idle-cursor-restore ()
  "Restore the cursor color and type to the values they had
before `idle-cursor-morph' changed them."
  (set-cursor-color idle-cursor-non-idle-color)
  (setq-default cursor-type idle-cursor-non-idle-type)
  (setq no-blinking-cursor (not idle-cursor-non-idle-blinking))
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
;;; idle-cursor-morph.el ends here
