import Foundation
import Alamofire
import Reachability

protocol IUsersPresenter {
    func getUsersByQuery(_ query: String?) -> Void
}

class UsersPresenter: IUsersPresenter {
    
    fileprivate let usersService: IUsersService
    fileprivate let usersView: IUsersView
    fileprivate let cacheManager: ICacheManager
    fileprivate let networkUtil: NetworkUtil
    fileprivate var prevQuery: String?
    fileprivate var failedQuery: String?
    
    init(withView usersView: IUsersView, withService usersService: IUsersService, withCacheManager cacheManager: ICacheManager) {
        self.usersView = usersView
        self.usersService = usersService
        self.cacheManager = cacheManager
        self.networkUtil = NetworkUtil()
        self.networkUtil.connectionChange = { connected in
            self.usersView.showNoInternetBar(!connected)
            if connected && self.failedQuery != nil {
                self.getUsersByQuery(self.failedQuery)
            }
        }
        self.networkUtil.startMonitoring()
    }
    
    deinit {
        self.networkUtil.stopMonitoring()
    }
    
    func getUsersByQuery(_ query: String? = "") {
        if let cachedUsers: [User] = self.cacheManager.getCachedList(query: query) {
            prevQuery = query
            DispatchQueue.main.async {
                self.usersView.hideDataDownload()
                if cachedUsers.count == 0 {
                    self.usersView.showEmptyUsers()
                    return
                }
                self.usersView.setUsers(cachedUsers)
            }
            return
        }
        guard networkUtil.hasConnection() else {
            if query!.isEmpty {
                DispatchQueue.main.async {
                    self.usersView.showEmptyPhase()
                }
            }
            failedQuery = query
            return
        }
        guard query != prevQuery else {
            return
        }
        guard !query!.isEmpty else {
            self.prevQuery = ""
            DispatchQueue.main.async {
                self.usersView.showEmptyPhase()
            }
            return
        }
        DispatchQueue.main.async {
            self.usersView.showDataDownload()
        }
        self.prevQuery = query
        self.usersService.getUsersByQuery(query, withCompletionBlock: { (users: [User]) in
            DispatchQueue.main.async {
                self.cacheManager.setCachedList(query: query!, users: users)
                if users.count == 0 {
                    self.usersView.showEmptyUsers()
                    self.usersView.hideDataDownload()
                    return
                }
                self.usersView.setUsers(users)
                self.usersView.hideDataDownload()
            }
        }) { (error) in
            self.prevQuery = nil
            DispatchQueue.main.async {
                self.usersView.hideDataDownload()
                self.usersView.onError(error)
            }
        }
    }
    
}
