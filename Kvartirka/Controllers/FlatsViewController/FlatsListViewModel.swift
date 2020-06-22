//
//  FlatsViewModel.swift
//  Kvartirka
//
//  Created by Екатерина Протасова on 18.06.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import Foundation

protocol FlatsListViewModelDelegate: class {
    func updateList(flats: [Flat])
    func showError(error: Error)
    func showSpinner(title: String)
    func hideSpinner()
}

final class FlatsListViewModel {

    weak var delegate: FlatsListViewModelDelegate?
    private var locationService: Location
    private let networkManager: Networking

    init(networkManager: Networking, locationService: Location) {
        self.networkManager = networkManager
        self.locationService = locationService
    }

    func getData() {
        delegate?.showSpinner(title: "Получаем ваше местоположение")
        locationService.checkLocation()
        locationService.locationCompletion = { [weak self] location in
            switch location {
            case .success(let value):
                self?.getCity(userLocation: value)
            case .failure:
                self?.getFlats()
            }
        }
    }

    private func getFlats(cityId: Int = 18) {
        delegate?.showSpinner(title: "Получаем квартиры поблизости")
        NetworkManager.shared.getFlats(cityId: cityId) { flats in
            self.delegate?.hideSpinner()
            switch flats {
            case .success(let flats):
                self.delegate?.updateList(flats: flats)
            case .failure(let error):
                self.delegate?.showError(error: error)
            }
        }
    }

    private func getCity(userLocation: UserLocation) {
        delegate?.showSpinner(title: "Ищем квартиры в вашем городе")
        NetworkManager.shared.getCity(userLocation: userLocation) { result in
            switch result {
            case .success(let city):
                self.getFlats(cityId: city.id)
            case .failure:
                self.getFlats()
            }
        }
    }
}
