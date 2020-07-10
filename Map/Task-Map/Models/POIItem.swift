//
//  POIItem.swift
//  Task-Map
//
//  Created by Christi John on 09/07/2020.
//  Copyright © 2020 Christi John. All rights reserved.
//

import Foundation
import GoogleMapsUtils

/// Point of Interest Item which implements the GMUClusterItem protocol.
///
class POIItem: NSObject, GMUClusterItem {
	var position: CLLocationCoordinate2D
	var name: String
	
	init(position: CLLocationCoordinate2D, name: String) {
		self.position = position
		self.name = name
	}
}
