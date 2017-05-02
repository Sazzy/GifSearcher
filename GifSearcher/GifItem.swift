import UIKit

class GifItem {
    var url: URL
    var gifData: Data?
    var width: Int
    var height: Int

    init(url: URL, gifData: Data?, width: Int = 0, height: Int = 0) {
        self.url = url
        self.gifData = gifData
        self.width = width
        self.height = height
    }
}
