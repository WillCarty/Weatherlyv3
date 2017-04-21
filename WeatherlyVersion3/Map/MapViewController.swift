//
//  MapViewController.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/15/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift

class MapViewController: Component {
	
	var backNextState = ""

	override func loadView() {
		super.loadView()
		view = map.getMap()
		map.gmap.mapType = .hybrid
		
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		sub([(state.app, gotState)])
	}
	
	func gotState(_ data: [String:Any]) {
		
	}
}
