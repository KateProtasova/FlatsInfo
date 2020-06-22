//
//  DetailsFlatViewController.swift
//  Kvartirka
//
//  Created by Екатерина Протасова on 15.06.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import UIKit
import ImageSlideshow

final class DetailsFlatViewController: UIViewController {

    var flat: Flat?
    private var kingfisherSource: [KingfisherSource] = []

    @IBOutlet private var slideshow: ImageSlideshow!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var roomLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var priseLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSlideshow()
    }

    func setupUI() {
        guard let flat = self.flat else {
            return
        }
        for photo in flat.photos {
            if let source = KingfisherSource(urlString: photo.url) {
                kingfisherSource.append(source)
            }
        }
        addressLabel.text = flat.address
        titleLabel.text = flat.title
        roomLabel.text = "\(flat.rooms) rooms"
        typeLabel.text = flat.buildingType
        priseLabel.text = "\(flat.prices.day)Р /ночь"
        title = flat.title
    }

    func setupSlideshow() {
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.setImageInputs(kingfisherSource)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideshow.addGestureRecognizer(recognizer)
    }

    @objc
    func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }
}
