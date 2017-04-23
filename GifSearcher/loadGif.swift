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
