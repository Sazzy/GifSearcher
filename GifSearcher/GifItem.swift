import UIKit

class GifItem {
    var gifData: Data
    var width: Double
    var height: Double
    //
    init(gifData: Data, width: Double=0, height: Double=0) {
        self.gifData = gifData
        self.width = width
        self.height = height
    }
}
