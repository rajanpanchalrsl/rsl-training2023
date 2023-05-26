import UIKit

protocol CharacterViewDelegate {
    func submitData(of character: Character)
    func submitError(_ error: String)
}

class CharacterView: UIView {
    
    var delegate:CharacterViewDelegate?

    lazy var idTextField = createIdTextField(of: "Id")
    lazy var firstNameTextField = createIdTextField(of: "First Name")
    lazy var lastNameTextField = createIdTextField(of: "Last Name")
    lazy var titleTextField = createIdTextField(of: "Title")
    lazy var familyTextField = createIdTextField(of: "Family")
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(idTextField)
        self.addSubview(firstNameTextField)
        self.addSubview(lastNameTextField)
        self.addSubview(titleTextField)
        self.addSubview(familyTextField)
        self.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            idTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            idTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            idTextField.heightAnchor.constraint(equalToConstant: 40),
            
            firstNameTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 16),
            firstNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            firstNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            lastNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            titleTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            familyTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            familyTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            familyTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            familyTextField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.topAnchor.constraint(equalTo: familyTextField.bottomAnchor, constant: 24),
            submitButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    func fillDetails(of character: Character) {
        idTextField.text = String(character.id)
        firstNameTextField.text = character.firstName
        lastNameTextField.text = character.lastName
        titleTextField.text = character.title
        familyTextField.text = character.family
        
    }
    
    private func createIdTextField(of placeHolder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeHolder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.autocorrectionType = .no
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        return textField
    }
        
    @objc private func submitButtonTapped() {
        guard let idText = idTextField.text, !idText.isEmpty else {
            self.delegate?.submitError("ID is Mandatory")
            return
        }
        guard let id = Int(idText) else {
            self.delegate?.submitError("Invalid ID format")
            return
        }
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            self.delegate?.submitError("First Name is Mandatory")
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            self.delegate?.submitError("Last Name is Mandatory")
            return
        }
        let fullName = firstName + " " + lastName
        guard let title = titleTextField.text, !title.isEmpty else {
            self.delegate?.submitError("Title is Mandatory")
            return
        }
        guard let family = familyTextField.text, !family.isEmpty else {
            self.delegate?.submitError("Family Name is Mandatory")
            return
        }
        let image = "\(firstName.lowercased()).jpg"
        let imageUrl = "https://thronesapi.com/assets/images/\(image)"
        
        let character = Character(id: id,
                                  firstName: firstName,
                                  lastName: lastName,
                                  fullName: fullName,
                                  title: title,
                                  family: family,
                                  image: image,
                                  imageUrl: imageUrl)
        self.delegate?.submitData(of: character)
    }
}
