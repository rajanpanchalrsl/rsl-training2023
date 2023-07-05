import UIKit

class GamePageViewController: UIViewController {
    private var gamePageView = GamePageView()
    private var shapeMaker = ShapeMaker()
    private var gameEngine = GameLogicManager()
    private var opponentTurnLabel = ""
    private var recordsCellIdentifier = "RecordsCellIdentifier"
    private var tableViewManager: RecordManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureGameSettings()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(gamePageView)
        gamePageView.translatesAutoresizingMaskIntoConstraints = false
        gamePageView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: recordsCellIdentifier)
        
        tableViewManager = RecordManager(tableView: gamePageView.tableView)
        gamePageView.tableView.dataSource = tableViewManager
        gamePageView.tableView.delegate = tableViewManager
        gamePageView.gridMaker.delegate = self
        
        let restartButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(restartGame))
        self.navigationItem.rightBarButtonItem = restartButton;
        
        NSLayoutConstraint.activate([
            gamePageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            gamePageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            gamePageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            gamePageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureGameSettings() {
        opponentTurnLabel = (Settings.shared.opponent == .ai) ? "Computer" : "Player 2"
        gamePageView.userLabel.text = (Settings.shared.firstTurn == .mine) ? "Player 1 Turn" : opponentTurnLabel + " Turn"
        if Settings.shared.firstTurn == .opponents && Settings.shared.opponent == .ai {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.aiTurn()
            }
        }
    }
    
    private func resetBoard() {
        gamePageView.gridMaker.resetGrid()
        shapeMaker.removeAllShapes(inView: gamePageView.gridMaker)
        gameEngine.resetBoard()
        configureGameSettings()
    }
    
    private func userTurn(at tag: Int) {
        let symbol = (Settings.shared.mySymbol == .cross) ? "Cross" : "Circle"
        shapeMaker.createShape(symbol: symbol, tag: tag, inView: gamePageView.gridMaker)
        gameEngine.player1Moves.insert(tag)
        handleMoveResult(playerMoves: gameEngine.player1Moves, playerLabel: "Player 1")
    }
    
    private func aiTurn() {
        let aiMoveTag = gameEngine.getNextMoveForAI()
        if let aiMoveTag = aiMoveTag {
            let symbol = (Settings.shared.mySymbol == .cross) ? "Circle" : "Cross"
            shapeMaker.createShape(symbol: symbol, tag: aiMoveTag, inView: gamePageView.gridMaker)
            gameEngine.player2Moves.insert(aiMoveTag)
            handleMoveResult(playerMoves: gameEngine.player2Moves, playerLabel: "Computer")
        }
    }
    
    private func handleMoveResult(playerMoves: Set<Int>, playerLabel: String) {
        if let winningLine = gameEngine.checkWinningMove(playerMoves: playerMoves) {
            let firstElement = winningLine[0]
            let lastElement = winningLine[1]
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.shapeMaker.createLineBetweenTags(fromTag: firstElement, toTag: lastElement, inView: self.gamePageView.gridMaker)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    ActionAndAlertMaker.showAlert(title: "Result", subtitle: "\(playerLabel) Won")
                    self.tableViewManager.updateRecord(with: (playerLabel))
                    self.resetBoard()
                }
            }
        } else if gameEngine.checkForDraw() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                ActionAndAlertMaker.showAlert(title: "Result", subtitle: "It's a Draw")
                self.tableViewManager.updateRecord(with: "Draw")
                self.resetBoard()
            }
        } else {
            gamePageView.userLabel.text = (playerLabel == "Player 1") ? opponentTurnLabel + " Turn" : "Player 1 Turn"
            if Settings.shared.opponent == .ai && playerLabel == "Player 1" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.aiTurn()
                }
            }
        }
    }

    @objc func restartGame() {
        ActionAndAlertMaker.showAlertWithAction(title: "Restart Game", message: "Do you want to restart the game?", actionTitle: "Yes") { [weak self] in
            self?.resetBoard()
            self?.tableViewManager.resetRecords()
        }
    }
}

extension GamePageViewController: GridMakerDelegate {
    func gridCellTapped(at tag: Int) {
        userTurn(at: tag)
    }
}
