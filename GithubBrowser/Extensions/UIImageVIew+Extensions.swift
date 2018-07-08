import UIKit
import SDWebImage

extension UIImageView {
    
    func setImageWithUrl(_ url: String) -> Void {
        guard let urlImage = URL(string: url) else {
            return
        }
        self.sd_setImage(with: urlImage, completed: nil)
    }
    
}
