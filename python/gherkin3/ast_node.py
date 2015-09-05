from collections import defaultdict


class AstNode(object):
    """
    Nodes are created by the :class:`AstBuilder`, and are the building blocks of the AST (Abstract Syntax Tree). 
    Every node has a `Location` that describes the line number and column number in the input file. 
    These numbers are 1-indexed.

    All fields on nodes are strings (except for `Location.line` and `Location.column`).

    The implementation is simple objects without behaviour, only data. 
    It's up to the implementation to decide whether to use classes or just basic collections, 
    but the AST must have a JSON representation (this is used for testing).

    Each node in the JSON representation also has a `type` property with the name of the node type.
    """
    
    def __init__(self, rule_type):
        self.rule_type = rule_type
        self._sub_items = defaultdict(list)

    def add(self, rule_type, obj):
        self._sub_items[rule_type].append(obj)

    def get_single(self, rule_type):
        return self._sub_items[rule_type][0] if self._sub_items[rule_type] else None

    def get_items(self, rule_type):
        return self._sub_items[rule_type]

    def get_token(self, token_type):
        return self.get_single(token_type)

    def get_tokens(self, token_type):
        return self._sub_items[token_type]
