//
//  MapPhotoViewController.swift
//  PhotoCollection
//
//  Created by Dale Musser on 10/19/15.
//  Copyright © 2015 Swift Developer Academy. All rights reserved.
//

import UIKit
import MapKit

class MapPhotoViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    let latDelta = 0.04
    let lonDelta = 0.04
    
    var photo:Photo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Map"

        if let p = photo {
            photoImageView.image = UIImage(named: "\(p.fileName)")
            
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(p.latitude, p.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            mapView.region = region
            
            let annotation:MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = p.title
            annotation.subtitle = p.description
            
            mapView.addAnnotation(annotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
