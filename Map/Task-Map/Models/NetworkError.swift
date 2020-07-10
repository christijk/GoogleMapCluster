//
//  NetworkError.swift
//  Task-Map
//
//  Created by Christi John on 09/07/2020.
//  Copyright © 2020 Christi John. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
	case defaultError
	case noInternet
}

extension NetworkError {
	public var errorCode: Int {
		switch self {
			case .defaultError:
				return 9999
			case .noInternet:
				return 9997
		}
	}
	
	public var errorDescription: String {
		switch self {
			case .defaultError:
				return ErrorMessages.defaultError
			case .noInternet:
				return ErrorMessages.offline
		}
	}
}


