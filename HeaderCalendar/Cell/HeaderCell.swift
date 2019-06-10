//
//  HeaderCell.swift
//  HeaderCalendar
//
//  Created by hiem seyha on 6/10/19.
//  Copyright © 2019 hiem seyha. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {

	@IBOutlet weak var monthLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	static var cellID: String {
		return String(describing: self)
	}
}


