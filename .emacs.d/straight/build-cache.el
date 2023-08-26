
:tanat

"28.2"

#s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data ("straight" ("2023-08-25 18:12:24" ("emacs") (:type git :host github :repo "radian-software/straight.el" :files ("straight*.el") :branch "master" :package "straight" :local-repo "straight.el")) "org-elpa" ("2023-08-25 18:12:24" nil (:local-repo nil :package "org-elpa" :type git)) "melpa" ("2023-08-25 18:12:24" nil (:type git :host github :repo "melpa/melpa" :build nil :package "melpa" :local-repo "melpa")) "gnu-elpa-mirror" ("2023-08-25 18:12:24" nil (:type git :host github :repo "emacs-straight/gnu-elpa-mirror" :build nil :package "gnu-elpa-mirror" :local-repo "gnu-elpa-mirror")) "nongnu-elpa" ("2023-08-25 18:12:24" nil (:type git :repo "https://git.savannah.gnu.org/git/emacs/nongnu.git" :depth (full single-branch) :local-repo "nongnu-elpa" :build nil :package "nongnu-elpa")) "el-get" ("2023-08-25 18:12:24" nil (:type git :host github :repo "dimitri/el-get" :build nil :files ("*.el" ("recipes" "recipes/el-get.rcp") "methods" "el-get-pkg.el") :flavor melpa :package "el-get" :local-repo "el-get")) "emacsmirror-mirror" ("2023-08-25 18:12:24" nil (:type git :host github :repo "emacs-straight/emacsmirror-mirror" :build nil :package "emacsmirror-mirror" :local-repo "emacsmirror-mirror")) "copilot" ("2023-08-25 18:12:24" ("emacs" "s" "dash" "editorconfig" "jsonrpc") (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el") :package "copilot" :type git :local-repo "copilot.el")) "s" ("2023-08-25 18:12:24" nil (:type git :flavor melpa :host github :repo "magnars/s.el" :package "s" :local-repo "s.el")) "dash" ("2023-08-25 18:12:24" ("emacs") (:type git :flavor melpa :files ("dash.el" "dash.texi" "dash-pkg.el") :host github :repo "magnars/dash.el" :package "dash" :local-repo "dash.el")) "editorconfig" ("2023-08-25 18:12:24" ("emacs" "nadvice") (:type git :flavor melpa :host github :repo "editorconfig/editorconfig-emacs" :package "editorconfig" :local-repo "editorconfig-emacs")) "jsonrpc" ("2023-08-25 18:12:24" ("emacs") (:type git :host github :repo "emacs-straight/jsonrpc" :files ("*" (:exclude ".git")) :package "jsonrpc" :local-repo "jsonrpc")) "openai" ("2023-08-25 18:12:25" ("emacs" "request" "tblui") (:host github :repo "emacs-openai/openai" :package "openai" :type git :local-repo "openai")) "request" ("2023-08-25 18:12:25" ("emacs") (:type git :flavor melpa :files ("request.el" "request-pkg.el") :host github :repo "tkf/emacs-request" :package "request" :local-repo "emacs-request")) "tblui" ("2023-08-25 18:12:25" ("dash" "magit-popup" "tablist" "cl-lib") (:type git :flavor melpa :host github :repo "Yuki-Inoue/tblui.el" :package "tblui" :local-repo "tblui.el")) "magit-popup" ("2023-08-25 18:12:25" ("emacs" "dash") (:type git :flavor melpa :host github :repo "magit/magit-popup" :package "magit-popup" :local-repo "magit-popup")) "tablist" ("2023-08-25 18:12:25" ("emacs") (:type git :flavor melpa :host github :repo "emacsorphanage/tablist" :package "tablist" :local-repo "tablist")) "chatgpt" ("2023-08-25 18:12:25" ("emacs" "openai" "lv" "ht" "markdown-mode" "spinner") (:host github :repo "emacs-openai/chatgpt" :package "chatgpt" :type git :local-repo "chatgpt")) "lv" ("2023-08-25 18:12:25" nil (:type git :flavor melpa :files ("lv.el" "lv-pkg.el") :host github :repo "abo-abo/hydra" :package "lv" :local-repo "hydra")) "ht" ("2023-08-25 18:12:25" ("dash") (:type git :flavor melpa :host github :repo "Wilfred/ht.el" :package "ht" :local-repo "ht.el")) "markdown-mode" ("2023-08-25 18:12:25" ("emacs") (:type git :flavor melpa :host github :repo "jrblevin/markdown-mode" :package "markdown-mode" :local-repo "markdown-mode")) "spinner" ("2023-08-25 18:12:25" ("emacs") (:type git :host github :repo "emacs-straight/spinner" :files ("*" (:exclude ".git")) :package "spinner" :local-repo "spinner")) "codegpt" ("2023-08-25 18:12:25" ("emacs" "openai" "markdown-mode" "spinner") (:host github :repo "emacs-openai/codegpt" :package "codegpt" :type git :local-repo "codegpt")) "dall-e" ("2023-08-25 18:12:25" ("emacs" "openai" "lv" "ht" "spinner" "reveal-in-folder" "async") (:host github :repo "emacs-openai/dall-e" :package "dall-e" :type git :local-repo "dall-e")) "reveal-in-folder" ("2023-08-25 18:12:25" ("emacs" "f" "s") (:type git :flavor melpa :host github :repo "jcs-elpa/reveal-in-folder" :package "reveal-in-folder" :local-repo "reveal-in-folder")) "f" ("2023-08-25 18:12:25" ("emacs" "s" "dash") (:type git :flavor melpa :host github :repo "rejeep/f.el" :package "f" :local-repo "f.el")) "async" ("2023-08-25 18:12:25" ("emacs") (:type git :flavor melpa :host github :repo "jwiegley/emacs-async" :package "async" :local-repo "emacs-async"))))

#s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data ("straight" ((straight-x straight-autoloads straight straight-ert-print-hack) (autoload 'straight-remove-unused-repos "straight" "Remove unused repositories from the repos and build directories.
A repo is considered \"unused\" if it was not explicitly requested via
`straight-use-package' during the current Emacs session.
If FORCE is non-nil do not prompt before deleting repos.

(fn &optional FORCE)" t nil) (autoload 'straight-get-recipe "straight" "Interactively select a recipe from one of the recipe repositories.
All recipe repositories in `straight-recipe-repositories' will
first be cloned. After the recipe is selected, it will be copied
to the kill ring. With a prefix argument, first prompt for a
recipe repository to search. Only that repository will be
cloned.

From Lisp code, SOURCES should be a subset of the symbols in
`straight-recipe-repositories'. Only those recipe repositories
are cloned and searched. If it is nil or omitted, then the value
of `straight-recipe-repositories' is used. If SOURCES is the
symbol `interactive', then the user is prompted to select a
recipe repository, and a list containing that recipe repository
is used for the value of SOURCES. ACTION may be `copy' (copy
recipe to the kill ring), `insert' (insert at point), or nil (no
action, just return it).

Optional arg FILTER must be a unary function.
It takes a package name as its sole argument.
If it returns nil the candidate is excluded.

(fn &optional SOURCES ACTION FILTER)" t nil) (autoload 'straight-visit-package-website "straight" "Visit the package RECIPE's website.

(fn RECIPE)" t nil) (autoload 'straight-visit-package "straight" "Open PACKAGE's local repository directory.
When BUILD is non-nil visit PACKAGE's build directory.

(fn PACKAGE &optional BUILD)" t nil) (autoload 'straight-use-package "straight" "Register, clone, build, and activate a package and its dependencies.
This is the main entry point to the functionality of straight.el.

MELPA-STYLE-RECIPE is either a symbol naming a package, or a list
whose car is a symbol naming a package and whose cdr is a
property list containing e.g. `:type', `:local-repo', `:files',
and VC backend specific keywords.

First, the package recipe is registered with straight.el. If
NO-CLONE is a function, then it is called with two arguments: the
package name as a string, and a boolean value indicating whether
the local repository for the package is available. In that case,
the return value of the function is used as the value of NO-CLONE
instead. In any case, if NO-CLONE is non-nil, then processing
stops here.

Otherwise, the repository is cloned, if it is missing. If
NO-BUILD is a function, then it is called with one argument: the
package name as a string. In that case, the return value of the
function is used as the value of NO-BUILD instead. In any case,
if NO-BUILD is non-nil, then processing halts here. Otherwise,
the package is built and activated. Note that if the package
recipe has a nil `:build' entry, then NO-BUILD is ignored
and processing always stops before building and activation
occurs.

CAUSE is a string explaining the reason why
`straight-use-package' has been called. It is for internal use
only, and is used to construct progress messages. INTERACTIVE is
non-nil if the function has been called interactively. It is for
internal use only, and is used to determine whether to show a
hint about how to install the package permanently.

Return non-nil when package is initially installed, nil otherwise.

(fn MELPA-STYLE-RECIPE &optional NO-CLONE NO-BUILD CAUSE INTERACTIVE)" t nil) (autoload 'straight-register-package "straight" "Register a package without cloning, building, or activating it.
This function is equivalent to calling `straight-use-package'
with a non-nil argument for NO-CLONE. It is provided for
convenience. MELPA-STYLE-RECIPE is as for
`straight-use-package'.

(fn MELPA-STYLE-RECIPE)" nil nil) (autoload 'straight-use-package-no-build "straight" "Register and clone a package without building it.
This function is equivalent to calling `straight-use-package'
with nil for NO-CLONE but a non-nil argument for NO-BUILD. It is
provided for convenience. MELPA-STYLE-RECIPE is as for
`straight-use-package'.

(fn MELPA-STYLE-RECIPE)" nil nil) (autoload 'straight-use-package-lazy "straight" "Register, build, and activate a package if it is already cloned.
This function is equivalent to calling `straight-use-package'
with symbol `lazy' for NO-CLONE. It is provided for convenience.
MELPA-STYLE-RECIPE is as for `straight-use-package'.

(fn MELPA-STYLE-RECIPE)" nil nil) (autoload 'straight-use-recipes "straight" "Register a recipe repository using MELPA-STYLE-RECIPE.
This registers the recipe and builds it if it is already cloned.
Note that you probably want the recipe for a recipe repository to
include a nil `:build' property, to unconditionally
inhibit the build phase.

This function also adds the recipe repository to
`straight-recipe-repositories', at the end of the list.

(fn MELPA-STYLE-RECIPE)" nil nil) (autoload 'straight-override-recipe "straight" "Register MELPA-STYLE-RECIPE as a recipe override.
This puts it in `straight-recipe-overrides', depending on the
value of `straight-current-profile'.

(fn MELPA-STYLE-RECIPE)" nil nil) (autoload 'straight-check-package "straight" "Rebuild a PACKAGE if it has been modified.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. See also `straight-rebuild-package' and
`straight-check-all'.

(fn PACKAGE)" t nil) (autoload 'straight-check-all "straight" "Rebuild any packages that have been modified.
See also `straight-rebuild-all' and `straight-check-package'.
This function should not be called during init." t nil) (autoload 'straight-rebuild-package "straight" "Rebuild a PACKAGE.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument RECURSIVE, rebuild
all dependencies as well. See also `straight-check-package' and
`straight-rebuild-all'.

(fn PACKAGE &optional RECURSIVE)" t nil) (autoload 'straight-rebuild-all "straight" "Rebuild all packages.
See also `straight-check-all' and `straight-rebuild-package'." t nil) (autoload 'straight-prune-build-cache "straight" "Prune the build cache.
This means that only packages that were built in the last init
run and subsequent interactive session will remain; other
packages will have their build mtime information and any cached
autoloads discarded." nil nil) (autoload 'straight-prune-build-directory "straight" "Prune the build directory.
This means that only packages that were built in the last init
run and subsequent interactive session will remain; other
packages will have their build directories deleted." nil nil) (autoload 'straight-prune-build "straight" "Prune the build cache and build directory.
This means that only packages that were built in the last init
run and subsequent interactive session will remain; other
packages will have their build mtime information discarded and
their build directories deleted." t nil) (autoload 'straight-normalize-package "straight" "Normalize a PACKAGE's local repository to its recipe's configuration.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'.

(fn PACKAGE)" t nil) (autoload 'straight-normalize-all "straight" "Normalize all packages. See `straight-normalize-package'.
Return a list of recipes for packages that were not successfully
normalized. If multiple packages come from the same local
repository, only one is normalized.

PREDICATE, if provided, filters the packages that are normalized.
It is called with the package name as a string, and should return
non-nil if the package should actually be normalized.

(fn &optional PREDICATE)" t nil) (autoload 'straight-fetch-package "straight" "Try to fetch a PACKAGE from the primary remote.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM,
fetch not just from primary remote but also from upstream (for
forked packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-fetch-package-and-deps "straight" "Try to fetch a PACKAGE and its (transitive) dependencies.
PACKAGE, its dependencies, their dependencies, etc. are fetched
from their primary remotes.

PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM,
fetch not just from primary remote but also from upstream (for
forked packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-fetch-all "straight" "Try to fetch all packages from their primary remotes.
With prefix argument FROM-UPSTREAM, fetch not just from primary
remotes but also from upstreams (for forked packages).

Return a list of recipes for packages that were not successfully
fetched. If multiple packages come from the same local
repository, only one is fetched.

PREDICATE, if provided, filters the packages that are fetched. It
is called with the package name as a string, and should return
non-nil if the package should actually be fetched.

(fn &optional FROM-UPSTREAM PREDICATE)" t nil) (autoload 'straight-merge-package "straight" "Try to merge a PACKAGE from the primary remote.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM,
merge not just from primary remote but also from upstream (for
forked packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-merge-package-and-deps "straight" "Try to merge a PACKAGE and its (transitive) dependencies.
PACKAGE, its dependencies, their dependencies, etc. are merged
from their primary remotes.

PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM,
merge not just from primary remote but also from upstream (for
forked packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-merge-all "straight" "Try to merge all packages from their primary remotes.
With prefix argument FROM-UPSTREAM, merge not just from primary
remotes but also from upstreams (for forked packages).

Return a list of recipes for packages that were not successfully
merged. If multiple packages come from the same local
repository, only one is merged.

PREDICATE, if provided, filters the packages that are merged. It
is called with the package name as a string, and should return
non-nil if the package should actually be merged.

(fn &optional FROM-UPSTREAM PREDICATE)" t nil) (autoload 'straight-pull-package "straight" "Try to pull a PACKAGE from the primary remote.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM, pull
not just from primary remote but also from upstream (for forked
packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-pull-package-and-deps "straight" "Try to pull a PACKAGE and its (transitive) dependencies.
PACKAGE, its dependencies, their dependencies, etc. are pulled
from their primary remotes.

PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'. With prefix argument FROM-UPSTREAM,
pull not just from primary remote but also from upstream (for
forked packages).

(fn PACKAGE &optional FROM-UPSTREAM)" t nil) (autoload 'straight-pull-all "straight" "Try to pull all packages from their primary remotes.
With prefix argument FROM-UPSTREAM, pull not just from primary
remotes but also from upstreams (for forked packages).

Return a list of recipes for packages that were not successfully
pulled. If multiple packages come from the same local repository,
only one is pulled.

PREDICATE, if provided, filters the packages that are pulled. It
is called with the package name as a string, and should return
non-nil if the package should actually be pulled.

(fn &optional FROM-UPSTREAM PREDICATE)" t nil) (autoload 'straight-push-package "straight" "Push a PACKAGE to its primary remote, if necessary.
PACKAGE is a string naming a package. Interactively, select
PACKAGE from the known packages in the current Emacs session
using `completing-read'.

(fn PACKAGE)" t nil) (autoload 'straight-push-all "straight" "Try to push all packages to their primary remotes.

Return a list of recipes for packages that were not successfully
pushed. If multiple packages come from the same local repository,
only one is pushed.

PREDICATE, if provided, filters the packages that are normalized.
It is called with the package name as a string, and should return
non-nil if the package should actually be normalized.

(fn &optional PREDICATE)" t nil) (autoload 'straight-freeze-versions "straight" "Write version lockfiles for currently activated packages.
This implies first pushing all packages that have unpushed local
changes. If the package management system has been used since the
last time the init-file was reloaded, offer to fix the situation
by reloading the init-file again. If FORCE is
non-nil (interactively, if a prefix argument is provided), skip
all checks and write the lockfile anyway.

Currently, writing version lockfiles requires cloning all lazily
installed packages. Hopefully, this inconvenient requirement will
be removed in the future.

Multiple lockfiles may be written (one for each profile),
according to the value of `straight-profiles'.

(fn &optional FORCE)" t nil) (autoload 'straight-thaw-versions "straight" "Read version lockfiles and restore package versions to those listed." t nil) (autoload 'straight-bug-report "straight" "Test straight.el in a clean environment.
ARGS may be any of the following keywords and their respective values:
  - :pre-bootstrap (Form)...
      Forms evaluated before bootstrapping straight.el
      e.g. (setq straight-repository-branch \"develop\")
      Note this example is already in the default bootstrapping code.

  - :post-bootstrap (Form)...
      Forms evaluated in the testing environment after boostrapping.
      e.g. (straight-use-package \\='(example :type git :host github))

  - :interactive Boolean
      If nil, the subprocess will immediately exit after the test.
      Output will be printed to `straight-bug-report--process-buffer'
      Otherwise, the subprocess will be interactive.

  - :preserve Boolean
      If non-nil, the test directory is left in the directory stored in the
      variable `temporary-file-directory'. Otherwise, it is
      immediately removed after the test is run.

  - :executable String
      Indicate the Emacs executable to launch.
      Defaults to the path of the current Emacs executable.

  - :raw Boolean
      If non-nil, the raw process output is sent to
      `straight-bug-report--process-buffer'. Otherwise, it is
      formatted as markdown for submitting as an issue.

  - :user-dir String
      If non-nil, the test is run with `user-emacs-directory' set to STRING.
      Otherwise, a temporary directory is created and used.
      Unless absolute, paths are expanded relative to the variable
      `temporary-file-directory'.

ARGS are accessible within the :pre/:post-bootsrap phases via the
locally bound plist, straight-bug-report-args.

(fn &rest ARGS)" nil t) (function-put 'straight-bug-report 'lisp-indent-function '0) (autoload 'straight-dependencies "straight" "Return a list of PACKAGE's dependencies.

(fn &optional PACKAGE)" t nil) (autoload 'straight-dependents "straight" "Return a list PACKAGE's dependents.

(fn &optional PACKAGE)" t nil) (register-definition-prefixes "straight" '("straight-")) (register-definition-prefixes "straight-ert-print-hack" '("+without-print-limits")) (defvar straight-x-pinned-packages nil "List of pinned packages.") (register-definition-prefixes "straight-x" '("straight-x-")) (provide 'straight-autoloads)) "s" ((s s-autoloads) (register-definition-prefixes "s" '("s-")) (provide 's-autoloads)) "dash" ((dash dash-autoloads) (autoload 'dash-fontify-mode "dash" "Toggle fontification of Dash special variables.

This is a minor mode.  If called interactively, toggle the
`Dash-Fontify mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `dash-fontify-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

Dash-Fontify mode is a buffer-local minor mode intended for Emacs
Lisp buffers.  Enabling it causes the special variables bound in
anaphoric Dash macros to be fontified.  These anaphoras include
`it', `it-index', `acc', and `other'.  In older Emacs versions
which do not dynamically detect macros, Dash-Fontify mode
additionally fontifies Dash macro calls.

See also `dash-fontify-mode-lighter' and
`global-dash-fontify-mode'.

(fn &optional ARG)" t nil) (put 'global-dash-fontify-mode 'globalized-minor-mode t) (defvar global-dash-fontify-mode nil "Non-nil if Global Dash-Fontify mode is enabled.
See the `global-dash-fontify-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-dash-fontify-mode'.") (custom-autoload 'global-dash-fontify-mode "dash" nil) (autoload 'global-dash-fontify-mode "dash" "Toggle Dash-Fontify mode in all buffers.
With prefix ARG, enable Global Dash-Fontify mode if ARG is positive;
otherwise, disable it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Dash-Fontify mode is enabled in all buffers where
`dash--turn-on-fontify-mode' would do it.

See `dash-fontify-mode' for more information on Dash-Fontify mode.

(fn &optional ARG)" t nil) (autoload 'dash-register-info-lookup "dash" "Register the Dash Info manual with `info-lookup-symbol'.
This allows Dash symbols to be looked up with \\[info-lookup-symbol]." t nil) (register-definition-prefixes "dash" '("!cdr" "!cons" "--" "->" "-a" "-butlast" "-c" "-d" "-e" "-f" "-gr" "-i" "-juxt" "-keep" "-l" "-m" "-no" "-o" "-p" "-r" "-s" "-t" "-u" "-value-to-list" "-when-let" "-zip" "dash-")) (provide 'dash-autoloads)) "editorconfig" ((editorconfig-conf-mode editorconfig-autoloads editorconfig editorconfig-core editorconfig-core-handle editorconfig-fnmatch) (autoload 'editorconfig-apply "editorconfig" "Get and apply EditorConfig properties to current buffer.

This function does not respect the values of `editorconfig-exclude-modes' and
`editorconfig-exclude-regexps' and always applies available properties.
Use `editorconfig-mode-apply' instead to make use of these variables." t nil) (defvar editorconfig-mode nil "Non-nil if Editorconfig mode is enabled.
See the `editorconfig-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `editorconfig-mode'.") (custom-autoload 'editorconfig-mode "editorconfig" nil) (autoload 'editorconfig-mode "editorconfig" "Toggle EditorConfig feature.

This is a minor mode.  If called interactively, toggle the
`Editorconfig mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='editorconfig-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

To disable EditorConfig in some buffers, modify
`editorconfig-exclude-modes' or `editorconfig-exclude-regexps'.

(fn &optional ARG)" t nil) (autoload 'editorconfig-find-current-editorconfig "editorconfig" "Find the closest .editorconfig file for current file." t nil) (autoload 'editorconfig-display-current-properties "editorconfig" "Display EditorConfig properties extracted for current buffer." t nil) (defalias 'describe-editorconfig-properties 'editorconfig-display-current-properties) (autoload 'editorconfig-format-buffer "editorconfig" "Format buffer according to .editorconfig indent_style and indent_width." t nil) (autoload 'editorconfig-version "editorconfig" "Get EditorConfig version as string.

If called interactively or if SHOW-VERSION is non-nil, show the
version in the echo area and the messages buffer.

(fn &optional SHOW-VERSION)" t nil) (register-definition-prefixes "editorconfig" '("editorconfig-")) (autoload 'editorconfig-conf-mode "editorconfig-conf-mode" "Major mode for editing .editorconfig files.

(fn)" t nil) (add-to-list 'auto-mode-alist '("\\.editorconfig\\'" . editorconfig-conf-mode)) (register-definition-prefixes "editorconfig-conf-mode" '("editorconfig-conf-mode-")) (autoload 'editorconfig-core-get-nearest-editorconfig "editorconfig-core" "Return path to .editorconfig file that is closest to DIRECTORY.

(fn DIRECTORY)" nil nil) (autoload 'editorconfig-core-get-properties "editorconfig-core" "Get EditorConfig properties for FILE.
If FILE is not given, use currently visiting file.
Give CONFNAME for basename of config file other than .editorconfig.
If need to specify config format version, give CONFVERSION.

This function returns an alist of properties.  Each element will
look like (KEY . VALUE).

(fn &optional FILE CONFNAME CONFVERSION)" nil nil) (autoload 'editorconfig-core-get-properties-hash "editorconfig-core" "Get EditorConfig properties for FILE.
If FILE is not given, use currently visiting file.
Give CONFNAME for basename of config file other than .editorconfig.
If need to specify config format version, give CONFVERSION.

This function is almost same as `editorconfig-core-get-properties', but returns
hash object instead.

(fn &optional FILE CONFNAME CONFVERSION)" nil nil) (register-definition-prefixes "editorconfig-core" '("editorconfig-core--")) (register-definition-prefixes "editorconfig-core-handle" '("editorconfig-core-handle")) (autoload 'editorconfig-fnmatch-p "editorconfig-fnmatch" "Test whether STRING match PATTERN.

Matching ignores case if `case-fold-search' is non-nil.

PATTERN should be a shell glob pattern, and some zsh-like wildcard matchings can
be used:

*           Matches any string of characters, except path separators (/)
**          Matches any string of characters
?           Matches any single character
[name]      Matches any single character in name
[^name]     Matches any single character not in name
{s1,s2,s3}  Matches any of the strings given (separated by commas)
{min..max}  Matches any number between min and max

(fn STRING PATTERN)" nil nil) (register-definition-prefixes "editorconfig-fnmatch" '("editorconfig-fnmatch-")) (provide 'editorconfig-autoloads)) "jsonrpc" ((jsonrpc jsonrpc-autoloads) (register-definition-prefixes "jsonrpc" '("jsonrpc-")) (provide 'jsonrpc-autoloads)) "copilot" ((copilot-autoloads copilot) (autoload 'copilot-complete "copilot" "Complete at the current point." t nil) (autoload 'copilot-mode "copilot" "Minor mode for Copilot.

This is a minor mode.  If called interactively, toggle the
`Copilot mode' mode.  If the prefix argument is positive, enable
the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `copilot-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t nil) (put 'global-copilot-mode 'globalized-minor-mode t) (defvar global-copilot-mode nil "Non-nil if Global Copilot mode is enabled.
See the `global-copilot-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-copilot-mode'.") (custom-autoload 'global-copilot-mode "copilot" nil) (autoload 'global-copilot-mode "copilot" "Toggle Copilot mode in all buffers.
With prefix ARG, enable Global Copilot mode if ARG is positive;
otherwise, disable it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Copilot mode is enabled in all buffers where `copilot-mode' would do
it.

See `copilot-mode' for more information on Copilot mode.

(fn &optional ARG)" t nil) (register-definition-prefixes "copilot" '("copilot-")) (provide 'copilot-autoloads)) "request" ((request-autoloads request) (autoload 'request-response-header "request" "Fetch the values of RESPONSE header field named FIELD-NAME.

It returns comma separated values when the header has multiple
field with the same name, as :RFC:`2616` specifies.

Examples::

  (request-response-header response
                           \"content-type\") ; => \"text/html; charset=utf-8\"
  (request-response-header response
                           \"unknown-field\") ; => nil

(fn RESPONSE FIELD-NAME)" nil nil) (autoload 'request-response-headers "request" "Return RESPONSE headers as an alist.
I would have chosen a function name that wasn't so suggestive that
`headers` is a member of the `request-response` struct, but
as there's already precedent with `request-response-header', I
hew to consistency.

(fn RESPONSE)" nil nil) (autoload 'request "request" "Main entry requesting URL with property list SETTINGS as follow.

==================== ========================================================
Keyword argument      Explanation
==================== ========================================================
TYPE          (string)   type of request to make: POST/GET/PUT/DELETE
PARAMS         (alist)   set \"?key=val\" part in URL
DATA    (string/alist)   data to be sent to the server
FILES          (alist)   files to be sent to the server (see below)
PARSER        (symbol)   a function that reads current buffer and return data
HEADERS        (alist)   additional headers to send with the request
ENCODING      (symbol)   encoding for request body (utf-8 by default)
SUCCESS     (function)   called on success
ERROR       (function)   called on error
COMPLETE    (function)   called on both success and error
TIMEOUT       (number)   timeout in second
STATUS-CODE    (alist)   map status code (int) to callback
SYNC            (bool)   If non-nil, wait until request is done. Default is nil.
==================== ========================================================


* Callback functions

Callback functions STATUS, ERROR, COMPLETE and `cdr\\='s in element of
the alist STATUS-CODE take same keyword arguments listed below.  For
forward compatibility, these functions must ignore unused keyword
arguments (i.e., it\\='s better to use `&allow-other-keys\\=' [#]_).::

    (CALLBACK                      ; SUCCESS/ERROR/COMPLETE/STATUS-CODE
     :data          data           ; whatever PARSER function returns, or nil
     :error-thrown  error-thrown   ; (ERROR-SYMBOL . DATA), or nil
     :symbol-status symbol-status  ; success/error/timeout/abort/parse-error
     :response      response       ; request-response object
     ...)

.. [#] `&allow-other-keys\\=' is a special \"markers\" available in macros
   in the CL library for function definition such as `cl-defun\\=' and
   `cl-function\\='.  Without this marker, you need to specify all arguments
   to be passed.  This becomes problem when request.el adds new arguments
   when calling callback functions.  If you use `&allow-other-keys\\='
   (or manually ignore other arguments), your code is free from this
   problem.  See info node `(cl) Argument Lists\\=' for more information.

Arguments data, error-thrown, symbol-status can be accessed by
`request-response-data\\=', `request-response-error-thrown\\=',
`request-response-symbol-status\\=' accessors, i.e.::

    (request-response-data RESPONSE)  ; same as data

Response object holds other information which can be accessed by
the following accessors:
`request-response-status-code\\=',
`request-response-url\\=' and
`request-response-settings\\='

* STATUS-CODE callback

STATUS-CODE is an alist of the following format::

    ((N-1 . CALLBACK-1)
     (N-2 . CALLBACK-2)
     ...)

Here, N-1, N-2,... are integer status codes such as 200.


* FILES

FILES is an alist of the following format::

    ((NAME-1 . FILE-1)
     (NAME-2 . FILE-2)
     ...)

where FILE-N is a list of the form::

    (FILENAME &key PATH BUFFER STRING MIME-TYPE)

FILE-N can also be a string (path to the file) or a buffer object.
In that case, FILENAME is set to the file name or buffer name.

Example FILES argument::

    `((\"passwd\"   . \"/etc/passwd\")                ; filename = passwd
      (\"scratch\"  . ,(get-buffer \"*scratch*\"))    ; filename = *scratch*
      (\"passwd2\"  . (\"password.txt\" :file \"/etc/passwd\"))
      (\"scratch2\" . (\"scratch.txt\"  :buffer ,(get-buffer \"*scratch*\")))
      (\"data\"     . (\"data.csv\"     :data \"1,2,3\\n4,5,6\\n\")))

.. note:: FILES is implemented only for curl backend for now.
   As furl.el_ supports multipart POST, it should be possible to
   support FILES in pure elisp by making furl.el_ another backend.
   Contributions are welcome.

   .. _furl.el: https://code.google.com/p/furl-el/


* PARSER function

PARSER function takes no argument and it is executed in the
buffer with HTTP response body.  The current position in the HTTP
response buffer is at the beginning of the buffer.  As the HTTP
header is stripped off, the cursor is actually at the beginning
of the response body.  So, for example, you can pass `json-read\\='
to parse JSON object in the buffer.  To fetch whole response as a
string, pass `buffer-string\\='.

When using `json-read\\=', it is useful to know that the returned
type can be modified by `json-object-type\\=', `json-array-type\\=',
`json-key-type\\=', `json-false\\=' and `json-null\\='.  See docstring of
each function for what it does.  For example, to convert JSON
objects to plist instead of alist, wrap `json-read\\=' by `lambda\\='
like this.::

    (request
     \"https://...\"
     :parser (lambda ()
               (let ((json-object-type \\='plist))
                 (json-read)))
     ...)

This is analogous to the `dataType\\=' argument of jQuery.ajax_.
Only this function can access to the process buffer, which
is killed immediately after the execution of this function.

* SYNC

Synchronous request is functional, but *please* don\\='t use it
other than testing or debugging.  Emacs users have better things
to do rather than waiting for HTTP request.  If you want a better
way to write callback chains, use `request-deferred\\='.

If you can\\='t avoid using it (e.g., you are inside of some hook
which must return some value), make sure to set TIMEOUT to
relatively small value.

Due to limitation of `url-retrieve-synchronously\\=', response slots
`request-response-error-thrown\\=', `request-response-history\\=' and
`request-response-url\\=' are unknown (always nil) when using
synchronous request with `url-retrieve\\=' backend.

* Note

API of `request\\=' is somewhat mixture of jQuery.ajax_ (Javascript)
and requests.request_ (Python).

.. _jQuery.ajax: https://api.jquery.com/jQuery.ajax/
.. _requests.request: https://docs.python-requests.org

(fn URL &rest SETTINGS &key (PARAMS nil) (DATA nil) (HEADERS nil) (ENCODING \\='utf-8) (ERROR nil) (SYNC nil) (RESPONSE (make-request-response)) &allow-other-keys)" nil nil) (function-put 'request 'lisp-indent-function 'defun) (autoload 'request-untrampify-filename "request" "Return FILE as the local file name.

(fn FILE)" nil nil) (autoload 'request-abort "request" "Abort request for RESPONSE (the object returned by `request').
Note that this function invoke ERROR and COMPLETE callbacks.
Callbacks may not be called immediately but called later when
associated process is exited.

(fn RESPONSE)" nil nil) (register-definition-prefixes "request" '("request-")) (provide 'request-autoloads)) "magit-popup" ((magit-popup-autoloads magit-popup) (register-definition-prefixes "magit-popup" '("magit-")) (provide 'magit-popup-autoloads)) "tablist" ((tablist-autoloads tablist tablist-filter) (autoload 'tablist-minor-mode "tablist" "Toggle tablist minor mode.

This is a minor mode.  If called interactively, toggle the
`Tablist minor mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `tablist-minor-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t nil) (autoload 'tablist-mode "tablist" "

(fn)" t nil) (register-definition-prefixes "tablist" '("tablist-")) (register-definition-prefixes "tablist-filter" '("tablist-filter-")) (provide 'tablist-autoloads)) "tblui" ((tblui tblui-autoloads) (autoload 'tblui-define "tblui" "Define tabulated list UI easily.  Hereafter referred as tblui.
This macro defines functions and popups for the defined tblui.
User of this macro can focus on writing the logic for ui, let this
package handle the tabulated list buffer interaction part.

Each arguments are explained as follows:

 * `TBLUI-NAME` : the symbol name of defining tblui.  It will be used
                  as prefix for functions defined via this macro.
 * `ENTRIES-PROVIDER` : the function which provides tabulated-list-entries
 * `TABLE-LAYOUT` : the `tabulated-list-format` to be used for the tblui.
 * `POPUP-DEFINITIONS` : list of popup definition.
   A popup definition is an plist of
       `(:key KEY :name NAME :funcs FUNCTIONS)`.
   KEY is the key to be bound for the defined magit-popup.
   NAME is the name for defined magit-popup.
   FUNCTIONS is the list of action definition.
   Action definition is a list of 3 elements,
   which is `(ACTIONKEY DESCRIPTION FUNCTION)`.

   ACTIONKEY is the key to be used as action key in the magit-popup.
   DESCRIPTION is the description of the action.
   FUNCTION is the logic to be called for this UI.
   It is the elisp function which receives the IDs of tabulated-list entry,
    and do what ever operation.

With this macro `TBLUI-NAME-goto-ui` function is defined.
Calling this function will popup and switch to the tblui buffer.

(fn TBLUI-NAME ENTRIES-PROVIDER TABLE-LAYOUT POPUP-DEFINITIONS)" nil t) (register-definition-prefixes "tblui" '("tblui--")) (provide 'tblui-autoloads)) "openai" ((openai-autoloads openai-fine-tune openai openai-embedding openai-edit openai-file openai-chat openai-engine openai-moderation openai-model openai-completion openai-image openai-audio) (autoload 'openai-key-auth-source "openai" "Retrieve the OpenAI API key from auth-source given a BASE-URL.
If BASE-URL is not specified, it defaults to `openai-base-url'.

(fn &optional BASE-URL)" nil nil) (register-definition-prefixes "openai" '("open")) (autoload 'openai-audio-create-transcription "openai-audio" "Send transcribe audio request.

Argument FILE is audio file to transcribe, in one of these formats: mp3, mp4,
mpeg, mpga, m4a, wav, or webm.  CALLBACK is the execuation after request is
made.

Arguments BASE-URL, PARAMETERS, CONTENT-TYPE, KEY and ORG-ID are global
options; however, you can overwrite the value by passing it in.

The rest of the arugments are optional, please see OpenAI API reference page
for more information.  Arguments here refer to MODEL PROMPT, RESPONSE-FORMAT,
TEMPERATURE, and LANGUAGE.

(fn FILE CALLBACK &key (BASE-URL openai-base-url) (PARAMETERS openai-parameters) (CONTENT-TYPE \"application/json\") (KEY openai-key) ORG-ID (MODEL \"whisper-1\") PROMPT RESPONSE-FORMAT TEMPERATURE LANGUAGE)" nil nil) (autoload 'openai-audio-create-translation "openai-audio" "Send translate audio request.

Argument FILE is the audio file to translate, in one of these formats: mp3,
mp4, mpeg, mpga, m4a, wav, or webm.  CALLBACK is the execuation after request
is made.

Arguments BASE-URL, PARAMETERS, CONTENT-TYPE, KEY and ORG-ID are global
options; however, you can overwrite the value by passing it in.

The rest of the arugments are optional, please see OpenAI API reference page
for more information.  Arguments here refer to MODEL PROMPT, RESPONSE-FORMAT,
and TEMPERATURE.

(fn FILE CALLBACK &key (BASE-URL openai-base-url) (PARAMETERS openai-parameters) (CONTENT-TYPE \"application/json\") (KEY openai-key) ORG-ID (MODEL \"whisper-1\") PROMPT RESPONSE-FORMAT TEMPERATURE)" nil nil) (autoload 'openai-chat "openai-chat" "Send chat request.

Arguments MESSAGES and CALLBACK are required for this type of request.
MESSAGES is the conversation data.  CALLBACK is the execuation after request is
made.

Arguments BASE-URL, PARAMETERS, CONTENT-TYPE, KEY, ORG-ID and USER are global
options; however, you can overwrite the value by passing it in.

The rest of the arugments are optional, please see OpenAI API reference page
for more information.  Arguments here refer to MODEL,  TEMPERATURE, TOP-P, N,
STREAM, STOP, MAX-TOKENS, PRESENCE-PENALTY, FREQUENCY-PENALTY, and LOGIT-BIAS.

(fn MESSAGES CALLBACK &key (BASE-URL openai-base-url) (PARAMETERS openai-parameters) (CONTENT-TYPE \"application/json\") (KEY openai-key) ORG-ID (MODEL \"gpt-3.5-turbo\") TEMPERATURE TOP-P N STREAM STOP MAX-TOKENS PRESENCE-PENALTY FREQUENCY-PENALTY LOGIT-BIAS (USER openai-user))" nil nil) (autoload 'openai-chat-say "openai-chat" "Start making a conversation to OpenAI.

This is a ping pong message, so you will only get one response." t nil) (register-definition-prefixes "openai-chat" '("openai-chat-")) (autoload 'openai-completion "openai-completion" "Send completion request.

Arguments PROMPT and CALLBACK are required for this type of request.  PROMPT is
either the question or instruction to OpenAI.  CALLBACK is the execution after
request is made.

Arguments BASE-URL, PARAMETERS, CONTENT-TYPE, KEY, ORG-ID and USER are global
options; however, you can overwrite the value by passing it in.

The rest of the arugments are optional, please see OpenAI API reference page
for more information.  Arguments here refer to MODEL, SUFFIX, MAX-TOKENS,
TEMPERATURE, TOP-P, N, STREAM, LOGPROBS, ECHO, STOP, PRESENCE-PENALTY,
FREQUENCY-PENALTY, BEST-OF, and LOGIT-BIAS.

(fn PROMPT CALLBACK &key (BASE-URL openai-base-url) (PARAMETERS openai-parameters) (CONTENT-TYPE \"application/json\") (KEY openai-key) ORG-ID (MODEL \"text-davinci-003\") SUFFIX MAX-TOKENS TEMPERATURE TOP-P N STREAM LOGPROBS ECHO STOP PRESENCE-PENALTY FREQUENCY-PENALTY BEST-OF LOGIT-BIAS (USER openai-user))" nil nil) (autoload 'openai-completion-select-insert "openai-completion" "Send the region to OpenAI and insert the result to the next paragraph.

START and END are selected region boundaries.

(fn START END)" t nil) (autoload 'openai-completion-buffer-insert "openai-completion" "Send the entire buffer to OpenAI and insert the result to the end of buffer." t nil) (register-definition-prefixes "openai-completion" '("openai-completion-")) (autoload 'openai-edit-prompt "openai-edit" "Prompt to ask for edited version." t nil) (autoload 'openai-list-engines "openai-engine" "List currently available (non-finetuned) models." t nil) (register-definition-prefixes "openai-engine" '("openai-engine-entries")) (autoload 'openai-list-files "openai-file" "List files that belong to the user's organization." t nil) (autoload 'openai-upload-file "openai-file" "Prompt to upload the file to OpenAI server for file-tuning." t nil) (autoload 'openai-delete-file "openai-file" "Prompt to select the file and delete it." t nil) (autoload 'openai-retrieve-file "openai-file" "Prompt to select the file and print its' information." t nil) (autoload 'openai-retrieve-file-content "openai-file" "Prompt to select the file and print its' content." t nil) (register-definition-prefixes "openai-file" '("openai-")) (autoload 'openai-list-fine-tunes "openai-fine-tune" "List fine-tuning jobs." t nil) (register-definition-prefixes "openai-fine-tune" '("openai-fine-tune-entries")) (autoload 'openai-image-prompt "openai-image" "Use PROMPT to ask for image, and display result in a buffer.

(fn PROMPT)" t nil) (autoload 'openai-image-edit-prompt "openai-image" "Use prompt to ask for image, and display result in a buffer." t nil) (autoload 'openai-image-variation-prompt "openai-image" "Prompt to select an IMAGE file, and display result in a buffer.

(fn IMAGE)" t nil) (register-definition-prefixes "openai-image" '("openai-")) (autoload 'openai-retrieve-model "openai-model" "Retrieves a model instance, providing basic information about the model such
as the owner and permissioning." t nil) (autoload 'openai-list-models "openai-model" "Lists the currently available models, and provides basic information about
each one such as the owner and availability." t nil) (register-definition-prefixes "openai-model" '("openai-model-entries")) (provide 'openai-autoloads)) "lv" ((lv-autoloads lv) (register-definition-prefixes "lv" '("lv-")) (provide 'lv-autoloads)) "ht" ((ht ht-autoloads) (register-definition-prefixes "ht" 'nil) (provide 'ht-autoloads)) "markdown-mode" ((markdown-mode markdown-mode-autoloads) (autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files.

(fn)" t nil) (add-to-list 'auto-mode-alist '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode)) (autoload 'gfm-mode "markdown-mode" "Major mode for editing GitHub Flavored Markdown files.

(fn)" t nil) (autoload 'markdown-view-mode "markdown-mode" "Major mode for viewing Markdown content.

(fn)" t nil) (autoload 'gfm-view-mode "markdown-mode" "Major mode for viewing GitHub Flavored Markdown content.

(fn)" t nil) (autoload 'markdown-live-preview-mode "markdown-mode" "Toggle native previewing on save for a specific markdown file.

This is a minor mode.  If called interactively, toggle the
`Markdown-Live-Preview mode' mode.  If the prefix argument is
positive, enable the mode, and if it is zero or negative, disable
the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `markdown-live-preview-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t nil) (register-definition-prefixes "markdown-mode" '("defun-markdown-" "gfm-" "markdown")) (provide 'markdown-mode-autoloads)) "spinner" ((spinner spinner-autoloads) (autoload 'spinner-create "spinner" "Create a spinner of the given TYPE.
The possible TYPEs are described in `spinner--type-to-frames'.

FPS, if given, is the number of desired frames per second.
Default is `spinner-frames-per-second'.

If BUFFER-LOCAL is non-nil, the spinner will be automatically
deactivated if the buffer is killed.  If BUFFER-LOCAL is a
buffer, use that instead of current buffer.

When started, in order to function properly, the spinner runs a
timer which periodically calls `force-mode-line-update' in the
current buffer.  If BUFFER-LOCAL was set at creation time, then
`force-mode-line-update' is called in that buffer instead.  When
the spinner is stopped, the timer is deactivated.

DELAY, if given, is the number of seconds to wait after starting
the spinner before actually displaying it. It is safe to cancel
the spinner before this time, in which case it won't display at
all.

(fn &optional TYPE BUFFER-LOCAL FPS DELAY)" nil nil) (autoload 'spinner-start "spinner" "Start a mode-line spinner of given TYPE-OR-OBJECT.
If TYPE-OR-OBJECT is an object created with `make-spinner',
simply activate it.  This method is designed for minor modes, so
they can use the spinner as part of their lighter by doing:
    \\='(:eval (spinner-print THE-SPINNER))
To stop this spinner, call `spinner-stop' on it.

If TYPE-OR-OBJECT is anything else, a buffer-local spinner is
created with this type, and it is displayed in the
`mode-line-process' of the buffer it was created it.  Both
TYPE-OR-OBJECT and FPS are passed to `make-spinner' (which see).
To stop this spinner, call `spinner-stop' in the same buffer.

Either way, the return value is a function which can be called
anywhere to stop this spinner.  You can also call `spinner-stop'
in the same buffer where the spinner was created.

FPS, if given, is the number of desired frames per second.
Default is `spinner-frames-per-second'.

DELAY, if given, is the number of seconds to wait until actually
displaying the spinner. It is safe to cancel the spinner before
this time, in which case it won't display at all.

(fn &optional TYPE-OR-OBJECT FPS DELAY)" nil nil) (register-definition-prefixes "spinner" '("spinner-")) (provide 'spinner-autoloads)) "chatgpt" ((chatgpt chatgpt-autoloads) (autoload 'chatgpt-new "chatgpt" "Run a new instance of ChatGPT." t nil) (autoload 'chatgpt "chatgpt" "Start ChatGPT with existing instance, else create a new instance." t nil) (register-definition-prefixes "chatgpt" '("chatgpt-")) (provide 'chatgpt-autoloads)) "codegpt" ((codegpt-autoloads codegpt) (autoload 'codegpt-mode "codegpt" "Major mode for `codegpt-mode'.

\\<codegpt-mode-map>

(fn)" t nil) (autoload 'codegpt-doc "codegpt" "Automatically write documentation for your code.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

(fn START END)" t nil) (autoload 'codegpt-fix "codegpt" "Fix your code.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

(fn START END)" t nil) (autoload 'codegpt-explain "codegpt" "Explain the selected code.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

(fn START END)" t nil) (autoload 'codegpt-improve "codegpt" "Improve, refactor or optimize your code.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

(fn START END)" t nil) (autoload 'codegpt-custom "codegpt" "Do completion with custom instruction.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

(fn START END)" t nil) (autoload 'codegpt "codegpt" "Do completion with OpenAI to your code.

This command is interactive region only, the START and END are boundaries of
that region in buffer.

(fn START END)" t nil) (register-definition-prefixes "codegpt" '("codeg")) (provide 'codegpt-autoloads)) "f" ((f f-autoloads f-shortdoc) (register-definition-prefixes "f" '("f-")) (provide 'f-autoloads)) "reveal-in-folder" ((reveal-in-folder reveal-in-folder-autoloads) (autoload 'reveal-in-folder-at-point "reveal-in-folder" "Reveal the current file in folder at point." t nil) (autoload 'reveal-in-folder-this-buffer "reveal-in-folder" "Reveal the current buffer in folder." t nil) (autoload 'reveal-in-folder "reveal-in-folder" "Reveal buffer/path depends on cursor condition." t nil) (register-definition-prefixes "reveal-in-folder" '("reveal-in-folder-")) (provide 'reveal-in-folder-autoloads)) "async" ((dired-async smtpmail-async async async-bytecomp async-autoloads) (autoload 'async-start-process "async" "Start the executable PROGRAM asynchronously named NAME.  See `async-start'.
PROGRAM is passed PROGRAM-ARGS, calling FINISH-FUNC with the
process object when done.  If FINISH-FUNC is nil, the future
object will return the process object when the program is
finished.  Set DEFAULT-DIRECTORY to change PROGRAM's current
working directory.

(fn NAME PROGRAM FINISH-FUNC &rest PROGRAM-ARGS)" nil nil) (autoload 'async-start "async" "Execute START-FUNC (often a lambda) in a subordinate Emacs process.
When done, the return value is passed to FINISH-FUNC.  Example:

    (async-start
       ;; What to do in the child process
       (lambda ()
         (message \"This is a test\")
         (sleep-for 3)
         222)

       ;; What to do when it finishes
       (lambda (result)
         (message \"Async process done, result should be 222: %s\"
                  result)))

If you call `async-send' from a child process, the message will
be also passed to the FINISH-FUNC.  You can test RESULT to see if
it is a message by using `async-message-p'.  If nil, it means
this is the final result.  Example of the FINISH-FUNC:

    (lambda (result)
      (if (async-message-p result)
          (message \"Received a message from child process: %s\" result)
        (message \"Async process done, result: %s\" result)))

If FINISH-FUNC is nil or missing, a future is returned that can
be inspected using `async-get', blocking until the value is
ready.  Example:

    (let ((proc (async-start
                   ;; What to do in the child process
                   (lambda ()
                     (message \"This is a test\")
                     (sleep-for 3)
                     222))))

        (message \"I'm going to do some work here\") ;; ....

        (message \"Waiting on async process, result should be 222: %s\"
                 (async-get proc)))

If you don't want to use a callback, and you don't care about any
return value from the child process, pass the `ignore' symbol as
the second argument (if you don't, and never call `async-get', it
will leave *emacs* process buffers hanging around):

    (async-start
     (lambda ()
       (delete-file \"a remote file on a slow link\" nil))
     \\='ignore)

Special case:
If the output of START-FUNC is a string with properties
e.g. (buffer-string) RESULT will be transformed in a list where the
car is the string itself (without props) and the cdr the rest of
properties, this allows using in FINISH-FUNC the string without
properties and then apply the properties in cdr to this string (if
needed).
Properties handling special objects like markers are returned as
list to allow restoring them later.
See <https://github.com/jwiegley/emacs-async/issues/145> for more infos.

Note: Even when FINISH-FUNC is present, a future is still
returned except that it yields no value (since the value is
passed to FINISH-FUNC).  Call `async-get' on such a future always
returns nil.  It can still be useful, however, as an argument to
`async-ready' or `async-wait'.

(fn START-FUNC &optional FINISH-FUNC)" nil nil) (register-definition-prefixes "async" '("async-")) (autoload 'async-byte-recompile-directory "async-bytecomp" "Compile all *.el files in DIRECTORY asynchronously.
All *.elc files are systematically deleted before proceeding.

(fn DIRECTORY &optional QUIET)" nil nil) (defvar async-bytecomp-package-mode nil "Non-nil if Async-Bytecomp-Package mode is enabled.
See the `async-bytecomp-package-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `async-bytecomp-package-mode'.") (custom-autoload 'async-bytecomp-package-mode "async-bytecomp" nil) (autoload 'async-bytecomp-package-mode "async-bytecomp" "Byte compile asynchronously packages installed with package.el.
Async compilation of packages can be controlled by
`async-bytecomp-allowed-packages'.

This is a minor mode.  If called interactively, toggle the
`Async-Bytecomp-Package mode' mode.  If the prefix argument is
positive, enable the mode, and if it is zero or negative, disable
the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='async-bytecomp-package-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t nil) (autoload 'async-byte-compile-file "async-bytecomp" "Byte compile Lisp code FILE asynchronously.

Same as `byte-compile-file' but asynchronous.

(fn FILE)" t nil) (register-definition-prefixes "async-bytecomp" '("async-")) (defvar dired-async-mode nil "Non-nil if Dired-Async mode is enabled.
See the `dired-async-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `dired-async-mode'.") (custom-autoload 'dired-async-mode "dired-async" nil) (autoload 'dired-async-mode "dired-async" "Do dired actions asynchronously.

This is a minor mode.  If called interactively, toggle the
`Dired-Async mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='dired-async-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t nil) (autoload 'dired-async-do-copy "dired-async" "Run ‘dired-do-copy’ asynchronously.

(fn &optional ARG)" t nil) (autoload 'dired-async-do-symlink "dired-async" "Run ‘dired-do-symlink’ asynchronously.

(fn &optional ARG)" t nil) (autoload 'dired-async-do-hardlink "dired-async" "Run ‘dired-do-hardlink’ asynchronously.

(fn &optional ARG)" t nil) (autoload 'dired-async-do-rename "dired-async" "Run ‘dired-do-rename’ asynchronously.

(fn &optional ARG)" t nil) (register-definition-prefixes "dired-async" '("dired-async-")) (register-definition-prefixes "smtpmail-async" '("async-smtpmail-")) (provide 'async-autoloads)) "dall-e" ((dall-e-autoloads dall-e) (autoload 'dall-e-new "dall-e" "Run a new instance of DALL-E." t nil) (autoload 'dall-e "dall-e" "Start DALL-E with existing instance, else create a new instance." t nil) (register-definition-prefixes "dall-e" '("dall-e-")) (provide 'dall-e-autoloads))))

#s(hash-table size 65 test eq rehash-size 1.5 rehash-threshold 0.8125 data (org-elpa #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 15 "melpa" nil "gnu-elpa-mirror" nil "nongnu-elpa" nil "el-get" nil "emacsmirror-mirror" nil "straight" nil "copilot" nil "s" nil "dash" nil "editorconfig" nil "jsonrpc" nil "openai" nil "request" nil "tblui" nil "magit-popup" nil "tablist" nil "cl-lib" nil "chatgpt" nil "lv" nil "ht" nil "markdown-mode" nil "spinner" nil "codegpt" nil "dall-e" nil "reveal-in-folder" nil "f" nil "async" nil)) melpa #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 2 "gnu-elpa-mirror" nil "nongnu-elpa" nil "el-get" (el-get :type git :flavor melpa :files ("*.el" ("recipes" "recipes/el-get.rcp") "methods" "el-get-pkg.el") :host github :repo "dimitri/el-get") "emacsmirror-mirror" nil "straight" nil "copilot" nil "s" (s :type git :flavor melpa :host github :repo "magnars/s.el") "dash" (dash :type git :flavor melpa :files ("dash.el" "dash.texi" "dash-pkg.el") :host github :repo "magnars/dash.el") "editorconfig" (editorconfig :type git :flavor melpa :host github :repo "editorconfig/editorconfig-emacs") "jsonrpc" nil "openai" nil "request" (request :type git :flavor melpa :files ("request.el" "request-pkg.el") :host github :repo "tkf/emacs-request") "tblui" (tblui :type git :flavor melpa :host github :repo "Yuki-Inoue/tblui.el") "magit-popup" (magit-popup :type git :flavor melpa :host github :repo "magit/magit-popup") "tablist" (tablist :type git :flavor melpa :host github :repo "emacsorphanage/tablist") "cl-lib" nil "chatgpt" nil "lv" (lv :type git :flavor melpa :files ("lv.el" "lv-pkg.el") :host github :repo "abo-abo/hydra") "ht" (ht :type git :flavor melpa :host github :repo "Wilfred/ht.el") "markdown-mode" (markdown-mode :type git :flavor melpa :host github :repo "jrblevin/markdown-mode") "spinner" nil "codegpt" nil "dall-e" nil "reveal-in-folder" (reveal-in-folder :type git :flavor melpa :host github :repo "jcs-elpa/reveal-in-folder") "f" (f :type git :flavor melpa :host github :repo "rejeep/f.el") "async" (async :type git :flavor melpa :host github :repo "jwiegley/emacs-async"))) gnu-elpa-mirror #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 3 "nongnu-elpa" nil "emacsmirror-mirror" nil "straight" nil "copilot" nil "jsonrpc" (jsonrpc :type git :host github :repo "emacs-straight/jsonrpc" :files ("*" (:exclude ".git"))) "openai" nil "cl-lib" nil "chatgpt" nil "spinner" (spinner :type git :host github :repo "emacs-straight/spinner" :files ("*" (:exclude ".git"))) "codegpt" nil "dall-e" nil)) nongnu-elpa #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 4 "emacsmirror-mirror" nil "straight" nil "copilot" nil "openai" nil "cl-lib" nil "chatgpt" nil "codegpt" nil "dall-e" nil)) el-get #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 2 "emacsmirror-mirror" nil "straight" nil "copilot" nil "openai" nil "cl-lib" nil "chatgpt" nil "codegpt" nil "dall-e" nil)) emacsmirror-mirror #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data (version 2 "straight" (straight :type git :host github :repo "emacsmirror/straight") "copilot" nil "openai" nil "cl-lib" nil "chatgpt" nil "codegpt" nil "dall-e" nil))))

("org-elpa" "melpa" "gnu-elpa-mirror" "nongnu-elpa" "el-get" "emacsmirror-mirror" "straight" "emacs" "copilot" "s" "dash" "editorconfig" "nadvice" "jsonrpc" "openai" "request" "tblui" "magit-popup" "tablist" "cl-lib" "chatgpt" "lv" "ht" "markdown-mode" "spinner" "codegpt" "dall-e" "reveal-in-folder" "f" "async")

t
