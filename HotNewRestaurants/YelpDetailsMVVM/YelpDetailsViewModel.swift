//
//  YelpDetailsViewModel.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/12/22.
//

import Foundation

class YelpDetailsViewModel {
    
    var yelpBusinessModel: YelpAPIBusinessModel
    
    init(yelpBusinessModel: YelpAPIBusinessModel) {
        self.yelpBusinessModel = yelpBusinessModel
    }
}
