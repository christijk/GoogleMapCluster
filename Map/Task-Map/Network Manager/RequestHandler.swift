//
//  RequestHandler.swift
//  Task-Map
//
//  Created by Christi John on 09/07/2020.
//  Copyright © 2020 Christi John. All rights reserved.
//

import Foundation

final class RequestHandler {
	static func getLocations(_ path: String, _ parameters: [String: String],
							 completion: @escaping (Result<Locations, NetworkError>) -> Void) {
		NetworkManager.post(path, parameters, completion: completion)
	}
}
