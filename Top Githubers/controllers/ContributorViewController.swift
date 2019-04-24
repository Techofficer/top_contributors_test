import UIKit
import MapKit
import CoreLocation

class ContributorViewController: GenericViewController {

    @IBOutlet weak var placeholderView: UIView! {
        didSet {
            placeholderView.isHidden = true
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var errorLabel: UILabel!
    
    lazy var geocoder = CLGeocoder()
    
    var contributor : Contributor!
    var annotation : MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        contentView.layer.cornerRadius = 5.0
        
        retrieveContributorLocation()
    }
    
    func showError(error : String){
        placeholderView.isHidden = false
        errorLabel.text = error
    }
    
    func getContributorLocation(data : AnyObject?, completion: @escaping (String?, CLLocation?) -> Void){
        guard let address = data?["location"] as? String  else {
            completion("Contributor's location is not known", nil)
            return
        }
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                completion("Contributor's location is not known", nil)
                return
            }
            
            completion(nil, location)
        }
    }
    
    func retrieveContributorLocation(){
        displaySpinner()
        
        GithubApi.getContributorLocation(contributor: contributor) { error, result in
            if let error = error {
                self.hideSpinner()
                self.showError(error: error.localizedDescription)
                return
            }
            
            self.getContributorLocation(data: result){ error, location in
                self.hideSpinner()
                
                if let error = error {
                    self.showError(error: error)
                    return
                }
                
                self.addMarket(location: location!)
            }

        }
    }
    
    func addMarket(location : CLLocation){
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(coordinateRegion, animated: true)

        annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        annotation!.coordinate = centerCoordinate
        annotation!.title = contributor.name
        
        mapView.addAnnotation(annotation!)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
