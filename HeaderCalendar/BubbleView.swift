//
//  BubbleView.swift
//  HeaderCalendar
//
//  Created by hiem seyha on 6/12/19.
//  Copyright © 2019 hiem seyha. All rights reserved.
//

import UIKit

class BubbleView: UIView {
	
	private lazy var contentView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.gray
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var ageLabel: UILabel = {
		let label = UILabel()
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Hello world"
		label.sizeToFit()
		return label
	}()
	
	// MARK: - Init
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		
		self.frame = ageLabel.frame
		self.setNeedsLayout()
		self.layoutIfNeeded()
		
		setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupView()
	}
	
	fileprivate func setupView() {
		
		debugPrint("frame of age label \(ageLabel.frame)")
		
		
		
		
		addSubview(contentView)
		
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		
		contentView.addSubview(ageLabel)
		
		ageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		ageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		
	}

	override func draw(_ rect: CGRect) {
		super.draw(rect)
		drawBorder()
		contentMode = .redraw
	}
	
	
	
	// MARK: - Other Functions
	fileprivate func drawBorder() {
		let maskLayer = CAShapeLayer()
		maskLayer.path = createReplyViewLayer().cgPath
		contentView.layer.mask = maskLayer
		if (contentView.layer.sublayers?.last?.isKind(of: CAShapeLayer.self))! {
			contentView.layer.sublayers?.removeLast()
		}
		let borderLayer = CAShapeLayer()
		borderLayer.path = maskLayer.path
		borderLayer.lineWidth = 5
		borderLayer.strokeColor = UIColor.darkGray.cgColor
		borderLayer.fillColor = UIColor.clear.cgColor
		contentView.layer.addSublayer(borderLayer)
	}
	
	private func createReplyViewLayer() -> UIBezierPath {
		let originX = contentView.bounds.origin.x
//		let originY = contentView.bounds.origin.y
		let width = contentView.frame.size.width
		let height = contentView.frame.size.height
		let centerPoint = width / 2
		
		let radius: CGFloat = 9.0
		let narrowHeight: CGFloat = 7
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: originX, y: height))
		path.addLine(to: CGPoint(x: originX, y: 0))
	
		path.addArc(withCenter: CGPoint(x: radius, y: narrowHeight), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)

		path.addArc(withCenter: CGPoint(x: width - radius, y: narrowHeight), radius: radius, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
		
		path.addLine(to: CGPoint(x: width, y: height - radius))
		
		path.addArc(withCenter: CGPoint(x: width - radius, y: height - radius - narrowHeight), radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi / 2), clockwise: true)
		
		path.addLine(to: CGPoint(x: centerPoint + radius, y: height - narrowHeight))
		path.addLine(to: CGPoint(x: centerPoint + radius - 5 , y: height))
		path.addLine(to: CGPoint(x: centerPoint , y: height - narrowHeight))
		path.addLine(to: CGPoint(x: originX, y: height - narrowHeight))
		
		path.addArc(withCenter: CGPoint(x: originX + radius, y: height - radius - narrowHeight), radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
		
		path.close()
		
		return path
	}
}
