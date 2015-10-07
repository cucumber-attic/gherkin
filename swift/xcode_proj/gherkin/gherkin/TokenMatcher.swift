enum TokenType {
    case TagLine
    case FeatureLine
    case ScenarioLine
    case ScenarioOutlineLine
    case BackgroundLine
    case ExamplesLine
    case TableRow
    case Empty
    case Comment
    case Language
    case DocStringSeparator
    case EOF
    case Other
    case StepLine
}

class TokenMatcher {
    let defaultDialectName: String
    
    init(dialectName: String = "en") {
        
        self.defaultDialectName = dialectName
    }
    
    func reset() {
        
    }
    
    func matchEmpty(token: Token) -> Bool {
        
    }
    
    func matchComment(token: Token) -> Bool {
        
    }
    
    func matchTagLine(toke: Token) -> Bool {
        
    }
    
    func matchFeatureLine(token: Token) -> Bool {
        
    }
    
    func matchBackgroundLine(token: Token) -> Bool {
        
    }
    
    func matchScenarioLine(token: Token) -> Bool {
        
    }
    
    
    
    private func changeDialect(dialectName: String, location: String) {

    }
    
//    def match_title_line(token, token_type, keywords)
//    keyword = keywords.detect { |k| token.line.start_with_title_keyword?(k) }
//    
//    return false unless keyword
//    
//    title = token.line.get_rest_trimmed(keyword.length + ':'.length)
//    set_token_matched(token, token_type, title, keyword)
//    true
//    end
    private func matchTitleLine(token: Token, tokenType: TokenType, keywords: [String]) -> Bool {
        
        title = token.
        setTokenMatched(token, matchedType: tokenType, text: title, keyword: keyword)
        return true
    }
    
    private func setTokenMatched(token: Token, matchedType: TokenType, text: String = "", keyword: String = "", indent: String = "", items: [String] = []) {
        
    }
}