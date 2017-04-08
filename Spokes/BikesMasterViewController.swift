import UIKit
import MapKit
import FirebaseDatabase
import SideMenu

class BikesMasterViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var database: FIRDatabaseReference!
    var bikes: [Bike]!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.menuPresentMode = .menuSlideIn
        /*
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(BikesMasterViewController.panGestureRecognized(withRecognizer:)))
        self.tableView.addGestureRecognizer(panRecognizer)
        */
        let kansas = MKCoordinateRegionMake(CLLocationCoordinate2DMake(39.0558, 95.6890), MKCoordinateSpanMake(13, 30))
        self.mapView.setRegion(kansas, animated: false)
        
        var status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            self.locationManager = CLLocationManager()
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        status = CLLocationManager.authorizationStatus()
        if (status == .denied || status == .restricted) {
            let alert = UIAlertController(title: "Error", message: "Enable location services to find bikes near you.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
        
        self.mapView.showsUserLocation = true
        
        database = FIRDatabase.database().reference()
        let key = self.database.child("bikes").childByAutoId().key
        let post = ["user": "andrew", "size": "small", "location": "Noah", "cost": 5.0, "available": true, "date": NSDate().timeIntervalSince1970] as [String : Any]
        
        database.child("bikes/\(key)").setValue(post)
        self.bikes = [Bike]()
        database.child("bikes").observeSingleEvent(of: .value, with: {(snapshot) in
            if let data = snapshot.value as? NSDictionary {
                for value in data.allValues {
                    
                    if let dictionary = value as? NSDictionary {
                        print(NSDate(timeIntervalSince1970: dictionary  .object(forKey: "date") as! TimeInterval))
                        if let size: String = dictionary.object(forKey: "size") as! String? {
                            if let location: String = dictionary.object(forKey: "location") as! String? {
                                if let available: Bool = dictionary.object(forKey: "available") as! Bool? {
                                    if let cost: Double = dictionary.object(forKey: "cost") as! Double? {
                                        if let user: String = dictionary.object(forKey: "user") as! String? {
                                            self.bikes.append(Bike(size: size, location: location, available: available, cost: cost, user: user))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 200, 200)
        self.mapView.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.bikes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! BikesTableViewCell
        
        // Configure the cell...
        let bike = bikes[indexPath.row]
        cell.titleLabel.text = bike.user
        cell.secondaryLabel.text = bike.locationString
        var costString = "\(bike.cost)"
        if (bike.cost.truncatingRemainder(dividingBy: 1.0) == 0) {
            costString = String(format: "%.0f", bike.cost)
        }
        cell.costLabel.text = "$" + costString
        
        return cell
    }
    
    var beginPoint:CGPoint!
    
    func panGestureRecognized(withRecognizer recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: self.view)
        if recognizer.state == .began {
            guard self.tableView.frame.contains(point) else {
                return
            }
            self.beginPoint = point
        } else if recognizer.state == .changed {
            /* if (self.tableView.tableHeaderView?.frame.contains(point))! {
             if beginPoint != nil {
             self.tableView.frame.origin.y = recognizer.location(in: self.view).
             }
             
             }
             */
        } else if recognizer.state == .ended {
            self.beginPoint = nil
        }
    }
    
}
