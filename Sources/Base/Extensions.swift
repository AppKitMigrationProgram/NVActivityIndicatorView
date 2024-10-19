import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

extension NSCoder {
    static func cgPoint(for string: String) -> CGPoint {
        NSPointFromString(string)
    }
}

extension NSBezierPath {
    @inlinable
    func addArc(withCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        let startDegrees = startAngle * 180 / .pi
        let endDegrees = endAngle * 180 / .pi
        appendArc(withCenter: center, radius: radius, startAngle: startDegrees, endAngle: endDegrees, clockwise: clockwise)
    }

    @inlinable
    func addLine(to point: CGPoint) {
        line(to: point)
    }

    convenience init(roundedRect rect: CGRect, cornerRadius: CGFloat) {
        self.init(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
    }

    convenience init(arcCenter: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        self.init()
        addArc(withCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }

    var asCGPath: CGPath {
        if #available(macOS 14.0, *) {
            return cgPath
        } else {
            let path = CGMutablePath()
            var points = [CGPoint](repeating: .zero, count: 3)
            for i in 0 ..< elementCount {
                let type = element(at: i, associatedPoints: &points)
                switch type {
                case .moveTo: path.move(to: points[0])
                case .lineTo: path.addLine(to: points[0])
                case .curveTo,
                     .cubicCurveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
                case .closePath: path.closeSubpath()
                default:
                    break
                }
            }
            return path
        }
    }
}

extension NSView {
    var backgroundColor: NSColor? {
        set {
            setWantsLayer()
            layer?.backgroundColor = newValue?.cgColor
        }
        get {
            layer?.backgroundColor.flatMap { .init(cgColor: $0) }
        }
    }

    static func animate(withDuration duration: TimeInterval = 0.25, timingFunction: CAMediaTimingFunction? = nil, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        NSAnimationContext.runAnimationGroup {
            context in
            context.duration = duration
            context.timingFunction = timingFunction ?? context.timingFunction
            context.allowsImplicitAnimation = true
            context.completionHandler = {
                completion?(true)
            }
            animations()
        }
    }

    var alpha: CGFloat {
        set { alphaValue = newValue }
        get { alphaValue }
    }
    
    func setWantsLayer() {
        wantsLayer = true
    }
}

extension CGRect {
    func inset(by insets: NSEdgeInsets) -> CGRect {
        return CGRect(
            x: origin.x + insets.left,
            y: origin.y + insets.top,
            width: width - (insets.left + insets.right),
            height: height - (insets.top + insets.bottom)
        )
    }
}

extension NSValue {
    convenience init(cgSize: CGSize) {
        self.init(size: cgSize)
    }
}

#endif

#if canImport(UIKit)

extension UIBezierPath {
    var asCGPath: CGPath {
        cgPath
    }
}

#endif

extension NSUIView {
    var _layer: CALayer? {
        layer
    }
}
