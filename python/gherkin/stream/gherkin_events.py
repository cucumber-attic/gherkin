from gherkin.parser import Parser
from gherkin.pickles.compiler import compile
from gherkin.errors import ParserError, CompositeParserException

class GherkinEvents:
    def __init__(self, options):
        self.options = options
        self.parser = Parser()

    def enum(self, source_event):
        uri = source_event['uri']
        source = source_event['data']

        events = []

        try:
            gherkin_document = self.parser.parse(source)

            if (self.options.print_source):
                events.append(source_event)

            if (self.options.print_ast):
                events.append({
                    'type': 'gherkin-document',
                    'uri': uri,
                    'document': gherkin_document
                })

            if (self.options.print_pickles):
                pickles = compile(gherkin_document)
                for pickle in pickles:
                    events.append({
                        'type': 'pickle',
                        'uri': uri,
                        'pickle': pickle
                    })
        except CompositeParserException as e:
            yield_errors(y, e.errors, uri)
        except ParserError as e:
            yield_errors(output, [e], uri)

        return events
