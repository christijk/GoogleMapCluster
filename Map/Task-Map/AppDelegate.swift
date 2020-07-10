//
//  AppDelegate.swift
//  Task-Map
//
//  Created by Christi John on 09/07/2020.
//  Copyright © 2020 Christi John. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	static let kGoogleAPIKey = "AIzaSyC-5ONSnNpoUbynNaxKA7LdHuIE3BmHsZ8"
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		// Configure Google SDK using API Keys
		GMSServices.provideAPIKey(AppDelegate.kGoogleAPIKey)
		GMSPlacesClient.provideAPIKey(AppDelegate.kGoogleAPIKey)
		
		return true
	}
}

