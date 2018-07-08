import UIKit

extension UIButton {
    
    func setTitle(_ title: String) -> Void {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.setTitle(title, for: .selected)
    }
    
}
