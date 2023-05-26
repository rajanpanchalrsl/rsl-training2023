import UIKit

class CharacterViewController: UIViewController {

    private var characterView = CharacterView()
    private var characterModel = CharacterNetworkManager()
    private var character: Character?

    convenience init(character: Character?) {
        self.init()
        self.character = character
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        if let character = character {
            title = "Edit Character"
            characterView.fillDetails(of: character)
        } else {
            title = "Add Character"
        }

        view.addSubview(characterView)
        characterView.translatesAutoresizingMaskIntoConstraints = false
        characterView.delegate = self
        
        NSLayoutConstraint.activate([
            characterView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            characterView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            characterView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            characterView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CharacterViewController: CharacterViewDelegate {
    func submitError(_ error: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: error,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func submitData(of character: Character) {
        characterModel.postCharacter(character) { isSuccess, error in
            if let error = error {
                print("Failed to Post Data: \(error)")
                return
            }
            if !isSuccess {
                print("Failed to Post Data due to Unknown Error")
                return
            }
            DispatchQueue.main.async {
                let dataAddedAlert = UIAlertController(title: "Alert",
                                                       message: "Data Added Successfully",
                                                       preferredStyle: .alert)
                dataAddedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(dataAddedAlert, animated: true, completion: nil)
            }
        }
    }
}

