class GherkinLine(object):
    def __init__(self, line_text, line_number):
        self._line_text = line_text
        self._line_number = line_number
        self._trimmed_line_text = line_text.lstrip()
        self.indent = len(line_text) - len(self._trimmed_line_text)

    def get_rest_trimmed(self, length):
        return self._trimmed_line_text[length:].strip()

    def get_line_text(self, indent_to_remove=-1):
        if indent_to_remove < 0 or indent_to_remove > self.indent:
            return self._trimmed_line_text
        else:
            return self._line_text[indent_to_remove:]

    def is_empty(self):
        return not self._trimmed_line_text

    def startswith(self, prefix):
        return self._trimmed_line_text.startswith(prefix)

    def startswith_title_keyword(self, keyword):
        return self._trimmed_line_text.startswith(keyword + ':')

    def table_cells(self):
        column = self.indent + 1
        items = self._trimmed_line_text.strip().split('|')
        cells = []
        for item in items[1:-1]:
            cell_indent = len(item) - len(item.lstrip()) + 1
            cells.append({'column': column + cell_indent, 'text': item.strip()})
            column += len(item) + 1
        return cells

    def tags(self):
        column = self.indent + 1
        items = self._trimmed_line_text.strip().split('@')
        tags = []
        for item in items[1:]:
            tags.append({'column': column, 'text': '@' + item.strip()})
            column += len(item) + 1
        return tags
