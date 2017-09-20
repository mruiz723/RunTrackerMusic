//
//  DebriefingViewController.swift
//  runTracker
//
//  Created by Ihonahan Buitrago on 2/16/16.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import UIKit
import MapKit
import MobileCoreServices

class DebriefingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var fullContainer : UIView!
    @IBOutlet weak var blurView : UIVisualEffectView!
    @IBOutlet weak var contentContainer : UIView!
    @IBOutlet weak var congratulationsLabel : UILabel!
    @IBOutlet weak var metersLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var photoButton : UIButton!
    @IBOutlet weak var closeButton : UIButton!
    
    var startCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var endCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var meters : CLLocationDistance = 0
    var time : TimeInterval = 0
    var metersText : String = ""
    var timeText : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupView(self.meters, time: self.time)
    }
    
    
    func setupView(_ meters: CLLocationDistance, time: TimeInterval) {
        if meters > 0 {
            let metersInt = Int(meters)
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
//            let metersFormatted = formatter.string(from: NSNumber(metersInt))
            let metersFormatted = formatter.string(from: NSNumber(integerLiteral: metersInt))
            self.metersText = "Recorriste \(metersFormatted!) metros"
        } else {
            self.metersText = "Recorriste varios metros"
        }
        self.metersLabel.text = self.metersText

        let minutes = (time / 60).truncatingRemainder(dividingBy: 60)
        let minutesInt = Int(minutes)
        if minutes > 0 {
            self.timeText = "En \(minutesInt) minutos"
        } else {
            self.timeText = "En varios minutos"
        }
        self.timeLabel.text = self.timeText
    }
    

    @IBAction func tapUpClose(_ sender: UIButton) {
        self.dismiss(animated: true) { () -> Void in
        }
    }

    @IBAction func tapUpPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            imagePicker.setEditing(true, animated: true)
            
            self.present(imagePicker, animated: true, completion: nil)
        }

    }

    
    //MARK:- UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType == kUTTypeImage as String {
            let image = info[UIImagePickerControllerEditedImage] as! UIImage
            print("taken photo size: \(image.size)")
            
            let resultPhoto = PhotoSaveView.exportPhotoSaveViewToUIImage(image, metersMessage: self.metersText, timeMessage: self.timeText, startCoordinates: self.startCoordinate, endCoordinates: self.endCoordinate)
            
            UIImageWriteToSavedPhotosAlbum(resultPhoto, self, #selector(DebriefingViewController.successLastPhoto(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func successLastPhoto(_ image: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    

    

}
