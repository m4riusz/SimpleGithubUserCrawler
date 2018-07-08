import UIKit

class BaseNavigationController: UINavigationController {
    
    func initWithAppociatedController() -> BaseNavigationController {
        return BaseNavigationController(rootViewController: BaseScreenController())
    }

}
