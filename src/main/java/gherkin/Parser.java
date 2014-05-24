package gherkin;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

import static java.util.Arrays.asList;

public class Parser
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
        TableRow,
        Language,
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
        _TableRow, // #TableRow
        _Language, // #Language
        _Other, // #Other
        Feature, // Feature! := Feature_Header Background? Scenario_Definition*
        Feature_Header, // Feature_Header! := #Language? Tags? #FeatureLine Feature_Description
        Background, // Background! := #BackgroundLine Background_Description Scenario_Step*
        Scenario_Definition, // Scenario_Definition! := Tags? (Scenario | ScenarioOutline)
        Scenario, // Scenario! := #ScenarioLine Scenario_Description Scenario_Step*
        ScenarioOutline, // ScenarioOutline! := #ScenarioOutlineLine ScenarioOutline_Description ScenarioOutline_Step* Examples+
        Examples, // Examples! [#Empty|#Comment|#TagLine-&gt;#ExamplesLine] := Tags? #ExamplesLine Examples_Description Examples_Table
        Examples_Table, // Examples_Table := #TableRow+
        Scenario_Step, // Scenario_Step := Step
        ScenarioOutline_Step, // ScenarioOutline_Step := Step
        Step, // Step! := #StepLine Step_Arg?
        Step_Arg, // Step_Arg := (DataTable | DocString)
        DataTable, // DataTable! := #TableRow+
        DocString, // DocString! := #DocStringSeparator #Other* #DocStringSeparator
        Tags, // Tags! := #TagLine+
        Feature_Description, // Feature_Description := Description_Helper
        Background_Description, // Background_Description := Description_Helper
        Scenario_Description, // Scenario_Description := Description_Helper
        ScenarioOutline_Description, // ScenarioOutline_Description := Description_Helper
        Examples_Description, // Examples_Description := Description_Helper
        Description_Helper, // Description_Helper := #Empty* Description? #Comment*
        Description, // Description! := #Other+
    }


    public boolean StopAtFirstError;

    class ParserContext
    {
        public final ITokenScanner TokenScanner;
        public final ITokenMatcher TokenMatcher;
        public final IAstBuilder Builder;
        public final Queue<Token> TokenQueue;
        public final List<ParserException> Errors;


        ParserContext(ITokenScanner tokenScanner, ITokenMatcher tokenMatcher, IAstBuilder builder, Queue<Token> tokenQueue, List<ParserException> errors) {
            TokenScanner = tokenScanner;
            TokenMatcher = tokenMatcher;
            Builder = builder;
            TokenQueue = tokenQueue;
            Errors = errors;
        }
    }

    public Object Parse(ITokenScanner tokenScanner)
    {
        return Parse(tokenScanner, new TokenMatcher(), new AstBuilder());
    }

    public Object Parse(ITokenScanner tokenScanner, ITokenMatcher tokenMatcher, IAstBuilder astBuilder)
    {
        ParserContext context = new ParserContext(
                tokenScanner,
                tokenMatcher,
                astBuilder,
                new LinkedList<Token>(),
                new ArrayList<ParserException>()
        );

        StartRule(context, RuleType.Feature);
        int state = 0;
        Token token;
        do
        {
            token = ReadToken(context);
            state = MatchToken(state, token, context);
        } while(!token.IsEOF());

        EndRule(context, RuleType.Feature);

        if (context.Errors.size() > 0)
        {
            throw new ParserException.CompositeParserException(context.Errors);
        }

        return GetResult(context);
    }

    private void AddError(ParserContext context, ParserException error) {
        context.Errors.add(error);
        if (context.Errors.size() > 10)
            throw new ParserException.CompositeParserException(context.Errors);
    }

    private <T> T HandleAstError(ParserContext context, final Func<T> action) {
        return HandleExternalError(context, new Func<T>() {
            public T call() {
                return action.call();
            }
        }, null);
    }

    private <T> T HandleExternalError(ParserContext context, Func<T> action, T defaultValue) {
        if (StopAtFirstError) {
            return action.call();
        }

        try {
            return action.call();
        } catch (ParserException.CompositeParserException compositeParserException) {
            for (ParserException error : compositeParserException.Errors) {
                AddError(context, error);
            }
        } catch (ParserException error) {
            AddError(context, error);
        }
        return defaultValue;
    }

    void Build(final ParserContext context, final Token token) {
        HandleAstError(context, new Func<Void>() {
            public Void call() {
                context.Builder.Build(token);
                return null;
            }
        });
    }

    void StartRule(final ParserContext context, final RuleType ruleType) {
        HandleAstError(context, new Func<Void>() {
            public Void call() {
                context.Builder.StartRule(ruleType);
                return null;
            }
        });
    }

    void EndRule(final ParserContext context, final RuleType ruleType) {
        HandleAstError(context, new Func<Void>() {
            public Void call() {
                context.Builder.EndRule(ruleType);
                return null;
            }
        });
    }

    Object GetResult(ParserContext context)
    {
        return context.Builder.GetResult();
    }

    Token ReadToken(ParserContext context)
    {
        return context.TokenQueue.size() > 0 ? context.TokenQueue.remove() : context.TokenScanner.Read();
    }


    boolean Match_EOF(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_EOF(token);
            }
        }, false);
    }

    boolean Match_Empty(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_Empty(token);
            }
        }, false);
    }

    boolean Match_Comment(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_Comment(token);
            }
        }, false);
    }

    boolean Match_TagLine(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_TagLine(token);
            }
        }, false);
    }

    boolean Match_FeatureLine(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_FeatureLine(token);
            }
        }, false);
    }

    boolean Match_BackgroundLine(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_BackgroundLine(token);
            }
        }, false);
    }

    boolean Match_ScenarioLine(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_ScenarioLine(token);
            }
        }, false);
    }

    boolean Match_ScenarioOutlineLine(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_ScenarioOutlineLine(token);
            }
        }, false);
    }

    boolean Match_ExamplesLine(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_ExamplesLine(token);
            }
        }, false);
    }

    boolean Match_StepLine(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_StepLine(token);
            }
        }, false);
    }

    boolean Match_DocStringSeparator(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_DocStringSeparator(token);
            }
        }, false);
    }

    boolean Match_TableRow(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_TableRow(token);
            }
        }, false);
    }

    boolean Match_Language(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_Language(token);
            }
        }, false);
    }

    boolean Match_Other(final ParserContext context, final Token token) {
        return HandleExternalError(context, new Func<Boolean>() {
            public Boolean call() {
                return context.TokenMatcher.Match_Other(token);
            }
        }, false);
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
            default:
                throw new IllegalStateException("Unknown state: " + state);
        }
        return newState;
    }


    // Start
    int MatchTokenAt_0(Token token, ParserContext context)
    {
        if (Match_Language(context, token))
        {
            StartRule(context, RuleType.Feature_Header);
            Build(context, token);
            return 1;
        }
        if (Match_TagLine(context, token))
        {
            StartRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 2;
        }
        if (Match_FeatureLine(context, token))
        {
            StartRule(context, RuleType.Feature_Header);
            Build(context, token);
            return 3;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 0;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 0;
        }

        final String stateComment = "State: 0 - Start";
        token.Detach();
        List<String> expectedTokens = asList("#Language", "#TagLine", "#FeatureLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 0;

    }


    // Feature:0>Feature_Header:0>#Language:0
    int MatchTokenAt_1(Token token, ParserContext context)
    {
        if (Match_TagLine(context, token))
        {
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 2;
        }
        if (Match_FeatureLine(context, token))
        {
            Build(context, token);
            return 3;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 1;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 1;
        }

        final String stateComment = "State: 1 - Feature:0>Feature_Header:0>#Language:0";
        token.Detach();
        List<String> expectedTokens = asList("#TagLine", "#FeatureLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 1;

    }


    // Feature:0>Feature_Header:1>Tags:0>#TagLine:0
    int MatchTokenAt_2(Token token, ParserContext context)
    {
        if (Match_TagLine(context, token))
        {
            Build(context, token);
            return 2;
        }
        if (Match_FeatureLine(context, token))
        {
            EndRule(context, RuleType.Tags);
            Build(context, token);
            return 3;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 2;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 2;
        }

        final String stateComment = "State: 2 - Feature:0>Feature_Header:1>Tags:0>#TagLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#TagLine", "#FeatureLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 2;

    }


    // Feature:0>Feature_Header:2>#FeatureLine:0
    int MatchTokenAt_3(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Feature_Header);
            Build(context, token);
            return 27;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 3;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 5;
        }
        if (Match_BackgroundLine(context, token))
        {
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Background);
            Build(context, token);
            return 6;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Other(context, token))
        {
            StartRule(context, RuleType.Description);
            Build(context, token);
            return 4;
        }

        final String stateComment = "State: 3 - Feature:0>Feature_Header:2>#FeatureLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#Empty", "#Comment", "#BackgroundLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 3;

    }


    // Feature:0>Feature_Header:3>Feature_Description:0>Description_Helper:1>Description:0>#Other:0
    int MatchTokenAt_4(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Feature_Header);
            Build(context, token);
            return 27;
        }
        if (Match_Comment(context, token))
        {
            EndRule(context, RuleType.Description);
            Build(context, token);
            return 5;
        }
        if (Match_BackgroundLine(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Background);
            Build(context, token);
            return 6;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Other(context, token))
        {
            Build(context, token);
            return 4;
        }

        final String stateComment = "State: 4 - Feature:0>Feature_Header:3>Feature_Description:0>Description_Helper:1>Description:0>#Other:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#Comment", "#BackgroundLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 4;

    }


    // Feature:0>Feature_Header:3>Feature_Description:0>Description_Helper:2>#Comment:0
    int MatchTokenAt_5(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Feature_Header);
            Build(context, token);
            return 27;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 5;
        }
        if (Match_BackgroundLine(context, token))
        {
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Background);
            Build(context, token);
            return 6;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Feature_Header);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 5;
        }

        final String stateComment = "State: 5 - Feature:0>Feature_Header:3>Feature_Description:0>Description_Helper:2>#Comment:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#Comment", "#BackgroundLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 5;

    }


    // Feature:1>Background:0>#BackgroundLine:0
    int MatchTokenAt_6(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Background);
            Build(context, token);
            return 27;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 6;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 8;
        }
        if (Match_StepLine(context, token))
        {
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 9;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Other(context, token))
        {
            StartRule(context, RuleType.Description);
            Build(context, token);
            return 7;
        }

        final String stateComment = "State: 6 - Feature:1>Background:0>#BackgroundLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#Empty", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 6;

    }


    // Feature:1>Background:1>Background_Description:0>Description_Helper:1>Description:0>#Other:0
    int MatchTokenAt_7(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Background);
            Build(context, token);
            return 27;
        }
        if (Match_Comment(context, token))
        {
            EndRule(context, RuleType.Description);
            Build(context, token);
            return 8;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.Description);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 9;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Other(context, token))
        {
            Build(context, token);
            return 7;
        }

        final String stateComment = "State: 7 - Feature:1>Background:1>Background_Description:0>Description_Helper:1>Description:0>#Other:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 7;

    }


    // Feature:1>Background:1>Background_Description:0>Description_Helper:2>#Comment:0
    int MatchTokenAt_8(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Background);
            Build(context, token);
            return 27;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 8;
        }
        if (Match_StepLine(context, token))
        {
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 9;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 8;
        }

        final String stateComment = "State: 8 - Feature:1>Background:1>Background_Description:0>Description_Helper:2>#Comment:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 8;

    }


    // Feature:1>Background:2>Scenario_Step:0>Step:0>#StepLine:0
    int MatchTokenAt_9(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            Build(context, token);
            return 27;
        }
        if (Match_TableRow(context, token))
        {
            StartRule(context, RuleType.DataTable);
            Build(context, token);
            return 10;
        }
        if (Match_DocStringSeparator(context, token))
        {
            StartRule(context, RuleType.DocString);
            Build(context, token);
            return 32;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 9;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 9;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 9;
        }

        final String stateComment = "State: 9 - Feature:1>Background:2>Scenario_Step:0>Step:0>#StepLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#TableRow", "#DocStringSeparator", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 9;

    }


    // Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0
    int MatchTokenAt_10(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            Build(context, token);
            return 27;
        }
        if (Match_TableRow(context, token))
        {
            Build(context, token);
            return 10;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 9;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 10;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 10;
        }

        final String stateComment = "State: 10 - Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#TableRow", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 10;

    }


    // Feature:2>Scenario_Definition:0>Tags:0>#TagLine:0
    int MatchTokenAt_11(Token token, ParserContext context)
    {
        if (Match_TagLine(context, token))
        {
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Tags);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Tags);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 11;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 11;
        }

        final String stateComment = "State: 11 - Feature:2>Scenario_Definition:0>Tags:0>#TagLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 11;

    }


    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:0>#ScenarioLine:0
    int MatchTokenAt_12(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            Build(context, token);
            return 27;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 12;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 14;
        }
        if (Match_StepLine(context, token))
        {
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 15;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Other(context, token))
        {
            StartRule(context, RuleType.Description);
            Build(context, token);
            return 13;
        }

        final String stateComment = "State: 12 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:0>#ScenarioLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#Empty", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 12;

    }


    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:1>Description:0>#Other:0
    int MatchTokenAt_13(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            Build(context, token);
            return 27;
        }
        if (Match_Comment(context, token))
        {
            EndRule(context, RuleType.Description);
            Build(context, token);
            return 14;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.Description);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 15;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Description);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Other(context, token))
        {
            Build(context, token);
            return 13;
        }

        final String stateComment = "State: 13 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:1>Description:0>#Other:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 13;

    }


    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:2>#Comment:0
    int MatchTokenAt_14(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            Build(context, token);
            return 27;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 14;
        }
        if (Match_StepLine(context, token))
        {
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 15;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 14;
        }

        final String stateComment = "State: 14 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:2>#Comment:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#Comment", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 14;

    }


    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:0>#StepLine:0
    int MatchTokenAt_15(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            Build(context, token);
            return 27;
        }
        if (Match_TableRow(context, token))
        {
            StartRule(context, RuleType.DataTable);
            Build(context, token);
            return 16;
        }
        if (Match_DocStringSeparator(context, token))
        {
            StartRule(context, RuleType.DocString);
            Build(context, token);
            return 30;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 15;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 15;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 15;
        }

        final String stateComment = "State: 15 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:0>#StepLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#TableRow", "#DocStringSeparator", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 15;

    }


    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0
    int MatchTokenAt_16(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            Build(context, token);
            return 27;
        }
        if (Match_TableRow(context, token))
        {
            Build(context, token);
            return 16;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 15;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 16;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 16;
        }

        final String stateComment = "State: 16 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#TableRow", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 16;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:0>#ScenarioOutlineLine:0
    int MatchTokenAt_17(Token token, ParserContext context)
    {
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 17;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 19;
        }
        if (Match_StepLine(context, token))
        {
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 20;
        }
        if (Match_TagLine(context, token))
        {
            StartRule(context, RuleType.Examples);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 22;
        }
        if (Match_ExamplesLine(context, token))
        {
            StartRule(context, RuleType.Examples);
            Build(context, token);
            return 23;
        }
        if (Match_Other(context, token))
        {
            StartRule(context, RuleType.Description);
            Build(context, token);
            return 18;
        }

        final String stateComment = "State: 17 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:0>#ScenarioOutlineLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#Empty", "#Comment", "#StepLine", "#TagLine", "#ExamplesLine", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 17;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:1>Description:0>#Other:0
    int MatchTokenAt_18(Token token, ParserContext context)
    {
        if (Match_Comment(context, token))
        {
            EndRule(context, RuleType.Description);
            Build(context, token);
            return 19;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.Description);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 20;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Description);
            StartRule(context, RuleType.Examples);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 22;
        }
        if (Match_ExamplesLine(context, token))
        {
            EndRule(context, RuleType.Description);
            StartRule(context, RuleType.Examples);
            Build(context, token);
            return 23;
        }
        if (Match_Other(context, token))
        {
            Build(context, token);
            return 18;
        }

        final String stateComment = "State: 18 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:1>Description:0>#Other:0";
        token.Detach();
        List<String> expectedTokens = asList("#Comment", "#StepLine", "#TagLine", "#ExamplesLine", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 18;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:2>#Comment:0
    int MatchTokenAt_19(Token token, ParserContext context)
    {
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 19;
        }
        if (Match_StepLine(context, token))
        {
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 20;
        }
        if (Match_TagLine(context, token))
        {
            StartRule(context, RuleType.Examples);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 22;
        }
        if (Match_ExamplesLine(context, token))
        {
            StartRule(context, RuleType.Examples);
            Build(context, token);
            return 23;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 19;
        }

        final String stateComment = "State: 19 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:2>#Comment:0";
        token.Detach();
        List<String> expectedTokens = asList("#Comment", "#StepLine", "#TagLine", "#ExamplesLine", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 19;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:0>#StepLine:0
    int MatchTokenAt_20(Token token, ParserContext context)
    {
        if (Match_TableRow(context, token))
        {
            StartRule(context, RuleType.DataTable);
            Build(context, token);
            return 21;
        }
        if (Match_DocStringSeparator(context, token))
        {
            StartRule(context, RuleType.DocString);
            Build(context, token);
            return 28;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 20;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Examples);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 22;
        }
        if (Match_ExamplesLine(context, token))
        {
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Examples);
            Build(context, token);
            return 23;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 20;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 20;
        }

        final String stateComment = "State: 20 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:0>#StepLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#TableRow", "#DocStringSeparator", "#StepLine", "#TagLine", "#ExamplesLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 20;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0
    int MatchTokenAt_21(Token token, ParserContext context)
    {
        if (Match_TableRow(context, token))
        {
            Build(context, token);
            return 21;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 20;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Examples);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 22;
        }
        if (Match_ExamplesLine(context, token))
        {
            EndRule(context, RuleType.DataTable);
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Examples);
            Build(context, token);
            return 23;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 21;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 21;
        }

        final String stateComment = "State: 21 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>DataTable:0>#TableRow:0";
        token.Detach();
        List<String> expectedTokens = asList("#TableRow", "#StepLine", "#TagLine", "#ExamplesLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 21;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples:0>Tags:0>#TagLine:0
    int MatchTokenAt_22(Token token, ParserContext context)
    {
        if (Match_TagLine(context, token))
        {
            Build(context, token);
            return 22;
        }
        if (Match_ExamplesLine(context, token))
        {
            EndRule(context, RuleType.Tags);
            Build(context, token);
            return 23;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 22;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 22;
        }

        final String stateComment = "State: 22 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples:0>Tags:0>#TagLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#TagLine", "#ExamplesLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 22;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples:1>#ExamplesLine:0
    int MatchTokenAt_23(Token token, ParserContext context)
    {
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 23;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 25;
        }
        if (Match_TableRow(context, token))
        {
            Build(context, token);
            return 26;
        }
        if (Match_Other(context, token))
        {
            StartRule(context, RuleType.Description);
            Build(context, token);
            return 24;
        }

        final String stateComment = "State: 23 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples:1>#ExamplesLine:0";
        token.Detach();
        List<String> expectedTokens = asList("#Empty", "#Comment", "#TableRow", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 23;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:1>Description:0>#Other:0
    int MatchTokenAt_24(Token token, ParserContext context)
    {
        if (Match_Comment(context, token))
        {
            EndRule(context, RuleType.Description);
            Build(context, token);
            return 25;
        }
        if (Match_TableRow(context, token))
        {
            EndRule(context, RuleType.Description);
            Build(context, token);
            return 26;
        }
        if (Match_Other(context, token))
        {
            Build(context, token);
            return 24;
        }

        final String stateComment = "State: 24 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:1>Description:0>#Other:0";
        token.Detach();
        List<String> expectedTokens = asList("#Comment", "#TableRow", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 24;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:2>#Comment:0
    int MatchTokenAt_25(Token token, ParserContext context)
    {
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 25;
        }
        if (Match_TableRow(context, token))
        {
            Build(context, token);
            return 26;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 25;
        }

        final String stateComment = "State: 25 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:2>#Comment:0";
        token.Detach();
        List<String> expectedTokens = asList("#Comment", "#TableRow", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 25;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples:3>Examples_Table:0>#TableRow:0
    int MatchTokenAt_26(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.Examples);
            EndRule(context, RuleType.ScenarioOutline);
            EndRule(context, RuleType.Scenario_Definition);
            Build(context, token);
            return 27;
        }
        if (Match_TableRow(context, token))
        {
            Build(context, token);
            return 26;
        }
        if (Match_TagLine(context, token))
        {
            if (LookAhead_0(context, token))
            {
                EndRule(context, RuleType.Examples);
                StartRule(context, RuleType.Examples);
                StartRule(context, RuleType.Tags);
                Build(context, token);
                return 22;
            }
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.Examples);
            EndRule(context, RuleType.ScenarioOutline);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ExamplesLine(context, token))
        {
            EndRule(context, RuleType.Examples);
            StartRule(context, RuleType.Examples);
            Build(context, token);
            return 23;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.Examples);
            EndRule(context, RuleType.ScenarioOutline);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.Examples);
            EndRule(context, RuleType.ScenarioOutline);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 26;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 26;
        }

        final String stateComment = "State: 26 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:3>Examples:3>Examples_Table:0>#TableRow:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#TableRow", "#TagLine", "#ExamplesLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 26;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0
    int MatchTokenAt_28(Token token, ParserContext context)
    {
        if (Match_DocStringSeparator(context, token))
        {
            Build(context, token);
            return 29;
        }
        if (Match_Other(context, token))
        {
            Build(context, token);
            return 28;
        }

        final String stateComment = "State: 28 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0";
        token.Detach();
        List<String> expectedTokens = asList("#DocStringSeparator", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 28;

    }


    // Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0
    int MatchTokenAt_29(Token token, ParserContext context)
    {
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 20;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Examples);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 22;
        }
        if (Match_ExamplesLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Examples);
            Build(context, token);
            return 23;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 29;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 29;
        }

        final String stateComment = "State: 29 - Feature:2>Scenario_Definition:1>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0";
        token.Detach();
        List<String> expectedTokens = asList("#StepLine", "#TagLine", "#ExamplesLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 29;

    }


    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0
    int MatchTokenAt_30(Token token, ParserContext context)
    {
        if (Match_DocStringSeparator(context, token))
        {
            Build(context, token);
            return 31;
        }
        if (Match_Other(context, token))
        {
            Build(context, token);
            return 30;
        }

        final String stateComment = "State: 30 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0";
        token.Detach();
        List<String> expectedTokens = asList("#DocStringSeparator", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 30;

    }


    // Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0
    int MatchTokenAt_31(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            Build(context, token);
            return 27;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 15;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Scenario);
            EndRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 31;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 31;
        }

        final String stateComment = "State: 31 - Feature:2>Scenario_Definition:1>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 31;

    }


    // Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0
    int MatchTokenAt_32(Token token, ParserContext context)
    {
        if (Match_DocStringSeparator(context, token))
        {
            Build(context, token);
            return 33;
        }
        if (Match_Other(context, token))
        {
            Build(context, token);
            return 32;
        }

        final String stateComment = "State: 32 - Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:0>#DocStringSeparator:0";
        token.Detach();
        List<String> expectedTokens = asList("#DocStringSeparator", "#Other");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 32;

    }


    // Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0
    int MatchTokenAt_33(Token token, ParserContext context)
    {
        if (Match_EOF(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            Build(context, token);
            return 27;
        }
        if (Match_StepLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            StartRule(context, RuleType.Step);
            Build(context, token);
            return 9;
        }
        if (Match_TagLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Tags);
            Build(context, token);
            return 11;
        }
        if (Match_ScenarioLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.Scenario);
            Build(context, token);
            return 12;
        }
        if (Match_ScenarioOutlineLine(context, token))
        {
            EndRule(context, RuleType.DocString);
            EndRule(context, RuleType.Step);
            EndRule(context, RuleType.Background);
            StartRule(context, RuleType.Scenario_Definition);
            StartRule(context, RuleType.ScenarioOutline);
            Build(context, token);
            return 17;
        }
        if (Match_Comment(context, token))
        {
            Build(context, token);
            return 33;
        }
        if (Match_Empty(context, token))
        {
            Build(context, token);
            return 33;
        }

        final String stateComment = "State: 33 - Feature:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>DocString:2>#DocStringSeparator:0";
        token.Detach();
        List<String> expectedTokens = asList("#EOF", "#StepLine", "#TagLine", "#ScenarioLine", "#ScenarioOutlineLine", "#Comment", "#Empty");
        ParserException error = token.IsEOF()
                ? new ParserException.UnexpectedEOFException(token, expectedTokens, stateComment)
                : new ParserException.UnexpectedTokenException(token, expectedTokens, stateComment);
        if (StopAtFirstError)
            throw error;

        AddError(context, error);
        return 33;

    }



    boolean LookAhead_0(ParserContext context, Token currentToken)
    {
        currentToken.Detach();
        Token token;
        Queue<Token> queue = new ArrayDeque<Token>();
        boolean match = false;
        do
        {
            token = ReadToken(context);
            token.Detach();
            queue.add(token);

            if (false
                    || Match_ExamplesLine(context, token)
                    )
            {
                match = true;
                break;
            }
        } while (false
                || Match_Empty(context, token)
                || Match_Comment(context, token)
                || Match_TagLine(context, token)
                );
        for (Token t : queue) {
            context.TokenQueue.add(t);
        }
        return match;
    }


    public interface IAstBuilder
    {
        void Build(Token token);
        void StartRule(RuleType ruleType);
        void EndRule(RuleType ruleType);
        Object GetResult();
    }

    public interface ITokenScanner
    {
        Token Read();
    }

    public interface ITokenMatcher
    {
        boolean Match_EOF(Token token);
        boolean Match_Empty(Token token);
        boolean Match_Comment(Token token);
        boolean Match_TagLine(Token token);
        boolean Match_FeatureLine(Token token);
        boolean Match_BackgroundLine(Token token);
        boolean Match_ScenarioLine(Token token);
        boolean Match_ScenarioOutlineLine(Token token);
        boolean Match_ExamplesLine(Token token);
        boolean Match_StepLine(Token token);
        boolean Match_DocStringSeparator(Token token);
        boolean Match_TableRow(Token token);
        boolean Match_Language(Token token);
        boolean Match_Other(Token token);
    }

}
