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
	
	lazy var textLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.sizeToFit()
		return label
	}()
	
	let radius: CGFloat = 8
	let narrowHeight: CGFloat = 5
	
	// MARK: - Init
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
		setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupView()
	}
	
	static func setText(value: String, fontSize: CGFloat = 15) -> BubbleView {
		let title: NSString = value as NSString
		let size = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])
		let cgPoint = CGPoint(x: 50, y: 500)
		let frame = CGRect(x: cgPoint.x, y: cgPoint.y, width: size.width, height: 22)
		let bubbleView = BubbleView(frame: frame)
		bubbleView.textLabel.text = value
		return bubbleView
	}
	
	fileprivate func setupView() {
	
		addSubview(contentView)
		
		contentView.topAnchor.constraint(equalTo: topAnchor, constant:0).isActive = true
//		contentView.heightAnchor.constraint(equalTo: heightAnchor, constant: 100).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5).isActive = true
		
		contentView.addSubview(textLabel)
	
//		ageLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//		ageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//		ageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
//		ageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
		
		textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		
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
		let originY = contentView.bounds.origin.y
		
		let width = contentView.frame.size.width
		let height = contentView.frame.size.height
		let centerPoint = width / 2
		
		let path = UIBezierPath()
		
		path.move(to: CGPoint(x: originX, y: height))
		path.addLine(to: CGPoint(x: originX, y: height - narrowHeight))
	
		path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)

		path.addArc(withCenter: CGPoint(x: width - radius, y: radius), radius: radius, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
		
		path.addLine(to: CGPoint(x: width, y: height - radius))
		
		path.addArc(withCenter: CGPoint(x: width - radius, y: height - radius - narrowHeight), radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi / 2), clockwise: true)
		
//		path.addLine(to: CGPoint(x: centerPoint + radius, y: height - narrowHeight))
//		path.addLine(to: CGPoint(x: centerPoint + radius - 5 , y: height))
//		path.addLine(to: CGPoint(x: centerPoint , y: height - narrowHeight))
//		path.addLine(to: CGPoint(x: originX, y: height - narrowHeight))
		
		path.addLine(to: CGPoint(x: centerPoint + (radius / 2), y: height - narrowHeight))
		path.addLine(to: CGPoint(x: centerPoint , y: height))
		path.addLine(to: CGPoint(x: centerPoint - (radius / 2) , y: height - narrowHeight))
		path.addLine(to: CGPoint(x: originX, y: height - narrowHeight))
		
		path.addArc(withCenter: CGPoint(x: originX + radius, y: height - radius - narrowHeight), radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
		
		path.close()
		
		return path
	}
}
