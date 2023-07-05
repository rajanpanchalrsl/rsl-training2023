import UIKit

class RecordManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let recordsCellIdentifier = "RecordsCellIdentifier"
    private var rounds: Int = 0
    private var player1Wins: Int = 0
    private var player1Losses: Int = 0
    private var results: [String] = []
    private weak var tableView: UITableView?

    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        configureTableView()
    }

    private func configureTableView() {
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: recordsCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results.isEmpty {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recordsCellIdentifier, for: indexPath)
        let result = results[indexPath.row]
        cell.textLabel?.text = result
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        headerView.backgroundColor = .lightGray

        let totalRoundsLabel = UILabel(frame: headerView.bounds)
        totalRoundsLabel.textAlignment = .center
        totalRoundsLabel.text = "Total Rounds: \(rounds)"
        headerView.addSubview(totalRoundsLabel)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        footerView.backgroundColor = .lightGray

        let totalWinsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: footerView.bounds.width / 2, height: footerView.bounds.height))
        totalWinsLabel.textAlignment = .center
        totalWinsLabel.text = "Total Wins: \(player1Wins)"
        footerView.addSubview(totalWinsLabel)

        let totalLossesLabel = UILabel(frame: CGRect(x: footerView.bounds.width / 2, y: 0, width: footerView.bounds.width / 2, height: footerView.bounds.height))
        totalLossesLabel.textAlignment = .center
        totalLossesLabel.text = "Total Losses: \(player1Losses)"
        footerView.addSubview(totalLossesLabel)

        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func resetRecords() {
        rounds = 0
        player1Wins = 0
        player1Losses = 0
        results.removeAll()
        tableView?.reloadData()
    }

    func updateRecord(with result: String) {
        rounds += 1
        if (result == "Player 1") {
            player1Wins += 1
            results.insert("Round \(rounds): \(result) - Won", at: 0)
        } else if (result == "Draw") {
            results.insert("Round \(rounds): \(result)", at: 0)
        } else {
            player1Losses += 1
            results.insert("Round \(rounds): \(result) - Loss", at: 0)
        }
        tableView?.reloadData()
    }
}
