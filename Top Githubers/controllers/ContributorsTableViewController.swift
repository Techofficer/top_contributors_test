import UIKit

class ContributorsTableViewController: GenericViewController {

    var contributors : [Contributor]! = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveContributors(nil)
    }
    
    func retrieveContributors(_ completion: (() -> Void)?){
        displaySpinner()
        
        GithubApi.getContributors { error, result in
            self.hideSpinner()
            
            if let error = error {
                self.showAlert(error: error.localizedDescription)
                return
            }
            
            if let result = result as? [[String:Any]] {
                self.contributors = []
                for json in result {
                    self.contributors.append(Contributor(json: json))
                }
                self.contributors.sort { $0.numberOfCommits > $1.numberOfCommits }
                self.tableView.reloadData()
            }
            
            completion?()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ContributorViewController, let contributor = sender as? Contributor {
            vc.contributor = contributor
        }
    }
}

extension ContributorsTableViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return contributors.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100.0 }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowContributorVC", sender: contributors[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContributorTableViewCell", for: indexPath) as! ContributorTableViewCell
        cell.setContributor(contributor: contributors[indexPath.row])
        return cell
    }
}
