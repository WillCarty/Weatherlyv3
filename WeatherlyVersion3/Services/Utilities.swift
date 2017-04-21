//
//  Utilities.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/17/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//

import UIKit

class Utilities {
	static var _si: Utilities!
	static var si: Utilities {
		get {
			if Utilities._si == nil {
				Utilities._si = Utilities()
			}
			
			return Utilities._si
		}
	}

	func getDate( utc: Double) -> String {
		// create dateFormatter with UTC time format
		let date = NSDate(timeIntervalSince1970: utc)
		
		let dayTimePeriodFormatter = DateFormatter()
		dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
		
		let dateString = dayTimePeriodFormatter.string(from: date as Date)

		return dateString
	}

	func textFieldAnimation(_ text: UILabel) {
		UIView.animate(withDuration: 12.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
			let halfX = 0 - text.bounds.size.width
			let y = text.center.y
			text.center = CGPoint(x:halfX, y: y)
		}, completion:  { _ in })
	}
	
	func getHour( utc: Double) -> String {
		let date = NSDate(timeIntervalSince1970: utc)
		
		let dayTimePeriodFormatter = DateFormatter()
		dayTimePeriodFormatter.dateFormat = "hh:mm a"
		
		let dateString = dayTimePeriodFormatter.string(from: date as Date)
		
		return dateString
	}
	
	func rounder(_ number: Double) -> String {
		let rounder = round(number)
		let stringMaker = String(rounder)
		return stringMaker
	}
	
	
	
}
