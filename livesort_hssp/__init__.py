from hissp.reader import transpile
transpile(__package__, "livesort", "test_livesort")
del transpile

from livesort_hssp.livesort import Livesort
