import UIKit

class GifItemTableViewCell: UITableViewCell {
    @IBOutlet weak var gifItemImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        gifItemImageView.image = nil
    }
}
