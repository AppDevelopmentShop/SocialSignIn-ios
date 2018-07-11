//
//  File.swift
//  SocialSingIn
//
//  Created by Павел Привалов on 7/3/18.
//  Copyright © 2018 Павел Привалов. All rights reserved.
//

import Foundation

extension String {
	
	var length: Int {
		return self.count;
	}
	
	var digits: String {
		return components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "");
	}
	
	func capitalizingFirstLetter() -> String {
		return prefix(1).uppercased() + dropFirst()
	}
	
	mutating func capitalizeFirstLetter() {
		self = self.capitalizingFirstLetter()
	}
	
}
