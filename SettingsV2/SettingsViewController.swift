import UIKit

class SettingsViewController: UIViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<HeadersItem, ListItem>
    typealias DataSource = UICollectionViewDiffableDataSource<HeadersItem, ListItem>
    typealias HeaderCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HeadersItem>
    typealias SettingsItemCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingsItem>

    private var sections = HeadersItem.generatedTestData
    private var filteredModelObjects: [HeadersItem] = []
    private lazy var dataSource = makeDataSource()
    private let searchController = UISearchController(searchResultsController: nil)

    private lazy var collectionView: UICollectionView = {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureSearchController()
        applySnapshot()
    }
    
    private func setupView() {
        self.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemGray6
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        let addSettingsItemButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(addSettingsItemButtonTapped))
        self.navigationItem.leftBarButtonItem = editButtonItem
        self.navigationItem.rightBarButtonItem = addSettingsItemButton;
    }
    
    private func makeDataSource() -> DataSource{
        let headerCellRegistration = HeaderCellRegistration { cell, indexPath, headersItem in
            var content = cell.defaultContentConfiguration()
            let config = UIImage.SymbolConfiguration(hierarchicalColor: .red)
            content.image = UIImage(systemName: headersItem.iconName, withConfiguration: config)
            content.text = headersItem.title
            cell.contentConfiguration = content
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerDisclosureOption),
                                .delete(displayed: .whenEditing, actionHandler: { [weak self] in
                                    self?.deleteHeadersItem(headersItem)
                                })]
        }
        
        let settingsItemCellRegistration = SettingsItemCellRegistration { cell, indexPath, settingsItem in
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: settingsItem.iconName)
            if let secText = settingsItem.subTitle {
                content.secondaryText = secText
                content.prefersSideBySideTextAndSecondaryText = true
            }
            content.text = settingsItem.title
            cell.contentConfiguration = content
            cell.accessories = [.delete(displayed: .whenEditing, actionHandler: { [weak self] in
                self?.deleteSettingsItem(settingsItem)
            })]
        }
            
        dataSource = DataSource (collectionView: collectionView) { collectionView, indexPath, listItem -> UICollectionViewCell? in
            switch listItem {
            case .item(let settingsItem):
                let cell = collectionView.dequeueConfiguredReusableCell(using: settingsItemCellRegistration,
                                                                        for: indexPath,
                                                                        item: settingsItem)
                return cell
            case .header(let headersItem):
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration,
                                                                        for: indexPath,
                                                                        item: headersItem)
                return cell
            }
                
        }
        return dataSource
    }
    
    private func applySnapshot() {
        var dataSourceSnapshot = Snapshot()
        dataSourceSnapshot.appendSections(sections)
        dataSource.apply(dataSourceSnapshot)
        for section in sections {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
            let sectionListItem = ListItem.header(section)
            sectionSnapshot.append([sectionListItem])
            let settingsItemsArray = section.items.map { ListItem.item($0) }
            sectionSnapshot.append(settingsItemsArray, to: sectionListItem)
            sectionSnapshot.expand([sectionListItem])
            dataSource.apply(sectionSnapshot, to: section, animatingDifferences: false)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.isEditing = editing
        collectionView.allowsMultipleSelection = editing
    }
    
    private func deleteHeadersItem(_ headersItem: HeadersItem) {
        guard let index = sections.firstIndex(where: { $0 === headersItem }) else {
            return
        }
        sections.remove(at: index)
        applySnapshot()
    }

    private func deleteSettingsItem(_ settingsItem: SettingsItem) {
        for (sectionIndex, section) in sections.enumerated() {
            if let itemIndex = section.items.firstIndex(where: { $0 === settingsItem }) {
                section.items.remove(at: itemIndex)
                sections[sectionIndex] = section
                applySnapshot()
                break
            }
        }
    }
    
    @objc private func addSettingsItemButtonTapped() {
        let actionSheet = UIAlertController(title: "Select Section to add New Item", message: nil, preferredStyle: .actionSheet)
        for section in sections {
            let sectionAction = UIAlertAction(title: section.title, style: .default) { [weak self] _ in
                guard let self = self else  {
                    return
                }
                self.addNewSettingsItem(to: section)
            }
            actionSheet.addAction(sectionAction)
        }
        let newSectionAction = UIAlertAction(title: "Add New Section", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.addNewSection()
        }
        actionSheet.addAction(newSectionAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }

    private func addNewSettingsItem(to section: HeadersItem) {
        let alertController = UIAlertController(title: "Add New Setting Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Title"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Subtitle (Optional)"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Icon Name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let titleTextField = alertController.textFields?.first,
                  let subtitleTextField = alertController.textFields?[1],
                  let iconNameTextField = alertController.textFields?.last,
                  let title = titleTextField.text,
                  let iconName = iconNameTextField.text,
                  !title.isEmpty,
                  !iconName.isEmpty else {
                return
            }
            let newSettingsItem = SettingsItem(title: title, subTitle: subtitleTextField.text, iconName: iconName)
            let updatedSection = section
            updatedSection.items.append(newSettingsItem)
            guard let sectionIndex = self.sections.firstIndex(where: { $0 === section }) else {
                return
            }
            self.sections[sectionIndex] = updatedSection
            self.applySnapshot()
        }
        alertController.addAction(addAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }


    private func addNewSection() {
        let alertController = UIAlertController(title: "Add New Section", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Title"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Icon Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let titleTextField = alertController.textFields?.first,
                  let iconNameTextField = alertController.textFields?.last,
                  let title = titleTextField.text,
                  let iconName = iconNameTextField.text else {
                return
            }
            let newSection = HeadersItem(title: title, iconName: iconName, items: [])
            self.sections.append(newSection)
            self.applySnapshot()
        }
        alertController.addAction(addAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension SettingsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
            !searchText.isEmpty {
            var filteredItems: [ListItem] = []
            for section in sections {
                let filteredSectionItems = section.items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
                filteredItems.append(contentsOf: filteredSectionItems.map { ListItem.item($0) })
            }
            filteredModelObjects = sections.filter { !$0.items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }.isEmpty }
            dataSource.apply(constructSnapshot(filteredItems))
        } else {
            filteredModelObjects = sections
            applySnapshot()
        }
    }
    
    private func constructSnapshot(_ items: [ListItem]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(filteredModelObjects)
        for section in filteredModelObjects {
            let filteredSectionItems = items.filter {
                if case .item(let settingsItem) = $0 {
                    return section.items.contains(settingsItem)
                }
                return false
            }
            snapshot.appendItems(filteredSectionItems, toSection: section)
        }
        return snapshot
    }
    
    func configureSearchController() {
      searchController.searchResultsUpdater = self
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "Search"
      navigationItem.searchController = searchController
      definesPresentationContext = true
    }
}

extension SettingsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredModelObjects = sections
        applySnapshot()
    }
}
