import UIKit

class SettingsPageViewController: UIViewController {
    private var settingsPageView = SettingsPageView()
    private var textWithSecondaryTextCellIdentifier = "TextWithSecondaryTextCell"
    private var textWithIconCellIdentifier = "TextWithIconCell"

    private let footerText = "(Opponent Type: User) is Still in Development."
    private let aboutText = "This Game is Made by Rajan Panchal as an Assignment related to CustomViews & Shapes in Raja Software Labs."
    private let rulesText = "Tic-tac-toe is a classic game played on a 3x3 grid. Two players take turns marking X or O in empty spaces with the goal of achieving three of their marks in a row, either horizontally, vertically, or diagonally. The first player to accomplish this wins the game. If all spaces are filled without a winner, the game ends in a draw."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
        self.title = "Settings"
        self.view.addSubview(settingsPageView)
        settingsPageView.translatesAutoresizingMaskIntoConstraints = false
        settingsPageView.tableView.register(TextWithSecondaryTextCell.self, forCellReuseIdentifier: textWithSecondaryTextCellIdentifier)
        settingsPageView.tableView.register(TextWithIconCell.self, forCellReuseIdentifier: textWithIconCellIdentifier)

        settingsPageView.tableView.delegate = self
        settingsPageView.tableView.dataSource = self
        NSLayoutConstraint.activate([
            settingsPageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            settingsPageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            settingsPageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            settingsPageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func addTableFooterView() {
        let footerLabel = UILabel()
        footerLabel.textColor = .red
        footerLabel.font = UIFont.systemFont(ofSize: 18)
        footerLabel.numberOfLines = 0
        footerLabel.text = footerText
        
        let footerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        footerContainerView.addSubview(footerLabel)
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerLabel.topAnchor.constraint(equalTo: footerContainerView.topAnchor),
            footerLabel.leadingAnchor.constraint(equalTo: footerContainerView.leadingAnchor, constant: 32),
            footerLabel.trailingAnchor.constraint(equalTo: footerContainerView.trailingAnchor, constant: -16),
            footerLabel.bottomAnchor.constraint(equalTo: footerContainerView.bottomAnchor),
        ])
        settingsPageView.tableView.tableFooterView = footerContainerView
    }
}

extension SettingsPageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 4
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = settingsPageView.tableView.dequeueReusableCell(withIdentifier: textWithIconCellIdentifier, for: indexPath) as! TextWithIconCell
            cell.configure(text: "About")
            return cell
        case 1:
            let cell = settingsPageView.tableView.dequeueReusableCell(withIdentifier: textWithIconCellIdentifier, for: indexPath) as! TextWithIconCell
            cell.configure(text: "Rules")
            return cell
        case 2:
            let cell = settingsPageView.tableView.dequeueReusableCell(withIdentifier: textWithSecondaryTextCellIdentifier, for: indexPath) as! TextWithSecondaryTextCell
            let text: String
            let secondaryText: String
            switch indexPath.row {
            case 0:
                text = "Level"
                secondaryText = Settings.shared.level.rawValue
            case 1:
                text = "Opponent"
                secondaryText = Settings.shared.opponent.rawValue
            case 2:
                text = "First Turn"
                secondaryText = Settings.shared.firstTurn.rawValue
            case 3:
                text = "My Symbol"
                secondaryText = Settings.shared.mySymbol.rawValue
            default:
                return UITableViewCell()
            }
            cell.configure(text: text, secondaryText: secondaryText)
            return cell
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            addTableFooterView()
        }
    }
}

extension SettingsPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 2) {
            switch indexPath.row {
            case 0:
                ActionAndAlertMaker.showActionSheet(title: "Select Level", options: Settings.Level.allCases) { level in
                    Settings.shared.level = level
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
                }
            case 1:
                ActionAndAlertMaker.showActionSheet(title: "Select Opponent", options: Settings.Opponent.allCases) { opponent in
                    Settings.shared.opponent = opponent
                    tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
                }
            case 2:
                ActionAndAlertMaker.showActionSheet(title: "Select First Turn", options: Settings.FirstTurn.allCases) { firstTurn in
                    Settings.shared.firstTurn = firstTurn
                    tableView.reloadRows(at: [IndexPath(row: 2, section: 2)], with: .automatic)
                }
            case 3:
                ActionAndAlertMaker.showActionSheet(title: "Select My Symbol", options: Settings.MySymbol.allCases) { symbol in
                    Settings.shared.mySymbol = symbol
                    tableView.reloadRows(at: [IndexPath(row: 3, section: 2)], with: .automatic)
                }
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            ActionAndAlertMaker.showAlert(title: "About", subtitle: aboutText)
        case 1:
            ActionAndAlertMaker.showAlert(title: "Rules", subtitle: rulesText)
        default:
            break
        }
    }
}
