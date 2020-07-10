//
//  NetworkManager.swift
//  Task-Map
//
//  Created by Christi John on 09/07/2020.
//  Copyright © 2020 Christi John. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case patch = "PATCH"
}

final class NetworkManager {
	/// Method to make API call to communicate with server
	/// - parameter urlString: The server endpoint
	/// - parameter parameters: Dictionary holding params
	/// - parameter completion: Completion handler which holds the result
	///
	static func post<T: Decodable>(_ urlString: String,
								   _ parameters: [String: String],
								   completion: @escaping (Result<T, NetworkError>) -> Void) {
		guard let url = URL(string: urlString) else { return }
		
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = HTTPMethod.post.rawValue
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpBody = parameters.percentEncoded()
		
		let dataTask = URLSession.shared.dataTask(with: request) { data,response,error in
			guard let data = data else {
				completion(.failure(.defaultError))
				return
			}
			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let model = try decoder.decode(T.self, from: data)
				completion(.success(model))
			} catch {
				completion(.failure(.defaultError))
			}
		}
		dataTask.resume()
	}
}


