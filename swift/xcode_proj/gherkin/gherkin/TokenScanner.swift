import Cocoa
import Foundation

/**
    The scanner reads a gherkin doc (typically read from a .feature file) and
    creates a token for line. The tokens are passed to the parser, which outputs
    an AST (Abstract Syntax Tree).

    If the scanner sees a # language header, it will reconfigure itself dynamically
    to look for Gherkin keywords for the associated language. The keywords are defined
    in gherkin-languages.json.
*/
class TokenScanner {
    
    let soruce: NSURL
    let fileContents: String
    
    private var lineNumber: Int = 0
    
    /**
        Initializer
        
        :param: filePath NSURL to source file.
    */
    init(filePath: NSURL) {
        
        do {
            fileContents = try String(contentsOfURL: filePath)
        } catch {
            print("failure. Unable to get contents of file")
        }
    }
    
    /**
        Initializer
        
        :param: string String to be scanned
    */
    init(string: String) {
        
        fileContents = string
    }
    
    /**
        Read the given file or string
    
        :return: Token
    */
    func read() -> Token {
        var location = [ "line": self.lineNumber += 1 ]
        
//        if 
    }
}