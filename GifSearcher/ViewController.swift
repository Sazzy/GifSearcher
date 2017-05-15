import UIKit
import SwiftGifOrigin

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var gifTableView: UITableView!
    @IBOutlet weak var resultLabel: UILabel!
    let manager = GifDownloadManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        manager.makeRequest(queryTerm: "") { errString in
            if let error = errString {
                self.show(message: error)
            } else {
                self.gifTableView.isHidden = false
            }
            DispatchQueue.main.async {
                self.gifTableView.reloadData()
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if let query = searchTextField.text {
            manager.makeRequest(queryTerm: query) { errString in
                if let error = errString {
                    self.show(message: error)
                } else {
                    self.gifTableView.isHidden = false
                }
                DispatchQueue.main.async {
                    self.gifTableView.reloadData()
                }
            }
        }
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.requestResult.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gif", for: indexPath)
        guard let gifItemCell = cell as? GifItemTableViewCell else {
            return cell
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

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.manager.stopDownloadGifData(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(manager.requestResult[indexPath.row].gif.height)
    }
    
    func show(message labelText: String) {
        gifTableView.isHidden = true
        resultLabel.text = labelText
        resultLabel.isHidden = false
    }
}
