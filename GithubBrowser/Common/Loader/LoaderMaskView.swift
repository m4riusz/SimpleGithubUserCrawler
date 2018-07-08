import UIKit
import NVActivityIndicatorView

protocol LoaderMaskViewProtocol {
    func onRefresh() -> Void
}

class LoaderMaskView: NibView {
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var delegate: LoaderMaskViewProtocol?
    
    override func commonInit() {
        super.commonInit()
        activityIndicator.type = .ballRotateChase
    }
    
    func show() -> Void {
        self.isHidden = false
        activityIndicator.isHidden = false;
        imageView.isHidden = true
        titleLabel.isHidden = false
        descriptionLabel.isHidden = false
        tryAgainButton.isHidden = true
        activityIndicator.startAnimating()
        titleLabel.text = "Trwa pobieranie danych"
        descriptionLabel.text = "Proszę czekać, to może chwilę potrwać"
        self.superview?.bringSubview(toFront: self)
    }
    
    func hide() -> Void {
        self.isHidden = true
        activityIndicator.stopAnimating();
        self.superview?.sendSubview(toBack: self)
    }
    
    func error(error: Error? = nil) -> Void {
        self.isHidden = false
        activityIndicator.isHidden = true;
        imageView.isHidden = false
        titleLabel.isHidden = false
        descriptionLabel.isHidden = false
        tryAgainButton.isHidden = false
        activityIndicator.stopAnimating()
        imageView.tintColor = UIColor.red
        titleLabel.text = "Błąd!"
        var errorMessage: String = error?.localizedDescription ?? "Ups, coś poszło nie tak"
        if let err = error as NSError? {
            if err.code == NSURLErrorNotConnectedToInternet {
                errorMessage = "Brak połączenia z internetem."
            } else if err.code == NSURLErrorTimedOut {
                errorMessage = "Upłynął czas na otrzymanie odpowiedzi. Spróbuj ponownie później."
            }
        }
        descriptionLabel.text = errorMessage
        tryAgainButton.setTitle("SPRÓBUJ PONOWNIE")
        self.superview?.bringSubview(toFront: self)
    }
    
    // MARK- Actions
    
    @IBAction func onTryAgainButton(_ sender: Any) {
        delegate?.onRefresh()
    }
    
}
