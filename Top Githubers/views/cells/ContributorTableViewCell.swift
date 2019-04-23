import UIKit

class ContributorTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.rounded()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberOfComitsLabel: UILabel!
    
    func setContributor(contributor : Contributor){
        if let image = contributor.image {
            avatarImageView.imageFromUrl(urlString: image)
        }
        nameLabel.text = contributor.name
        numberOfComitsLabel.text = "Number of commits: \(contributor.numberOfCommits!)"
    }

}
