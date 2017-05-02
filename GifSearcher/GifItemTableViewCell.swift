import UIKit

class GifItemTableViewCell: UITableViewCell {
    @IBOutlet weak var gifItemImageView: UIImageView!
    var suspendDownloading: (() -> ())?

    override func prepareForReuse() {
        super.prepareForReuse()
        gifItemImageView.image = nil
        suspendDownloading?()
    }
}
