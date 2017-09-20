//
//  ViewController.swift
//  runTracker
//
//  Created by Ihonahan Buitrago on 2/12/16.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, SettingsViewControllerDelegate {

    @IBOutlet weak var fullContainer : UIView!
    @IBOutlet weak var mapview : MKMapView!
    @IBOutlet weak var startButton : UIButton!
    @IBOutlet weak var finishButton : UIButton!

    let locationManager : CLLocationManager = CLLocationManager()
    
    var runnerPin : MKAnnotationView!
    var currentPoint : CLLocation!
    var currentAnnotation : MKPointAnnotation!
    
    let musicPlayer = MusicPlayer()
    
    var musicEnabled = false
    var registerTrack = false
    var drawTrack = false
    var isRunning = false

    var trackPoints = [CLLocation]()
    
    var initialTime = Date()
    var finalTime = Date()
    var travelledDistance : CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        self.mapview.delegate = self
        self.mapview.camera.altitude = 450
        
        self.finishButton.isHidden = true
        self.startButton.isHidden = false
        
        self.musicPlayer.setupPlayer { (success) in
            self.musicEnabled = success
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func tapUpStop(_ sender: UIButton) {
        self.musicPlayer.stop()
        self.clean()
    }
    
    
    func calculateDistance() -> CLLocationDistance {
        var distance = 0.0
        if trackPoints.count > 0 {
            for i in 1...(self.trackPoints.count - 1)  {
                let previousPoint = self.trackPoints[i-1]
                let currentPoint = self.trackPoints[i]
                
                distance += currentPoint.distance(from: previousPoint)
            }
        }

        return distance
    }
    
    func calculateTime() -> TimeInterval {
        let result = self.finalTime.timeIntervalSince(self.initialTime)
        
        return result
    }

    //MARK:- Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSettings" {
            let destination = segue.destination as! SettingsViewController
            destination.delegate = self
            destination.musicEnabled = self.musicEnabled
            destination.registerTrack = self.registerTrack
            destination.registerTrack = self.registerTrack
            destination.isEnabledMusic = self.musicEnabled
        } else if segue.identifier == "ShowDebrief" {
            self.isRunning = false
            self.finishButton.isHidden = true
            self.startButton.isHidden = false
            self.finalTime = Date()
            
            let destination = segue.destination as! DebriefingViewController
            let meters = self.calculateDistance()
            let time = self.calculateTime()
            destination.meters = meters
            destination.time = time
            
            if trackPoints.count > 0 {
                destination.startCoordinate = self.trackPoints[0].coordinate
                destination.endCoordinate = self.trackPoints[self.trackPoints.count - 1].coordinate

            }
        }
    }
    
    
    func clean() {
        self.mapview.removeOverlays(self.mapview.overlays)
        self.trackPoints.removeAll()
    }
    
    //MARK:- MKMapViewDelegate methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if self.runnerPin == nil {
            self.runnerPin = MKAnnotationView(annotation: annotation, reuseIdentifier: "UserLocation")
            self.runnerPin?.image = UIImage(named: "flecha")
        }
        self.runnerPin.annotation = annotation
        
        return self.runnerPin
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 2
            renderer.strokeColor = UIColor(red: (19.0/255.0), green: (192.0/255.0), blue: (215.0/255.0), alpha: 1)
            return renderer
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }

    
    
    //MARK:- CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Nueva autorización: \(status.rawValue)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentPoint = location
            if self.currentAnnotation == nil {
                self.currentAnnotation = MKPointAnnotation()
                self.currentAnnotation.coordinate = location.coordinate
                self.mapview.addAnnotation(self.currentAnnotation)
            }
            self.mapview.camera.centerCoordinate = location.coordinate
            self.currentAnnotation.coordinate = location.coordinate
            
            if self.registerTrack {
                self.trackPoints.append(location)
                
                let count = self.trackPoints.count
                
                if self.drawTrack && count >= 2 {
                    var coordinates = [CLLocationCoordinate2D]()
                    coordinates.append(self.trackPoints[count - 2].coordinate)
                    coordinates.append(self.trackPoints[count - 1].coordinate)
                    let path = MKPolyline(coordinates: &coordinates, count: coordinates.count)
                    self.mapview.add(path)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.mapview.camera.heading = newHeading.trueHeading
    }
    
    
    
    //MARK:- SettingsViewControllerDelegate methods
    func settingsViewControllerDidToggleMusic(_ sender: SettingsViewController, toggle: Bool) {
        self.musicEnabled = toggle
    }
    
    func settingsViewControllerDidToggleRegisterTrack(_ sender: SettingsViewController, toggle: Bool) {
        self.registerTrack = toggle
    }
    
    func settingsViewControllerDidToggleDrawTrack(_ sender: SettingsViewController, toggle: Bool) {
        self.drawTrack = toggle
    }
    
    func settingsViewControllerDidStart(_ sender: SettingsViewController) {
        if self.musicEnabled {
            self.musicPlayer.play()
        }
        self.isRunning = true
        self.finishButton.isHidden = false
        self.startButton.isHidden = true
        self.trackPoints = [CLLocation]()
        self.initialTime = Date()
    }
}

