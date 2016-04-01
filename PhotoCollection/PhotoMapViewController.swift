//
//  PhotoMapViewController.swift
//  PhotoCollection
//
//  Created by Dale Musser on 10/19/15.
//  Copyright © 2015 Swift Developer Academy. All rights reserved.
//
// http://www.devfright.com/mkpointannotation-tutorial/
// https://www.hackingwithswift.com/read/19/3/annotations-and-accessory-views-mkpinannotationview
// http://stackoverflow.com/questions/9700413/how-can-i-catch-tap-on-mapview-and-then-pass-it-to-default-gesture-recognizers

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let photoCollection = PhotoCollection.sharedInstance
    var selectedPhoto: Photo?
    
    var latDelta:Double = 90.0
    var lonDelta:Double = 180.0
    var latitude:Double = 45.0
    var longitude:Double = -90.0
    var scaleFactor:Double = 1.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photo Map"
        
        determineLocationParameters()

        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta * scaleFactor, longitudeDelta: lonDelta * scaleFactor)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapView.region = region
        
        addPhotoMKAnnotationPoints()
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "resetMapPosition")
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        mapView.addGestureRecognizer(doubleTapGesture)
    }
    
    /*
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
*/
    

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func resetMapPosition() {
        print("Reset")
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta * scaleFactor, longitudeDelta: lonDelta * scaleFactor)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapView.region = region
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The following is very naive regarding the math.  It works because the images are clustered
    // and don't cross any boundaries that would make the math not work out.
    func determineLocationParameters() {
        var minLatitude: Double = 0.0
        var maxLatitude: Double = 90.0
        var minLongitude: Double = -180.0
        var maxLongitude: Double = 0.0
        
        if photoCollection.photos.count > 0 {
            let firstPhoto = photoCollection.photos[0]
            minLatitude = firstPhoto.latitude
            maxLatitude = firstPhoto.latitude
            minLongitude = firstPhoto.longitude
            maxLongitude = firstPhoto.longitude
            
            for photo in photoCollection.photos {
                if photo.latitude < minLatitude {
                    minLatitude = photo.latitude
                } else if photo.latitude > maxLatitude {
                    maxLatitude = photo.latitude
                }
                if photo.longitude < minLongitude {
                    minLongitude = photo.longitude
                } else if photo.longitude > maxLongitude {
                    maxLongitude = photo.longitude
                }
            }
        }
        
        latDelta = maxLatitude - minLatitude
        lonDelta = maxLongitude - minLongitude
        latitude = minLatitude + latDelta / 2
        longitude = minLongitude + lonDelta / 2
    }
    
    func addPhotoMKAnnotationPoints() {
        for photo in photoCollection.photos {
            let annotation:PhotoMKPointAnnotation = PhotoMKPointAnnotation()
            annotation.photo = photo
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(photo.latitude, photo.longitude)
            annotation.coordinate = location
            annotation.title = photo.title
            annotation.subtitle = photo.description

            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = PhotoMKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
        let photoPointAnnotation = annotation as! PhotoMKPointAnnotation
        pinView.photo = photoPointAnnotation.photo
        pinView.canShowCallout = true
        //pinView.calloutOffset = CGPointMake(0, 32);
        let button = UIButton(type: .DetailDisclosure)
        pinView.rightCalloutAccessoryView = button
        if let photo = photoPointAnnotation.photo {
            let imageView = UIImageView(image: UIImage(named: photo.fileName))
            imageView.contentMode = .ScaleAspectFill
            imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            pinView.leftCalloutAccessoryView = imageView
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let photoPinView = view as! PhotoMKPinAnnotationView
        if let photo = photoPinView.photo {
            selectedPhoto = photo
            self.performSegueWithIdentifier("PhotoDetail", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController:PhotoViewController = segue.destinationViewController as? PhotoViewController {
            viewController.photo = selectedPhoto
        }
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
