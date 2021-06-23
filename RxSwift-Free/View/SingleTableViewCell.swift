
import UIKit

final class SingleTableViewCell: UITableViewCell {
    static var className: String { String(describing: SingleTableViewCell.self) }

    @IBOutlet weak private var nameLabel: UILabel!
    
    func configure(githubModel: GithubModel) {
        nameLabel.text = githubModel.name
    }
    
}
