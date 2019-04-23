import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var spinnerView : UIView?
    
    func displaySpinner()  {
        spinnerView = UIView.init(frame: self.view.bounds)
        spinnerView!.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let indicator = UIActivityIndicatorView.init(style: .whiteLarge)
        indicator.startAnimating()
        indicator.center = spinnerView!.center
        
        spinnerView!.addSubview(indicator)
        view.addSubview(spinnerView!)
    }
    
    func hideSpinner() {
        spinnerView?.removeFromSuperview()
    }
    
    func processError(error : Error){
        DispatchQueue.main.async {
            self.hideSpinner()
            self.showAlert(error: error.localizedDescription)
        }
    }
    
    func showAlert(error : String?) {
        if presentedViewController == nil {
            let alert = UIAlertController(title: "Error", message: error ?? "Something went wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
