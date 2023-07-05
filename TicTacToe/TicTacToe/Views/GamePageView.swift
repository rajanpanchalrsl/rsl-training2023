import UIKit

class GamePageView: UIView {
    
    var userLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = ""
        myLabel.font = UIFont.boldSystemFont(ofSize: 32.0)
        myLabel.textAlignment = .center
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        return myLabel
    }()
    
    var gridMaker: GridMaker = {
       let gridMaker = GridMaker(gridSize: 3)
        gridMaker.translatesAutoresizingMaskIntoConstraints = false
        return gridMaker
    }()
    
    let tableView : UITableView = {
        let myTableView = UITableView()
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        return myTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(userLabel)
        self.addSubview(gridMaker)
        self.addSubview(tableView)

        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            userLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            gridMaker.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 32),
            gridMaker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            gridMaker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.80),
            gridMaker.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.80),
            
            tableView.topAnchor.constraint(equalTo: gridMaker.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32)
        ])
    }
}
