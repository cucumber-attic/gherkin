
:token_None
:token_EOF
:token_Empty
:token_Comment
:token_TagLine
:token_Feature
:token_Background
:token_Scenario
:token_ScenarioOutline
:token_Examples
:token_Step
:token_MultiLineArgument
:token_TableRow
:token_Other

:rule_None
:rule__EOF  # #EOF
:rule__Empty  # #Empty
:rule__Comment  # #Comment
:rule__TagLine  # #TagLine
:rule__Feature  # #Feature
:rule__Background  # #Background
:rule__Scenario  # #Scenario
:rule__ScenarioOutline  # #ScenarioOutline
:rule__Examples  # #Examples
:rule__Step  # #Step
:rule__MultiLineArgument  # #MultiLineArgument
:rule__TableRow  # #TableRow
:rule__Other  # #Other
:rule_Feature_File  # Feature_File! := Feature_Def Background? Scenario_Base*
:rule_Feature_Def  # Feature_Def! := #TagLine* #Feature Feature_Description
:rule_Background  # Background! := #Background Background_Description Scenario_Step*
:rule_Scenario_Base  # Scenario_Base! := #TagLine* Scenario_Base_Body
:rule_Scenario_Base_Body  # Scenario_Base_Body := __alt0
:rule_Scenario  # Scenario! := #Scenario Scenario_Description Scenario_Step*
:rule_ScenarioOutline  # ScenarioOutline! := #ScenarioOutline ScenarioOutline_Description ScenarioOutline_Step* Examples+
:rule_Examples  # Examples! := #TagLine[#Empty|#Comment|#TagLine-&gt;#Examples]* #Examples Examples_Description Examples_Table
:rule_Examples_Table  # Examples_Table! := #TableRow+
:rule_Scenario_Step  # Scenario_Step := Step
:rule_ScenarioOutline_Step  # ScenarioOutline_Step := Step
:rule_Step  # Step! := #Step Step_Arg?
:rule_Step_Arg  # Step_Arg := __alt1
:rule_Table_And_Multiline_Arg  # Table_And_Multiline_Arg := Table_Arg Multiline_Arg?
:rule_Multiline_And_Table_Arg  # Multiline_And_Table_Arg := Multiline_Arg Table_Arg?
:rule_Table_Arg  # Table_Arg! := #TableRow+
:rule_Multiline_Arg  # Multiline_Arg! := #MultiLineArgument Multiline_Arg_Line* #MultiLineArgument
:rule_Multiline_Arg_Line  # Multiline_Arg_Line := __alt2
:rule_Feature_Description  # Feature_Description := Description_Helper
:rule_Background_Description  # Background_Description := Description_Helper
:rule_Scenario_Description  # Scenario_Description := Description_Helper
:rule_ScenarioOutline_Description  # ScenarioOutline_Description := Description_Helper
:rule_Examples_Description  # Examples_Description := Description_Helper
:rule_Description_Helper  # Description_Helper := Description? #Comment*
:rule_Description  # Description! := Description_Line+
:rule_Description_Line  # Description_Line := __alt3
:rule___alt0  # __alt0 := (Scenario | ScenarioOutline)
:rule___alt1  # __alt1 := (Table_And_Multiline_Arg | Multiline_And_Table_Arg)
:rule___alt2  # __alt2 := (#Empty | #Other)
:rule___alt3  # __alt3 := (#Empty | #Other)

module Gherkin
  class ParserContext
    attr_accessor :tokenScanner
    attr_accessor :astBuilder
    attr_accessor :tokenQueue
    attr_accessor :tokenMatcher

    def initialize(tokenScanner, astBuilder, tokenQueue, tokenMatcher)
      @tokenScanner = tokenScanner
      @astBuilder = astBuilder
      @tokenQueue = tokenQueue
      @tokenMatcher = tokenMatcher
    end
  end

  class Parser

    def parse(tokenScanner)

        context = ParserContext.new(tokenScanner, ASTBuilder.new(), [], TokenMatcher.new)

        context.astBuilder.push(:rule_Feature_File);
              state = 0
              loop do
          token = readToken(context)
          #puts token.line #TODO
          state = matchToken(state, token, context)

          break if token.eof?
              end

        if (state != 32)

          raise ParseError.new("parsing error: end of file expected")
        end

        context.astBuilder.pop(:rule_Feature_File)
        return context.astBuilder.rootNode?;
    end

    def readToken(context)

      return context.tokenQueue.count > 0 ? context.tokenQueue.shift : context.tokenScanner.read()
    end

    def matchToken(state, token, context)

      case state
      when 0
        newState = matchTokenAt_0(token, context)
      when 1
        newState = matchTokenAt_1(token, context)
      when 2
        newState = matchTokenAt_2(token, context)
      when 3
        newState = matchTokenAt_3(token, context)
      when 4
        newState = matchTokenAt_4(token, context)
      when 5
        newState = matchTokenAt_5(token, context)
      when 6
        newState = matchTokenAt_6(token, context)
      when 7
        newState = matchTokenAt_7(token, context)
      when 8
        newState = matchTokenAt_8(token, context)
      when 9
        newState = matchTokenAt_9(token, context)
      when 10
        newState = matchTokenAt_10(token, context)
      when 11
        newState = matchTokenAt_11(token, context)
      when 12
        newState = matchTokenAt_12(token, context)
      when 13
        newState = matchTokenAt_13(token, context)
      when 14
        newState = matchTokenAt_14(token, context)
      when 15
        newState = matchTokenAt_15(token, context)
      when 16
        newState = matchTokenAt_16(token, context)
      when 17
        newState = matchTokenAt_17(token, context)
      when 18
        newState = matchTokenAt_18(token, context)
      when 19
        newState = matchTokenAt_19(token, context)
      when 20
        newState = matchTokenAt_20(token, context)
      when 21
        newState = matchTokenAt_21(token, context)
      when 22
        newState = matchTokenAt_22(token, context)
      when 23
        newState = matchTokenAt_23(token, context)
      when 24
        newState = matchTokenAt_24(token, context)
      when 25
        newState = matchTokenAt_25(token, context)
      when 26
        newState = matchTokenAt_26(token, context)
      when 27
        newState = matchTokenAt_27(token, context)
      when 28
        newState = matchTokenAt_28(token, context)
      when 29
        newState = matchTokenAt_29(token, context)
      when 30
        newState = matchTokenAt_30(token, context)
      when 31
        newState = matchTokenAt_31(token, context)
      when 33
        newState = matchTokenAt_33(token, context)
      when 34
        newState = matchTokenAt_34(token, context)
      when 35
        newState = matchTokenAt_35(token, context)
      when 36
        newState = matchTokenAt_36(token, context)
      when 37
        newState = matchTokenAt_37(token, context)
      when 38
        newState = matchTokenAt_38(token, context)
      when 39
        newState = matchTokenAt_39(token, context)
      when 40
        newState = matchTokenAt_40(token, context)
      when 41
        newState = matchTokenAt_41(token, context)
      else
        raise ParserError.new("unknown state")
      end

      return newState;
    end

      
      # Start
      def matchTokenAt_0(token, context)

        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.push(:rule_Feature_Def);
        context.astBuilder.build(token);
          return 1;
        end
        if (context.tokenMatcher.match_Feature(token))
          #puts 'Feature' #TODO
        context.astBuilder.push(:rule_Feature_Def);
        context.astBuilder.build(token);
          return 2;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 0;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 0;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:0>Feature_Def:0>#TagLine:0
      def matchTokenAt_1(token, context)

        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.build(token);
          return 1;
        end
        if (context.tokenMatcher.match_Feature(token))
          #puts 'Feature' #TODO
        context.astBuilder.build(token);
          return 2;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 1;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 1;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:0>Feature_Def:1>#Feature:0
      def matchTokenAt_2(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.push(:rule_Description);
        context.astBuilder.build(token);
          return 3;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 4;
        end
        if (context.tokenMatcher.match_Background(token))
          #puts 'Background' #TODO
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Background);
        context.astBuilder.build(token);
          return 5;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.push(:rule_Description);
        context.astBuilder.build(token);
          return 3;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:0>Feature_Def:2>Feature_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
      def matchTokenAt_3(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 3;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.build(token);
          return 4;
        end
        if (context.tokenMatcher.match_Background(token))
          #puts 'Background' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Background);
        context.astBuilder.build(token);
          return 5;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 3;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:0>Feature_Def:2>Feature_Description:0>Description_Helper:1>#Comment:0
      def matchTokenAt_4(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 4;
        end
        if (context.tokenMatcher.match_Background(token))
          #puts 'Background' #TODO
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Background);
        context.astBuilder.build(token);
          return 5;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Feature_Def);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 4;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:1>Background:0>#Background:0
      def matchTokenAt_5(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.push(:rule_Description);
        context.astBuilder.build(token);
          return 6;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 7;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 8;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.push(:rule_Description);
        context.astBuilder.build(token);
          return 6;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:1>Background:1>Background_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
      def matchTokenAt_6(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 6;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.build(token);
          return 7;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 8;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 6;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:1>Background:1>Background_Description:0>Description_Helper:1>#Comment:0
      def matchTokenAt_7(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 7;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 8;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 7;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:1>Background:2>Scenario_Step:0>Step:0>#Step:0
      def matchTokenAt_8(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.push(:rule_Table_Arg);
        context.astBuilder.build(token);
          return 9;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.push(:rule_Multiline_Arg);
        context.astBuilder.build(token);
          return 39;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 8;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 8;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 8;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0
      def matchTokenAt_9(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.build(token);
          return 9;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.push(:rule_Multiline_Arg);
        context.astBuilder.build(token);
          return 10;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 8;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 9;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 9;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0
      def matchTokenAt_10(token, context)

        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 10;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.build(token);
          return 11;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 10;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0
      def matchTokenAt_11(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 8;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 11;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 11;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:0>#TagLine:0
      def matchTokenAt_12(token, context)

        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 12;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:0>#Scenario:0
      def matchTokenAt_13(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.push(:rule_Description);
        context.astBuilder.build(token);
          return 14;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 15;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 16;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.push(:rule_Description);
        context.astBuilder.build(token);
          return 14;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
      def matchTokenAt_14(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 14;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.build(token);
          return 15;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 16;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 14;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:1>#Comment:0
      def matchTokenAt_15(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 15;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 16;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 15;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:0>#Step:0
      def matchTokenAt_16(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.push(:rule_Table_Arg);
        context.astBuilder.build(token);
          return 17;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.push(:rule_Multiline_Arg);
        context.astBuilder.build(token);
          return 36;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 16;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 16;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 16;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0
      def matchTokenAt_17(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.build(token);
          return 17;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.push(:rule_Multiline_Arg);
        context.astBuilder.build(token);
          return 18;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 16;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 17;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 17;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0
      def matchTokenAt_18(token, context)

        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 18;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.build(token);
          return 19;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 18;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0
      def matchTokenAt_19(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 16;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 19;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 19;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:0>#ScenarioOutline:0
      def matchTokenAt_20(token, context)

        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.push(:rule_Description);
        context.astBuilder.build(token);
          return 21;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 22;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 23;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 27;
        end
        if (context.tokenMatcher.match_Examples(token))
          #puts 'Examples' #TODO
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 28;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.push(:rule_Description);
        context.astBuilder.build(token);
          return 21;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
      def matchTokenAt_21(token, context)

        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 21;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.build(token);
          return 22;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 23;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 27;
        end
        if (context.tokenMatcher.match_Examples(token))
          #puts 'Examples' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 28;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 21;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:1>#Comment:0
      def matchTokenAt_22(token, context)

        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 22;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 23;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 27;
        end
        if (context.tokenMatcher.match_Examples(token))
          #puts 'Examples' #TODO
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 28;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 22;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:0>#Step:0
      def matchTokenAt_23(token, context)

        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.push(:rule_Table_Arg);
        context.astBuilder.build(token);
          return 24;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.push(:rule_Multiline_Arg);
        context.astBuilder.build(token);
          return 33;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 23;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 27;
        end
        if (context.tokenMatcher.match_Examples(token))
          #puts 'Examples' #TODO
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 28;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 23;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 23;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0
      def matchTokenAt_24(token, context)

        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.build(token);
          return 24;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.push(:rule_Multiline_Arg);
        context.astBuilder.build(token);
          return 25;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 23;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 27;
        end
        if (context.tokenMatcher.match_Examples(token))
          #puts 'Examples' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 28;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 24;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 24;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0
      def matchTokenAt_25(token, context)

        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 25;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.build(token);
          return 26;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 25;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0
      def matchTokenAt_26(token, context)

        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 23;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 27;
        end
        if (context.tokenMatcher.match_Examples(token))
          #puts 'Examples' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 28;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 26;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 26;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:0>#TagLine:0
      def matchTokenAt_27(token, context)

        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.build(token);
          return 27;
        end
        if (context.tokenMatcher.match_Examples(token))
          #puts 'Examples' #TODO
        context.astBuilder.build(token);
          return 28;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 27;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 27;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:1>#Examples:0
      def matchTokenAt_28(token, context)

        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.push(:rule_Description);
        context.astBuilder.build(token);
          return 29;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 30;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.push(:rule_Examples_Table);
        context.astBuilder.build(token);
          return 31;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.push(:rule_Description);
        context.astBuilder.build(token);
          return 29;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
      def matchTokenAt_29(token, context)

        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 29;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.build(token);
          return 30;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.pop(:rule_Description);
        context.astBuilder.push(:rule_Examples_Table);
        context.astBuilder.build(token);
          return 31;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 29;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:1>#Comment:0
      def matchTokenAt_30(token, context)

        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 30;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.push(:rule_Examples_Table);
        context.astBuilder.build(token);
          return 31;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 30;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:3>Examples_Table:0>#TableRow:0
      def matchTokenAt_31(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Examples_Table);
        context.astBuilder.pop(:rule_Examples);
        context.astBuilder.pop(:rule_ScenarioOutline);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.build(token);
          return 31;
        end
        if (context.tokenMatcher.match_TagLine(token))
          if (lookAhead_0(context, token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Examples_Table);
        context.astBuilder.pop(:rule_Examples);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 27;
          end
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Examples_Table);
        context.astBuilder.pop(:rule_Examples);
        context.astBuilder.pop(:rule_ScenarioOutline);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Examples(token))
          #puts 'Examples' #TODO
        context.astBuilder.pop(:rule_Examples_Table);
        context.astBuilder.pop(:rule_Examples);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 28;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Examples_Table);
        context.astBuilder.pop(:rule_Examples);
        context.astBuilder.pop(:rule_ScenarioOutline);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Examples_Table);
        context.astBuilder.pop(:rule_Examples);
        context.astBuilder.pop(:rule_ScenarioOutline);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 31;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 31;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0
      def matchTokenAt_33(token, context)

        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 33;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.build(token);
          return 34;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 33;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0
      def matchTokenAt_34(token, context)

        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.push(:rule_Table_Arg);
        context.astBuilder.build(token);
          return 35;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 23;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 27;
        end
        if (context.tokenMatcher.match_Examples(token))
          #puts 'Examples' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 28;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 34;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 34;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0
      def matchTokenAt_35(token, context)

        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.build(token);
          return 35;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 23;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 27;
        end
        if (context.tokenMatcher.match_Examples(token))
          #puts 'Examples' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Examples);
        context.astBuilder.build(token);
          return 28;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 35;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 35;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0
      def matchTokenAt_36(token, context)

        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 36;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.build(token);
          return 37;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 36;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0
      def matchTokenAt_37(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.push(:rule_Table_Arg);
        context.astBuilder.build(token);
          return 38;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 16;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 37;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 37;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0
      def matchTokenAt_38(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.build(token);
          return 38;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 16;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Scenario);
        context.astBuilder.pop(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 38;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 38;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0
      def matchTokenAt_39(token, context)

        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 39;
        end
        if (context.tokenMatcher.match_MultiLineArgument(token))
          #puts 'MultiLineArgument' #TODO
        context.astBuilder.build(token);
          return 40;
        end
        if (context.tokenMatcher.match_Other(token))
          #puts 'Other' #TODO
        context.astBuilder.build(token);
          return 39;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0
      def matchTokenAt_40(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.push(:rule_Table_Arg);
        context.astBuilder.build(token);
          return 41;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 8;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Multiline_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 40;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 40;
        end
        raise ParseError.new()
      end
      
      
      # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0
      def matchTokenAt_41(token, context)

        if (context.tokenMatcher.match_EOF(token))
          #puts 'EOF' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.build(token);
          return 32;
        end
        if (context.tokenMatcher.match_TableRow(token))
          #puts 'TableRow' #TODO
        context.astBuilder.build(token);
          return 41;
        end
        if (context.tokenMatcher.match_Step(token))
          #puts 'Step' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.push(:rule_Step);
        context.astBuilder.build(token);
          return 8;
        end
        if (context.tokenMatcher.match_TagLine(token))
          #puts 'TagLine' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.build(token);
          return 12;
        end
        if (context.tokenMatcher.match_Scenario(token))
          #puts 'Scenario' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_Scenario);
        context.astBuilder.build(token);
          return 13;
        end
        if (context.tokenMatcher.match_ScenarioOutline(token))
          #puts 'ScenarioOutline' #TODO
        context.astBuilder.pop(:rule_Table_Arg);
        context.astBuilder.pop(:rule_Step);
        context.astBuilder.pop(:rule_Background);
        context.astBuilder.push(:rule_Scenario_Base);
        context.astBuilder.push(:rule_ScenarioOutline);
        context.astBuilder.build(token);
          return 20;
        end
        if (context.tokenMatcher.match_Comment(token))
          #puts 'Comment' #TODO
        context.astBuilder.build(token);
          return 41;
        end
        if (context.tokenMatcher.match_Empty(token))
          #puts 'Empty' #TODO
        context.astBuilder.build(token);
          return 41;
        end
        raise ParseError.new()
      end
      

      
      def lookAhead_0(context, currentToken)

        currentToken.detach()
        queue = []
        match = false;
          loop do
              token = readToken(context);
          token.detach();
              queue.push(token)

              if (false \
            or context.tokenMatcher.match_Examples(token) \
          )
            match = true
            break
              end

          break if not(false \
              or context.tokenMatcher.match_Empty(token) \
              or context.tokenMatcher.match_Comment(token) \
              or context.tokenMatcher.match_TagLine(token) \
          )
        end
        queue.each do |t|
          context.tokenQueue.push(t)
        end
        return match
      end
      
  end
end
