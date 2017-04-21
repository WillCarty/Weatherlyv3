//
//  WeatherViewController.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/15/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//
import Alamofire
import UIKit
import RxSwift
import SwiftyJSON

class WeatherViewController: Component, UICollectionViewDelegate, UICollectionViewDataSource {
	var backNextState = ""
	
	
	@IBOutlet weak var iconImage: UIImageView!
	@IBOutlet weak var currentTemp: UILabel!
	@IBOutlet weak var precipChance: UILabel!
	@IBOutlet weak var dateTime: UILabel!
	@IBOutlet weak var summary: UITextView!
	@IBOutlet weak var busyIndicator: UIActivityIndicatorView!
	@IBOutlet weak var hourlyCollection: UICollectionView!
	@IBOutlet weak var weatherAlert: UITextView!
	@IBOutlet weak var weatherAlertContraint: NSLayoutConstraint!
	@IBOutlet weak var dismissButton: UIButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(4000)) {
			self.viewLoaded()
		}
		
	}
	
	func viewLoaded() {
		weatherAlert.text = "FLOOD WATCH REMAINS IN EFFECT THROUGH LATE FRIDAY NIGHT... THE FLOOD WATCH CONTINUES FOR A PORTION OF NORTHWEST WASHINGTON...INCLUDING THE FOLLOWING COUNTY...MASON. THROUGH LATE FRIDAY NIGHT  A STRONG WARM FRONT WILL BRING HEAVY RAIN TO THE OLYMPICS TONIGHT THROUGH THURSDAY NIGHT. THE HEAVY RAIN WILL PUSH THE SKOKOMISH RIVER ABOVE FLOOD STAGE TODAY...AND MAJOR FLOODING IS POSSIBLE.  A FLOOD WARNING IS IN EFFECT FOR THE SKOKOMISH RIVER. THE FLOOD WATCH REMAINS IN EFFECT FOR MASON COUNTY FOR THE POSSIBILITY OF AREAL FLOODING ASSOCIATED WITH A MAJOR FLOOD."
		
		if weatherAlert.text != "" {
			weatherAlertContraint.constant = 150
			
		} else {
			weatherAlertContraint.constant = 0
			dismissButton.alpha = 0.0
			dismissButton.isUserInteractionEnabled = false
		}
		hourlyCollection.delegate = self
		hourlyCollection.dataSource = self
		super.view.backgroundColor = .white
		busyIndicator.startAnimating()
		Backend.si.getWeather()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
			self.busyIndicator.stopAnimating()
			self.busyIndicator.isHidden = true
		}
		sub([(state.app, gotState)])
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
			self.view.addBackground()
			switch DataModel.si.icon {
			case "partly-cloudy-day":
				self.iconImage.image = UIImage(named: "partly-cloudy-day-icon")
			case "partly-cloudy-night":
				self.iconImage.image = UIImage(named: "partly-cloudy-night")
			case "cloudy":
				self.iconImage.image = UIImage(named: "cloudy")
			case "fog":
				self.iconImage.image = UIImage(named: "fog")
			case "wind":
				self.iconImage.image = UIImage(named: "wind")
			case "sleet":
				self.iconImage.image = UIImage(named: "sleet")
			case "snow":
				self.iconImage.image = UIImage(named: "snow")
			case "rain":
				self.iconImage.image = UIImage(named: "rain")
			case "clear-night":
				self.iconImage.image = UIImage(named: "clear-night")
			case "clear-day":
				self.iconImage.image = UIImage(named: "clear-day")
			default : break
			}
			
			self.dateTime.text = DataModel.si.time
			self.currentTemp.text = "Current Temp: \(round(Double(DataModel.si.temp)))°"
			self.summary.text = DataModel.si.summary
			self.precipChance.text = "Chance of Rain: \(DataModel.si.precipChance)%"
		}
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return Backend.si.hourlyArray.count
		
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath) as! HourlyCell
		var hourImage = UIImage(named: "clear-day")
		var temp = ""
		//	var precipChance = ""
		var time = ""
		let currentHourly = Backend.si.hourlyArray[indexPath.row]
		//for i in Backend.si.hourlyArray {
		switch currentHourly.icon {
		case "partly-cloudy-day":
			hourImage = UIImage(named: "partly-cloudy-day-icon")
		case "partly-cloudy-night":
			hourImage = UIImage(named: "partly-cloudy-night")
		case "cloudy":
			hourImage = UIImage(named: "cloudy")
		case "fog":
			hourImage = UIImage(named: "fog")
		case "wind":
			hourImage = UIImage(named: "wind")
		case "sleet":
			hourImage = UIImage(named: "sleet")
		case "snow":
			hourImage = UIImage(named: "snow")
		case "rain":
			hourImage = UIImage(named: "rain")
		case "clear-night":
			hourImage = UIImage(named: "clear-night")
		case "clear-day":
			hourImage = UIImage(named: "clear-day")
		default : break
		}
		temp = Utilities.si.rounder(Double(currentHourly.temp)!)
		time = Utilities.si.getHour(utc: Double(currentHourly.time)!)
		//		precipChance = i.precipProb
		//		print(i.icon)
		//		print(i.temp)
		//		print(i.time)
		cell.hourlyIcon.image = hourImage
		cell.tempLabel.text = temp
		cell.timeLabel.text = time
		
		
		//}
		return cell
	}
	
	func gotState(_ data: [String:Any]) {
	}
	
	@IBAction func dismissButtonTapped(_ sender: Any) {
		weatherAlertContraint.constant = 0
		dismissButton.isUserInteractionEnabled = false
		dismissButton.alpha = 0.0
	}
	
}

class HourlyCell: UICollectionViewCell {
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var hourlyIcon: UIImageView!
	@IBOutlet weak var tempLabel: UILabel!
	
}

extension UIView {
	func addBackground() {
		// screen width and height:
		let width = UIScreen.main.bounds.size.width
		let height = UIScreen.main.bounds.size.height
		
		let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
		imageViewBackground.image = UIImage(named: "background-image")
		
		// you can change the content mode:
		imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
		
		self.addSubview(imageViewBackground)
		self.sendSubview(toBack: imageViewBackground)
	}}
