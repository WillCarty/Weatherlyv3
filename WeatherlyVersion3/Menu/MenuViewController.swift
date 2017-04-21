//
//  MenuViewController.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/15/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//

import UIKit
import RxSwift

class MenuViewController: Component {
	@IBOutlet weak var currentView: UIView!
	@IBOutlet weak var weeklyView: UIView!
	@IBOutlet weak var mapView: UIView!
	@IBOutlet weak var settingsView: UIView!
	@IBOutlet weak var currentImage: UIImageView!
	@IBOutlet weak var weeklyImage: UIImageView!
	@IBOutlet weak var mapImage: UIImageView!
	@IBOutlet weak var settingsImage: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		sub([(state.app, gotState)])
		
		mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(mapTapped)))
		currentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(currentTapped)))
		
	}
	
	func mapTapped() {
		mapImage.image = UIImage(named: "mapIconSelected")
		currentImage.image = UIImage(named: "clockIcon")
		state.app.onNext(["header": true,
		                  "map" : true,
		                  "menu": true,
		                  "search" : false,
		                  "weather" : false,
		                  "setting": false,
		                  "weekly": false
			])
		
	}
	
	func currentTapped() {
		mapImage.image = UIImage(named: "mapIcon")
		currentImage.image = UIImage(named: "clockIconSelected")
		state.app.onNext(["header": true,
		                  "map" : false,
		                  "menu": true,
		                  "search" : false,
		                  "weather" : true,
		                  "setting": false,
		                  "weekly": false
			])
		
	}
	
	func gotState(_ data: [String:Any]) {
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
			if data["menu"] as! Bool {
				
			}
		}
	}
}
