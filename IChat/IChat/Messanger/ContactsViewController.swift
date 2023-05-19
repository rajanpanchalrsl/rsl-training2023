import UIKit

class ContactsViewController: UIViewController {
    
    private let contact: String
    private let mobile: String
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    init(contact: String? = nil, mobile: String? = nil) {
        self.contact = contact ?? ""
        self.mobile = mobile ?? ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLabels()
    }
    
    private func setupLabels() {
        view.addSubview(nameLabel)
        view.addSubview(numberLabel)
        
        nameLabel.text = contact
        numberLabel.text = mobile
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            numberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            numberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            numberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
