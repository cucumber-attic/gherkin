# This file is generated. Do not edit! Edit gherkin-ruby.razor instead.
require 'gherkin/ast_builder'

module Gherkin
  class ParserContext
    attr_reader :token_scanner
    attr_reader :ast_builder
    attr_reader :token_matcher
    attr_reader :token_queue

    def initialize(token_scanner, ast_builder, token_matcher)
      @token_scanner = token_scanner
      @ast_builder = ast_builder
      @token_matcher = token_matcher

      @token_queue = []
    end
  end

  class Parser

    def parse(token_scanner)
      context = ParserContext.new(token_scanner, ASTBuilder.new, TokenMatcher.new)

      context.ast_builder.push(:rule_Feature_File)
      state = 0
      loop do
        token = read_token(context)
        state = match_token(state, token, context)

        break if token.eof?
      end

      if (state != 32)
        raise ParseError.new("parsing error: end of file expected")
      end

      context.ast_builder.pop(:rule_Feature_File)
      context.ast_builder.root_node?
    end

    def read_token(context)
      context.token_queue.count > 0 ? context.token_queue.shift : context.token_scanner.read
    end

    def match_token(state, token, context)
      case state
      when 0
        new_state = match_token_at_0(token, context)
      when 1
        new_state = match_token_at_1(token, context)
      when 2
        new_state = match_token_at_2(token, context)
      when 3
        new_state = match_token_at_3(token, context)
      when 4
        new_state = match_token_at_4(token, context)
      when 5
        new_state = match_token_at_5(token, context)
      when 6
        new_state = match_token_at_6(token, context)
      when 7
        new_state = match_token_at_7(token, context)
      when 8
        new_state = match_token_at_8(token, context)
      when 9
        new_state = match_token_at_9(token, context)
      when 10
        new_state = match_token_at_10(token, context)
      when 11
        new_state = match_token_at_11(token, context)
      when 12
        new_state = match_token_at_12(token, context)
      when 13
        new_state = match_token_at_13(token, context)
      when 14
        new_state = match_token_at_14(token, context)
      when 15
        new_state = match_token_at_15(token, context)
      when 16
        new_state = match_token_at_16(token, context)
      when 17
        new_state = match_token_at_17(token, context)
      when 18
        new_state = match_token_at_18(token, context)
      when 19
        new_state = match_token_at_19(token, context)
      when 20
        new_state = match_token_at_20(token, context)
      when 21
        new_state = match_token_at_21(token, context)
      when 22
        new_state = match_token_at_22(token, context)
      when 23
        new_state = match_token_at_23(token, context)
      when 24
        new_state = match_token_at_24(token, context)
      when 25
        new_state = match_token_at_25(token, context)
      when 26
        new_state = match_token_at_26(token, context)
      when 27
        new_state = match_token_at_27(token, context)
      when 28
        new_state = match_token_at_28(token, context)
      when 29
        new_state = match_token_at_29(token, context)
      when 30
        new_state = match_token_at_30(token, context)
      when 31
        new_state = match_token_at_31(token, context)
      when 33
        new_state = match_token_at_33(token, context)
      when 34
        new_state = match_token_at_34(token, context)
      when 35
        new_state = match_token_at_35(token, context)
      when 36
        new_state = match_token_at_36(token, context)
      when 37
        new_state = match_token_at_37(token, context)
      when 38
        new_state = match_token_at_38(token, context)
      when 39
        new_state = match_token_at_39(token, context)
      when 40
        new_state = match_token_at_40(token, context)
      when 41
        new_state = match_token_at_41(token, context)
      else
        raise ParserError.new("unknown state")
      end

      new_state
    end

    
    # Start
    def match_token_at_0(token, context)
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.push(:rule_Feature_Def)
        context.ast_builder.build(token)
        return 1
      end
      if (context.token_matcher.match_Feature(token))
        context.ast_builder.push(:rule_Feature_Def)
        context.ast_builder.build(token)
        return 2
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 0
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 0
      end
      raise ParseError.new
    end
    
    
    # Feature_File:0>Feature_Def:0>#TagLine:0
    def match_token_at_1(token, context)
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.build(token)
        return 1
      end
      if (context.token_matcher.match_Feature(token))
        context.ast_builder.build(token)
        return 2
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 1
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 1
      end
      raise ParseError.new
    end
    
    
    # Feature_File:0>Feature_Def:1>#Feature:0
    def match_token_at_2(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.push(:rule_Description)
        context.ast_builder.build(token)
        return 3
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 4
      end
      if (context.token_matcher.match_Background(token))
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Background)
        context.ast_builder.build(token)
        return 5
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.push(:rule_Description)
        context.ast_builder.build(token)
        return 3
      end
      raise ParseError.new
    end
    
    
    # Feature_File:0>Feature_Def:2>Feature_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
    def match_token_at_3(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 3
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.build(token)
        return 4
      end
      if (context.token_matcher.match_Background(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Background)
        context.ast_builder.build(token)
        return 5
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 3
      end
      raise ParseError.new
    end
    
    
    # Feature_File:0>Feature_Def:2>Feature_Description:0>Description_Helper:1>#Comment:0
    def match_token_at_4(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 4
      end
      if (context.token_matcher.match_Background(token))
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Background)
        context.ast_builder.build(token)
        return 5
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Feature_Def)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 4
      end
      raise ParseError.new
    end
    
    
    # Feature_File:1>Background:0>#Background:0
    def match_token_at_5(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.push(:rule_Description)
        context.ast_builder.build(token)
        return 6
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 7
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 8
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.push(:rule_Description)
        context.ast_builder.build(token)
        return 6
      end
      raise ParseError.new
    end
    
    
    # Feature_File:1>Background:1>Background_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
    def match_token_at_6(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 6
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.build(token)
        return 7
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 8
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 6
      end
      raise ParseError.new
    end
    
    
    # Feature_File:1>Background:1>Background_Description:0>Description_Helper:1>#Comment:0
    def match_token_at_7(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 7
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 8
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 7
      end
      raise ParseError.new
    end
    
    
    # Feature_File:1>Background:2>Scenario_Step:0>Step:0>#Step:0
    def match_token_at_8(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.push(:rule_Table_Arg)
        context.ast_builder.build(token)
        return 9
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.push(:rule_Multiline_Arg)
        context.ast_builder.build(token)
        return 39
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 8
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 8
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 8
      end
      raise ParseError.new
    end
    
    
    # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0
    def match_token_at_9(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.build(token)
        return 9
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.push(:rule_Multiline_Arg)
        context.ast_builder.build(token)
        return 10
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 8
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 9
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 9
      end
      raise ParseError.new
    end
    
    
    # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0
    def match_token_at_10(token, context)
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 10
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.build(token)
        return 11
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 10
      end
      raise ParseError.new
    end
    
    
    # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0
    def match_token_at_11(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 8
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 11
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 11
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:0>#TagLine:0
    def match_token_at_12(token, context)
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 12
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:0>#Scenario:0
    def match_token_at_13(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.push(:rule_Description)
        context.ast_builder.build(token)
        return 14
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 15
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 16
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.push(:rule_Description)
        context.ast_builder.build(token)
        return 14
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
    def match_token_at_14(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 14
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.build(token)
        return 15
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 16
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 14
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:1>Scenario_Description:0>Description_Helper:1>#Comment:0
    def match_token_at_15(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 15
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 16
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 15
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:0>#Step:0
    def match_token_at_16(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.push(:rule_Table_Arg)
        context.ast_builder.build(token)
        return 17
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.push(:rule_Multiline_Arg)
        context.ast_builder.build(token)
        return 36
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 16
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 16
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 16
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0
    def match_token_at_17(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.build(token)
        return 17
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.push(:rule_Multiline_Arg)
        context.ast_builder.build(token)
        return 18
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 16
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 17
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 17
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0
    def match_token_at_18(token, context)
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 18
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.build(token)
        return 19
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 18
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0
    def match_token_at_19(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 16
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 19
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 19
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:0>#ScenarioOutline:0
    def match_token_at_20(token, context)
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.push(:rule_Description)
        context.ast_builder.build(token)
        return 21
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 22
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 23
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 27
      end
      if (context.token_matcher.match_Examples(token))
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 28
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.push(:rule_Description)
        context.ast_builder.build(token)
        return 21
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
    def match_token_at_21(token, context)
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 21
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.build(token)
        return 22
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 23
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 27
      end
      if (context.token_matcher.match_Examples(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 28
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 21
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:1>ScenarioOutline_Description:0>Description_Helper:1>#Comment:0
    def match_token_at_22(token, context)
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 22
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 23
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 27
      end
      if (context.token_matcher.match_Examples(token))
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 28
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 22
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:0>#Step:0
    def match_token_at_23(token, context)
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.push(:rule_Table_Arg)
        context.ast_builder.build(token)
        return 24
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.push(:rule_Multiline_Arg)
        context.ast_builder.build(token)
        return 33
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 23
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 27
      end
      if (context.token_matcher.match_Examples(token))
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 28
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 23
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 23
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:0>Table_Arg:0>#TableRow:0
    def match_token_at_24(token, context)
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.build(token)
        return 24
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.push(:rule_Multiline_Arg)
        context.ast_builder.build(token)
        return 25
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 23
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 27
      end
      if (context.token_matcher.match_Examples(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 28
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 24
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 24
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:0>#MultiLineArgument:0
    def match_token_at_25(token, context)
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 25
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.build(token)
        return 26
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 25
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:0>Table_And_Multiline_Arg:1>Multiline_Arg:2>#MultiLineArgument:0
    def match_token_at_26(token, context)
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 23
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 27
      end
      if (context.token_matcher.match_Examples(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 28
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 26
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 26
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:0>#TagLine:0
    def match_token_at_27(token, context)
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.build(token)
        return 27
      end
      if (context.token_matcher.match_Examples(token))
        context.ast_builder.build(token)
        return 28
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 27
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 27
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:1>#Examples:0
    def match_token_at_28(token, context)
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.push(:rule_Description)
        context.ast_builder.build(token)
        return 29
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 30
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.push(:rule_Examples_Table)
        context.ast_builder.build(token)
        return 31
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.push(:rule_Description)
        context.ast_builder.build(token)
        return 29
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:0>Description:0>Description_Line:0>__alt3:0>#Empty:0
    def match_token_at_29(token, context)
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 29
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.build(token)
        return 30
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.pop(:rule_Description)
        context.ast_builder.push(:rule_Examples_Table)
        context.ast_builder.build(token)
        return 31
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 29
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:2>Examples_Description:0>Description_Helper:1>#Comment:0
    def match_token_at_30(token, context)
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 30
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.push(:rule_Examples_Table)
        context.ast_builder.build(token)
        return 31
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 30
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:3>Examples:3>Examples_Table:0>#TableRow:0
    def match_token_at_31(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Examples_Table)
        context.ast_builder.pop(:rule_Examples)
        context.ast_builder.pop(:rule_ScenarioOutline)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.build(token)
        return 31
      end
      if (context.token_matcher.match_TagLine(token))
        if (lookahead_0(context, token))
        context.ast_builder.pop(:rule_Examples_Table)
        context.ast_builder.pop(:rule_Examples)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 27
        end
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Examples_Table)
        context.ast_builder.pop(:rule_Examples)
        context.ast_builder.pop(:rule_ScenarioOutline)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Examples(token))
        context.ast_builder.pop(:rule_Examples_Table)
        context.ast_builder.pop(:rule_Examples)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 28
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Examples_Table)
        context.ast_builder.pop(:rule_Examples)
        context.ast_builder.pop(:rule_ScenarioOutline)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Examples_Table)
        context.ast_builder.pop(:rule_Examples)
        context.ast_builder.pop(:rule_ScenarioOutline)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 31
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 31
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0
    def match_token_at_33(token, context)
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 33
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.build(token)
        return 34
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 33
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0
    def match_token_at_34(token, context)
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.push(:rule_Table_Arg)
        context.ast_builder.build(token)
        return 35
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 23
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 27
      end
      if (context.token_matcher.match_Examples(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 28
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 34
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 34
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:1>ScenarioOutline:2>ScenarioOutline_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0
    def match_token_at_35(token, context)
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.build(token)
        return 35
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 23
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 27
      end
      if (context.token_matcher.match_Examples(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Examples)
        context.ast_builder.build(token)
        return 28
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 35
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 35
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0
    def match_token_at_36(token, context)
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 36
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.build(token)
        return 37
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 36
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0
    def match_token_at_37(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.push(:rule_Table_Arg)
        context.ast_builder.build(token)
        return 38
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 16
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 37
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 37
      end
      raise ParseError.new
    end
    
    
    # Feature_File:2>Scenario_Base:1>Scenario_Base_Body:0>__alt0:0>Scenario:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0
    def match_token_at_38(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.build(token)
        return 38
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 16
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Scenario)
        context.ast_builder.pop(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 38
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 38
      end
      raise ParseError.new
    end
    
    
    # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:0>#MultiLineArgument:0
    def match_token_at_39(token, context)
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 39
      end
      if (context.token_matcher.match_MultiLineArgument(token))
        context.ast_builder.build(token)
        return 40
      end
      if (context.token_matcher.match_Other(token))
        context.ast_builder.build(token)
        return 39
      end
      raise ParseError.new
    end
    
    
    # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:0>Multiline_Arg:2>#MultiLineArgument:0
    def match_token_at_40(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.push(:rule_Table_Arg)
        context.ast_builder.build(token)
        return 41
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 8
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Multiline_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 40
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 40
      end
      raise ParseError.new
    end
    
    
    # Feature_File:1>Background:2>Scenario_Step:0>Step:1>Step_Arg:0>__alt1:1>Multiline_And_Table_Arg:1>Table_Arg:0>#TableRow:0
    def match_token_at_41(token, context)
      if (context.token_matcher.match_EOF(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.build(token)
        return 32
      end
      if (context.token_matcher.match_TableRow(token))
        context.ast_builder.build(token)
        return 41
      end
      if (context.token_matcher.match_Step(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.push(:rule_Step)
        context.ast_builder.build(token)
        return 8
      end
      if (context.token_matcher.match_TagLine(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.build(token)
        return 12
      end
      if (context.token_matcher.match_Scenario(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_Scenario)
        context.ast_builder.build(token)
        return 13
      end
      if (context.token_matcher.match_ScenarioOutline(token))
        context.ast_builder.pop(:rule_Table_Arg)
        context.ast_builder.pop(:rule_Step)
        context.ast_builder.pop(:rule_Background)
        context.ast_builder.push(:rule_Scenario_Base)
        context.ast_builder.push(:rule_ScenarioOutline)
        context.ast_builder.build(token)
        return 20
      end
      if (context.token_matcher.match_Comment(token))
        context.ast_builder.build(token)
        return 41
      end
      if (context.token_matcher.match_Empty(token))
        context.ast_builder.build(token)
        return 41
      end
      raise ParseError.new
    end
    

    
    def lookahead_0(context, current_token)
      current_token.detach
      queue = []
      match = false
      loop do
        token = read_token(context)
        token.detach
        queue.push(token)

        if (false \
          || context.token_matcher.match_Examples(token) \
        )
          match = true
          break
        end

        if not(false \
          || context.token_matcher.match_Empty(token) \
          || context.token_matcher.match_Comment(token) \
          || context.token_matcher.match_TagLine(token) \
        )
          break
        end
      end
      queue.each do |t|
        context.token_queue.push(t)
      end
      match
    end
    
  end
end
