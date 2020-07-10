//
//  Locations.swift
//  Task-Map
//
//  Created by Christi John on 09/07/2020.
//  Copyright © 2020 Christi John. All rights reserved.
//

//"error": false,
//"status": "success",
//"locationData": [
//{
//"image": "https://myscrap.com/",
//"id": "1131",
//"name": "1ST COAST RECYCLING INC ",
//"latitude": "29.686431",
//"longitude": "-81.661203",
//"addressOne": "108 Seaboard Dr , Palatka , Florida  , 32177, Palatka , Florida  , 32177",
//"addressTwo": "Palatka ",
//"state": "Florida  ",
//"country": "United States",
//"userLocation": "United States",
//"companyType": "Trader",
//"category": "0",
//"newJoined": false
//},


import Foundation
import GoogleMaps

struct Locations: Codable {
	var error: Bool?
	var status: String?
	var locationData: [Location]?
}

struct Location: Codable {
	var name: String?
	var latitude: String?
	var longitude: String?
	
	var lat: Double? {
		guard let latitude = self.latitude else {
			return nil
		}
		return Double(latitude)
	}
	
	var longi: Double? {
		guard let longitude = self.longitude else {
			return nil
		}
		return Double(longitude)
	}
	
}
