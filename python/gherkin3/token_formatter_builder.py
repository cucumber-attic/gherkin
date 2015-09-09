from __future__ import unicode_literals
from .ast_builder import AstBuilder


class TokenFormatterBuilder(AstBuilder):
    def __init__(self):
        self.reset()

    def reset(self):
        self._tokens = []

    def build(self, token):
        self._tokens.append(token)

    def start_rule(self, rule_type):
        pass

    def end_rule(self, rule_type):
        pass

    def get_result(self):
        return '\n'.join([self._format_token(token) for token in self._tokens])

    def _format_token(self, token):
        if token.eof():
            return 'EOF'
        
        matched = {
            'type':    token.matched_type,
            'keyword': token.matched_keyword if token.matched_keyword else '',
            'text':    token.matched_text    if token.matched_text    else '',
            'items':   ','.join(['{item[column]!s}:{item[text]!s}'.format(item=item) 
                                 for item in token.matched_items])
            }
        
        return ('({location[line]!s}:{location[column]!s}){matched[type]}'
               ':{matched[keyword]}/{matched[text]}/{matched[items]}').format(
                    location = token.location,
                    matched = matched)
