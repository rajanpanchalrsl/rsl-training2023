import UIKit

protocol HomepageViewDelegate {
    func startNewGame()
    func changeSettings()
}

class HomePageView: UIView {
    var delegate: HomepageViewDelegate?

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "TicTacToe")
        return imageView
    }()
    
    private var gameTitle : UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Tic Tac Toe"
        myLabel.font = UIFont.boldSystemFont(ofSize: 32.0)
        myLabel.textAlignment = .center
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        return myLabel
    }()
    
    private let startGameButton : UIButton = {
        let myBtn = UIButton()
        myBtn.setTitle("Start Game", for: .normal)
        myBtn.backgroundColor = .systemGreen
        myBtn.layer.cornerRadius = 15;
        myBtn.titleLabel?.font = .systemFont(ofSize: 22)
        myBtn.translatesAutoresizingMaskIntoConstraints = false;
        return myBtn
    }()
    
    private let settingsButton : UIButton = {
        let myBtn = UIButton()
        myBtn.setTitle("Settings", for: .normal)
        myBtn.backgroundColor = .systemBlue
        myBtn.layer.cornerRadius = 15;
        myBtn.titleLabel?.font = .systemFont(ofSize: 22)
        myBtn.translatesAutoresizingMaskIntoConstraints = false;
        return myBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(gameTitle)
        self.addSubview(logoImageView)
        self.addSubview(startGameButton)
        self.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -64),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            
            gameTitle.bottomAnchor.constraint(equalTo: logoImageView.topAnchor, constant: -64),
            gameTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            startGameButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 64),
            startGameButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startGameButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            startGameButton.heightAnchor.constraint(equalToConstant: 50),
            
            settingsButton.topAnchor.constraint(equalTo: startGameButton.bottomAnchor, constant: 32),
            settingsButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            settingsButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            settingsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        startGameButton.addTarget(self,action: #selector(startGameButtonTapped),for: .touchUpInside);
        settingsButton.addTarget(self,action: #selector(settingsButtonTapped),for: .touchUpInside);
    }
    
    
    @objc private func startGameButtonTapped() {
        self.delegate?.startNewGame()
    }
    
    @objc private func settingsButtonTapped() {
        self.delegate?.changeSettings()
    }
}
    
