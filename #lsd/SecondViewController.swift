
import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var startStopTracking: UISegmentedControl! //Starts and stop tracking
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    var locationManager:CLLocationManager?
    var myLocations: [CLLocation] = []
    
    func displayAlertWithTitle(title: String, message: String){ //UIAlertController template to give alert messages in case authorization is not given
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func createLocationManager(#startImmediately: Bool){ //Creates the location manager
        locationManager = CLLocationManager()
        if let manager = locationManager{
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation() 
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled(){//check if location services are enabled.
            
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedWhenInUse:
                createLocationManager(startImmediately: true)
            case .Denied:
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined: //Not sure yet - Prompt the user.
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            default :
                createLocationManager(startImmediately: true)

            }
            
            
        } else {
            println("Location services are not enabled")
        }

        //Setup our Map View
        theMap?.delegate = self
        theMap?.mapType = MKMapType.Hybrid
        theMap?.showsUserLocation = true
        
        startStopTracking.selectedSegmentIndex = 0
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) { //In case user changes the option
        switch startStopTracking.selectedSegmentIndex
        {
        case 0:
            locationManager!.startUpdatingLocation()
        case 1:
            locationManager!.stopUpdatingLocation()
        default:
            break;
        }
        
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        myLocations.append(locations[0] as CLLocation) //Plotting the new Map
        
        let spanX = 0.005
        let spanY = 0.005
        var newRegion = MKCoordinateRegion(center: theMap!.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        theMap!.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            var sourceIndex = myLocations.count - 1
            var destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count) //drawing the line connecting the beggining point to current point.
            theMap!.addOverlay(polyline)
        }
    }
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return nil
    }
}