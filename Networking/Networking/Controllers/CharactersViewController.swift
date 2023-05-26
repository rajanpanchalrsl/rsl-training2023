import UIKit

class CharactersViewController: UIViewController {

    private var charactersView = CharactersView()
    private var charactersModel = CharacterNetworkManager()
    private var imageModel = ImageNetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupModel()
        self.setupView()
    }
    
    func setupModel() {
        charactersModel.getCharacters { characters, error in
            if let error = error {
                print("Error Fetching Characters: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.charactersView.charactersTableView.reloadData()
            }
        }
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
        self.title = "GOT Characters"
        
        let addCharacterButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(addCharacterButtonTapped))
        self.navigationItem.rightBarButtonItem = addCharacterButton;
        
        charactersView.charactersTableView.delegate = self;
        charactersView.charactersTableView.dataSource = self;
        charactersView.charactersTableView.register(CharacterCell.self, forCellReuseIdentifier: "CharacterCellIdentifier")
        self.view.addSubview(charactersView)
        charactersView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            charactersView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            charactersView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            charactersView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            charactersView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func addCharacterButtonTapped() {
        let characterViewController = CharacterViewController()
        navigationController?.pushViewController(characterViewController, animated: true)
    }
}

extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = charactersView.charactersTableView.dequeueReusableCell(withIdentifier: "CharacterCellIdentifier",
                                                                          for: indexPath) as! CharacterCell
        let character = charactersModel.characters[indexPath.row]
        cell.configureCell(character: character)
        cell.delegate = self
        return cell;
    }
}

extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
}

extension CharactersViewController: CharacterCellDelegate {
    func editDetails(at indexPath: IndexPath) {
        let character = charactersModel.characters[indexPath.row];
        let characterViewController = CharacterViewController(character: character)
        navigationController?.pushViewController(characterViewController, animated: true)
    }

    func downloadImage(at indexPath: IndexPath) {
        print("Downloading Started...")
        let character = charactersModel.characters[indexPath.row];
        imageModel.saveImage(of: character) { isSuccess, error in
            if let error = error {
                print("Error Saving Image: \(error)")
                return
            }
            if !isSuccess {
                print("Unknown Error Occured while Saving Image")
                return
            }
            print("Image Saved Successfully")
        }
    }
}
