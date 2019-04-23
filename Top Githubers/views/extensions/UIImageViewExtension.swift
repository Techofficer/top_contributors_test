import Foundation
import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { self.image = UIImage(data: data) }
        }
        
        task.resume()
    }
    
    func rounded(){
        layer.borderWidth = 0
        layer.masksToBounds = false
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
