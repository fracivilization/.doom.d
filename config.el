;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Takayoshi Shibahara"
      user-mail-address "fractal.civilization@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; (setq doom-font (font-spec :family "Fira Code" :size 15 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 16))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/.org/")
(after! org
  (add-to-list 'org-capture-templates
    `("i" "inbox" entry
     (file ,(concat org-directory "inbox.org"))
     "* %?\n %i\n"))
  ;; Add org-roam files into org-agenda
  ;; ref: https://systemcrafters.net/build-a-second-brain-in-emacs/5-org-roam-hacks/
  (defun my/org-roam-filter-by-tag (tag-name)
    (lambda (node)
      (member tag-name (org-roam-node-tags node))))

  (defun my/org-roam-list-notes-by-tag (tag-name)
    (mapcar #'org-roam-node-file
            (seq-filter
             (my/org-roam-filter-by-tag tag-name)
             (org-roam-node-list))))

  (defun my/org-roam-refresh-agenda-list ()
    (interactive)
    (setq org-agenda-files (delete-dups (my/org-roam-list-notes-by-tag "Project"))))

  ;; Build the agenda list the first time for the session
  (my/org-roam-refresh-agenda-list)
  )
(defun org-capture-inbox ()
    (interactive)
    (org-capture nil "i"))
(define-key global-map (kbd "s-i") 'org-capture-inbox)
(setq org-roam-directory (concat org-directory "roam"))

;; toggle-truncate-lines for eww
;; 
(eval-after-load 'shr
  '(progn (setq shr-width -1)
          (defun shr-fill-text (text) text)
          (defun shr-fill-lines (start end) nil)
          (defun shr-fill-line () nil)))
;; C-jではなくs-jをskk-kakuteiにわりあてる
;;
;; (with-eval-after-load 'skk
;;   (define-key minibuffer-local-map (kbd "s-j") 'skk-kakutei)
;;   (define-key minibuffer-mode-map (kbd "s-j") 'skk-kakutei)
;;   (define-key skk-jisx0208-latin-mode-map (kbd "s-j") 'skk-kakutei)
;;   (define-key skk-latin-mode-map (kbd "s-j") 'skk-kakutei)
;;   (define-key skk-j-mode-map (kbd "s-j") 'skk-kakutei)
;;   (with-eval-after-load 'skk-tut
;;     (define-key skktut-abbrev-mode-map (kbd "s-j") 'skk-kakutei)
;;     (define-key skktut-jisx0208-latin-mode-map (kbd "s-j") 'skk-kakutei)
;;     (define-key skktut-latin-mode-map (kbd "s-j") 'skk-kakutei)
;;   )
;; )
;; (setq skk-tut-file "/home/takayoshi-s/.emacs.d/.local/straight/repos/ddskk/etc/SKK.tut")

;; For docker-tramp.el
;; Use remote-container-path in tramp
(after! docker-tramp
        (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
