import UIKit

struct UserDetails: Codable {
    
    let id: UInt?
    let login: String
    let avatarImage:  String
    let name: String?
    let company: String?
    let location: String?
    let email: String?
    let bio: String?
    let followersCount: Int
    let followingCount: Int
    
    enum CodingKeys : String, CodingKey {
        case id
        case login
        case avatarImage = "avatar_url"
        case name
        case company
        case location
        case email
        case bio
        case followersCount = "followers"
        case followingCount = "following"
    }
}


protocol IUsersDetailView {
    func showDataDownload() -> Void
    func showNotSelectedUser() -> Void
    func showNotConnected() -> Void
    func hideDataDownload() -> Void
    func setUserDetails(_ userDetails: UserDetails) -> Void
    func onError(_ error: Error?) -> Void
}

class UsersDetailController: BaseUsersController {

    @IBOutlet weak var userDetailsAvatarImage: UIImageView!
    @IBOutlet weak var userDetailsUsernameLabel: UILabel!
    @IBOutlet weak var userDetailsBioLabel: UILabel!
    @IBOutlet weak var userDetailsNameLabel: UILabel!
    @IBOutlet weak var userDetailsLocationLabel: UILabel!
    @IBOutlet weak var userDetailsEmailLabel: UILabel!
    @IBOutlet weak var userDetailsCompanyLabel: UILabel!
    @IBOutlet weak var userDetailsFollowersLabel: UILabel!
    @IBOutlet weak var userDetailsFollowingLabel: UILabel!
    @IBOutlet weak var emptyMaskView: EmptyMaskView!
    
    fileprivate var userDetails: UserDetails?
    fileprivate var usersDetailConfigurator: IUsersDetailConfigurator = UsersDetailConfigurator()
    var usersDetailPresenter: IUsersDetailPresenter?
    
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersDetailConfigurator.configure(usersDetailController: self)
    }
    
    override func loadScreenData() {
        super.loadScreenData()
        usersDetailPresenter!.getUsersDetailByLogin(username)
    }
    
    override func getTitle() -> String? {
        return username
    }
    
}

extension UsersDetailController: IUsersDetailView {
    
    func showDataDownload() {
        loaderScreen.show()
    }
    
    func showNotSelectedUser() -> Void {
        emptyMaskView.setupForType(.notSelectedUser)
        emptyMaskView.isHidden = false
    }
    
    func showNotConnected() -> Void {
        emptyMaskView.setupForType(.noInternetConnection)
        emptyMaskView.isHidden = false
    }
    
    func hideDataDownload() {
        loaderScreen.hide()
    }
    
    func setUserDetails(_ userDetails: UserDetails) {
        emptyMaskView.isHidden = true
        userDetailsAvatarImage.setImageWithUrl(userDetails.avatarImage)
        userDetailsUsernameLabel.text = userDetails.login
        userDetailsBioLabel.text = userDetails.bio ?? ""
        userDetailsNameLabel.text = userDetails.name ?? ""
        userDetailsLocationLabel.text = userDetails.location ?? ""
        userDetailsEmailLabel.text = userDetails.email ?? ""
        userDetailsCompanyLabel.text = userDetails.company ?? ""
        userDetailsFollowersLabel.text = "Liczba obserwujących: \(userDetails.followersCount)"
        userDetailsFollowingLabel.text = "Liczba obserwowanych: \(userDetails.followingCount)"
        
        userDetailsBioLabel.isHidden = userDetailsBioLabel.text!.count == 0
        userDetailsNameLabel.isHidden = userDetailsNameLabel.text!.count == 0
        userDetailsLocationLabel.isHidden = userDetailsLocationLabel.text!.count == 0
        userDetailsEmailLabel.isHidden = userDetailsEmailLabel.text!.count == 0
        userDetailsCompanyLabel.isHidden = userDetailsCompanyLabel.text!.count == 0
    }
    
    func onError(_ error: Error?) {
        loaderScreen.error(error: error)
    }
    
}
