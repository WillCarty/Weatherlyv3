//
//  States.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/16/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//

import Foundation
import RxSwift

class State {
	static var _si: State!
	static var si: State {
		get {
			State._si = State._si ?? State()
			
			return State._si
		}
	}
	
	private var data: [String:Any] = [:]
	
	var app =			BehaviorSubject<[String:Any]>(value: [
		"about":		false,
		"search":		false,
		"weather":	true,
		"map":      false,
		"header":   true,
		"menu": true,
		"setting": false,
		"weekly" : false
		])
	
//	var currentApp = BehaviorSubject<[String:Any]>(value: [
//		"weather": true,
//		"map": false,
//		"menu": true
//		])
	
	var header =	BehaviorSubject<[String:Any]>(value: [
		"back":						"",
		"image":					UIImage(),
		"label":					""
		])
	
	var menu =		BehaviorSubject<[String:Any]>(value: [
		"hour": "hour",
		"week":	"week",
		"map" : "mao"
		])
	
	var state: String {
		get { return "" }
		set {
			setState(newValue, nil)
		}
	}
	
	func setState(_ newState: String, _ data: [String:Any]?) {
		self.data = data ?? [:]
		setAppState(newState)
		setHeaderState(newState)
	}

	func setAppState(_ newState: String) {
		app.onNext([
			"about":		newState == "about",
			"map":		newState == "map",
			"search":		newState == "search",
			"weather": newState == "weather",
			"header" : newState == "header",
			"menu": newState == "menu",
			"weekly": newState == "weekly",
			"setting": newState == "setting"
			])
	}

	func setHeaderState(_ newState: String) {
		header.onNext([
				"back":						"",
				"image":					UIImage(),
				"label":					""
				])
	}
}

