//
//  Backend.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/17/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//

import Alamofire
import Foundation
import GoogleMaps
import RxSwift
import SwiftyJSON

class Backend {
	static var _si: Backend!
	static var si: Backend {
		get {
			if Backend._si == nil {
				Backend._si = Backend()
			}
			
			return Backend._si
		}
	}
	var hourlyArray:[HourlyModel] = []
	var lat: Double = 37.7526
	var lng: Double = -83.0688
	
	private var _history: BehaviorSubject<[[String:Any]]>!
	var history: BehaviorSubject<[[String:Any]]> {
		get {
			if _history == nil {
				if let h = UserDefaults.standard.array(forKey: "weatherly-search-history") as? [[String:Any]] {
					_history = BehaviorSubject(value: h)
				} else {
					_history = BehaviorSubject(value: [])
					
					UserDefaults.standard.setValue([], forKey: "weatherly-search-history")
					UserDefaults.standard.synchronize()
				}
			}
			
			return _history
		}
	}
	
	
	func gotAddress(response: DataResponse<Any>) {
		if let val = response.result.value {
			let json = JSON(val)["results"]
			
			if json.count > 0 {
			//	print(json)
				updateHistory(json[0]["formatted_address"].stringValue, json[0]["geometry"]["location"]["lat"].doubleValue, json[0]["geometry"]["location"]["lng"].doubleValue)
				lat = json[0]["geometry"]["location"]["lat"].doubleValue
				lng = json[0]["geometry"]["location"]["lng"].doubleValue
				
				DataModel.si.cityName = json[0]["formatted_address"].stringValue
				
				Map.si.setPosition(json[0]["geometry"]["location"]["lat"].doubleValue, json[0]["geometry"]["location"]["lng"].doubleValue)
				getWeather()
			} else {
				print("No search results")
			}
		}
	}
	
	func searchAddress(_ address: String) {
		Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json?address=\(address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&key=\(NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)?["SearchKey"] as! String)").responseJSON(completionHandler: gotAddress)
	}
	
	func getWeather() {
		Alamofire.request("https://api.darksky.net/forecast/\(NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)?["WeatherKey"] as! String)/\(lat),\(lng)").responseJSON(completionHandler: gotWeather)
		
	}
	
	func gotCityName(_ address: String) {
		Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json?address=\(address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&key=\(NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)?["SearchKey"] as! String)").responseJSON { response in
			if let val = response.result.value {
				let json = JSON(val)["results"]
				DataModel.si.cityName = json[0]["formatted_address"].stringValue
			}
		}
	}
	
	
	func gotWeather(response: DataResponse<Any>) {
		
		switch response.result {
		case .success(let value):
			let json = JSON(value)
			let currently = json["currently"]
			let icon = currently["icon"]
			let temp = currently["temperature"].doubleValue
			let time = currently["time"]
			let summary = currently["summary"]
			//Alert Calls
			let alert = json["alerts"]
			let alertTitle = alert["title"]
			let alertTime = alert["time"]
			let alertExpires = alert["expires"]
			let alertDescription = alert["description"]
			let precipChance = currently["precipProbability"].doubleValue
			let currentModel = DataModel.si
			//print("Current Weather Json: \(json)")
			currentModel.time = Utilities.si.getDate(utc: time.doubleValue)
			currentModel.icon = icon.stringValue
			currentModel.summary = summary.stringValue
			currentModel.precipChance = precipChance
			currentModel.temp = temp
			
			currentModel.alertTitle = alertTitle.stringValue
			currentModel.alertTime = alertTime.doubleValue
			currentModel.alertExpires = alertExpires.doubleValue
			currentModel.alertDescription = alertDescription.stringValue
			
		case .failure(let error):
			print(error.localizedDescription)
		}
	}
	
	func getHourlyWeather() {
		Alamofire.request("https://api.darksky.net/forecast/\(NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)?["WeatherKey"] as! String)/\(lat),\(lng)").responseJSON { response in

			if let val = response.result.value {
				let json = JSON(val)
				let hourly = json["hourly"]
				let data = hourly["data"]
				for object in data.arrayValue {
						let time = object["time"].stringValue
						let icon = object["icon"].stringValue
						let temp = object["temperature"].stringValue
						let chance = object["precipProbability"].stringValue
					
					self.hourlyArray.append(HourlyModel.init(time: time, icon: icon, precipProb: chance, temp: temp))
					}
				
				
//				let timeValue = json["data"]["time"]
//				let iconValue = json["data"]["icon"]
//				let tempValue = json["data"]["temp"]
//				
//				self.hourlyArray.append(HourlyModel.init(time: timeValue.stringValue, icon: iconValue.stringValue, temp: tempValue.stringValue))
				
			}
	}
	}
		
		
		
		func updateHistory(_ address: String, _ lat: Double, _ lng: Double) {
			do {
				let h = try history.value()
				var found = -1
				var i = 0
				var hist: [[String:Any]] = []
				
				h.forEach({ item in
					if item["address"] as! String == address {
						found = i
					}
					
					i += 1
				})
				
				if found > -1 {
					i = 0
					
					h.forEach({ item in
						if (i != found) {
							hist.append(item)
						}
						
						i += 1
					})
				} else if h.count > 4 {
					i = 0
					
					h.forEach({ item in
						if (i < 4) {
							hist.append(item)
						}
						
						i += 1
					})
				} else {
					hist = h
				}
				
				hist.insert([
					"address":	address,
					"lat":			lat,
					"lng":			lng
					], at: 0)
				
				history.onNext(hist)
				
				UserDefaults.standard.setValue(hist, forKey: "electra-search-history")
				UserDefaults.standard.synchronize()
			} catch {
				print(error)
			}
		}
}



