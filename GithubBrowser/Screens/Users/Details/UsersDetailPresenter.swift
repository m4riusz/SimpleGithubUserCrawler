import Foundation

protocol IUsersDetailPresenter {
    func getUsersDetailByLogin(_ login: String?) -> Void
}

class UsersDetailPresenter: IUsersDetailPresenter {
  
    fileprivate let usersDetailView: IUsersDetailView
    fileprivate let usersService: IUsersService
    fileprivate let cacheManager: ICacheManager
    fileprivate let networkUtil: NetworkUtil
    
    init(withView usersDetailView: IUsersDetailView, withService usersService: IUsersService, withCacheManager cacheManager: ICacheManager) {
        self.usersDetailView = usersDetailView;
        self.usersService = usersService
        self.cacheManager = cacheManager
        self.networkUtil = NetworkUtil()
        self.networkUtil.startMonitoring()
    }
    
    deinit {
        self.networkUtil.stopMonitoring()
    }
    
    func getUsersDetailByLogin(_ login: String?) {
        if let cachedUserDetails: UserDetails = self.cacheManager.getCachedUser(username: login) {
            DispatchQueue.main.async {
                self.usersDetailView.setUserDetails(cachedUserDetails)
            }
            return
        }
        
        guard self.networkUtil.hasConnection() else {
            DispatchQueue.main.async {
                self.usersDetailView.showNotConnected()
            }
            return
        }
        guard login != nil else {
            DispatchQueue.main.async {
                self.usersDetailView.showNotSelectedUser()
            }
            return
        }
        DispatchQueue.main.async {
            self.usersDetailView.showDataDownload()
        }
        self.usersService.getUserDetailsByLogin(login!, withCompletionBlock: { (userDetails) in
            DispatchQueue.main.async {
                self.cacheManager.setCachedUser(userDetails: userDetails)
                self.usersDetailView.setUserDetails(userDetails)
                self.usersDetailView.hideDataDownload()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.usersDetailView.hideDataDownload()
                self.usersDetailView.onError(error)
            }
        }
    }
    
}
