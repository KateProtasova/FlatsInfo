//
//  FlatCell.swift
//  Kvartirka
//
//  Created by Екатерина Протасова on 12.06.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import UIKit
import Kingfisher

class FlatCell: UITableViewCell {

    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 4
    }

    func configureWith(flat: Flat) {
        priceLabel.text = "\(flat.prices.day)Р /ночь"
        addressLabel.text = flat.address
        titleLabel.text = flat.title
        let url = URL(string: flat.photoDefault.url)
        KingfisherManager.shared.downloader.trustedHosts = Set(["beta.kvartirka.pro"])
        photoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
    }
}
