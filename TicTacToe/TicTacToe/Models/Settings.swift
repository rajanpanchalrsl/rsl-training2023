struct Settings {
    enum Level: String, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    enum Opponent: String, CaseIterable {
        case ai = "AI"
        case user = "User"
    }
    
    enum FirstTurn: String, CaseIterable {
        case mine = "Mine"
        case opponents = "Opponents"
    }
    
    enum MySymbol: String, CaseIterable {
        case cross = "Cross (X)"
        case circle = "Circle (O)"
    }
    
    static var shared = Settings(level: .easy, opponent: .ai, firstTurn: .mine, mySymbol: .cross)
    
    var level: Level
    var opponent: Opponent
    var firstTurn: FirstTurn
    var mySymbol: MySymbol 
    
    private init(level: Level, opponent: Opponent, firstTurn: FirstTurn, mySymbol: MySymbol) {
        self.level = level
        self.opponent = opponent
        self.firstTurn = firstTurn
        self.mySymbol = mySymbol
    }
}
