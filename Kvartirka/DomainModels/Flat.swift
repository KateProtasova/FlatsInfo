//
//  Flat.swift
//  Kvartirka
//
//  Created by Екатерина Протасова on 20.06.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import Foundation

class Flat: Codable {
    let id: Int
    let cityId: Int
    let buildingType: String
    let rooms: Int
    let address: String?
    let url: String
    let prices: Prices
    let photoDefault: PhotoDefault
    let photos: [Photo]
    let title: String
}
