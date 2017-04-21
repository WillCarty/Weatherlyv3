//
//  HeaderViewController.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/15/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//

import UIKit

class HeaderViewController: Component {
	
	@IBOutlet weak var headerImage: UIImageView!
	@IBOutlet weak var searchButton: UIButton!
	var backNextState = ""
	@IBOutlet weak var cityLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		sub([ (state.header, gotState)])
		
		if DataModel.si.cityName == "" {
			Backend.si.gotCityName(DataModel.si.defaultAddress)
			
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
				self.cityLabel.text = DataModel.si.cityName
			}
		} else {
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
				self.cityLabel.text = DataModel.si.cityName
			}
		}
	}
		func gotState(_ data: [String:Any]) {
			backNextState = data["back"] as! String
			
		}
	@IBAction func searchButtonTapped(_ sender: Any) {
		
			state.app.onNext(["header": false,
			                  "map" : true,
			                  "menu": true,
			                  "search" : true,
			                  "weather" : false,
			                  "setting": false,
			                  "weekly": false
				])
		}
	}

