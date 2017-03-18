//
//  ArrowView.swift
//  ArrowView
//
//  Created by Guy Umbright on 3/14/17.
//  Copyright © 2017 Guy Umbright. All rights reserved.
//

import UIKit

@IBDesignable
class UIXArrowView: UIView
{
    enum Corner: UInt8
    {
        case topLeft = 0x00
        case topRight = 0x01
        case bottomLeft = 0x10
        case bottomRight = 0x11
    }
    
    enum BendType
    {
        case verticalFirst
        case horizontalFirst
    }
    
    enum InsetEnd
    {
        case none
        case start
        case end
    }
    
    //configuration
    //var arrowColor : UIColor = UIColor.black {didSet {self.setNeedsLayout()}}
    var lineWidth : CGFloat = 2.0 {didSet {self.setNeedsLayout()}}
    var headLineLength : CGFloat = 20.0

    var startCorner : Corner = .topLeft {didSet {self.setNeedsLayout()}}
    var endCorner : Corner = .bottomRight {didSet {self.setNeedsLayout()}}
    
    var bendType : BendType = .horizontalFirst {didSet {self.setNeedsLayout()}}
    let arrowFlare : CGFloat = 10
    
    //internal
    var arrowLayer : CAShapeLayer = CAShapeLayer()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if arrowLayer.superlayer == nil
        {
            self.layer.addSublayer(arrowLayer)
        }

        arrowLayer.frame = self.bounds

        arrowLayer.path = nil
        
        if startCorner == endCorner
        {
            return //do nothing
        }
        
        let xor = startCorner.rawValue ^ endCorner.rawValue
        let leftDifferent = xor & 0xF0
        let rightDifferent = xor & 0x0F
        
        if leftDifferent == 0 && rightDifferent != 0
        {
            generateHorizontalArrow()
        }
        else if leftDifferent != 0 && rightDifferent == 0
        {
            generateVerticalArrow()
        }
        else
        {
            generateBentArrow()
        }

        let flipX = ((0xF0 & startCorner.rawValue) > 0 )
        let flipY = ((0x0F & startCorner.rawValue) > 0 )
        
        arrowLayer.transform = createLayerTransform(flipX: flipX, flipY: flipY)
        
        arrowLayer.lineWidth = lineWidth
        arrowLayer.lineCap = kCALineCapRound
        arrowLayer.strokeColor = tintColor.cgColor
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func createLayerTransform(flipX: Bool, flipY: Bool) -> CATransform3D
    {
        var transform = CATransform3DIdentity
        
        if flipX
        {
            transform = CATransform3DRotate(transform, CGFloat(M_PI), 1, 0, 0)
        }
        
        if flipY
        {
            transform = CATransform3DRotate(transform, CGFloat(M_PI), 0, 1, 0)
        }

        return transform
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func horzFarEnd(top:Bool = true) -> CGPoint
    {
        let y = (top) ? arrowFlare+(lineWidth/2.0) : self.bounds.size.height - (arrowFlare+(lineWidth/2.0))
        return CGPoint(x:arrowLayer.bounds.size.width-(lineWidth/2.0),y:y)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func vertFarEnd(left:Bool = true) -> CGPoint
    {
        let x = (left) ? arrowFlare+(lineWidth/2.0) : self.bounds.size.width - (arrowFlare+(lineWidth/2.0))
        return CGPoint(x:x,y:arrowLayer.bounds.size.height-(lineWidth/2.0))
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func generateHorzBar(top:Bool = true,inset:InsetEnd = .none) -> UIBezierPath
    {
        let path = UIBezierPath()
        var x = lineWidth/2.0
        if inset == .start
        {
            x = x + arrowFlare+(lineWidth/2.0)
        }
        let y = (top) ? arrowFlare+(lineWidth/2.0) : self.bounds.size.height - (arrowFlare+(lineWidth/2.0))
        path.move(to: CGPoint(x: x, y: y))
        
        var farEnd = horzFarEnd(top:top)
        if inset == .end
        {
            farEnd.x = farEnd.x - arrowFlare
        }
        path.addLine(to: farEnd)
        
        return path
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
//    func generateBottomHorzBar() -> UIBezierPath
//    {
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: lineWidth/2.0, y: self.bounds.size.height-(arrowFlare+(lineWidth/2.0))))
//        
//        let farEnd = horzFarEnd()
//        path.addLine(to: farEnd)
//        
//        return path
//    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func generateVertBar(left:Bool = true,inset:InsetEnd = .none) -> UIBezierPath
    {
        let path = UIBezierPath()
        let x = (left) ? arrowFlare+(lineWidth/2.0):self.bounds.size.width - (arrowFlare+(lineWidth/2.0))
        var y = lineWidth/2.0
        if inset == .start
        {
            y = y + arrowFlare+(lineWidth/2.0)
        }
        
        path.move(to: CGPoint(x:x , y: y))
        
        var farEnd = vertFarEnd(left:left)
        if inset == .end
        {
            farEnd.y = farEnd.y - arrowFlare
        }
        
        path.addLine(to: farEnd)
        
        return path
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func generateHorzArrowTip(at point: CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: point)
        path.addLine(to:CGPoint(x: point.x-10.0, y: point.y-arrowFlare))
        
        path.move(to: point)
        path.addLine(to:CGPoint(x: point.x-10.0, y: point.y+arrowFlare))
        return path
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func generateVertArrowTip(at point: CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: point)
        path.addLine(to:CGPoint(x: point.x-arrowFlare, y: point.y-10.0))
        
        path.move(to: point)
        path.addLine(to:CGPoint(x: point.x+arrowFlare, y: point.y-10.0))
        return path
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func generateHorizontalArrow()
    {
        let path = generateHorzBar()
    
        let farEnd = horzFarEnd()
        
        let arrow = generateHorzArrowTip(at: farEnd)
        path.append(arrow)
      
//        arrowLayer.lineWidth = lineWidth
//        arrowLayer.lineCap = kCALineCapRound
//        arrowLayer.strokeColor = arrowColor.cgColor
        arrowLayer.path = path.cgPath
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func generateVerticalArrow()
    {
        let path = generateVertBar()
        
        let farEnd = vertFarEnd()
        
        let arrow = generateVertArrowTip(at: farEnd)
        
        path.append(arrow)
        
//        arrowLayer.lineWidth = lineWidth
//        arrowLayer.lineCap = kCALineCapRound
//        arrowLayer.strokeColor = arrowColor.cgColor
        arrowLayer.path = path.cgPath
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func generateBentArrow()
    {
        switch bendType
        {
        case .horizontalFirst:
                generateHorzFirstBentArrow()
            
        case .verticalFirst:
                generateVertFirstBentArrow()
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func generateHorzFirstBentArrow()
    {
        let path = generateHorzBar(inset:.end)
        let right = generateVertBar(left:false,inset: .start)
        path.append(right)

        let arrow = generateVertArrowTip(at: vertFarEnd(left:false))
        path.append(arrow)
        
//        arrowLayer.lineWidth = lineWidth
//        arrowLayer.lineCap = kCALineCapRound
//        arrowLayer.strokeColor = arrowColor.cgColor
        arrowLayer.path = path.cgPath
        
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func generateVertFirstBentArrow()
    {
        let path = generateVertBar(inset:.end)
        let bottom = generateHorzBar(top:false,inset: .start)
        path.append(bottom)
        
        let arrow = generateHorzArrowTip(at: horzFarEnd(top:false))
        path.append(arrow)
        
//        arrowLayer.lineWidth = lineWidth
//        arrowLayer.lineCap = kCALineCapRound
//        arrowLayer.strokeColor = arrowColor.cgColor
        arrowLayer.path = path.cgPath
        
    }
}
