import UIKit
import RxSwift
import RxCocoa
import SwiftGifOrigin

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var gifTableView: UITableView!
    let manager = GifDownloadManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        manager.makeRequest() {
            self.gifTableView.reloadData()
        }
        //gifTableView.estimatedRowHeight = 70.0
        //gifTableView.rowHeight = UITableViewAutomaticDimension
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if let query = searchTextField.text {
            manager.makeRequest(queryTerm: query) {
                self.gifTableView.reloadData()
            }
        }
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gif", for: indexPath)
        guard let gifItemCell = cell as? GifItemTableViewCell else {
            return cell
        }
        gifItemCell.suspendDownloading = { [weak self] in
            self?.manager.stopDownloadGifData(index: indexPath.row)
        }
        manager.downloadGifData(index: indexPath.row, completionHandler: { gifItem, error in
            if let data = gifItem.gifData {
                DispatchQueue.main.async {
                    gifItemCell.gifItemImageView.image = UIImage.gif(data: data)
                }
            }
        })
        return gifItemCell
    }

}
