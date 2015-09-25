import Foundation


/*
DIALECT_FILE_PATH = File.expand_path("gherkin-languages.json", File.dirname(__FILE__))
DIALECTS = JSON.parse File.read(DIALECT_FILE_PATH)
*/

class Dialect {
    let spec: Dictionary<String,String>
    
    class func dialectFor(name: String)
    
    init() {
        
    }
    
    
}