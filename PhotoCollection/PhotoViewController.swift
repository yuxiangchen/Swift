//
//  PhotoViewController.swift
//  PhotoCollection
//
//  Created by Dale Musser on 10/19/15.
//  Copyright © 2015 Swift Developer Academy. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photo"
        
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let p = photo {
            titleLabel.text = p.title
            descriptionLabel.text = p.description
            dateLabel.text = dateFormatter.stringFromDate(p.date)
            latitudeLabel.text = "\(p.latitude)"
            longitudeLabel.text = "\(p.longitude)"
            photoImageView.image = UIImage(named: p.fileName)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller:MapPhotoViewController = segue.destinationViewController as! MapPhotoViewController
        controller.photo = photo
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
