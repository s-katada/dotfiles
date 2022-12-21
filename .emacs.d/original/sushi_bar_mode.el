(make-variable-buffer-local
 (defvar sushi-bar--conveyor-belt ""))

(make-variable-buffer-local
 (defvar sushi-bar--backup-mode-line-format nil))

(defvar sushi-bar--updater-object nil)

(defun sushi-bar--sushi-is-ready-p ()
  (eq (random 15) 1))

(defun sushi-bar--conveyor-update ()
  (unless (window-minibuffer-p)
    (let* ((current-belt (substring-no-properties sushi-bar--conveyor-belt
                                                  1)) ;; Conveyor moved to left
           (padding-right (- (window-width)
                             (length current-belt))))
      (setq current-belt
            (cond ((> padding-right 1)
                   (concat current-belt (make-string (1- padding-right) ? )))
                  ((< padding-right 1)
                   (substring-no-properties current-belt 0 (1- padding-right)))
                  (t current-belt)))

      (setq sushi-bar--conveyor-belt
            (concat current-belt
                    (if (sushi-bar--sushi-is-ready-p) "🍣" " "))))
    (force-mode-line-update)))

(defun sushi-bar--conveyor-in-active-current-buffer-p ()
  (when sushi-bar--updater-object t))

(defun sushi-bar--mode-enable ()
  (unless (sushi-bar--conveyor-in-active-current-buffer-p)
    (setq sushi-bar--conveyor-belt (make-string (window-width) ? ))
    (setq sushi-bar--updater-object (run-at-time t 0.045 'sushi-bar--conveyor-update))

    (setq sushi-bar--backup-mode-line-format mode-line-format)
    (setq mode-line-format '(:eval sushi-bar--conveyor-belt))))

(defun sushi-bar--mode-disable ()
  (when (sushi-bar--conveyor-in-active-current-buffer-p)
    (setq mode-line-format sushi-bar--backup-mode-line-format)
    (cancel-timer sushi-bar--updater-object)

    (setq sushi-bar--updater-object nil)
    (setq sushi-bar--conveyor-belt "")))

(define-minor-mode sushi-bar-mode ()
  :global nil
  (if sushi-bar-mode
      (sushi-bar--mode-enable)
    (sushi-bar--mode-disable)))
