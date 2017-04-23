//
//  GifItem.swift
//  GifSearcher
//
//  Created by Eugene Sazonov on 22/04/2017.
//  Copyright © 2017 Eugene Sazonov. All rights reserved.
//

import UIKit

class GifItem {
    var url: String
    var width: Double
    var height: Double
    init(url: String="", width: Double=0, height: Double=0) {
        self.url = url
        self.width = width
        self.height = height
    }
}
