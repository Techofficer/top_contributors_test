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
    
    func retrieveContributorLocation(){
        displaySpinner()
        
        GithubApi.getContributorLocation(contributor: contributor) { error, result in
            if let error = error {
                self.hideSpinner()
                self.showError(error: error.localizedDescription)
                return
            }
            
            guard let address = result?["location"] as? String  else {
                self.hideSpinner()
                self.showError(error: "Contributor's location is not known")
                return
            }
            
            self.geocoder.geocodeAddressString(address) { (placemarks, error) in
                self.hideSpinner()
                    
                guard let p = placemarks?.first, let location = p.location else {
                    self.showError(error: "Contributor's location is not known")
                    return
                }
                        
                self.addMarket(location: location)
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
