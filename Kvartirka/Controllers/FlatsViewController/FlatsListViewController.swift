//
//  FlatsListViewController.swift
//  Kvartirka
//
//  Created by Екатерина Протасова on 12.06.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftSpinner

final class FlatsListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    private var flats: [Flat] = []
    private let viewModel = FlatsListViewModel(networkManager: NetworkManager.shared, locationService: LocationService())

    override func viewDidLoad() {
        super.viewDidLoad()
        ImageDownloader.default.authenticationChallengeResponder = self
        setupUI()
        viewModel.delegate = self
        viewModel.getData()
    }

    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FlatCell", bundle: nil), forCellReuseIdentifier: "FlatCell")
        tableView.estimatedRowHeight = 227
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Объявления"
    }
}

extension FlatsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FlatCell", for: indexPath) as? FlatCell {
            cell.configureWith(flat: flats[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailsFlatViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsFlatViewController") as? DetailsFlatViewController {
            detailsFlatViewController.flat = flats[indexPath.row]
            navigationController?.pushViewController(detailsFlatViewController, animated: true)
        }
    }
}

extension FlatsListViewController: FlatsListViewModelDelegate {
    func updateList(flats: [Flat]) {
        self.flats = flats
        tableView.reloadData()
    }

    func showError(error: Error) {
        showAlert(with: "Ошибка!", and: error.localizedDescription)
    }

    func showSpinner(title: String) {
        SwiftSpinner.setTitleFont(UIFont.systemFont(ofSize: 16))
        SwiftSpinner.show(title, animated: true)
    }

    func hideSpinner() {
        SwiftSpinner.hide()
    }
}

extension FlatsListViewController: AuthenticationChallengeResponsable {
    // swiftlint:disable force_unwrapping
    func downloader(_ downloader: ImageDownloader, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }

    func downloader(_ downloader: ImageDownloader, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}
