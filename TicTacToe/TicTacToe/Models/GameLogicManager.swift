import UIKit

class GameLogicManager {
    private let winningMoves = [[1,2,3], [4,5,6], [7,8,9],
                                [1,4,7], [2,5,8], [3,6,9],
                                [1,5,9], [3,5,7]]
    var player1Moves = Set<Int>()
    var player2Moves = Set<Int>()
    private var currentPlayer = 1
    
    func resetBoard() {
        player1Moves.removeAll()
        player2Moves.removeAll()
        currentPlayer = 1
    }
    
    func getNextMoveForAI() -> Int? {
        let emptyCells = getEmptyCells()
        var aiMoveTag: Int?
        if Settings.shared.level == .easy {
            aiMoveTag = emptyCells.randomElement()
        } else if Settings.shared.level == .medium {
            aiMoveTag = findNextWinningMove(playerMoves: player2Moves, emptyCells: emptyCells)
                ?? findNextWinningMove(playerMoves: player1Moves, emptyCells: emptyCells)
                ?? emptyCells.randomElement()
        } else if Settings.shared.level == .hard {
            aiMoveTag = findNextWinningMove(playerMoves: player2Moves, emptyCells: emptyCells)
                ?? findNextWinningMove(playerMoves: player1Moves, emptyCells: emptyCells)
                ?? emptyCells.first(where: { $0 == 5 })
                ?? emptyCells.randomElement()
        }
        
        return aiMoveTag
    }
    
    func checkWinningMove(playerMoves: Set<Int>) -> [Int]? {
        for winningMove in winningMoves {
            let intersectingMoves = winningMove.filter { playerMoves.contains($0) }
            if intersectingMoves.count == winningMove.count {
                let firstElement = intersectingMoves.first!
                let lastElement = intersectingMoves.last!
                return [firstElement, lastElement]
            }
        }
        return nil
    }
    
    func checkForDraw() -> Bool {
        return getEmptyCells().isEmpty
    }
    
    func findNextWinningMove(playerMoves: Set<Int>, emptyCells: [Int]) -> Int? {
        for winningMove in winningMoves {
            let intersectingMoves = winningMove.filter { playerMoves.contains($0) }
            if intersectingMoves.count == winningMove.count - 1 {
                for move in winningMove {
                    if emptyCells.contains(where: { $0 == move }) {
                        return move
                    }
                }
            }
        }
        return nil
    }
    
    func getEmptyCells() -> [Int] {
        let allTags = Array(1...9)
        var emptyCells = [Int]()
        for tag in allTags {
            if !player1Moves.contains(tag) && !player2Moves.contains(tag) {
                emptyCells.append(tag)
            }
        }
        return emptyCells
    }
}
