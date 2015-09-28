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
}