
protocol IUsersConfigurator {
    func configure(usersController: UsersController) -> Void
}

class UsersConfigurator: IUsersConfigurator {
    
    func configure(usersController: UsersController) {
        let usersView: IUsersView = usersController
        let usersService: IUsersService = UsersService()
        let cacheManager: ICacheManager = CacheManager(withDiscConfig: CacheConfig(cacheSize: 10240, expireSeconds: 360),
                                                       withMemoryConfig: CacheConfig(cacheSize: 1024, expireSeconds: 60))
        let usersPresenter: IUsersPresenter = UsersPresenter(withView: usersView, withService: usersService, withCacheManager: cacheManager)
        usersController.usersPresenter = usersPresenter
    }
    
}
