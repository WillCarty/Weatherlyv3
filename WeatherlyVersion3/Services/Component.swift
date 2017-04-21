//
//  Component.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/16/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//
import RxSwift
import Foundation

class Component: UIViewController {
	let disposeBag = DisposeBag()
	var subs:[Disposable] = []
	
//	var backend:	Backend =	Backend.si
//	var config:		Config =	Config.si
	var map:			Map =			Map.si
	var state:		State =		State.si
	
	func sub(_ obs: BehaviorSubject<[String:Any]>, _ callback: @escaping ([String:Any]) -> ()) {
		subs.append(obs.subscribe(onNext: callback))
		subs.last!.addDisposableTo(disposeBag)
	}
	
	func sub(_ list: [(obs: BehaviorSubject<[String:Any]>, callback: ([String:Any]) -> ())]) {
		list.forEach({ item in
			subs.append(item.obs.subscribe(onNext: item.callback))
			subs.last!.addDisposableTo(disposeBag)
		})
	}
}
