
import UIKit
import CoreData
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var imgFieldName: UITextField!
    @IBOutlet weak var imgHolder: UIImageView!
    @IBOutlet weak var mapper: MKMapView!
    @IBOutlet weak var descr: UITextView!
    
//    @IBOutlet weak var email: UITextField!
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var lat:Double!
    var long:Double!
    
    var locObj:Locate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if locObj != nil {
            name.text = locObj?.name
            descr.text = locObj?.descr
            imgFieldName.text = locObj!.imgurl
            imgHolder.image = UIImage(named: imgFieldName.text)
            let cityName = locObj?.name
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(cityName, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                    self.lat = Double(placemark.location.coordinate.latitude)
                    self.long = Double(placemark.location.coordinate.longitude)
                    
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let latDegree: CLLocationDegrees = (self.lat)
                    let longDegree: CLLocationDegrees = (self.long)
                    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latDegree, longDegree)
                    let region = MKCoordinateRegion(center: location, span: span)
                    region.center
                    self.mapper.setRegion(region, animated: true)
                    var tation = MKPointAnnotation()
                    tation.coordinate = location
                    tation.title = self.locObj?.name
                    
                    self.mapper.addAnnotation(tation)
                }
                dispatch_async(
                    dispatch_get_main_queue(), {
                        
                })
            })
            
            
        }
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveData(sender: UIBarButtonItem) {
        if locObj == nil
        {
            let context = self.context
            let ent = NSEntityDescription.entityForName("Locate", inManagedObjectContext: context!)
            
            let locObj = Locate(entity: ent!, insertIntoManagedObjectContext: context)
            locObj.name = name.text
            locObj.descr = descr.text
            locObj.imgurl = imgFieldName.text
        
            context?.save(nil)
        }else
        {
            locObj!.name = name.text
            locObj!.descr = descr.text
            locObj!.imgurl = imgFieldName.text
            context?.save(nil)
        }
        
        navigationController!.popViewControllerAnimated(true)
        
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
