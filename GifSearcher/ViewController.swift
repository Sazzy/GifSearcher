import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var gifTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        searchTextField.returnKeyType = UIReturnKeyType.search
        gifTableView.estimatedRowHeight = 70.0
        gifTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        //gifTableView.reloadData()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
