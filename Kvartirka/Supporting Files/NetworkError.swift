//
//  NetworkError.swift
//  Kvartirka
//
//  Created by Екатерина Протасова on 17.06.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import Foundation

enum NetworkError {
    case networkError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError:
            return NSLocalizedString("Произошла ошибка подключения к сети, проверьте интернет соединение", comment: "")
        }
    }
}
