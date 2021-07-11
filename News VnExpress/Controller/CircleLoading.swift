//
//  CircleLoading.swift
//  News VnExpress
//
//  Created by Quan Tran on 07/07/2021.
//

import UIKit

class CircleLoading: UIView {
    
    //MARK: - Properties

    let circleLayer: CAShapeLayer = {
        // Setup the CAShapeLayer with the path, colors, and line width
        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.systemBlue.cgColor
        circle.lineWidth = 5.0
        
        circle.strokeEnd = 0.0
        return circle
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    //MARK: - Override Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // if startAngle equal endAngle circle do not work draw, so set offset very small this is 0.00001 for startAngle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                      radius: (frame.size.width - 10)/2,
                                      startAngle: CGFloat((0 - (Double.pi / 2) + 0.00001)),
                                      endAngle: CGFloat(0 - (Double.pi / 2) ),
                                      clockwise: true)

        circleLayer.path = circlePath.cgPath
    }
    
    //MARK: - Functions
    
    func setup(){
        backgroundColor = UIColor.clear
        layer.addSublayer(circleLayer)
    }

    func animateCircle(duration t: TimeInterval) {
    
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        // Set the animation duration appropriately
        animation.duration = t

        animation.fromValue = 0
        animation.toValue = 1
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        circleLayer.strokeEnd = 1.0
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }
}
