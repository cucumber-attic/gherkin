//: Playground - noun: a place where people can play

import Cocoa
import Foundation







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
    
    case CompositeParserException
    case UnknownState
    case UnexpectedEOFException
    case UnexpectedTokenException
}

class ParserContext {
    var tokenScanner: TokenScanner
    var tokenMatcher: TokenMatcher
    var tokenQueue: [Token]
    var errors: [InvalidOperationException]
    
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
        
        self.astBuilder.reset()
        tokenMatcher.reset()
        
        var context = ParserContext(tokenScanner: tokenScanner, tokenMatcher: tokenMatcher, tokenQueue: [], errors: [])
        
        startRule(context, ruleType: .@Model.RuleSet.StartRule.Name)
        var state = 0
        var token: Token?
        
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
            
            throw InvalidOperationException.CompositeParserException
        }
        
        return getResult()
    }
    
    func build(context: ParserContext, token: Token) {
        handleASTError(context) { () -> Void in
            self.astBuilder.build(token)
        }
    }
    
    func addError(context: ParserContext, error: InvalidOperationException) throws {
        
        context.errors.append(error)
        throw InvalidOperationException.CompositeParserException
    }

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
    
    func readToken(context: ParserContext) -> Token {
        
        return context.tokenQueue.count > 0 ? context.tokenQueue.removeFirst() : context.tokenScanner.read()
    }

    
    /*
    @foreach(var rule in Model.RuleSet.TokenRules)
    {<text>
        def match_@(rule.Name.Replace("#", ""))( context, token)
        @if (rule.Name != "#EOF")
        {
        @:return false if token.eof?
        }
        return handle_external_error(context, false) do
        context.token_matcher.match_@(rule.Name.Replace("#", ""))(token)
        end
        end</text>
    }
    */
    func match_(context: ParserContext, token: Token) {
        
    }


    func matchToken(state: Int, token: Token, context: ParserContext) throws -> Int {
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
    @foreach(var state in Model.States.Values.Where(s => !s.IsEndState))
    {<text>
    # @Raw(state.Comment)
    def match_token_at_@(state.Id)(token, context)
    @foreach(var transition in state.Transitions)
    {
    @:if @MatchToken(transition.TokenType)
    if (transition.LookAheadHint != null)
    {
    @:if lookahead_@(transition.LookAheadHint.Id)(context, token)
    }
    foreach(var production in transition.Productions)
    {
    @CallProduction(production)
    }
    @:return @transition.TargetState
    if (transition.LookAheadHint != null)
    {
    @:end
    }
    @:end
    }
    @HandleParserError(state.Transitions.Select(t => "#" + t.TokenType.ToString()).Distinct(), state)
    end</text>
    }
    */
    func matchTokenAt0(token: Token, context: ParserContext) {
        
    }
    
    
    
    
    
    
    
    private func handleASTError(context: AnyObject, action: () throws -> Void ) {
        
        handleExternalError(context, defaultValue: true, action: action)
    }
    
    private func handleExternalError(context: AnyObject, defaultValue: Bool, action: () throws -> Void ) {
        
        
    }
}



















