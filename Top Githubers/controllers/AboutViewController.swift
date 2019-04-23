import UIKit
import SafariServices


class AboutViewController: UITableViewController {

    func openURL(value : String){
        guard let url = URL(string: value) else { return }
        self.present(SFSafariViewController(url: url), animated: true)
    }
    
    @IBAction func openRepo(_ sender: Any) {
        openURL(value: "https://github.com/MSWorkers/support.996.ICU")
    }
    
}
