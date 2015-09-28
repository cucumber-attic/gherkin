// This file is generated. Do not edit! Edit gherkin-swift.razor instead.

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
    case GenericErrorFIXME
}

class ParserContext {
    var tokenScanner: TokenScanner
    var tokenMatcher: TokenMatcher
    var tokenQueue: [Token]
    var errors: [InvalidOperationException]

    init(tokenScanner: TokenScanner, tokenMatcher: TokenMatcher, tokenQueue: [Token], errors: [InvalidOperationException]) {

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

      let context = ParserContext(tokenScanner: tokenScanner, tokenMatcher: tokenMatcher, tokenQueue: [], errors: [])

      startRule(context, ruleType: .Feature)
      var state = 0
      var token: Token?

      while !token!.eof() {

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

      endRule(context, ruleType: .Feature)

      if context.errors.count > 0 {

          throw InvalidOperationException.CompositeParserException
      }

      return getResult()
  }

  func build(context: ParserContext, token: Token) {

      handleASTError(context) { () -> Bool in
          self.astBuilder.build(token)
      }
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

  }


    func matchEOF(context: ParserContext, token: Token) -> Bool {
    }

    func matchEmpty(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchEmpty(token)
             })
      }
    }

    func matchComment(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchComment(token)
             })
      }
    }

    func matchTagLine(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchTagLine(token)
             })
      }
    }

    func matchFeatureLine(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchFeatureLine(token)
             })
      }
    }

    func matchBackgroundLine(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchBackgroundLine(token)
             })
      }
    }

    func matchScenarioLine(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchScenarioLine(token)
             })
      }
    }

    func matchScenarioOutlineLine(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchScenarioOutlineLine(token)
             })
      }
    }

    func matchExamplesLine(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchExamplesLine(token)
             })
      }
    }

    func matchStepLine(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchStepLine(token)
             })
      }
    }

    func matchDocStringSeparator(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchDocStringSeparator(token)
             })
      }
    }

    func matchTableRow(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchTableRow(token)
             })
      }
    }

    func matchLanguage(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchLanguage(token)
             })
      }
    }

    func matchOther(context: ParserContext, token: Token) -> Bool {

      if token.eof() {
        return false
      } else {
        return handleExternalError(context, defaultValue: false, action: { () -> Bool in
                context.tokenMatcher.matchOther(token)
             })
      }
    }

  func matchToken(state: Int, token: Token, context: ParserContext) throws -> Int {
    switch state {
      case 0:
          return matchTokenAt0(token, context: context)
      case 1:
          return matchTokenAt1(token, context: context)
      case 2:
          return matchTokenAt2(token, context: context)
      case 3:
          return matchTokenAt3(token, context: context)
      case 4:
          return matchTokenAt4(token, context: context)
      case 5:
          return matchTokenAt5(token, context: context)
      case 6:
          return matchTokenAt6(token, context: context)
      case 7:
          return matchTokenAt7(token, context: context)
      case 8:
          return matchTokenAt8(token, context: context)
      case 9:
          return matchTokenAt9(token, context: context)
      case 10:
          return matchTokenAt10(token, context: context)
      case 11:
          return matchTokenAt11(token, context: context)
      case 12:
          return matchTokenAt12(token, context: context)
      case 13:
          return matchTokenAt13(token, context: context)
      case 14:
          return matchTokenAt14(token, context: context)
      case 15:
          return matchTokenAt15(token, context: context)
      case 16:
          return matchTokenAt16(token, context: context)
      case 17:
          return matchTokenAt17(token, context: context)
      case 18:
          return matchTokenAt18(token, context: context)
      case 19:
          return matchTokenAt19(token, context: context)
      case 20:
          return matchTokenAt20(token, context: context)
      case 21:
          return matchTokenAt21(token, context: context)
      case 22:
          return matchTokenAt22(token, context: context)
      case 23:
          return matchTokenAt23(token, context: context)
      case 24:
          return matchTokenAt24(token, context: context)
      case 25:
          return matchTokenAt25(token, context: context)
      case 26:
          return matchTokenAt26(token, context: context)
      case 27:
          return matchTokenAt27(token, context: context)
      case 29:
          return matchTokenAt29(token, context: context)
      case 30:
          return matchTokenAt30(token, context: context)
      case 31:
          return matchTokenAt31(token, context: context)
      case 32:
          return matchTokenAt32(token, context: context)
      case 33:
          return matchTokenAt33(token, context: context)
      case 34:
          return matchTokenAt34(token, context: context)
      default:
          throw InvalidOperationException.UnknownState
    }
  }


    // Start
    func matchTokenAt0(token: Token, context: ParserContext) -> Int {
      if matchLanguage(context, token: token) {
        startRule(context, ruleType: .Feature_Header);
        build(context, token);
          return 1
        }
      if matchTagLine(context, token: token) {
        startRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 2
        }
      if matchFeatureLine(context, token: token) {
        startRule(context, ruleType: .Feature_Header);
        build(context, token);
          return 3
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 0
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 0
        }
    
      let state_comment: String = "State: 0 - Start"
      token.detach()
      let expected_tokens = ["#Language", "#TagLine", "#FeatureLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 0
    }

    // Feature:0>Feature_Header:0>#Language:0
    func matchTokenAt1(token: Token, context: ParserContext) -> Int {
      if matchTagLine(context, token: token) {
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 2
        }
      if matchFeatureLine(context, token: token) {
        build(context, token);
          return 3
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 1
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 1
        }
    
      let state_comment: String = "State: 1 - Feature:0>Feature_Header:0>#Language:0"
      token.detach()
      let expected_tokens = ["#TagLine", "#FeatureLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 1
    }

    // Feature:0>Feature_Header:1>Tags:0>#TagLine:0
    func matchTokenAt2(token: Token, context: ParserContext) -> Int {
      if matchTagLine(context, token: token) {
        build(context, token);
          return 2
        }
      if matchFeatureLine(context, token: token) {
        endRule(context, ruleType: .Tags);
        build(context, token);
          return 3
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 2
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 2
        }
    
      let state_comment: String = "State: 2 - Feature:0>Feature_Header:1>Tags:0>#TagLine:0"
      token.detach()
      let expected_tokens = ["#TagLine", "#FeatureLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 2
    }

    // Feature:0>Feature_Header:2>#FeatureLine:0
    func matchTokenAt3(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Feature_Header);
        build(context, token);
          return 28
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 3
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 5
        }
      if matchBackgroundLine(context, token: token) {
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Background);
        build(context, token);
          return 6
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchOther(context, token: token) {
        startRule(context, ruleType: .Description);
        build(context, token);
          return 4
        }
    
      let state_comment: String = "State: 3 - Feature:0>Feature_Header:2>#FeatureLine:0"
      token.detach()
      let expected_tokens = ["#EOF", "#Empty", "#Comment", "#BackgroundLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 3
    }

    // Feature:0>Feature_Header:3>Feature_Description:0>Description_Helper:1>Description:0>#Other:0
    func matchTokenAt4(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Feature_Header);
        build(context, token);
          return 28
        }
      if matchComment(context, token: token) {
        endRule(context, ruleType: .Description);
        build(context, token);
          return 5
        }
      if matchBackgroundLine(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Background);
        build(context, token);
          return 6
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchOther(context, token: token) {
        build(context, token);
          return 4
        }
    
      let state_comment: String = "State: 4 - Feature:0>Feature_Header:3>Feature_Description:0>Description_Helper:1>Description:0>#Other:0"
      token.detach()
      let expected_tokens = ["#EOF", "#Comment", "#BackgroundLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 4
    }

    // Feature:0>Feature_Header:3>Feature_Description:0>Description_Helper:2>#Comment:0
    func matchTokenAt5(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Feature_Header);
        build(context, token);
          return 28
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 5
        }
      if matchBackgroundLine(context, token: token) {
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Background);
        build(context, token);
          return 6
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Feature_Header);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 5
        }
    
      let state_comment: String = "State: 5 - Feature:0>Feature_Header:3>Feature_Description:0>Description_Helper:2>#Comment:0"
      token.detach()
      let expected_tokens = ["#EOF", "#Comment", "#BackgroundLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 5
    }

    // Feature:1>Background:0>#BackgroundLine:0
    func matchTokenAt6(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Background);
        build(context, token);
          return 28
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 6
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 8
        }
      if matchStepLine(context, token: token) {
        startRule(context, ruleType: .Step);
        build(context, token);
          return 9
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchOther(context, token: token) {
        startRule(context, ruleType: .Description);
        build(context, token);
          return 7
        }
    
      let state_comment: String = "State: 6 - Feature:1>Background:0>#BackgroundLine:0"
      token.detach()
      let expected_tokens = ["#EOF", "#Empty", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 6
    }

    // Feature:1>Background:1>Background_Description:0>Description_Helper:1>Description:0>#Other:0
    func matchTokenAt7(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Background);
        build(context, token);
          return 28
        }
      if matchComment(context, token: token) {
        endRule(context, ruleType: .Description);
        build(context, token);
          return 8
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .Description);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 9
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchOther(context, token: token) {
        build(context, token);
          return 7
        }
    
      let state_comment: String = "State: 7 - Feature:1>Background:1>Background_Description:0>Description_Helper:1>Description:0>#Other:0"
      token.detach()
      let expected_tokens = ["#EOF", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 7
    }

    // Feature:1>Background:1>Background_Description:0>Description_Helper:2>#Comment:0
    func matchTokenAt8(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Background);
        build(context, token);
          return 28
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 8
        }
      if matchStepLine(context, token: token) {
        startRule(context, ruleType: .Step);
        build(context, token);
          return 9
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 8
        }
    
      let state_comment: String = "State: 8 - Feature:1>Background:1>Background_Description:0>Description_Helper:2>#Comment:0"
      token.detach()
      let expected_tokens = ["#EOF", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 8
    }

    // Feature:1>Background:2>Scenario_Step:0>Step:0>#StepLine:0
    func matchTokenAt9(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        build(context, token);
          return 28
        }
      if matchTableRow(context, token: token) {
        startRule(context, ruleType: .DataTable);
        build(context, token);
          return 10
        }
      if matchDocStringSeparator(context, token: token) {
        startRule(context, ruleType: .DocString);
        build(context, token);
          return 33
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 9
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 9
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 9
        }
    
      let state_comment: String = "State: 9 - Feature:1>Background:2>Scenario_Step:0>Step:0>#StepLine:0"
      token.detach()
      let expected_tokens = ["#EOF", "#TableRow", "#DocStringSeparator", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 9
    }

    // Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0
    func matchTokenAt10(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        build(context, token);
          return 28
        }
      if matchTableRow(context, token: token) {
        build(context, token);
          return 10
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 9
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 10
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 10
        }
    
      let state_comment: String = "State: 10 - Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0"
      token.detach()
      let expected_tokens = ["#EOF", "#TableRow", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 10
    }

    // Feature:2>Scenario_Definition:0>Tags:0>#TagLine:0
    func matchTokenAt11(token: Token, context: ParserContext) -> Int {
      if matchTagLine(context, token: token) {
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Tags);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Tags);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 11
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 11
        }
    
      let state_comment: String = "State: 11 - Feature:2>Scenario_Definition:0>Tags:0>#TagLine:0"
      token.detach()
      let expected_tokens = ["#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 11
    }

    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:0>#ScenarioLine:0
    func matchTokenAt12(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        build(context, token);
          return 28
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 12
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 14
        }
      if matchStepLine(context, token: token) {
        startRule(context, ruleType: .Step);
        build(context, token);
          return 15
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchOther(context, token: token) {
        startRule(context, ruleType: .Description);
        build(context, token);
          return 13
        }
    
      let state_comment: String = "State: 12 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:0>#ScenarioLine:0"
      token.detach()
      let expected_tokens = ["#EOF", "#Empty", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 12
    }

    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:1>Description:0>#Other:0
    func matchTokenAt13(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        build(context, token);
          return 28
        }
      if matchComment(context, token: token) {
        endRule(context, ruleType: .Description);
        build(context, token);
          return 14
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .Description);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 15
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Description);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchOther(context, token: token) {
        build(context, token);
          return 13
        }
    
      let state_comment: String = "State: 13 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:1>Description:0>#Other:0"
      token.detach()
      let expected_tokens = ["#EOF", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 13
    }

    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:2>#Comment:0
    func matchTokenAt14(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        build(context, token);
          return 28
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 14
        }
      if matchStepLine(context, token: token) {
        startRule(context, ruleType: .Step);
        build(context, token);
          return 15
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 14
        }
    
      let state_comment: String = "State: 14 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:2>#Comment:0"
      token.detach()
      let expected_tokens = ["#EOF", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 14
    }

    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:0>#StepLine:0
    func matchTokenAt15(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        build(context, token);
          return 28
        }
      if matchTableRow(context, token: token) {
        startRule(context, ruleType: .DataTable);
        build(context, token);
          return 16
        }
      if matchDocStringSeparator(context, token: token) {
        startRule(context, ruleType: .DocString);
        build(context, token);
          return 31
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 15
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 15
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 15
        }
    
      let state_comment: String = "State: 15 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:0>#StepLine:0"
      token.detach()
      let expected_tokens = ["#EOF", "#TableRow", "#DocStringSeparator", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 15
    }

    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0
    func matchTokenAt16(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        build(context, token);
          return 28
        }
      if matchTableRow(context, token: token) {
        build(context, token);
          return 16
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 15
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 16
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 16
        }
    
      let state_comment: String = "State: 16 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0"
      token.detach()
      let expected_tokens = ["#EOF", "#TableRow", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 16
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:0>#ScenarioOutlineLine:0
    func matchTokenAt17(token: Token, context: ParserContext) -> Int {
      if matchEmpty(context, token: token) {
        build(context, token);
          return 17
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 19
        }
      if matchStepLine(context, token: token) {
        startRule(context, ruleType: .Step);
        build(context, token);
          return 20
        }
      if matchTagLine(context, token: token) {
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 22
        }
      if matchExamplesLine(context, token: token) {
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Examples);
        build(context, token);
          return 23
        }
      if matchOther(context, token: token) {
        startRule(context, ruleType: .Description);
        build(context, token);
          return 18
        }
    
      let state_comment: String = "State: 17 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:0>#ScenarioOutlineLine:0"
      token.detach()
      let expected_tokens = ["#Empty", "#Comment", "#StepLine", "#TagLine", "#ExamplesLine", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 17
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:1>Description:0>#Other:0
    func matchTokenAt18(token: Token, context: ParserContext) -> Int {
      if matchComment(context, token: token) {
        endRule(context, ruleType: .Description);
        build(context, token);
          return 19
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .Description);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 20
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Description);
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 22
        }
      if matchExamplesLine(context, token: token) {
        endRule(context, ruleType: .Description);
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Examples);
        build(context, token);
          return 23
        }
      if matchOther(context, token: token) {
        build(context, token);
          return 18
        }
    
      let state_comment: String = "State: 18 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:1>Description:0>#Other:0"
      token.detach()
      let expected_tokens = ["#Comment", "#StepLine", "#TagLine", "#ExamplesLine", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 18
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:2>#Comment:0
    func matchTokenAt19(token: Token, context: ParserContext) -> Int {
      if matchComment(context, token: token) {
        build(context, token);
          return 19
        }
      if matchStepLine(context, token: token) {
        startRule(context, ruleType: .Step);
        build(context, token);
          return 20
        }
      if matchTagLine(context, token: token) {
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 22
        }
      if matchExamplesLine(context, token: token) {
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Examples);
        build(context, token);
          return 23
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 19
        }
    
      let state_comment: String = "State: 19 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:2>#Comment:0"
      token.detach()
      let expected_tokens = ["#Comment", "#StepLine", "#TagLine", "#ExamplesLine", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 19
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:0>#StepLine:0
    func matchTokenAt20(token: Token, context: ParserContext) -> Int {
      if matchTableRow(context, token: token) {
        startRule(context, ruleType: .DataTable);
        build(context, token);
          return 21
        }
      if matchDocStringSeparator(context, token: token) {
        startRule(context, ruleType: .DocString);
        build(context, token);
          return 29
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 20
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 22
        }
      if matchExamplesLine(context, token: token) {
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Examples);
        build(context, token);
          return 23
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 20
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 20
        }
    
      let state_comment: String = "State: 20 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:0>#StepLine:0"
      token.detach()
      let expected_tokens = ["#TableRow", "#DocStringSeparator", "#StepLine", "#TagLine", "#ExamplesLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 20
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0
    func matchTokenAt21(token: Token, context: ParserContext) -> Int {
      if matchTableRow(context, token: token) {
        build(context, token);
          return 21
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 20
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 22
        }
      if matchExamplesLine(context, token: token) {
        endRule(context, ruleType: .DataTable);
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Examples);
        build(context, token);
          return 23
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 21
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 21
        }
    
      let state_comment: String = "State: 21 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0"
      token.detach()
      let expected_tokens = ["#TableRow", "#StepLine", "#TagLine", "#ExamplesLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 21
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:0>Tags:0>#TagLine:0
    func matchTokenAt22(token: Token, context: ParserContext) -> Int {
      if matchTagLine(context, token: token) {
        build(context, token);
          return 22
        }
      if matchExamplesLine(context, token: token) {
        endRule(context, ruleType: .Tags);
        startRule(context, ruleType: .Examples);
        build(context, token);
          return 23
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 22
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 22
        }
    
      let state_comment: String = "State: 22 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:0>Tags:0>#TagLine:0"
      token.detach()
      let expected_tokens = ["#TagLine", "#ExamplesLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 22
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:1>Examples:0>#ExamplesLine:0
    func matchTokenAt23(token: Token, context: ParserContext) -> Int {
      if matchEmpty(context, token: token) {
        build(context, token);
          return 23
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 25
        }
      if matchTableRow(context, token: token) {
        build(context, token);
          return 26
        }
      if matchOther(context, token: token) {
        startRule(context, ruleType: .Description);
        build(context, token);
          return 24
        }
    
      let state_comment: String = "State: 23 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:1>Examples:0>#ExamplesLine:0"
      token.detach()
      let expected_tokens = ["#Empty", "#Comment", "#TableRow", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 23
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:1>Examples:1>Examples_Description:0>Description_Helper:1>Description:0>#Other:0
    func matchTokenAt24(token: Token, context: ParserContext) -> Int {
      if matchComment(context, token: token) {
        endRule(context, ruleType: .Description);
        build(context, token);
          return 25
        }
      if matchTableRow(context, token: token) {
        endRule(context, ruleType: .Description);
        build(context, token);
          return 26
        }
      if matchOther(context, token: token) {
        build(context, token);
          return 24
        }
    
      let state_comment: String = "State: 24 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:1>Examples:1>Examples_Description:0>Description_Helper:1>Description:0>#Other:0"
      token.detach()
      let expected_tokens = ["#Comment", "#TableRow", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 24
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:1>Examples:1>Examples_Description:0>Description_Helper:2>#Comment:0
    func matchTokenAt25(token: Token, context: ParserContext) -> Int {
      if matchComment(context, token: token) {
        build(context, token);
          return 25
        }
      if matchTableRow(context, token: token) {
        build(context, token);
          return 26
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 25
        }
    
      let state_comment: String = "State: 25 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:1>Examples:1>Examples_Description:0>Description_Helper:2>#Comment:0"
      token.detach()
      let expected_tokens = ["#Comment", "#TableRow", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 25
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:1>Examples:2>#TableRow:0
    func matchTokenAt26(token: Token, context: ParserContext) -> Int {
      if matchTableRow(context, token: token) {
        build(context, token);
          return 27
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 26
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 26
        }
    
      let state_comment: String = "State: 26 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:1>Examples:2>#TableRow:0"
      token.detach()
      let expected_tokens = ["#TableRow", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 26
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:1>Examples:3>#TableRow:0
    func matchTokenAt27(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .Examples);
        endRule(context, ruleType: .Examples_Definition);
        endRule(context, ruleType: .ScenarioOutline);
        endRule(context, ruleType: .Scenario_Definition);
        build(context, token);
          return 28
        }
      if matchTableRow(context, token: token) {
        build(context, token);
          return 27
        }
      if matchTagLine(context, token: token) {
        if lookahead0(context, token: token) {
        endRule(context, ruleType: .Examples);
        endRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 22
        }
      }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .Examples);
        endRule(context, ruleType: .Examples_Definition);
        endRule(context, ruleType: .ScenarioOutline);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchExamplesLine(context, token: token) {
        endRule(context, ruleType: .Examples);
        endRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Examples);
        build(context, token);
          return 23
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .Examples);
        endRule(context, ruleType: .Examples_Definition);
        endRule(context, ruleType: .ScenarioOutline);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .Examples);
        endRule(context, ruleType: .Examples_Definition);
        endRule(context, ruleType: .ScenarioOutline);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 27
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 27
        }
    
      let state_comment: String = "State: 27 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples_Definition:1>Examples:3>#TableRow:0"
      token.detach()
      let expected_tokens = ["#EOF", "#TableRow", "#TagLine", "#ExamplesLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 27
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0
    func matchTokenAt29(token: Token, context: ParserContext) -> Int {
      if matchDocStringSeparator(context, token: token) {
        build(context, token);
          return 30
        }
      if matchOther(context, token: token) {
        build(context, token);
          return 29
        }
    
      let state_comment: String = "State: 29 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0"
      token.detach()
      let expected_tokens = ["#DocStringSeparator", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 29
    }

    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0
    func matchTokenAt30(token: Token, context: ParserContext) -> Int {
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 20
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 22
        }
      if matchExamplesLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Examples_Definition);
        startRule(context, ruleType: .Examples);
        build(context, token);
          return 23
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 30
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 30
        }
    
      let state_comment: String = "State: 30 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0"
      token.detach()
      let expected_tokens = ["#StepLine", "#TagLine", "#ExamplesLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 30
    }

    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0
    func matchTokenAt31(token: Token, context: ParserContext) -> Int {
      if matchDocStringSeparator(context, token: token) {
        build(context, token);
          return 32
        }
      if matchOther(context, token: token) {
        build(context, token);
          return 31
        }
    
      let state_comment: String = "State: 31 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0"
      token.detach()
      let expected_tokens = ["#DocStringSeparator", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 31
    }

    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0
    func matchTokenAt32(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        build(context, token);
          return 28
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 15
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Scenario);
        endRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 32
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 32
        }
    
      let state_comment: String = "State: 32 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0"
      token.detach()
      let expected_tokens = ["#EOF", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 32
    }

    // Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0
    func matchTokenAt33(token: Token, context: ParserContext) -> Int {
      if matchDocStringSeparator(context, token: token) {
        build(context, token);
          return 34
        }
      if matchOther(context, token: token) {
        build(context, token);
          return 33
        }
    
      let state_comment: String = "State: 33 - Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0"
      token.detach()
      let expected_tokens = ["#DocStringSeparator", "#Other"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 33
    }

    // Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0
    func matchTokenAt34(token: Token, context: ParserContext) -> Int {
      if matchEOF(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        build(context, token);
          return 28
        }
      if matchStepLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        startRule(context, ruleType: .Step);
        build(context, token);
          return 9
        }
      if matchTagLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Tags);
        build(context, token);
          return 11
        }
      if matchScenarioLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .Scenario);
        build(context, token);
          return 12
        }
      if matchScenarioOutlineLine(context, token: token) {
        endRule(context, ruleType: .DocString);
        endRule(context, ruleType: .Step);
        endRule(context, ruleType: .Background);
        startRule(context, ruleType: .Scenario_Definition);
        startRule(context, ruleType: .ScenarioOutline);
        build(context, token);
          return 17
        }
      if matchComment(context, token: token) {
        build(context, token);
          return 34
        }
      if matchEmpty(context, token: token) {
        build(context, token);
          return 34
        }
    
      let state_comment: String = "State: 34 - Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0"
      token.detach()
      let expected_tokens = ["#EOF", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"]
      let error = token.eof() ? UnexpectedEOFException.new(token, expected_tokens, state_comment) : UnexpectedTokenException.new(token, expected_tokens, state_comment)
      if stopAtFirstError {
        throw InvalidOperationException.GenericErrorFIXME
      }
      addError(context, error)
      return 34
    }



  private func handleASTError(context: ParserContext, action: () throws -> Bool ) -> Bool {

      handleExternalError(context, defaultValue: true, action: action)
  }

  private func handleExternalError(context: ParserContext, defaultValue: Bool, action: () throws -> Bool ) -> Bool {

  }
