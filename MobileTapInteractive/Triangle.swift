//
//  Triangle.swift
//  MobileTapInteractive
//
//  Created by Админ on 05.07.2022.
//

import UIKit

class TriangleWedgeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    var colorSetFill: UIColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) { didSet { setNeedsDisplay() } }
    var colorSetStroke: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5) { didSet { setNeedsDisplay() } }
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        let path = trianglePath()
        
        colorSetFill.setFill()
        colorSetStroke.setStroke()
        path.lineWidth = lineWidth
        path.fill()
        path.stroke()
    }
    
    private func commonInit() {
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
    }
    
    private func trianglePath() -> UIBezierPath {
        let bounds = self.bounds
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 5, y: bounds.height / 2))
        path.addLine(to: CGPoint(x: bounds.width - 5, y: 4))
        path.addLine(to: CGPoint(x: bounds.width - 5, y:bounds.height - 4))
        
        path.close()
        return path
    }
}
