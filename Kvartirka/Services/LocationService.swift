//
//  LocationService.swift
//  Kvartirka
//
//  Created by Екатерина Протасова on 15.06.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftSpinner

protocol Location {
    var locationCompletion: ((Result<UserLocation, Error>) -> Void)? { get set }

    func checkLocation ()
}

final class LocationService: NSObject, Location {

    private let locationManager = CLLocationManager()
    var locationCompletion: ((Result<UserLocation, Error>) -> Void)?

    func checkLocation () {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        locationCompletion?(.success(UserLocation(latitude: "\(locValue.latitude)", longitude: "\(locValue.longitude)")))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(.failure(error))
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
