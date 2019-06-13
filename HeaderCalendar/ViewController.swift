//
//  ViewController.swift
//  HeaderCalendar
//
//  Created by hiem seyha on 6/10/19.
//  Copyright © 2019 hiem seyha. All rights reserved.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {

//	@IBOutlet weak var bubleView: BubbleView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var calendar: FSCalendar!
	@IBOutlet weak var widthConstraintConstant: NSLayoutConstraint!
	@IBOutlet weak var leftConstraintConstant: NSLayoutConstraint!
	
	var bubleView: BubbleView!
	
	var constLeft: CGFloat = 0.0
	
	var models: [Date] = []
	let format = DateFormatter()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		bubleView = BubbleView.setText(value: "$56KKKKKKK")
		self.view.addSubview(bubleView)
		
		constLeft = ((UIScreen.main.bounds.width / 3) - widthConstraintConstant.constant) / 2
		leftConstraintConstant.constant = constLeft
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		calendar.delegate = self
		calendar.dataSource = self
		calendar.placeholderType = .none
		
		mockData()
		setupCollectionViewCell()
		setupCalendar()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		bubleView.setNeedsDisplay()
	}

	fileprivate func mockData() {
		let curretDate = Date()
		for value in 0..<3 {
			
			guard let nextMonth = Calendar.current.date(byAdding: .month, value: value, to: curretDate) else { continue }
			models.append(nextMonth)
		}
		format.dateFormat = "MMM"
		
	}
	fileprivate func setupCollectionViewCell() {
		let nib = UINib(nibName: HeaderCell.cellID, bundle: nil)
		collectionView.register(nib, forCellWithReuseIdentifier: HeaderCell.cellID)
	}
	
	fileprivate func setupCalendar() {
		calendar.calendarHeaderView.isHidden = true
		calendar.headerHeight = 0
		guard let currentPage = models.first else { return }
		calendar.currentPage = currentPage
		calendar.allowsMultipleSelection = false
		calendar.collectionView.isScrollEnabled = false
		calendar.appearance.weekdayTextColor = UIColor.gray
	
	}

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return models.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.cellID, for: indexPath) as! HeaderCell
		let model = models[indexPath.row]
		cell.monthLabel.text = format.string(from: model)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let scrollDate = models[indexPath.row]
		calendar.setCurrentPage(scrollDate, animated: true)
		animataLine(with: collectionView, indexPath: indexPath)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: (self.view.bounds.width / 3), height: collectionView.bounds.height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
	func minimumDate(for calendar: FSCalendar) -> Date {
		return Date()
	}
	
	func maximumDate(for calendar: FSCalendar) -> Date {
		guard let lastDate = models.last else { return Date() }
		guard let day = Calendar.current.date(byAdding: DateComponents(month: 1, day: 0), to: lastDate) else {
			return Date()
		}
		return day
	}
	
	func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
		if self.models.contains(date) {
			return false
		}
		
		return true
	}
}

extension ViewController {
	fileprivate func animataLine(with collection: UICollectionView, indexPath: IndexPath) {
		let width = UIScreen.main.bounds.width
		let left = (width/3) * CGFloat(indexPath.row) + constLeft
		leftConstraintConstant.constant = max(left, constLeft)
		UIView.animate(withDuration: 0.2) {
			self.view.layoutIfNeeded()
		}
	}
}
