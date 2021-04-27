(import [bisect [bisect]])

(defclass Livesort []
  (defn __init__ [self
                  next-line ; iterable function yielding lines of text
                  print     ; function to write output
                  height    ; window/screen height in lines
                  width     ; window/screen width in characters
                  ]
    (setv self.next-line next-line
          self.print print
          self.height height
          self.width width
          self.lines (list)
          self.screen (* height [None])))
  (defn sortline [self line]
    "Insort a line"
    (when (line.strip)
      ;; Normally would use `insort` but there's going to be more
      (self.lines.insert (bisect self.lines line) line)))
  (defn render [self]
    "Produce a list of the lines which should be visible, cropped to `width`"
    (list (map (fn [line] (cut line 0 self.width))
               (cut self.lines 0 self.height))))
  (defn display [self]
    "Compare `(self.render)` to `self.screen` and return a string that
will update the display."
    (setv output (list)
          lines (self.render)
          changed? False)
    (output.append "[H")    ; Home cursor
    (for [lineno (range self.height)]
      (setv line (if (< lineno (len lines)) (get lines lineno) ""))
      (unless (= line (get self.screen lineno))
        (setv (get self.screen lineno) line
              changed? True)
        ;; ^[[K to erase any characters that follow on this line
        (.append output (.format "{}[K"
                                 (.rstrip line (chr 0x0a)))))
      (.append output (chr 0x0a))) ; Move to beginning of next line
    ;; if something changed, don't bother outputting the last cursor
    ;; movement code.  If nothing changed, don't bother outputting
    ;; anything.
    (if changed? (.join "" (cut output 0 -1)) ""))
  (defn livesort [self]
    "Process every input line, updating screen each line"
    (for [line self.next-line]
      (.sortline self line)
      (.print self (.display self)))))

(defmain
  ()
  (import sys os)
  (.livesort
    (Livesort sys.stdin
              (fn [data] (sys.stdout.write data) (sys.stdout.flush))
              (int (or (os.getenv "LINES") "24"))
              (int (or (os.getenv "COLUMNS") "80")))))
