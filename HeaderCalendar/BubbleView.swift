//
//  BubbleView.swift
//  HeaderCalendar
//
//  Created by hiem seyha on 6/12/19.
//  Copyright © 2019 hiem seyha. All rights reserved.
//

import UIKit

class BubbleView: UIView {
	
	 lazy var contentView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.gray
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var textLabel: UILabel = {
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
//		let cgPoint = CGPoint(x: 50, y: 200)
		let cgPoint = CGPoint.zero
		
		let frame = CGRect(x: cgPoint.x, y: cgPoint.y, width: size.width, height: 22)
		let bubbleView = BubbleView(frame: frame)
		bubbleView.textLabel.text = value
		return bubbleView
	}
	
	func convertToImage() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(contentView.bounds.size, false, UIScreen.main.scale)
		guard let context = UIGraphicsGetCurrentContext() else { return nil}
		contentView.layer.render(in: context)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
		
	}
	
	func generateImage() -> UIImage? {
		let renderer = UIGraphicsImageRenderer(size: self.contentView.frame.size)
		let image = renderer.image { ctx in
			self.drawHierarchy(in: self.frame, afterScreenUpdates: true)
		}
		return image
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
//		let originY = contentView.bounds.origin.y
		
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


extension BubbleView {
	
	
	static func drawText(text: String, inImage: UIImage, point: CGPoint = .zero) -> UIImage? {
		
		let size = inImage.size
		let font = UIFont.systemFont(ofSize: size.width / 3.5)
		let textSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
		
		let style : NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
		style.alignment = .center
		let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.foregroundColor: UIColor.white ]
		
		UIGraphicsBeginImageContext(textSize)
		
		inImage.draw(in: CGRect(x: 0, y: 0, width: textSize.width, height: size.height))
		
		let textPoint = CGPoint(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2 - 10)
		let textRect = CGRect(origin: textPoint, size: textSize)
		text.draw(in: textRect, withAttributes: attributes)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
	
//	static func drawText(text: String, inImage: UIImage, point: CGPoint = .zero) -> UIImage? {
//
//		let size = inImage.size
//		let font = UIFont.systemFont(ofSize: size.width / 3.5)
//		let textSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
//
//		let style : NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
//		style.alignment = .center
//		let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.foregroundColor: UIColor.white ]
//
//		UIGraphicsBeginImageContext(size)
//
//		inImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//
//		let textPoint = CGPoint(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2 - 10)
//		let textRect = CGRect(origin: textPoint, size: textSize)
//		text.draw(in: textRect, withAttributes: attributes)
//
//		let image = UIGraphicsGetImageFromCurrentImageContext()
//		UIGraphicsEndImageContext()
//
//		return image
//	}
}
