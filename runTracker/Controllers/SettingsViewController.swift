//
//  SettingsViewController.swift
//  runTracker
//
//  Created by Ihonahan Buitrago on 2/15/16.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import UIKit


@objc protocol SettingsViewControllerDelegate {
    @objc optional func settingsViewControllerDidToggleMusic(_ sender : SettingsViewController, toggle: Bool)
    @objc optional func settingsViewControllerDidToggleRegisterTrack(_ sender : SettingsViewController, toggle: Bool)
    @objc optional func settingsViewControllerDidToggleDrawTrack(_ sender : SettingsViewController, toggle: Bool)
    @objc optional func settingsViewControllerDidStart(_ sender : SettingsViewController)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var fullContainer : UIView!
    @IBOutlet weak var blurView : UIVisualEffectView!
    @IBOutlet weak var contentContainer : UIView!
    @IBOutlet weak var settingsLabel : UILabel!
    @IBOutlet weak var musicButton : UIButton!
    @IBOutlet weak var musicLabel : UILabel!
    @IBOutlet weak var registerTrackButton : UIButton!
    @IBOutlet weak var registerTrackLabel : UILabel!
    @IBOutlet weak var drawTrackButton : UIButton!
    @IBOutlet weak var drawTrackLabel : UILabel!
    
    @IBOutlet weak var startButton : UIButton!
    @IBOutlet weak var closeButton : UIButton!
    
    @IBOutlet weak var delegate : SettingsViewControllerDelegate!
    
    var musicEnabled = false
    var registerTrack = false
    var drawTrack = false
    var isEnabledMusic = true
    
    let musicOnImage = UIImage(named: "musica1")
    let musicOffImage = UIImage(named: "musica")
    let registerTrackOnImage = UIImage(named: "recorrido1")
    let registerTrackOffImage = UIImage(named: "recorrido")
    let drawTrackOnImage = UIImage(named: "pintar1")
    let drawTrackOffImage = UIImage(named: "pintar")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        musicButton.isEnabled = isEnabledMusic
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func tapUpStart(_ sender: UIButton) {
        if let myDelegate = self.delegate {
            myDelegate.settingsViewControllerDidStart?(self)
        }
        self.dismiss(animated: true) { () -> Void in
            
        }
    }

    @IBAction func tapUpClose(_ sender: UIButton) {
        self.dismiss(animated: true) { () -> Void in
            
        }
    }

    @IBAction func tapDownMusic(_ sender: UIButton) {
        self.musicEnabled = !self.musicEnabled
        
        if self.musicEnabled {
            self.musicButton.setImage(self.musicOnImage, for: UIControlState())
            self.musicLabel.text = "Música encendida"
        } else {
            self.musicButton.setImage(self.musicOffImage, for: UIControlState())
            self.musicLabel.text = "Música apagada"
        }
        
        if let myDelegate = self.delegate {
            myDelegate.settingsViewControllerDidToggleMusic?(self, toggle: self.musicEnabled)
        }
    }

    @IBAction func tapDownRegisterTrack(_ sender: UIButton) {
        self.registerTrack = !self.registerTrack
        
        if self.registerTrack {
            self.registerTrackButton.setImage(self.registerTrackOnImage, for: UIControlState())
            self.registerTrackLabel.text = "Registrando ruta"
        } else {
            self.registerTrackButton.setImage(self.registerTrackOffImage, for: UIControlState())
            self.registerTrackLabel.text = "No está registrando ruta"
        }
        
        if let myDelegate = self.delegate {
            myDelegate.settingsViewControllerDidToggleRegisterTrack?(self, toggle: self.registerTrack)
        }
    }

    @IBAction func tapDownDrawTrack(_ sender: UIButton) {
        self.drawTrack = !self.drawTrack
        
        if self.drawTrack {
            self.drawTrackButton.setImage(self.drawTrackOnImage, for: UIControlState())
            self.drawTrackLabel.text = "Dibujando ruta"
        } else {
            self.drawTrackButton.setImage(self.drawTrackOffImage, for: UIControlState())
            self.drawTrackLabel.text = "No está dibujando ruta"
        }
        
        if let myDelegate = self.delegate {
            myDelegate.settingsViewControllerDidToggleDrawTrack?(self, toggle: self.drawTrack)
        }
    }

    
}
