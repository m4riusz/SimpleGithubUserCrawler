import UIKit

class BaseUsersNavigationController: BaseNavigationController {

    override func initWithAppociatedController() -> BaseNavigationController {
        return BaseUsersNavigationController(rootViewController: UsersController())
    }

}
