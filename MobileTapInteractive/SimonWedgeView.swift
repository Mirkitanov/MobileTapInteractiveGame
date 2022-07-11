//
//  SimonWedgeView.swift
//  MobileTapInteractive
//
//  Created by Админ on 05.07.2022.
//

import UIKit

class SimonWedgeViewFirstForLeftThickIndicator: UIView {
    var koeficientToFill: CGFloat
    
    init(frame: CGRect, koeficientToFill: CGFloat) {
        self.koeficientToFill = koeficientToFill
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var centerAngle: Radians = 0 { didSet { setNeedsDisplay() } }
    var color: UIColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        let path = wedgePath()
        color.setFill()
        path.fill()
    }
    
    private func commonInit() {
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
    }
    
    private func wedgePath() -> UIBezierPath {
        let bounds = self.bounds
        let outerRadius = min(bounds.size.width, bounds.size.height) / 2.1
        let innerRadius = outerRadius / 1.2
        let path = UIBezierPath.simonWedgeFirstForLeftThickIndicator(innerRadius: innerRadius, outerRadius: outerRadius, centerAngle: centerAngle, koeficient: koeficientToFill)
        path.apply(CGAffineTransform(translationX: bounds.midX, y: bounds.midY))
        return path
    }
}


class SimonWedgeViewSecondForThinIndicator: UIView {
    var koeficientToFill: CGFloat
    
    init(frame: CGRect, koeficientToFill: CGFloat) {
        self.koeficientToFill = koeficientToFill
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var centerAngle: Radians = 0 { didSet { setNeedsDisplay() } }
    var color: UIColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        let path = wedgePath()
        color.setFill()
        path.fill()
    }
    
    private func commonInit() {
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
    }
    
    private func wedgePath() -> UIBezierPath {
        let bounds = self.bounds
        let outerRadius = min(bounds.size.width, bounds.size.height) / 2
        let innerRadius = outerRadius / 1.02
        let path = UIBezierPath.simonWedgeSecondForThinIndicator(innerRadius: innerRadius, outerRadius: outerRadius, centerAngle: centerAngle, koeficient: koeficientToFill)
        path.apply(CGAffineTransform(translationX: bounds.midX, y: bounds.midY))
        return path
    }
}


class SimonWedgeViewThirdForRightThickIndicator: UIView {
    var koeficientToFill: CGFloat
    
    init(frame: CGRect, koeficientToFill: CGFloat) {
        self.koeficientToFill = koeficientToFill
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var centerAngle: Radians = 0 { didSet { setNeedsDisplay() } }
    var color: UIColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        let path = wedgePath()
        color.setFill()
        path.fill()
    }
    
    private func commonInit() {
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
    }
    
    private func wedgePath() -> UIBezierPath {
        let bounds = self.bounds
        let outerRadius = min(bounds.size.width, bounds.size.height) / 2.1
        let innerRadius = outerRadius / 1.2
        let path = UIBezierPath.simonWedgeThirdForRightThickIndicator(innerRadius: innerRadius, outerRadius: outerRadius, centerAngle: centerAngle, koeficient: koeficientToFill)
        path.apply(CGAffineTransform(translationX: bounds.midX, y: bounds.midY))
        return path
    }
}
