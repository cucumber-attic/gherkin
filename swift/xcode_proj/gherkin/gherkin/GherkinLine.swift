import Foundation

class GherkinLine {
    let lineText: String
    var lineNumber: Int
    var trimmedLineText: String
    var indent: Int {
        return lineText.characters.count - trimmedLineText.characters.count
    }
    
    init(lineText: String, lineNumber: Int) {
        
        self.lineText = lineText
        self.lineNumber = lineNumber
        self.trimmedLineText = self.lineText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func startsWith(prefix: String) -> Bool {
        
        return self.trimmedLineText.hasPrefix(prefix)
    }
    
    func startsWithTitleKeyword(keyword: String) -> Bool {
        
        return self.startsWith("\(keyword):")
    }
}