import UIKit
import SDWebImage

struct User: Codable {
    
    let id: UInt
    let login: String
    let avatarImage:  String
    
    enum CodingKeys : String, CodingKey {
        case id
        case login
        case avatarImage = "avatar_url"
    }
}

protocol IUsersView {
    func showDataDownload() -> Void
    func showEmptyPhase() -> Void
    func showEmptyUsers() -> Void
    func showNoInternetBar(_ show: Bool) -> Void
    func hideDataDownload() -> Void
    func setUsers(_ users: [User]) -> Void
    func onError(_ error: Error?) -> Void
}

class UsersController: BaseUsersController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyMaskView: EmptyMaskView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var noConnectionConstraintHeight: NSLayoutConstraint!
    
    fileprivate var users: [User] = []
    fileprivate let debouncer: Debouncer = Debouncer(timeInterval: 0.5)
    fileprivate var usersConfigurator: IUsersConfigurator = UsersConfigurator()
    var usersPresenter: IUsersPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersConfigurator.configure(usersController: self)
        self.navigationItem.titleView = searchBar
        tableView.register(UINib(nibName: UsersTableViewCell.className(), bundle: nil), forCellReuseIdentifier: UsersTableViewCell.className())
        debouncer.handler = {
            self.usersPresenter!.getUsersByQuery(self.searchBar.text)
        }
    }
    
    override func loadScreenData() {
        super.loadScreenData()
        self.usersPresenter!.getUsersByQuery(self.searchBar.text)
    }
}

extension UsersController: IUsersView {
    
    func showDataDownload() -> Void {
        loaderScreen.show()
    }
    
    func showEmptyPhase() -> Void {
        emptyMaskView.setupForType(.emptySearchText)
        emptyMaskView.isHidden = false
    }
    
    func showEmptyUsers() -> Void {
        emptyMaskView.setupForType(.noUsersFilterResult)
        emptyMaskView.isHidden = false
    }
    
    func showNoInternetBar(_ show: Bool) -> Void {
        UIView.animate(withDuration: 0.3) {
            self.noConnectionConstraintHeight.constant = show ? 40 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    func hideDataDownload() -> Void {
        loaderScreen.hide()
    }
    
    func setUsers(_ users_: [User]) -> Void {
        emptyMaskView.isHidden = true
        users = users_
        tableView.reloadData()
        if (UIDevice.current.userInterfaceIdiom == .pad && users.count > 0) {
            self.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        }
    }
    
    func onError(_ error: Error? = nil) -> Void {
        loaderScreen.error(error: error)
    }
    
}

extension UsersController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UsersTableViewCell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.className(), for: indexPath) as! UsersTableViewCell
        cell.loadData(users[indexPath.row])
        return cell
    }
    
}

extension UsersController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let prefetchUrls = indexPaths.filter({ (indexPath) -> Bool in return users.count > indexPath.row })
            .map({ (indexPath) -> URL in return URL(string: users[indexPath.row].avatarImage)! })
        SDWebImagePrefetcher.shared().prefetchURLs(prefetchUrls)
    }
    
}

extension UsersController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard users.count > indexPath.row else {
            return
        }
        let userDetail: User = users[indexPath.row]
        if let detailController: UsersDetailController = self.navigationController?.splitViewController?.viewControllers.last as? UsersDetailController {
            detailController.username = userDetail.login
            detailController.loadScreenData()
            self.navigationController?.splitViewController?.showDetailViewController(detailController, sender: nil)
        } else {
            let detailController: UsersDetailController = UsersDetailController()
            detailController.username = userDetail.login
            self.navigationController?.splitViewController?.showDetailViewController(detailController, sender: nil)
        }
    }
    
}

extension UsersController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.renewInterval()
    }
    
}
