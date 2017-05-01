import UIKit
import RxSwift
import RxCocoa
import SwiftGifOrigin

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var gifTableView: UITableView!
    let test = GetData()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        gifTableView.estimatedRowHeight = 70.0
        gifTableView.rowHeight = UITableViewAutomaticDimension
        
        ///////test
        test.makeRequest()
        test.getJSON { jsonRes, error in
            self.test.getData(json: jsonRes) { _, _ in
            }
        }
    }
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        //gifTableView.reloadData()
        return true
    }
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gif", for: indexPath) as? GifItemTableViewCell
        cell?.gifItemImageView.image = UIImage(data: self.test.gifArr[indexPath.row].gifData)
        return cell!
    }

}
