//
//  YelpAPIErrorModel.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/11/22.
//

import Foundation

struct YelpAPIErrorModel: Decodable {
    var code: String
    var description: String
}
