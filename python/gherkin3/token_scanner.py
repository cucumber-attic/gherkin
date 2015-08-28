import os
from .token import Token
from .gherkin_line import GherkinLine
try:
    python2 = True
    from cStringIO import StringIO
except ImportError:
    python2 = False
    from io import StringIO


class TokenScanner(object):
    def __init__(self, io):
        if isinstance(io, str):
            if os.path.exists(io):
                self.io = open(io, 'rU')
            else:
                self.io = StringIO(io)
        self.line_number = 0

    def read(self):
        self.line_number += 1
        location = {'line': self.line_number}
        line = self.io.readline()
        if python2:
            line = line.decode('utf-8')
        return Token((GherkinLine(line, self.line_number) if line else line), location)
