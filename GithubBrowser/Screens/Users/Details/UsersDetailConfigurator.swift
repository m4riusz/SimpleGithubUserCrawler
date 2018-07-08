import Foundation

protocol IUsersDetailConfigurator {
    func configure(usersDetailController: UsersDetailController) -> Void
}

class UsersDetailConfigurator: IUsersDetailConfigurator {
    
    func configure(usersDetailController: UsersDetailController) {
        let usersDetailView: IUsersDetailView = usersDetailController
        let usersService: IUsersService = UsersService()
        let cacheManager: ICacheManager = CacheManager(withDiscConfig: CacheConfig(cacheSize: 10240, expireSeconds: 360),
                                                       withMemoryConfig: CacheConfig(cacheSize: 1024, expireSeconds: 60))
        let usersDetailPresenter: IUsersDetailPresenter = UsersDetailPresenter(withView: usersDetailView, withService: usersService, withCacheManager: cacheManager)
        usersDetailController.usersDetailPresenter = usersDetailPresenter
    }
    
}
