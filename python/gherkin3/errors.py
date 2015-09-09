class ParserError(Exception):
    pass


class ParserException(ParserError):
    def __init__(self, message, location):
        self.location = location
        _message = '({line!s}:{column!s}): {message}'.format(
                line    = location['line'],
                column  = location.get('column', 0),
                message = message )
        super(ParserException, self).__init__(_message)


class NoSuchLanguageException(ParserException):
    def __init__(self, language, location):
        message = 'Language not supported: {language}'.format(language=language)
        super(NoSuchLanguageException, self).__init__(message, location)


class AstBuilderException(ParserException):
    pass


class UnexpectedEOFException(ParserException):
    def __init__(self, received_token, expected_token_types, state_comment):
        expected = ', '.join(expected_token_types)
        message  = 'unexpected end of file, expected: {0}'.format(expected)
        super(UnexpectedEOFException, self).__init__(message, received_token.location)


class UnexpectedTokenException(ParserException):
    def __init__(self, received_token, expected_token_types, state_comment):
        message  = 'expected: {expected}, got {got!r}'.format(
                       expected = ', '.join(expected_token_types),
                       got      = received_token.token_value().strip()
                       )
        column   = received_token.location.get('column', None)
        if column:
            location = received_token.location
        else:
            location = {'line':   received_token.location['line'],
                        'column': received_token.line.indent + 1}
        super(UnexpectedTokenException, self).__init__(message, location)


class CompositeParserException(ParserError):
    def __init__(self, errors):
        self.errors = errors
        error_first_args = [error.args[0] for error in errors]
        message = 'Parser errors:\n{line_separated_errors}'.format(
             line_separated_errors = '\n'.join(error_first_args)
            )
        super(CompositeParserException, self).__init__(message)
