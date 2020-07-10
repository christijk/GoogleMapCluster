//
//  ViewController.swift
//  Task-Map
//
//  Created by Christi John on 09/07/2020.
//  Copyright © 2020 Christi John. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

class ViewController: UIViewController {
	private struct Constants {
		static let endPoint = "https://myscrap.com/api/msDiscoverPage"
		static let searchText = "searchText"
		static let apiKey = "apiKey"
		static let ok = "OK"
	}
	
	@IBOutlet weak var mapHolderView: UIView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	private var mapView: GMSMapView!
	private var clusterManager: GMUClusterManager!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		configureUI()
		getLocations(for: "")
	}

	
	// MARK: - Private Methods
	
	/// Method to configure initial Ui appearence
	///
	private func configureUI() {
		activityIndicator.isHidden = true
		if #available(iOS 13.0, *) {
			searchBar.searchTextField.backgroundColor = .white
		} else {
			let textField = searchBar.value(forKey: "_searchField") as! UITextField
			textField.backgroundColor = .white
		}
		searchBar.layer.borderColor = UIColor.black.cgColor
		searchBar.layer.borderWidth = 1.0
		searchBar.delegate = self
		
		configureGoogleMap()
		configureClusterManager()
	}
	
	/// Method to configure Google map view with a default location
	///
	private func configureGoogleMap() {
		let camera = GMSCameraPosition.camera(withLatitude: 25.2532,
											  longitude: 55.3657,
											  zoom: 11.5)
		mapView = GMSMapView.map(withFrame: mapHolderView.bounds,
									 camera: camera)
		mapView.setMinZoom(1, maxZoom: 25)
		mapView.delegate = self
		mapHolderView.addSubview(mapView)
	}
	
	/// Set up the cluster manager with the supplied icon generator and
	/// renderer.
	///
	private func configureClusterManager() {
		let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [99999],
														   backgroundColors: [UIColor(named: "AppThemeColor")!])
		let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
		let renderer = GMUDefaultClusterRenderer(mapView: mapView,
												 clusterIconGenerator: iconGenerator)
		renderer.delegate = self
		clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
										   renderer: renderer)
	}
	
	/// Method to to add markers on google map and cluster them
	///
	private func addMarkers(_ locations: Locations?) {
		guard let locations = locations?.locationData,
			locations.count > 0 else {
			showAlert(title: ErrorMessages.noResults, message: nil, cancelTitle: Constants.ok)
			return
		}
		
		for item in locations {
			if let latitude = item.lat,
				let longitude = item.longi,
				let name = item.name {
				let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
				let poi = POIItem(position: position, name: name)
				clusterManager.add(poi)
			}
		}
		clusterManager.cluster()
	}
	
	/// Method to to show loading indicator when making API call
	///
	private func startLoading() {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
	}
	
	/// Method to to hide loading indicator
	///
	private func stopLoading() {
		activityIndicator.isHidden = true
		activityIndicator.stopAnimating()
	}
	
	/// Method to to show UIAlert
	///
	func showAlert(title: String?, message: String?, cancelTitle: String?) {
		DispatchQueue.main.async {
			let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
			let action = UIAlertAction.init(title: cancelTitle, style: .cancel) { (action) in
				
			}
			alert.addAction(action)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
}

// MARK: - API Extension

extension ViewController {
	
	/// Method to to fetch location details from API
	/// - parameter searchWord: User entered text from UISearchBar
	///
	private func getLocations(for searchWord: String) {
		startLoading()
		
		let url = Constants.endPoint
		let params = [Constants.searchText: searchWord,
					  Constants.apiKey: APIKey.production]
		
		RequestHandler.getLocations(url, params) { [weak self] (result) in
			switch result {
				case .success(let locations):
					DispatchQueue.main.async {
						self?.stopLoading()
						self?.addMarkers(locations)
					}
				case .failure(_):
					self?.showAlert(title: ErrorMessages.noResults, message: nil, cancelTitle: Constants.ok)
			}
		}
	}
}

// MARK: - GMUClusterRendererDelegate Extension

extension ViewController: GMUClusterRendererDelegate {
	func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
		switch object {
			case let clusterItem as POIItem:
				let marker = GMSMarker(position: clusterItem.position)
				marker.title = clusterItem.name
				marker.icon = GMSMarker.markerImage(with: UIColor(named: "AppThemeColor"))
				return marker
			default:
				return nil
		}
	}
}

// MARK: - GMSMapViewDelegate Extension

extension ViewController: GMSMapViewDelegate {
	func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
		searchBar.resignFirstResponder()
	}
}

// MARK: - UISearchBarDelegate Extension

extension ViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		view.endEditing(true)
		let serachWord = searchBar.text ?? ""
		getLocations(for: serachWord)
	}
}
