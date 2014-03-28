using System;
using System.Collections.Generic;
namespace Gherkin
{
	public enum TokenType
	{
		None,
EOF,
Empty,
Comment,
TagLine,
Feature,
Background,
Scenario,
ScenarioOutline,
Examples,
Step,
MultiLineArgument,
TableRow,
Other,
	}

	public enum RuleType
	{
		None,
_EOF, // #EOF
_Empty, // #Empty
_Comment, // #Comment
_TagLine, // #TagLine
_Feature, // #Feature
_Background, // #Background
_Scenario, // #Scenario
_ScenarioOutline, // #ScenarioOutline
_Examples, // #Examples
_Step, // #Step
_MultiLineArgument, // #MultiLineArgument
_TableRow, // #TableRow
_Other, // #Other
Feature_File, // Feature_File! := Feature_Def Background? Scenario_Base*
Feature_Def, // Feature_Def! := #TagLine* #Feature Feature_Description
Background, // Background! := #Background Background_Description Scenario_Step*
Scenario_Base, // Scenario_Base! := #TagLine* Scenario_Base_Body
Scenario_Base_Body, // Scenario_Base_Body := (Scenario | ScenarioOutline)
Scenario, // Scenario! := #Scenario Scenario_Description Scenario_Step*
ScenarioOutline, // ScenarioOutline! := #ScenarioOutline ScenarioOutline_Description ScenarioOutline_Step* Examples+
Examples, // Examples! := #TagLine[#Empty|#Comment|#TagLine-&gt;#Examples]* #Examples Examples_Description Examples_Table
Examples_Table, // Examples_Table! := #TableRow+
Scenario_Step, // Scenario_Step := Step
ScenarioOutline_Step, // ScenarioOutline_Step := Step
Step, // Step! := #Step Step_Arg?
Step_Arg, // Step_Arg := (Table_And_Multiline_Arg | Multiline_And_Table_Arg)
Table_And_Multiline_Arg, // Table_And_Multiline_Arg := Table_Arg Multiline_Arg?
Multiline_And_Table_Arg, // Multiline_And_Table_Arg := Multiline_Arg Table_Arg?
Table_Arg, // Table_Arg! := #TableRow+
Multiline_Arg, // Multiline_Arg! := #MultiLineArgument Multiline_Arg_Line* #MultiLineArgument
Multiline_Arg_Line, // Multiline_Arg_Line := (#Empty | #Other)
Feature_Description, // Feature_Description := Description_Helper
Background_Description, // Background_Description := Description_Helper
Scenario_Description, // Scenario_Description := Description_Helper
ScenarioOutline_Description, // ScenarioOutline_Description := Description_Helper
Examples_Description, // Examples_Description := Description_Helper
Description_Helper, // Description_Helper := Description? #Comment*
Description, // Description! := Description_Line+
Description_Line, // Description_Line := (#Empty | #Other)
	}

    public partial class ParserError
    {
        public string StateComment { get; private set; }

        public Token ReceivedToken { get; private set; }
        public string[] ExpectedTokenTypes { get; private set; }

        public ParserError(Token receivedToken, string[] expectedTokenTypes, string stateComment)
        {
            this.ReceivedToken = receivedToken;
            this.ExpectedTokenTypes = expectedTokenTypes;
            this.StateComment = stateComment;
        }
    }

    public partial class ParserException : Exception
    {
        private ParserError[] errors = new ParserError[0];

        public ParserError[] Errors { get { return errors; } }

        public ParserException() { }
        public ParserException(string message) : base(message) { }
        public ParserException(string message, Exception inner) : base(message, inner) { }

        public ParserException(ParserMessageProvider messageProvider, params ParserError[] errors) 
			: base(messageProvider.GetDefaultExceptionMessage(errors))
        {
            if (errors != null)
                this.errors = errors;
        }
    }

    public partial class Parser
    {
		public bool StopAtFirstError { get; set;}
		public ParserMessageProvider ParserMessageProvider { get; private set; }

		class ParserContext
		{
			public TokenScanner TokenScanner { get; set; }
			public TokenMatcher TokenMatcher { get; set; }
			public AstBuilder Builder { get; set; }
			public Queue<Token> TokenQueue { get; set; }
			public List<ParserError> Errors { get; set; }
		}

		public Parser() : this(new ParserMessageProvider())
		{
		}

		public object Parse(TokenScanner tokenScanner)
		{
			return Parse(tokenScanner, new TokenMatcher(), new AstBuilder());
		}

		public Parser(ParserMessageProvider parserMessageProvider)
		{
			this.ParserMessageProvider = parserMessageProvider;
		}

        public object Parse(TokenScanner tokenScanner, TokenMatcher tokenMatcher, AstBuilder astBuilder)
		{
			var context = new ParserContext
			{
				TokenScanner = tokenScanner,
				TokenMatcher = tokenMatcher,
				Builder = astBuilder,
				TokenQueue = new Queue<Token>(),
				Errors = new List<ParserError>()
			};

			StartRule(context, RuleType.Feature_File);
            int state = 0;
            Token token;
            do
			{
				token = ReadToken(context);
				state = MatchToken(state, token, context);
            } while(!token.IsEOF);

			if (context.Errors.Count > 0)
			{
				throw new ParserException(ParserMessageProvider, context.Errors.ToArray());
			}

			if (state != 32)
			{
				throw new InvalidOperationException("One of the grammar rules expected #EOF explicitly.");
			}

			EndRule(context, RuleType.Feature_File);
			return GetResult(context);
		}

		void Build(ParserContext context, Token token)
		{
			context.Builder.Build(token);
		}

		void StartRule(ParserContext context, RuleType ruleType)
		{
			context.Builder.StartRule(ruleType);
		}

		void EndRule(ParserContext context, RuleType ruleType)
		{
			context.Builder.EndRule(ruleType);
		}

		object GetResult(ParserContext context)
		{
			return context.Builder.GetResult();
		}

		Token ReadToken(ParserContext context)
		{
			return context.TokenQueue.Count > 0 ? context.TokenQueue.Dequeue() : context.TokenScanner.Read();
		}

		int MatchToken(int state, Token token, ParserContext context)
		{
			int newState;
			switch(state)
			{
				case 0:
					newState = MatchTokenAt_0(token, context);
					break;
				case 1:
					newState = MatchTokenAt_1(token, context);
					break;
				case 2:
					newState = MatchTokenAt_2(token, context);
					break;
				case 3:
					newState = MatchTokenAt_3(token, context);
					break;
				case 4:
					newState = MatchTokenAt_4(token, context);
					break;
				case 5:
					newState = MatchTokenAt_5(token, context);
					break;
				case 6:
					newState = MatchTokenAt_6(token, context);
					break;
				case 7:
					newState = MatchTokenAt_7(token, context);
					break;
				case 8:
					newState = MatchTokenAt_8(token, context);
					break;
				case 9:
					newState = MatchTokenAt_9(token, context);
					break;
				case 10:
					newState = MatchTokenAt_10(token, context);
					break;
				case 11:
					newState = MatchTokenAt_11(token, context);
					break;
				case 12:
					newState = MatchTokenAt_12(token, context);
					break;
				case 13:
					newState = MatchTokenAt_13(token, context);
					break;
				case 14:
					newState = MatchTokenAt_14(token, context);
					break;
				case 15:
					newState = MatchTokenAt_15(token, context);
					break;
				case 16:
					newState = MatchTokenAt_16(token, context);
					break;
				case 17:
					newState = MatchTokenAt_17(token, context);
					break;
				case 18:
					newState = MatchTokenAt_18(token, context);
					break;
				case 19:
					newState = MatchTokenAt_19(token, context);
					break;
				case 20:
					newState = MatchTokenAt_20(token, context);
					break;
				case 21:
					newState = MatchTokenAt_21(token, context);
					break;
				case 22:
					newState = MatchTokenAt_22(token, context);
					break;
				case 23:
					newState = MatchTokenAt_23(token, context);
					break;
				case 24:
					newState = MatchTokenAt_24(token, context);
					break;
				case 25:
					newState = MatchTokenAt_25(token, context);
					break;
				case 26:
					newState = MatchTokenAt_26(token, context);
					break;
				case 27:
					newState = MatchTokenAt_27(token, context);
					break;
				case 28:
					newState = MatchTokenAt_28(token, context);
					break;
				case 29:
					newState = MatchTokenAt_29(token, context);
					break;
				case 30:
					newState = MatchTokenAt_30(token, context);
					break;
				case 31:
					newState = MatchTokenAt_31(token, context);
					break;
				case 33:
					newState = MatchTokenAt_33(token, context);
					break;
				case 34:
					newState = MatchTokenAt_34(token, context);
					break;
				case 35:
					newState = MatchTokenAt_35(token, context);
					break;
				case 36:
					newState = MatchTokenAt_36(token, context);
					break;
				case 37:
					newState = MatchTokenAt_37(token, context);
					break;
				case 38:
					newState = MatchTokenAt_38(token, context);
					break;
				case 39:
					newState = MatchTokenAt_39(token, context);
					break;
				case 40:
					newState = MatchTokenAt_40(token, context);
					break;
				case 41:
					newState = MatchTokenAt_41(token, context);
					break;
				default:
					throw new InvalidOperationException("Unknown state: " + state);
			}
			return newState;
		}

		
		// Start
		int MatchTokenAt_0(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				StartRule(context, RuleType.Feature_Def);
				Build(context, token);
				return 1;
			}
			if (	context.TokenMatcher.Match_Feature(token)
)
			{
				StartRule(context, RuleType.Feature_Def);
				Build(context, token);
				return 2;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 0;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 0;
			}
				var error = new ParserError(token, new string[] {"#TagLine", "#Feature", "#Comment", "#Empty"}, "State: 0 - Start");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 0;

		}
		
		
		// Feature_File:0>Feature_Def:0>#TagLine:0
		int MatchTokenAt_1(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				Build(context, token);
				return 1;
			}
			if (	context.TokenMatcher.Match_Feature(token)
)
			{
				Build(context, token);
				return 2;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 1;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 1;
			}
				var error = new ParserError(token, new string[] {"#TagLine", "#Feature", "#Comment", "#Empty"}, "State: 1 - Feature_File:0>Feature_Def:0>#TagLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 1;

		}
		
		
		// Feature_File:0>Feature_Def:1>#Feature:0
		int MatchTokenAt_2(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Feature_Def);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 3;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 4;
			}
			if (	context.TokenMatcher.Match_Background(token)
)
			{
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Background);
				Build(context, token);
				return 5;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 3;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#Background", "#TagLine", "#Scenario", "#ScenarioOutline", "#Other"}, "State: 2 - Feature_File:0>Feature_Def:1>#Feature:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 2;

		}
		
		
		// Feature_File:0>Feature_Def:2>Feature_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
		int MatchTokenAt_3(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Feature_Def);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 3;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				EndRule(context, RuleType.Description);
				Build(context, token);
				return 4;
			}
			if (	context.TokenMatcher.Match_Background(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Background);
				Build(context, token);
				return 5;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 3;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#Background", "#TagLine", "#Scenario", "#ScenarioOutline", "#Other"}, "State: 3 - Feature_File:0>Feature_Def:2>Feature_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 3;

		}
		
		
		// Feature_File:0>Feature_Def:2>Feature_Description:0>Description_Helper:1>#Comment:0
		int MatchTokenAt_4(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Feature_Def);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 4;
			}
			if (	context.TokenMatcher.Match_Background(token)
)
			{
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Background);
				Build(context, token);
				return 5;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Feature_Def);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 4;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Comment", "#Background", "#TagLine", "#Scenario", "#ScenarioOutline", "#Empty"}, "State: 4 - Feature_File:0>Feature_Def:2>Feature_Description:0>Description_Helper:1>#Comment:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 4;

		}
		
		
		// Feature_File:1>Background:0>#Background:0
		int MatchTokenAt_5(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 6;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 7;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 6;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Other"}, "State: 5 - Feature_File:1>Background:0>#Background:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 5;

		}
		
		
		// Feature_File:1>Background:1>Background_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
		int MatchTokenAt_6(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 6;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				EndRule(context, RuleType.Description);
				Build(context, token);
				return 7;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Description);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 6;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Other"}, "State: 6 - Feature_File:1>Background:1>Background_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 6;

		}
		
		
		// Feature_File:1>Background:1>Background_Description:0>Description_Helper:1>#Comment:0
		int MatchTokenAt_7(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 7;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 7;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Comment", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Empty"}, "State: 7 - Feature_File:1>Background:1>Background_Description:0>Description_Helper:1>#Comment:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 7;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:0>#Step:0
		int MatchTokenAt_8(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				StartRule(context, RuleType.Table_Arg);
				Build(context, token);
				return 9;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				StartRule(context, RuleType.Multiline_Arg);
				Build(context, token);
				return 39;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 8;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#MultiLineArgument", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 8 - Feature_File:1>Background:2>Scenario_Step:0>Step:0>#Step:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 8;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0
		int MatchTokenAt_9(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 9;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				StartRule(context, RuleType.Multiline_Arg);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 9;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 9;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#MultiLineArgument", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 9 - Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 9;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0
		int MatchTokenAt_10(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 10;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#MultiLineArgument", "#Other"}, "State: 10 - Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 10;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0
		int MatchTokenAt_11(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 11;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 11 - Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 11;

		}
		
		
		// Feature_File:2>Scenario_Base:0>#TagLine:0
		int MatchTokenAt_12(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 12;
			}
				var error = new ParserError(token, new string[] {"#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 12 - Feature_File:2>Scenario_Base:0>#TagLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 12;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:0>#Scenario:0
		int MatchTokenAt_13(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 14;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 15;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 14;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Other"}, "State: 13 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:0>#Scenario:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 13;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
		int MatchTokenAt_14(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 14;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				EndRule(context, RuleType.Description);
				Build(context, token);
				return 15;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Description);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 14;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Other"}, "State: 14 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 14;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:1>#Comment:0
		int MatchTokenAt_15(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 15;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 15;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Comment", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Empty"}, "State: 15 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:1>#Comment:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 15;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:0>#Step:0
		int MatchTokenAt_16(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				StartRule(context, RuleType.Table_Arg);
				Build(context, token);
				return 17;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				StartRule(context, RuleType.Multiline_Arg);
				Build(context, token);
				return 36;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 16;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#MultiLineArgument", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 16 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:0>#Step:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 16;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0
		int MatchTokenAt_17(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 17;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				StartRule(context, RuleType.Multiline_Arg);
				Build(context, token);
				return 18;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 17;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 17;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#MultiLineArgument", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 17 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 17;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0
		int MatchTokenAt_18(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 18;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				Build(context, token);
				return 19;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 18;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#MultiLineArgument", "#Other"}, "State: 18 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 18;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0
		int MatchTokenAt_19(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 19;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 19;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 19 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 19;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:0>#ScenarioOutline:0
		int MatchTokenAt_20(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 21;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 22;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_Examples(token)
)
			{
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 21;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#Comment", "#Step", "#TagLine", "#Examples", "#Other"}, "State: 20 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:0>#ScenarioOutline:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 20;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
		int MatchTokenAt_21(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 21;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				EndRule(context, RuleType.Description);
				Build(context, token);
				return 22;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Description);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Description);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_Examples(token)
)
			{
				EndRule(context, RuleType.Description);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 21;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#Comment", "#Step", "#TagLine", "#Examples", "#Other"}, "State: 21 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 21;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:1>#Comment:0
		int MatchTokenAt_22(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 22;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_Examples(token)
)
			{
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 22;
			}
				var error = new ParserError(token, new string[] {"#Comment", "#Step", "#TagLine", "#Examples", "#Empty"}, "State: 22 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:1>#Comment:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 22;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:0>#Step:0
		int MatchTokenAt_23(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				StartRule(context, RuleType.Table_Arg);
				Build(context, token);
				return 24;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				StartRule(context, RuleType.Multiline_Arg);
				Build(context, token);
				return 33;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_Examples(token)
)
			{
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 23;
			}
				var error = new ParserError(token, new string[] {"#TableRow", "#MultiLineArgument", "#Step", "#TagLine", "#Examples", "#Comment", "#Empty"}, "State: 23 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:0>#Step:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 23;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0
		int MatchTokenAt_24(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 24;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				StartRule(context, RuleType.Multiline_Arg);
				Build(context, token);
				return 25;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_Examples(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 24;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 24;
			}
				var error = new ParserError(token, new string[] {"#TableRow", "#MultiLineArgument", "#Step", "#TagLine", "#Examples", "#Comment", "#Empty"}, "State: 24 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 24;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0
		int MatchTokenAt_25(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 25;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 25;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#MultiLineArgument", "#Other"}, "State: 25 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 25;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0
		int MatchTokenAt_26(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_Examples(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 26;
			}
				var error = new ParserError(token, new string[] {"#Step", "#TagLine", "#Examples", "#Comment", "#Empty"}, "State: 26 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 26;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:0>#TagLine:0
		int MatchTokenAt_27(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_Examples(token)
)
			{
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 27;
			}
				var error = new ParserError(token, new string[] {"#TagLine", "#Examples", "#Comment", "#Empty"}, "State: 27 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:0>#TagLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 27;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:1>#Examples:0
		int MatchTokenAt_28(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 29;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 30;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				StartRule(context, RuleType.Examples_Table);
				Build(context, token);
				return 31;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 29;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#Comment", "#TableRow", "#Other"}, "State: 28 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:1>#Examples:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 28;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
		int MatchTokenAt_29(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 29;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				EndRule(context, RuleType.Description);
				Build(context, token);
				return 30;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				EndRule(context, RuleType.Description);
				StartRule(context, RuleType.Examples_Table);
				Build(context, token);
				return 31;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 29;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#Comment", "#TableRow", "#Other"}, "State: 29 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 29;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:1>#Comment:0
		int MatchTokenAt_30(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 30;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				StartRule(context, RuleType.Examples_Table);
				Build(context, token);
				return 31;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 30;
			}
				var error = new ParserError(token, new string[] {"#Comment", "#TableRow", "#Empty"}, "State: 30 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:1>#Comment:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 30;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:3>Examples_Table:0>#TableRow:0
		int MatchTokenAt_31(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Examples_Table);
				EndRule(context, RuleType.Examples);
				EndRule(context, RuleType.ScenarioOutline);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 31;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				if (LookAhead_0(context, token))
				{
				EndRule(context, RuleType.Examples_Table);
				EndRule(context, RuleType.Examples);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 27;
				}
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Examples_Table);
				EndRule(context, RuleType.Examples);
				EndRule(context, RuleType.ScenarioOutline);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Examples(token)
)
			{
				EndRule(context, RuleType.Examples_Table);
				EndRule(context, RuleType.Examples);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Examples_Table);
				EndRule(context, RuleType.Examples);
				EndRule(context, RuleType.ScenarioOutline);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Examples_Table);
				EndRule(context, RuleType.Examples);
				EndRule(context, RuleType.ScenarioOutline);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 31;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 31;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#TagLine", "#Examples", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 31 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:3>Examples_Table:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 31;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0
		int MatchTokenAt_33(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 33;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				Build(context, token);
				return 34;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 33;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#MultiLineArgument", "#Other"}, "State: 33 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 33;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0
		int MatchTokenAt_34(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				StartRule(context, RuleType.Table_Arg);
				Build(context, token);
				return 35;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_Examples(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 34;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 34;
			}
				var error = new ParserError(token, new string[] {"#TableRow", "#Step", "#TagLine", "#Examples", "#Comment", "#Empty"}, "State: 34 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 34;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0
		int MatchTokenAt_35(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 35;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_Examples(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 35;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 35;
			}
				var error = new ParserError(token, new string[] {"#TableRow", "#Step", "#TagLine", "#Examples", "#Comment", "#Empty"}, "State: 35 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 35;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0
		int MatchTokenAt_36(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 36;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				Build(context, token);
				return 37;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 36;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#MultiLineArgument", "#Other"}, "State: 36 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 36;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0
		int MatchTokenAt_37(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				StartRule(context, RuleType.Table_Arg);
				Build(context, token);
				return 38;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 37;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 37;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 37 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 37;

		}
		
		
		// Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0
		int MatchTokenAt_38(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 38;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 38;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 38;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 38 - Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 38;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0
		int MatchTokenAt_39(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 39;
			}
			if (	context.TokenMatcher.Match_MultiLineArgument(token)
)
			{
				Build(context, token);
				return 40;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 39;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#MultiLineArgument", "#Other"}, "State: 39 - Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 39;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0
		int MatchTokenAt_40(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				StartRule(context, RuleType.Table_Arg);
				Build(context, token);
				return 41;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Multiline_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 40;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 40;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 40 - Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 40;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0
		int MatchTokenAt_41(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 41;
			}
			if (	context.TokenMatcher.Match_Step(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Scenario(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_ScenarioOutline(token)
)
			{
				EndRule(context, RuleType.Table_Arg);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 41;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 41;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#Step", "#TagLine", "#Scenario", "#ScenarioOutline", "#Comment", "#Empty"}, "State: 41 - Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 41;

		}
		

		
		bool LookAhead_0(ParserContext context, Token currentToken)
		{
			currentToken.Detach();
            Token token;
			var queue = new Queue<Token>();
			bool match = false;
		    do
		    {
		        token = ReadToken(context);
				token.Detach();
		        queue.Enqueue(token);

		        if (false
					|| 	context.TokenMatcher.Match_Examples(token)

				)
		        {
					match = true;
					break;
		        }
		    } while (false
				|| 	context.TokenMatcher.Match_Empty(token)

				|| 	context.TokenMatcher.Match_Comment(token)

				|| 	context.TokenMatcher.Match_TagLine(token)

			);
			foreach(var t in queue)
				context.TokenQueue.Enqueue(t);
			return match;
		}
		
	}
}