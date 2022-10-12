//
//  YelpAPISearchModel.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/11/22.
//

import Foundation

struct YelpAPIBusinessModel: Decodable {
    var id: String?
    var name: String?
    var image_url: String?
    var price: String?
    var phone: String?
    var rating: CGFloat?
    var distance: CGFloat?
    var location: YelpBusinessLocationModel?
}
