import UIKit
import CoreLocation

protocol UniversitiesListViewControllerDelegate: AnyObject {
    func showRoute(to coordinates: CLLocationCoordinate2D)
}

class UniversitiesListViewController: UIViewController {
    
    weak var delegate: UniversitiesListViewControllerDelegate?

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var universityCellIdentifier = "UniversityCellIdentifier"
    private var searchController = UISearchController()
    private var universities: [University]
    private var filteredUniversities: [University]
    
    init(univeristies: [University]) {
        self.universities = univeristies
        self.filteredUniversities = universities
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        searchBarSetting()
    }
    
    private func setupView() {
        self.title = "List of Universities"
        self.view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: universityCellIdentifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension UniversitiesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUniversities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: universityCellIdentifier, for: indexPath)
        let university = filteredUniversities[indexPath.row]
        cell.textLabel?.text = university.attributes.universityChapter
        return cell
    }
}

extension UniversitiesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let university = universities[indexPath.row]
        let geometry = university.geometry
        let coordinate = CLLocationCoordinate2D(latitude: geometry.y, longitude: geometry.x)
        self.delegate?.showRoute(to: coordinate)
        navigationController?.popViewController(animated: true)
    }
}

extension UniversitiesListViewController: UISearchResultsUpdating {
    
    func searchBarSetting() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
           !searchText.isEmpty {
            filteredUniversities = universities.filter { location in
                let chapter = location.attributes.universityChapter.lowercased()
                return chapter.contains(searchText.lowercased())
            }
        } else {
            filteredUniversities = universities
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredUniversities = universities
        tableView.reloadData()
    }
}
