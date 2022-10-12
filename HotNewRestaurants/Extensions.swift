//
//  Extensions.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/12/22.
//

import UIKit

extension UIImageView {
    func loadImage(urlString: String) {
        APIService.shared.loadData(urlString: urlString) { [weak self] data in
            guard let data = data else { return }
            self?.image = UIImage(data: data)
        }
    }
}
