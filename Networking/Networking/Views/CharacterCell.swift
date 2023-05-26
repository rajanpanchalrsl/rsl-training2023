import UIKit

protocol CharacterCellDelegate {
    func editDetails(at indexPath: IndexPath)
    func downloadImage(at indexPath: IndexPath)
}

class CharacterCell: UITableViewCell {
    
    var delegate:CharacterCellDelegate?
    private var imageModel = ImageNetworkManager()

    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "thumb")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var idLabel = createLabel()
    lazy private var firstNameLabel = createLabel()
    lazy private var lastNameLabel = createLabel()
    lazy private var fullNameLabel = createLabel()
    lazy private var titleLabel = createLabel()
    lazy private var familyLabel = createLabel()
    lazy private var imageNameLabel = createLabel()

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Data", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download Image", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let imageAndButtonsStack = UIStackView(arrangedSubviews: [characterImageView,
                                                       editButton,
                                                       downloadButton])
        imageAndButtonsStack.axis = .vertical
        imageAndButtonsStack.distribution  = .fillProportionally
        imageAndButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageAndButtonsStack)
        
        let characterDetailsStack = UIStackView(arrangedSubviews: [idLabel,
                                                        firstNameLabel,
                                                        lastNameLabel,
                                                        fullNameLabel,
                                                        titleLabel,
                                                        familyLabel,
                                                        imageNameLabel])
        characterDetailsStack.axis = .vertical
        characterDetailsStack.distribution  = .fillProportionally
        characterDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(characterDetailsStack)
        
        NSLayoutConstraint.activate([
            characterImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            
            imageAndButtonsStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            imageAndButtonsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            imageAndButtonsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            imageAndButtonsStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
            
            characterDetailsStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            characterDetailsStack.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 8),
            characterDetailsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            characterDetailsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        
        selectionStyle = .none
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
        
    func configureCell(character:Character) {
        idLabel.text = "ID: \(character.id)"
        firstNameLabel.text = "First Name: \(character.firstName)"
        lastNameLabel.text = "Last Name: \(character.lastName)"
        fullNameLabel.text = "Full Name: \(character.fullName)"
        titleLabel.text = "Title: \(character.title)"
        familyLabel.text = "Family: \(character.family)"
        imageNameLabel.text = "Image: \(character.image)"
        
        imageModel.getImage(of: character) { image, error in
            if let error = error {
                print("Error Fetching Image: \(error)")
                return
            }
            guard let image = image else {
                print("Unknown Error")
                return
            }
            DispatchQueue.main.async {
                self.characterImageView.image = image
            }
        }
    }
    
    @objc private func editButtonTapped() {
        if let tableView = superview as? UITableView,
            let indexPath = tableView.indexPath(for: self) {
            delegate?.editDetails(at: indexPath)
        }
    }
    
    @objc private func downloadButtonTapped() {
        if let tableView = superview as? UITableView,
            let indexPath = tableView.indexPath(for: self) {
            delegate?.downloadImage(at: indexPath)
        }
    }
}

