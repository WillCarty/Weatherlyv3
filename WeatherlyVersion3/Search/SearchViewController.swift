//
//  SearchViewController.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/15/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//

import UIKit

class SearchViewController: Component, UITextFieldDelegate {
	
	
	@IBOutlet weak var searchButton: UIButton!

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var searchClearButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		sub([(state.app, gotState)])
		textField.delegate =							self
		textField.attributedPlaceholder =	NSAttributedString(string: " Search Address", attributes: [NSForegroundColorAttributeName: UIColor.white])
	}
	
	func gotState(data: [String:Any]) {
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
			if data["search"] as! Bool {
				self.textField.becomeFirstResponder()
			} else {
				self.textField.text = ""
				self.textField.resignFirstResponder()
			}
		}
	}

	@IBAction func searchButtonTapped(_ sender: Any) {
		Backend.si.searchAddress(self.textField.text!)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
			self.state.app.onNext(["header": true,
			                       "map" : false,
			                       "menu": true,
			                       "search" : false,
			                       "weather" : true,
			                       "setting": false,
			                       "weekly": false
				])
	}
}

	@IBAction func searchClearButtonTapped(_ sender: Any) {
		textField.text = ""
		
	}
	@IBAction func cancelButtonTapped(_ sender: Any) {
		state.app.onNext(["header": true,
		                  "map" : false,
		                  "menu": true,
		                  "search" : false,
		                  "weather" : true,
		                  "setting": false,
		                  "weekly": false
			])
	}
	
}
