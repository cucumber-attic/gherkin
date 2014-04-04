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
FeatureLine,
BackgroundLine,
ScenarioLine,
ScenarioOutlineLine,
ExamplesLine,
StepLine,
DocStringSeparator,
DocStringAlternativeSeparator,
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
_FeatureLine, // #FeatureLine
_BackgroundLine, // #BackgroundLine
_ScenarioLine, // #ScenarioLine
_ScenarioOutlineLine, // #ScenarioOutlineLine
_ExamplesLine, // #ExamplesLine
_StepLine, // #StepLine
_DocStringSeparator, // #DocStringSeparator
_DocStringAlternativeSeparator, // #DocStringAlternativeSeparator
_TableRow, // #TableRow
_Other, // #Other
Feature_File, // Feature_File! := Feature_Header Background? Scenario_Base*
Feature_Header, // Feature_Header! := Tags? #FeatureLine Feature_Description
Background, // Background! := #BackgroundLine Background_Description Scenario_Step*
Scenario_Base, // Scenario_Base! := Tags? (Scenario | ScenarioOutline)
Scenario, // Scenario! := #ScenarioLine Scenario_Description Scenario_Step*
ScenarioOutline, // ScenarioOutline! := #ScenarioOutlineLine ScenarioOutline_Description ScenarioOutline_Step* Examples+
Examples, // Examples! [#Empty|#Comment|#TagLine-&gt;#ExamplesLine] := Tags? #ExamplesLine Examples_Description Examples_Table
Examples_Table, // Examples_Table := #TableRow+
Scenario_Step, // Scenario_Step := Step
ScenarioOutline_Step, // ScenarioOutline_Step := Step
Step, // Step! := #StepLine Step_Arg?
Step_Arg, // Step_Arg := (DataTable | DocString)
DataTable, // DataTable! := #TableRow+
DocString, // DocString! := (DocString_QuoteSepatator | DocString_AlternativeSepatator)
DocString_QuoteSepatator, // DocString_QuoteSepatator := #DocStringSeparator (#Empty | #Other)* #DocStringSeparator
DocString_AlternativeSepatator, // DocString_AlternativeSepatator := #DocStringAlternativeSeparator (#Empty | #Other)* #DocStringAlternativeSeparator
Tags, // Tags! := #TagLine+
Feature_Description, // Feature_Description := Description_Helper
Background_Description, // Background_Description := Description_Helper
Scenario_Description, // Scenario_Description := Description_Helper
ScenarioOutline_Description, // ScenarioOutline_Description := Description_Helper
Examples_Description, // Examples_Description := Description_Helper
Description_Helper, // Description_Helper := Description? #Comment*
Description, // Description! := (#Empty | #Other)+
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
			public IAstBuilder Builder { get; set; }
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

        public object Parse(TokenScanner tokenScanner, TokenMatcher tokenMatcher, IAstBuilder astBuilder)
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

			if (state != 26)
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
				case 32:
					newState = MatchTokenAt_32(token, context);
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
				StartRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 1;
			}
			if (	context.TokenMatcher.Match_FeatureLine(token)
)
			{
				StartRule(context, RuleType.Feature_Header);
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
				var error = new ParserError(token, new string[] {"#TagLine", "#FeatureLine", "#Comment", "#Empty"}, "State: 0 - Start");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 0;

		}
		
		
		// Feature_File:0>Feature_Header:0>Tags:0>#TagLine:0
		int MatchTokenAt_1(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				Build(context, token);
				return 1;
			}
			if (	context.TokenMatcher.Match_FeatureLine(token)
)
			{
				EndRule(context, RuleType.Tags);
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
				var error = new ParserError(token, new string[] {"#TagLine", "#FeatureLine", "#Comment", "#Empty"}, "State: 1 - Feature_File:0>Feature_Header:0>Tags:0>#TagLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 1;

		}
		
		
		// Feature_File:0>Feature_Header:1>#FeatureLine:0
		int MatchTokenAt_2(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Feature_Header);
				Build(context, token);
				return 26;
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
			if (	context.TokenMatcher.Match_BackgroundLine(token)
)
			{
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Background);
				Build(context, token);
				return 5;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 3;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#BackgroundLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"}, "State: 2 - Feature_File:0>Feature_Header:1>#FeatureLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 2;

		}
		
		
		// Feature_File:0>Feature_Header:2>Feature_Description:0>Description_Helper:0>Description:0>__alt5:0>#Empty:0
		int MatchTokenAt_3(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Feature_Header);
				Build(context, token);
				return 26;
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
			if (	context.TokenMatcher.Match_BackgroundLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Background);
				Build(context, token);
				return 5;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 3;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#BackgroundLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"}, "State: 3 - Feature_File:0>Feature_Header:2>Feature_Description:0>Description_Helper:0>Description:0>__alt5:0>#Empty:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 3;

		}
		
		
		// Feature_File:0>Feature_Header:2>Feature_Description:0>Description_Helper:1>#Comment:0
		int MatchTokenAt_4(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Feature_Header);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 4;
			}
			if (	context.TokenMatcher.Match_BackgroundLine(token)
)
			{
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Background);
				Build(context, token);
				return 5;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Feature_Header);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 4;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Comment", "#BackgroundLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Empty"}, "State: 4 - Feature_File:0>Feature_Header:2>Feature_Description:0>Description_Helper:1>#Comment:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 4;

		}
		
		
		// Feature_File:1>Background:0>#BackgroundLine:0
		int MatchTokenAt_5(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 26;
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
			if (	context.TokenMatcher.Match_StepLine(token)
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
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 6;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"}, "State: 5 - Feature_File:1>Background:0>#BackgroundLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 5;

		}
		
		
		// Feature_File:1>Background:1>Background_Description:0>Description_Helper:0>Description:0>__alt5:0>#Empty:0
		int MatchTokenAt_6(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 26;
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
			if (	context.TokenMatcher.Match_StepLine(token)
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
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 6;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"}, "State: 6 - Feature_File:1>Background:1>Background_Description:0>Description_Helper:0>Description:0>__alt5:0>#Empty:0");
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
				return 26;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 7;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
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
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 7;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Empty"}, "State: 7 - Feature_File:1>Background:1>Background_Description:0>Description_Helper:1>#Comment:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 7;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:0>#StepLine:0
		int MatchTokenAt_8(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				StartRule(context, RuleType.DataTable);
				Build(context, token);
				return 9;
			}
			if (	context.TokenMatcher.Match_DocStringSeparator(token)
)
			{
				StartRule(context, RuleType.DocString);
				Build(context, token);
				return 33;
			}
			if (	context.TokenMatcher.Match_DocStringAlternativeSeparator(token)
)
			{
				StartRule(context, RuleType.DocString);
				Build(context, token);
				return 35;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
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
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
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
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#DocStringSeparator", "#DocStringAlternativeSeparator", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"}, "State: 8 - Feature_File:1>Background:2>Scenario_Step:0>Step:0>#StepLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 8;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0
		int MatchTokenAt_9(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 9;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
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
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"}, "State: 9 - Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 9;

		}
		
		
		// Feature_File:2>Scenario_Base:0>Tags:0>#TagLine:0
		int MatchTokenAt_10(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Tags);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Tags);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 10;
			}
				var error = new ParserError(token, new string[] {"#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"}, "State: 10 - Feature_File:2>Scenario_Base:0>Tags:0>#TagLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 10;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:0>#ScenarioLine:0
		int MatchTokenAt_11(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 14;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 12;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"}, "State: 11 - Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:0>#ScenarioLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 11;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:0>Description:0>__alt5:0>#Empty:0
		int MatchTokenAt_12(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 12;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				EndRule(context, RuleType.Description);
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				EndRule(context, RuleType.Description);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 14;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Description);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 12;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Empty", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other"}, "State: 12 - Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:0>Description:0>__alt5:0>#Empty:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 12;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:1>#Comment:0
		int MatchTokenAt_13(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 13;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 14;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 13;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Empty"}, "State: 13 - Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:1>#Comment:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 13;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:0>#StepLine:0
		int MatchTokenAt_14(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				StartRule(context, RuleType.DataTable);
				Build(context, token);
				return 15;
			}
			if (	context.TokenMatcher.Match_DocStringSeparator(token)
)
			{
				StartRule(context, RuleType.DocString);
				Build(context, token);
				return 30;
			}
			if (	context.TokenMatcher.Match_DocStringAlternativeSeparator(token)
)
			{
				StartRule(context, RuleType.DocString);
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 14;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 14;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 14;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#DocStringSeparator", "#DocStringAlternativeSeparator", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"}, "State: 14 - Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:0>#StepLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 14;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0
		int MatchTokenAt_15(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 15;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 14;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 15;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 15;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"}, "State: 15 - Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 15;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:0>#ScenarioOutlineLine:0
		int MatchTokenAt_16(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 17;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 18;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 19;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				StartRule(context, RuleType.Examples);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 21;
			}
			if (	context.TokenMatcher.Match_ExamplesLine(token)
)
			{
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 22;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 17;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#Comment", "#StepLine", "#TagLine", "#ExamplesLine", "#Other"}, "State: 16 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:0>#ScenarioOutlineLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 16;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:0>Description:0>__alt5:0>#Empty:0
		int MatchTokenAt_17(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 17;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				EndRule(context, RuleType.Description);
				Build(context, token);
				return 18;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				EndRule(context, RuleType.Description);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 19;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Description);
				StartRule(context, RuleType.Examples);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 21;
			}
			if (	context.TokenMatcher.Match_ExamplesLine(token)
)
			{
				EndRule(context, RuleType.Description);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 22;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 17;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#Comment", "#StepLine", "#TagLine", "#ExamplesLine", "#Other"}, "State: 17 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:0>Description:0>__alt5:0>#Empty:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 17;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:1>#Comment:0
		int MatchTokenAt_18(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 18;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 19;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				StartRule(context, RuleType.Examples);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 21;
			}
			if (	context.TokenMatcher.Match_ExamplesLine(token)
)
			{
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 22;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 18;
			}
				var error = new ParserError(token, new string[] {"#Comment", "#StepLine", "#TagLine", "#ExamplesLine", "#Empty"}, "State: 18 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:1>#Comment:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 18;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:0>#StepLine:0
		int MatchTokenAt_19(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				StartRule(context, RuleType.DataTable);
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_DocStringSeparator(token)
)
			{
				StartRule(context, RuleType.DocString);
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_DocStringAlternativeSeparator(token)
)
			{
				StartRule(context, RuleType.DocString);
				Build(context, token);
				return 29;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 19;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 21;
			}
			if (	context.TokenMatcher.Match_ExamplesLine(token)
)
			{
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 22;
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
				var error = new ParserError(token, new string[] {"#TableRow", "#DocStringSeparator", "#DocStringAlternativeSeparator", "#StepLine", "#TagLine", "#ExamplesLine", "#Comment", "#Empty"}, "State: 19 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:0>#StepLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 19;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0
		int MatchTokenAt_20(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 19;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 21;
			}
			if (	context.TokenMatcher.Match_ExamplesLine(token)
)
			{
				EndRule(context, RuleType.DataTable);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 22;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 20;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 20;
			}
				var error = new ParserError(token, new string[] {"#TableRow", "#StepLine", "#TagLine", "#ExamplesLine", "#Comment", "#Empty"}, "State: 20 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 20;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:3>Examples:0>Tags:0>#TagLine:0
		int MatchTokenAt_21(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				Build(context, token);
				return 21;
			}
			if (	context.TokenMatcher.Match_ExamplesLine(token)
)
			{
				EndRule(context, RuleType.Tags);
				Build(context, token);
				return 22;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 21;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 21;
			}
				var error = new ParserError(token, new string[] {"#TagLine", "#ExamplesLine", "#Comment", "#Empty"}, "State: 21 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:3>Examples:0>Tags:0>#TagLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 21;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:3>Examples:1>#ExamplesLine:0
		int MatchTokenAt_22(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 24;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 25;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				StartRule(context, RuleType.Description);
				Build(context, token);
				return 23;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#Comment", "#TableRow", "#Other"}, "State: 22 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:3>Examples:1>#ExamplesLine:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 22;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:0>Description:0>__alt5:0>#Empty:0
		int MatchTokenAt_23(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 23;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				EndRule(context, RuleType.Description);
				Build(context, token);
				return 24;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				EndRule(context, RuleType.Description);
				Build(context, token);
				return 25;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 23;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#Comment", "#TableRow", "#Other"}, "State: 23 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:0>Description:0>__alt5:0>#Empty:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 23;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:1>#Comment:0
		int MatchTokenAt_24(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 24;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 25;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 24;
			}
				var error = new ParserError(token, new string[] {"#Comment", "#TableRow", "#Empty"}, "State: 24 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:1>#Comment:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 24;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:3>Examples:3>Examples_Table:0>#TableRow:0
		int MatchTokenAt_25(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.Examples);
				EndRule(context, RuleType.ScenarioOutline);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_TableRow(token)
)
			{
				Build(context, token);
				return 25;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				if (LookAhead_0(context, token))
				{
				EndRule(context, RuleType.Examples);
				StartRule(context, RuleType.Examples);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 21;
				}
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.Examples);
				EndRule(context, RuleType.ScenarioOutline);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ExamplesLine(token)
)
			{
				EndRule(context, RuleType.Examples);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 22;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.Examples);
				EndRule(context, RuleType.ScenarioOutline);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.Examples);
				EndRule(context, RuleType.ScenarioOutline);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 25;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 25;
			}
				var error = new ParserError(token, new string[] {"#EOF", "#TableRow", "#TagLine", "#ExamplesLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"}, "State: 25 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:3>Examples:3>Examples_Table:0>#TableRow:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 25;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:0>#DocStringSeparator:0
		int MatchTokenAt_27(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 27;
			}
			if (	context.TokenMatcher.Match_DocStringSeparator(token)
)
			{
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 27;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#DocStringSeparator", "#Other"}, "State: 27 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:0>#DocStringSeparator:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 27;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:2>#DocStringSeparator:0
		int MatchTokenAt_28(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 19;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 21;
			}
			if (	context.TokenMatcher.Match_ExamplesLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Examples);
				Build(context, token);
				return 22;
			}
			if (	context.TokenMatcher.Match_Comment(token)
)
			{
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 28;
			}
				var error = new ParserError(token, new string[] {"#StepLine", "#TagLine", "#ExamplesLine", "#Comment", "#Empty"}, "State: 28 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:2>#DocStringSeparator:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 28;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:1>DocString_AlternativeSepatator:0>#DocStringAlternativeSeparator:0
		int MatchTokenAt_29(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 29;
			}
			if (	context.TokenMatcher.Match_DocStringAlternativeSeparator(token)
)
			{
				Build(context, token);
				return 28;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 29;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#DocStringAlternativeSeparator", "#Other"}, "State: 29 - Feature_File:2>Scenario_Base:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:1>DocString_AlternativeSepatator:0>#DocStringAlternativeSeparator:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 29;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:0>#DocStringSeparator:0
		int MatchTokenAt_30(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 30;
			}
			if (	context.TokenMatcher.Match_DocStringSeparator(token)
)
			{
				Build(context, token);
				return 31;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 30;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#DocStringSeparator", "#Other"}, "State: 30 - Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:0>#DocStringSeparator:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 30;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:2>#DocStringSeparator:0
		int MatchTokenAt_31(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 14;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Scenario);
				EndRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
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
				var error = new ParserError(token, new string[] {"#EOF", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"}, "State: 31 - Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:2>#DocStringSeparator:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 31;

		}
		
		
		// Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:1>DocString_AlternativeSepatator:0>#DocStringAlternativeSeparator:0
		int MatchTokenAt_32(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 32;
			}
			if (	context.TokenMatcher.Match_DocStringAlternativeSeparator(token)
)
			{
				Build(context, token);
				return 31;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 32;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#DocStringAlternativeSeparator", "#Other"}, "State: 32 - Feature_File:2>Scenario_Base:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:1>DocString_AlternativeSepatator:0>#DocStringAlternativeSeparator:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 32;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:0>#DocStringSeparator:0
		int MatchTokenAt_33(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 33;
			}
			if (	context.TokenMatcher.Match_DocStringSeparator(token)
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
				var error = new ParserError(token, new string[] {"#Empty", "#DocStringSeparator", "#Other"}, "State: 33 - Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:0>#DocStringSeparator:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 33;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:2>#DocStringSeparator:0
		int MatchTokenAt_34(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_EOF(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				Build(context, token);
				return 26;
			}
			if (	context.TokenMatcher.Match_StepLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				StartRule(context, RuleType.Step);
				Build(context, token);
				return 8;
			}
			if (	context.TokenMatcher.Match_TagLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Tags);
				Build(context, token);
				return 10;
			}
			if (	context.TokenMatcher.Match_ScenarioLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.Scenario);
				Build(context, token);
				return 11;
			}
			if (	context.TokenMatcher.Match_ScenarioOutlineLine(token)
)
			{
				EndRule(context, RuleType.DocString);
				EndRule(context, RuleType.Step);
				EndRule(context, RuleType.Background);
				StartRule(context, RuleType.Scenario_Base);
				StartRule(context, RuleType.ScenarioOutline);
				Build(context, token);
				return 16;
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
				var error = new ParserError(token, new string[] {"#EOF", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty"}, "State: 34 - Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:0>DocString_QuoteSepatator:2>#DocStringSeparator:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 34;

		}
		
		
		// Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:1>DocString_AlternativeSepatator:0>#DocStringAlternativeSeparator:0
		int MatchTokenAt_35(Token token, ParserContext context)
		{
			if (	context.TokenMatcher.Match_Empty(token)
)
			{
				Build(context, token);
				return 35;
			}
			if (	context.TokenMatcher.Match_DocStringAlternativeSeparator(token)
)
			{
				Build(context, token);
				return 34;
			}
			if (	context.TokenMatcher.Match_Other(token)
)
			{
				Build(context, token);
				return 35;
			}
				var error = new ParserError(token, new string[] {"#Empty", "#DocStringAlternativeSeparator", "#Other"}, "State: 35 - Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>__alt2:1>DocString_AlternativeSepatator:0>#DocStringAlternativeSeparator:0");
	if (StopAtFirstError)
		throw new ParserException(ParserMessageProvider, error);
	context.Errors.Add(error);
	return 35;

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
					|| 	context.TokenMatcher.Match_ExamplesLine(token)

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

	public partial interface IAstBuilder 
	{
		void Build(Token token);
		void StartRule(RuleType ruleType);
		void EndRule(RuleType ruleType);
		object GetResult();
	}
}
