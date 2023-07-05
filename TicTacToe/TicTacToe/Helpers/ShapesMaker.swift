import UIKit

class ShapeMaker {
    
    private let strokeWidth: CGFloat = 10.0
    private let animationDuration: TimeInterval = 1.0
    
    private func createCircle(at tag: Int, inView view: UIView) {
        guard let cellView = view.viewWithTag(tag) else {
            return
        }
        let circleRadius = cellView.bounds.width / 3.0
        let circleCenter = CGPoint(x: cellView.bounds.midX, y: cellView.bounds.midY)
        let startAngle = CGFloat(0.0)
        let endAngle = CGFloat(Double.pi * 2.0)
        let circlePath = UIBezierPath(arcCenter: circleCenter,
                                      radius: circleRadius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        addShapeLayer(with: circlePath, strokeColor: .black, inView: cellView)
    }
    
    private func createCross(at tag: Int, inView view: UIView) {
        guard let cellView = view.viewWithTag(tag) else {
            return
        }
        let crossPath = UIBezierPath()
        let crossWidth = cellView.bounds.width / 2.0
        crossPath.move(to: CGPoint(x: cellView.bounds.midX - crossWidth/2.0, y: cellView.bounds.midY - crossWidth/2.0))
        crossPath.addLine(to: CGPoint(x: cellView.bounds.midX + crossWidth/2.0, y: cellView.bounds.midY + crossWidth/2.0))
        crossPath.move(to: CGPoint(x: cellView.bounds.midX - crossWidth/2.0, y: cellView.bounds.midY + crossWidth/2.0))
        crossPath.addLine(to: CGPoint(x: cellView.bounds.midX + crossWidth/2.0, y: cellView.bounds.midY - crossWidth/2.0))
        addShapeLayer(with: crossPath, strokeColor: .red, inView: cellView)

    }
    
    func createLineBetweenTags(fromTag: Int, toTag: Int, inView view: UIView) {
        guard let fromCell = view.viewWithTag(fromTag),
              let toCell = view.viewWithTag(toTag),
              let parentView = view.superview else {
            return
        }
        let fromCenter = parentView.convert(fromCell.center, from: view)
        let toCenter = parentView.convert(toCell.center, from: view)
        let linePath = UIBezierPath()
        linePath.move(to: fromCenter)
        linePath.addLine(to: toCenter)
        addShapeLayer(with: linePath, strokeColor: .blue, inView: parentView)

    }
    
    func createShape(symbol: String, tag: Int, inView view: UIView) {
        switch symbol {
        case "Cross":
            createCross(at: tag, inView: view)
        case "Circle":
            createCircle(at: tag, inView: view)
        default:
            break
        }
    }
    
    private func addShapeLayer(with path: UIBezierPath, strokeColor: UIColor, inView view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        view.layer.addSublayer(shapeLayer)
        animate(layer: shapeLayer)
    }
    
    func removeAllShapes(inView view: UIView) {
        for subview in view.subviews {
            subview.layer.sublayers?.forEach { sublayer in
                if sublayer is CAShapeLayer {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
        view.superview?.layer.sublayers?.forEach { sublayer in
            if sublayer is CAShapeLayer {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    private func animate(layer: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = animationDuration
        layer.add(animation, forKey: "animate")
    }
    
}
