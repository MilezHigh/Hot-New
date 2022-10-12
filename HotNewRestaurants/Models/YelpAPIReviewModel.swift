//
//  YelpAPIReviewModel.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/12/22.
//

import Foundation

struct YelpAPIReviewModel: Decodable {
    var text: String?
    var time_created: String?
    var rating: Int?
    var user: YelpAPIUserModel?
}
