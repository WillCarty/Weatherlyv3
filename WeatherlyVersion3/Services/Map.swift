//
//  Map.swift
//  WeatherlyVersion3
//
//  Created by Will Carty on 4/16/17.
//  Copyright © 2017 Will Carty. All rights reserved.
//
import GoogleMaps

class Map {
	static var _si: Map!
	static var si: Map {
		get {
			Map._si = Map._si ?? Map()
			
			return Map._si
		}
	}
	
	var gmap: GMSMapView!
	
	
	func getMap() -> GMSMapView {
		
		// Coordinates used to set the default map position don't matter too much since the config will have the coordinates the map should actually show
		
		GMSServices.provideAPIKey("AIzaSyCNPJ0oZA462TLdvG7pn1QnBemrbq4JQ-0")
		
		gmap = GMSMapView.map(
			withFrame:	CGRect.zero,
			camera:			GMSCameraPosition.camera(
				withLatitude:	35,
				longitude:		-85,
				zoom:					9.0
			)
		)
		
		// Enable location services in order to show the user their current location and hone in on it
		gmap.isMyLocationEnabled = true
		
		return gmap
	}
	
	func setPosition(_ lat: Double, _ lng: Double) {
		
		gmap.moveCamera(GMSCameraUpdate.setTarget(
			CLLocationCoordinate2D(
				latitude:		lat,
				longitude:	lng
			),
			
			zoom: 12.0
		))
		
	}
}
