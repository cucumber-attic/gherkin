//: Playground - noun: a place where people can play

import Cocoa
import Foundation

class ASTBuilder {
    
    init () {
        
    }
    
    func reset() {
        
    }
    
    func startRule(ruleType: RuleType) {
        
    }
    
    func endRule(ruleType: RuleType) {
        
    }
    
    func getResult() -> String {
        
    }
}

class TokenMatcher {
    
    init() {
        
    }
    
    func reset() {
        
    }
}

class TokenScanner {
    
    init(source: NSURL) {
        
    }
    
    func read() -> Token {
        
    }
}

class Token {
    
    
}

enum RuleType {
    case None
    case _EOF // #EOF
    case _Empty // #Empty
    case _Comment // #Comment
    case _TagLine // #TagLine
    case _FeatureLine // #FeatureLine
    case _BackgroundLine // #BackgroundLine
    case _ScenarioLine // #ScenarioLine
    case _ScenarioOutlineLine // #ScenarioOutlineLine
    case _ExamplesLine // #ExamplesLine
    case _StepLine // #StepLine
    case _DocStringSeparator // #DocStringSeparator
    case _TableRow // #TableRow
    case _Language // #Language
    case _Other // #Other
    case Feature // Feature! := Feature_Header Background? Scenario_Definition*
    case Feature_Header // Feature_Header! := #Language? Tags? #FeatureLine Feature_Description
    case Background // Background! := #BackgroundLine Background_Description Scenario_Step*
    case Scenario_Definition // Scenario_Definition! := Tags? (Scenario | ScenarioOutline)
    case Scenario // Scenario! := #ScenarioLine Scenario_Description Scenario_Step*
    case ScenarioOutline // ScenarioOutline! := #ScenarioOutlineLine ScenarioOutline_Description ScenarioOutline_Step* Examples_Definition+
    case Examples_Definition // Examples_Definition! [#Empty|#Comment|#TagLine-&gt;#ExamplesLine] := Tags? Examples
    case Examples // Examples! := #ExamplesLine Examples_Description #TableRow #TableRow+
    case Scenario_Step // Scenario_Step := Step
    case ScenarioOutline_Step // ScenarioOutline_Step := Step
    case Step // Step! := #StepLine Step_Arg?
    case Step_Arg // Step_Arg := (DataTable | DocString)
    case DataTable // DataTable! := #TableRow+
    case DocString // DocString! := #DocStringSeparator #Other* #DocStringSeparator
    case Tags // Tags! := #TagLine+
    case Feature_Description // Feature_Description := Description_Helper
    case Background_Description // Background_Description := Description_Helper
    case Scenario_Description // Scenario_Description := Description_Helper
    case ScenarioOutline_Description // ScenarioOutline_Description := Description_Helper
    case Examples_Description // Examples_Description := Description_Helper
    case Description_Helper // Description_Helper := #Empty* Description? #Comment*
    case Description // Description! := #Other+
}

enum InvalidOperationException: ErrorType {
    
    case UnknownState
}

class ParserContext {
    var tokenScanner: TokenScanner
    var tokenMatcher: TokenMatcher
    var tokenQueue: [String]
    var errors: [String]
    
    init(tokenScanner: TokenScanner, tokenMatcher: TokenMatcher, tokenQueue: [String], errors: [String]) {
        
        self.tokenScanner = tokenScanner
        self.tokenMatcher = tokenMatcher
        self.tokenQueue = tokenQueue
        self.errors = errors
    }
}



class Parser {
    var stopAtFirstError: Bool = true
    var astBuilder: ASTBuilder
    
    init(astBuilder: ASTBuilder) {
        
        self.astBuilder = astBuilder
    }
    
    func parse(tokenScanner: TokenScanner, tokenMatcher: TokenMatcher) throws -> String {
        
        self.astBuilder.reset
        tokenMatcher.reset()
        
        var context = ParserContext(tokenScanner: tokenScanner, tokenMatcher: tokenMatcher, tokenQueue: [], errors: [])
        
        startRule(context, ruleType: .@Model.RuleSet.StartRule.Name)
        var state = 0
        var token: ParserContext?
        
        while !token.eof {
            
            token = readToken(context)
            if let newToken = token {
                do {
                    state = try matchToken(state, token: newToken, context: context)
                } catch {
                    //FIXME: Need to have some kind of logger
                    print ("failed")
                }
            }
        }
        
        endRule(context, ruleType: :@Model.RuleSet.StartRule.Name)
        
        if context.errors.count > 0 {
            
            throw CompositeParserException.new(context.errors)
        }
        
        return getResult()
    }
    
    func build(context: ParserContext, token:
    
    func startRule(context: ParserContext, ruleType: RuleType) {
        handleASTError(context, action: {
            self.astBuilder.startRule(ruleType)
        })
        
    }
    
    func endRule(context: ParserContext, ruleType: RuleType) {
        handleASTError(context, action: {
            self.astBuilder.endRule(ruleType)
        })
    }
    
    func getResult() -> String {
        
        return self.astBuilder.getResult()
    }
    
    func readToken(context: ParserContext) -> ParserContext {
  
    }
    
    func matchToken(state: Int, token: ParserContext, context: ParserContext) throws -> Int {
        switch state {
        case 0:
            return matchTokenAt0(token, context: context)
        case 1:
            return matchTokenAt1(token, context: context)
//            @foreach( var state in Model.States.Values.Where(s => !s.IsEndState))
//            {
//            @:case @state.Id
//                    @:matchTokenAt@(state.Id)(token, context: context)
//            }
            default:
                throw InvalidOperationException.UnknownState
        }
    }
    
    
    
    
    /*
def build(context, token)
handle_ast_error(context) do
@@ast_builder.build(token)
end
end

def add_error(context, error)
context.errors.push(error)
raise CompositeParserException, context.errors if context.errors.length > 10
end

def get_result()
@@ast_builder.get_result
end

def read_token(context)
context.token_queue.any? ? context.token_queue.shift : context.token_scanner.read
end
*/



    private func handleASTError(context: AnyObject, action: () throws -> Void ) {
        
        handleExternalError(context, defaultValue: true, action: action)
    }
    
    private func handleExternalError(context: AnyObject, defaultValue: Bool, action: () throws -> Void ) {
        
        
    }
}



















