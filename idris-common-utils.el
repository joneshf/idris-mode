;;; idris-common-utils.el --- Useful utilities -*- lexical-binding: t -*-

;; Copyright (C) 2013 Hannes Mehnert

;; Author: Hannes Mehnert <hannes@mehnert.org>

;; License:
;; Inspiration is taken from SLIME/DIME (http://common-lisp.net/project/slime/) (https://github.com/dylan-lang/dylan-mode)
;; Therefore license is GPL

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING. If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

(require 'idris-core)
(require 'cl-lib)

(defun idris-buffer-name (type)
  (assert (keywordp type))
  (concat (format "*idris-%s*" (substring (symbol-name type) 1))))

(defun idris-kill-buffer (buffer)
  (let ((buf (cond
              ((symbolp buffer)
               (get-buffer (idris-buffer-name buffer)))
              ((stringp buffer)
               (get-buffer buffer))
              ((bufferp buffer)
               buffer)
              (t (message "don't know how to kill buffer")))))
    (when (and buf (buffer-live-p buf)) (kill-buffer buf))))

(defun idris-minibuffer-respecting-message (text &rest args)
  "Display TEXT as a message, without hiding any minibuffer contents."
  (let ((mtext (format " [%s]" (apply #'format text args))))
    (if (minibuffer-window-active-p (minibuffer-window))
        (minibuffer-message mtext)
      (message "%s" mtext))))

(defun idris-same-line-p (pos1 pos2)
  "Return t if buffer positions POS1 and POS2 are on the same line."
  (save-excursion (goto-char (min pos1 pos2))
                  (<= (max pos1 pos2) (line-end-position))))

(defmacro idris-save-marker (marker &rest body)
  (let ((pos (cl-gensym "pos")))
  `(let ((,pos (marker-position ,marker)))
     (prog1 (progn . ,body)
       (set-marker ,marker ,pos)))))

(defmacro idris-propertize-region (props &rest body)
  "Execute BODY and add PROPS to all the text it inserts.
More precisely, PROPS are added to the region between the point's
positions before and after executing BODY."
  (let ((start (cl-gensym)))
    `(let ((,start (point)))
       (prog1 (progn ,@body)
	 (add-text-properties ,start (point) ,props)))))

(defmacro idris-propertize-spans (spans &rest body)
  "Execute BODY and add the properties indicated by SPANS to the
inserted text (that is, relative to point prior to insertion)."
  (let ((start (cl-gensym)))
    `(let ((,start (point)))
       (prog1 (progn ,@body)
         (cl-loop for (begin length props) in ,spans
                  do (add-text-properties (+ ,start begin)
                                          (+ ,start begin length)
                                          props))))))

(provide 'idris-common-utils)
