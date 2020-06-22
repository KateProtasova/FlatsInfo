//
//  NetworkManager.swift
//  Kvartirka
//
//  Created by Екатерина Протасова on 12.06.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import Foundation
import Alamofire

protocol Networking {
    func getFlats(cityId: Int, completion: @escaping (Result<[Flat], Error>) -> Void)
    func getCity(userLocation: UserLocation, completion: @escaping (Result<City, Error>) -> Void)
}

final class NetworkManager: Networking {

    static let shared = NetworkManager()

    private init() {}

    func getFlats(cityId: Int, completion: @escaping (Result<[Flat], Error>) -> Void) {

        let params: [String: Any] = ["city_id": cityId]
        let requestMethod = "\(baseUrlString)/\(ServerAPIMethods.getFlats)"

        AF.request(requestMethod, method: .get, parameters: params, encoding: URLEncoding.default)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let value):
                    let decoded = self.decodeJSON(type: FlatsRoot.self, from: value)
                    let flats: [Flat] = decoded?.flats ?? []
                    completion(.success(flats))
                case .failure:
                    completion(.failure(NetworkError.networkError))
                }
        }
    }

    func getCity(userLocation: UserLocation, completion: @escaping (Result<City, Error>) -> Void) {
        let params: [String: Any] = ["lat": userLocation.latitude, "lng": userLocation.longitude]
        let requestMethod = "\(baseUrlString)/\(ServerAPIMethods.getCities)"
        AF.request(requestMethod, method: .get, parameters: params, encoding: URLEncoding.default)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let value):
                    let decoded = self.decodeJSON(type: Cities.self, from: value)
                    let cities: [City] = decoded?.cities ?? []
                    guard let city = cities.first else {
                        return completion(.failure(NetworkError.networkError))
                    }
                    completion(.success(city))
                case .failure:
                    completion(.failure(NetworkError.networkError))
                }
        }
    }

    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else {
            return nil
        }
        return response
    }
}
