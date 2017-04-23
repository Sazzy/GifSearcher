//
//  loadGif.swift
//  GifSearcher
//
//  Created by Eugene Sazonov on 22/04/2017.
//  Copyright © 2017 Eugene Sazonov. All rights reserved.
//

import Foundation
import SwiftGifOrigin

extension UIImageView {
    public func loadGif(url: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(url: url)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
