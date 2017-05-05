import UIKit
import RxSwift
import RxCocoa
import SwiftGifOrigin

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var gifTableView: UITableView!
    @IBOutlet weak var resultLabel: UILabel!
    let manager = GifDownloadManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        manager.makeRequest(queryTerm: "") { err in
            if let error = err {
                self.handle(error: error)
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
            manager.makeRequest(queryTerm: query) { err in
                if let error = err {
                    self.handle(error: error)
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
    
    func show(message labelText: String) {
        gifTableView.isHidden = true
        resultLabel.text = labelText
        resultLabel.isHidden = false
    }
    
    func handle(error: Error) {
        switch error {
        case GettingGifsError.noResultsFound:
            self.show(message: "No results found")
        case GettingGifsError.incorrectData:
            print("Incorrect Data")
        case GettingGifsError.notConnectedToInternet:
            self.show(message: "Not connected to internet")
        default:
            print("default")
        }
    }
}
