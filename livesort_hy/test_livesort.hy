(import [livesort_hy [Livesort]])
(import unittest)


(defclass TestLivesort [unittest.TestCase]
  (defn setUp [self] 
    (setv self.input-buf (list)
          self.output-buf (list)
          self.ls (Livesort self.input-buf self.output-buf.append 4 8)))

  (defn tearDown [self]
    (del self.ls
         self.output-buf
         self.input-buf))

  (defn test_Livesort [self]
    (self.assertEqual self.ls.next-line self.input-buf)
    (self.assertEqual self.ls.print self.output-buf.append)
    (self.assertEqual self.ls.height 4)
    (self.assertEqual self.ls.width 8)
    (self.assertFalse self.ls.lines)
    (self.assertTrue self.ls.screen)
    (for [line self.ls.screen]
      (self.assertEqual None line)))

  (defn test_sortline [self]
    (self.assertFalse self.ls.lines)
    (self.ls.sortline "line 2")
    (self.assertEqual self.ls.lines ["line 2"])
    (self.ls.sortline "line 1")
    (self.assertEqual self.ls.lines ["line 1" "line 2"]))

  (defn test_render [self]
    (self.ls.sortline "line 1")
    (self.assertEqual (self.ls.render)
                      ["line 1"]))

  (defn test_display [self]
    ;; I got fed up trying to write this sensibly, will go away after refacor
    (self.assertEqual "[H[K
[K
[K
[K" (self.ls.display))
    (self.ls.sortline "line 1")
    (self.assertEqual "[Hline 1[K


" (self.ls.display)))

  ;; note (unfortunate) capitalization
  (defn test_livesort [self]
    (self.input-buf.append "line 1")
    (self.ls.livesort)))
