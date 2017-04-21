//
//  DataModel.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/17/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//

import Foundation
class DataModel {
	static var _si: DataModel!
	static var si: DataModel {
		get {
			DataModel._si = DataModel._si ?? DataModel()
			
			return DataModel._si
		}
	}
// Current weather model
	var hourlyData: [HourlyModel] = []
	var
		time = "",
		summary = "",
		icon = "",
		temp: Double = 0.0,
		precipChance: Double = 0.0

// location defaults
	var cityName = "",
	defaultAddress = "41465"
	
// Current Alert Model
	var alertTitle = "",
	alertTime = 1453375020.0,
	alertExpires =  1453407300.0,
	alertDescription = ""
	
// lat and long
	var lat: Double = 0.0,
	lng: Double = 0.0
}

class HourlyModel {
	static var _si: HourlyModel!
	static var si: HourlyModel {
		get {
			HourlyModel._si = HourlyModel._si
			return HourlyModel._si
		}
	}

	var
	time: String,
	icon: String,
	precipProb: String,
	temp: String

	
	init(time: String, icon: String, precipProb: String, temp: String) {
		self.time = time
		self.icon = icon
		self.precipProb = precipProb
		self.temp = temp

	}
	
//	init(time: String, icon: String, temp: String) {
//		self.time = time
//		self.icon = icon
//		self.temp = temp
//		
//	}
	
}

