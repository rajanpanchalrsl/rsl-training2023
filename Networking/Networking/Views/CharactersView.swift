import UIKit

class CharactersView: UIView {
    
    let charactersTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(charactersTableView)
        
        NSLayoutConstraint.activate([
            charactersTableView.topAnchor.constraint(equalTo: self.topAnchor),
            charactersTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            charactersTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            charactersTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
