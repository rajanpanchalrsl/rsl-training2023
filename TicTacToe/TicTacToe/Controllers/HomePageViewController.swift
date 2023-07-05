import UIKit

class HomePageViewController: UIViewController {
    private var homePageView = HomePageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(homePageView)
        homePageView.delegate = self
        homePageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homePageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            homePageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            homePageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            homePageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomePageViewController: HomepageViewDelegate {
    func startNewGame() {
        let gameViewController = GamePageViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    func changeSettings() {
        let settingsViewController = SettingsPageViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
}
