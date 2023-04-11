;;; codegpt-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "codegpt" "codegpt.el" (0 0 0 0))
;;; Generated autoloads from codegpt.el

(autoload 'codegpt-mode "codegpt" "\
Major mode for `codegpt-mode'.

\\<codegpt-mode-map>

\(fn)" t nil)

(autoload 'codegpt-doc "codegpt" "\
Automatically write documentation for your code.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

\(fn START END)" t nil)

(autoload 'codegpt-fix "codegpt" "\
Fix your code.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

\(fn START END)" t nil)

(autoload 'codegpt-explain "codegpt" "\
Explain the selected code.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

\(fn START END)" t nil)

(autoload 'codegpt-improve "codegpt" "\
Improve, refactor or optimize your code.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

\(fn START END)" t nil)

(autoload 'codegpt-custom "codegpt" "\
Do completion with custom instruction.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

\(fn START END)" t nil)

(autoload 'codegpt "codegpt" "\
Do completion with OpenAI to your code.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

\(fn START END)" t nil)

(register-definition-prefixes "codegpt" '("codeg"))

;;;***

(provide 'codegpt-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; codegpt-autoloads.el ends here
