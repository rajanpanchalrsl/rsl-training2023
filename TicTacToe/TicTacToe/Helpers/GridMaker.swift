import UIKit

protocol GridMakerDelegate: AnyObject {
    func gridCellTapped(at tag: Int)
}

class GridMaker: UIView {
    weak var delegate: GridMakerDelegate?

    private let gridSize: Int
    private var cellSize: CGFloat = 0.0
    private let cellSpacing: CGFloat = 10.0
    private var tappedCells: Set<UIView> = []
    private var isInteractionEnabled = true

    init(gridSize: Int) {
        self.gridSize = gridSize
        super.init(frame: .zero)
        setupGrid()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        calculateCellSize()
        setupGrid()
    }

    private func calculateCellSize() {
        let availableWidth = bounds.width
        let widthRatio = (availableWidth - CGFloat(gridSize - 1) * cellSpacing) / CGFloat(gridSize)
        cellSize = widthRatio
    }

    private func setupGrid() {
        for subview in subviews {
            subview.removeFromSuperview()
        }

        var tagCounter = 1
        for row in 0..<gridSize {
            for column in 0..<gridSize {
                let x = CGFloat(column) * (cellSize + cellSpacing)
                let y = CGFloat(row) * (cellSize + cellSpacing)
                let cellFrame = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                let cellView = UIView(frame: cellFrame)
                cellView.backgroundColor = .systemGray3
                cellView.layer.cornerRadius = 10
                cellView.tag = tagCounter
                tagCounter += 1
                addSubview(cellView)
                setupTapGesture(for: cellView)
            }
        }
    }

    private func setupTapGesture(for cellView: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        cellView.addGestureRecognizer(tapGesture)
        cellView.isUserInteractionEnabled = true
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard isInteractionEnabled else {
            return
        }
        let location = gesture.location(in: self)
        let tappedRow = Int(location.y / (cellSize + cellSpacing))
        let tappedColumn = Int(location.x / (cellSize + cellSpacing))

        guard let tappedCellView = getCellView(atRow: tappedRow, column: tappedColumn),
              !tappedCells.contains(tappedCellView) else {
            return
        }
        tappedCells.insert(tappedCellView)
        self.delegate?.gridCellTapped(at: tappedCellView.tag)
        isInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isInteractionEnabled = true
        }
    }

    private func getCellView(atRow row: Int, column: Int) -> UIView? {
        let cellIndex = row * gridSize + column
        if cellIndex < subviews.count {
            return subviews[cellIndex]
        }
        return nil
    }
    
    func resetGrid() {
        tappedCells.removeAll()
        isInteractionEnabled = true
    }
}
