//
//  ViewController.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/15/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//

import UIKit
import RxSwift

class AppViewController: Component {
	@IBOutlet weak var mapContainer: UIView!
	@IBOutlet weak var weatherContainer: UIView!
	@IBOutlet weak var searchContainer: UIView!
	@IBOutlet weak var menuContainer: UIView!
	@IBOutlet weak var headerContainer: UIView!
	@IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var weeklyContainer: UIView!
	@IBOutlet weak var settingContainer: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000)) {
			Backend.si.getHourlyWeather()
		}
		sub([(state.app, gotState)])
		// Do any additional setup after loading the view, typically from a nib.
	}
	func gotState(_ data: [String:Any]) {
		UIView.animate(
			withDuration:	0.25,
			delay:				0,
			options:			[.curveEaseInOut],
			animations:		{
				self.searchContainer.alpha = data["search"] as! Bool ? 1 : 0
				self.headerContainer.alpha = data["header"] as! Bool ? 1 : 0
				self.mapContainer.alpha = data["map"]	as! Bool ? 1 : 0
				self.weatherContainer.alpha = data["weather"]	as! Bool ? 1 : 0
				self.menuContainer.alpha =	data["menu"]	as! Bool ? 1 : 0
				self.settingContainer.alpha =	data["setting"]	as! Bool ? 1 : 0
				self.weeklyContainer.alpha =	data["weekly"]	as! Bool ? 1 : 0
				self.view.layoutIfNeeded()
		}
		)
	}
}

