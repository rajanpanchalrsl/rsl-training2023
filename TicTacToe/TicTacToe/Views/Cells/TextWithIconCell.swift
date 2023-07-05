import UIKit

class TextWithIconCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        configureDefaultContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        var content = defaultContentConfiguration()
        content.text = text
        self.contentConfiguration = content
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureDefaultContent()
    }
    
    private func configureDefaultContent() {
        var content = defaultContentConfiguration()
        content.text = "Primary Text"
        self.contentConfiguration = content
        accessoryType = .detailButton
    }
}
