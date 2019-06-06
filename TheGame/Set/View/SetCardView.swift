//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Кирилл Афонин on 26/02/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {
    
    // MARK: cardView's properties
    
    @IBInspectable
    var isSelected: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var isMatched: Bool? { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var faceBackgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) { didSet { setNeedsDisplay()} }
    
    @IBInspectable
    var count: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var symbolInt: Int = 1 {
        didSet {
            switch symbolInt {
            case 1: symbol = .oval
            case 2: symbol = .diamond
            case 3: symbol = .squiggle
            default: break
            }
        }
    }
    
    @IBInspectable
    var colorInt: Int = 1 {
        didSet {
            switch colorInt {
            case 1: color = Colors.red
            case 2: color = Colors.green
            case 3: color = Colors.purple
            default: break
            }
        }
    }
    
    @IBInspectable
    var fillInt: Int = 1 {
        didSet {
            switch fillInt {
            case 1: fill = .solid
            case 2: fill = .empty
            case 3: fill = .striped
            default: break
            }
        }
    }
    
    private var color = Colors.red  { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private var fill = Fill.striped  { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private var symbol = Symbol.squiggle  { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    // draws a card
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        faceBackgroundColor.setFill()
        roundedRect.fill()
        if isFaceUp {
            drawPips()
        } else {
            if let cardbackImage = UIImage(named: "cardBack", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardbackImage.draw(in: bounds)
            }
        }
    }
    
    // draws a shape on a card
    private func drawPips() {
        color.setFill()
        color.setStroke()
        
        let size = CGSize(width: faceFrame.width, height: pipHeight)
        let origin = CGPoint(x: faceFrame.minX, y: faceFrame.midY - pipHeight/2)
        let rectPip = CGRect(origin: origin, size: size)
        switch count {
        case 1: drawShape(in: rectPip)
        case 2:
            let firstRect = rectPip.offsetBy(dx: 0, dy: -(pipHeight + interPipHeight)/2)
            drawShape(in: firstRect)
            let secondRect = firstRect.offsetBy(dx: 0, dy: interPipHeight + pipHeight)
            drawShape(in: secondRect)
        case 3:
            drawShape(in: rectPip)
            let secondRect = rectPip.offsetBy(dx: 0, dy: -(pipHeight + interPipHeight))
            drawShape(in: secondRect)
            let thirdRect = rectPip.offsetBy(dx: 0, dy: pipHeight + interPipHeight)
            drawShape(in: thirdRect)
        default: break
        }
    }
    
    // selects what shape is should be drawn
    private func drawShape(in rect: CGRect) {
        let path: UIBezierPath
        switch symbol {
        case .diamond: path = pathForDiamond(in: rect)
        case .oval: path = pathForOval(in: rect)
        case .squiggle: path = pathForSquiggle(in: rect)
        }
        
        path.lineWidth = 3.0
        path.stroke()
        switch fill {
        case .solid: path.fill()
        case .striped: stripeShape(path: path, in: rect)
        default: break
        }
    }
    
    // draws Diamond
    private func pathForDiamond(in rect: CGRect) -> UIBezierPath {
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint(x: rect.minX, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        diamond.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        diamond.close()
        return diamond
    }
    
    // draws Oval
    private func pathForOval(in rect: CGRect) -> UIBezierPath {
        let oval = UIBezierPath()
        let radius = rect.height/2
        oval.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.midY), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi * 3/2, clockwise: true)
        oval.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        oval.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.midY), radius: radius, startAngle: CGFloat.pi * 3/2, endAngle: CGFloat.pi/2, clockwise: true)
        oval.close()
        return oval
    }
    
    // draws Squiggle
    private func pathForSquiggle(in rect: CGRect) -> UIBezierPath {
        let upperSquiggle = UIBezierPath()
        let sqdx = rect.width * 0.1
        let sqdy = rect.height * 0.2
        upperSquiggle.move(to: CGPoint(x: rect.minX, y: rect.midY))
        upperSquiggle.addCurve(to: CGPoint(x: rect.minX + rect.width/2,
                                           y: rect.minY + rect.height/8),
                               controlPoint1: CGPoint(x: rect.minX, y: rect.minY),
                               controlPoint2: CGPoint(x: rect.minX + rect.width/2 - sqdx,
                                                      y: rect.minY + rect.height/8 - sqdy))
        upperSquiggle.addCurve(to: CGPoint(x: rect.minX + rect.width * 4/5,
                                           y: rect.minY + rect.height/8),
                               controlPoint1: CGPoint(x: rect.minX + rect.width/2 + sqdx,
                                                      y: rect.minY + rect.height/8 + sqdy),
                               controlPoint2: CGPoint(x: rect.minX + rect.width * 4/5 - sqdx,
                                                      y: rect.minY + rect.height/8 + sqdy))
        upperSquiggle.addCurve(to: CGPoint(x: rect.minX + rect.width,
                                           y: rect.minY + rect.height/2),
                               controlPoint1: CGPoint(x: rect.minX + rect.width * 4/5 + sqdx,
                                                      y: rect.minY + rect.height/8 - sqdy),
                               controlPoint2: CGPoint(x: rect.minX + rect.width,
                                                      y: rect.minY))
        let lowerSquiggle = UIBezierPath(cgPath: upperSquiggle.cgPath)
        lowerSquiggle.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi))
        lowerSquiggle.apply(CGAffineTransform.identity.translatedBy(x: bounds.width, y: bounds.height))
        upperSquiggle.move(to: CGPoint(x: rect.minX, y: rect.midY))
        upperSquiggle.append(lowerSquiggle)
        return upperSquiggle
    }
    
    // clips the shape
    private func stripeShape(path: UIBezierPath, in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        stripeRect(rect)
        context?.restoreGState()
    }
    
    // draws stripes in shape
    private func stripeRect(_ rect: CGRect) {
        let stripe = UIBezierPath()
        let dashes: [CGFloat] = [1, 4]
        stripe.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        stripe.lineWidth = bounds.size.height
        stripe.lineCapStyle = .butt
        stripe.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        stripe.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        stripe.stroke()
    }
    
    // changes the view depending on state
    private func configureState() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        isOpaque = false
        contentMode = .redraw
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        if isSelected {
            layer.borderColor = Colors.selected
        }
        if let matched = isMatched {
            if matched {
                layer.borderColor = Colors.matched
            } else {
                layer.borderColor = Colors.mismatched
            }
        }
    }
    
    func copy() -> SetCardView {
        let copy = SetCardView()
        copy.symbolInt =  symbolInt
        copy.fillInt = fillInt
        copy.colorInt = colorInt
        copy.count =  count
        copy.isSelected =  false
        
        copy.isFaceUp = true
        copy.bounds = bounds
        copy.frame = frame
        copy.alpha = 1
        return copy
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureState()
    }
    
    
    // constants
    private enum Symbol {
        case oval
        case diamond
        case squiggle
    }
    
    private enum Fill {
        case solid
        case empty
        case striped
    }
    
    private struct Colors {
        static let red = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        static let green = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        static let purple = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        
        static let selected = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor
        static let matched = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor
        static let mismatched = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor
    }
    
    private struct SizeRatio {
        static let pinFontSizeToBoundsHeight: CGFloat = 0.09
        static let maxFaceSizeToBoundsSize: CGFloat = 0.75
        static let pipHeightToFaceHeight: CGFloat = 0.25
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let pinOffset: CGFloat = 0.03
    }
    
    private struct AspectRatio {
        static let faceFrame: CGFloat = 0.60
    }
    
    private var maxFaceFrame: CGRect {
        return bounds.zoomed(by: SizeRatio.maxFaceSizeToBoundsSize)
    }
    
    private var faceFrame: CGRect {
        let faceWidth = maxFaceFrame.height * AspectRatio.faceFrame
        return maxFaceFrame.insetBy(dx: (maxFaceFrame.width - faceWidth)/2, dy: 0)
    }
    
    private var pipHeight: CGFloat {
        return faceFrame.height * SizeRatio.pipHeightToFaceHeight
    }
    
    private var pinFontSize: CGFloat {
        return bounds.size.height * SizeRatio.pinFontSizeToBoundsHeight
    }
    
    private var interPipHeight: CGFloat {
        return (faceFrame.height - (3 * pipHeight)) / 2
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private let interStripeSpace: CGFloat = 5.0
    private let borderWidth: CGFloat = 5.0
}

extension CGRect {
    func zoomed(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
