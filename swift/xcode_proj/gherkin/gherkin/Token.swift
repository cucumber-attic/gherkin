import Foundation

struct Token {
    var line: GherkinLine
    var location: [String: String]
    var matchedType: TokenType?
    var matchedText: String?
    var matchedKeyword: [String]?
    var matchedIndent: Int?
    var matchedItems: [String]?
    var matchedGherkinDialect: String?
    
    init(line: GherkinLine, location: [String: String]) {
        self.line = line
        self.location = location
    }
    
    func eof() -> Bool {
        self.line
    }
    
}
