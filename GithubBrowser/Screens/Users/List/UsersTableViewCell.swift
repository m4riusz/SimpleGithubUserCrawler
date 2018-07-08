import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userTitle: UILabel!
    
}

extension UsersTableViewCell: DataLoadingProtocol {
    
    func loadData(_ data: Any) {
        if let userData: User = data as? User {
            userTitle.text = userData.login
            userImageView.setImageWithUrl(userData.avatarImage)
        }
    }
    
}
