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
    
    /**
        give a trimmed version of trimmedLineText
    
        :param: length Int to trim from front of text
    
        :return: String
    */
    func getRestTrimmed(length: Int) -> String {
        
        let range = Range(start: trimmedLineText.startIndex.advancedBy(length), end: trimmedLineText.endIndex)

        let trimmed = trimmedLineText.substringWithRange(range)
        return trimmed
    }
    
    /**
        check if trimmedLineText is empty

        :return: Bool
    */
    func empty() -> Bool {
        
        return trimmedLineText.isEmpty
    }
    
    /**
        Get the text with removed amount
    
        :param: indexToRemove Int
    
        :return: String
    */
    func getLineText(indexToRemove: Int = 0) -> String {
        
        if indexToRemove < 0 || indexToRemove > indent {
            return trimmedLineText
        } else {
            let range = Range(start: lineText.startIndex.advancedBy(indexToRemove), end: lineText.endIndex)
            let trimmed = lineText.substringWithRange(range)
            return trimmed
        }
    }
    
    func tableCells() -> Array<Dictionary<Int, String>> {
        let line = trimmedLineText
        let columns = line.componentsSeparatedByString("|").map {
            $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }.filter {$0 != ""}
        
        var indexedColumns = [[Int: String]]()
        for (index, value) in columns.enumerate() {
            indexedColumns.append([index: value])
        }
        return indexedColumns
    }
    
    func tags() -> Dictionary<Int, String> {
        
        var column = indent + 1
        var items = trimmedLineText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).componentsSeparatedByString("@")
    }
}

















