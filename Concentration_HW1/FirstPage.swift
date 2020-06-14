//
//  FirstPage.swift
//  Concentration_HW1
//
//  Created by user167535 on 5/26/20.
//  Copyright © 2020 user167535. All rights reserved.
//

import UIKit
import CoreLocation


class FirstPage: UIViewController{
    var locationManager: CLLocationManager!
    var lati : Double?
    var lngi : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    
    
    @IBAction func openHardGame(_ sender: Any) {
        // var hardGamePage = HardGame()
        self.performSegue(withIdentifier: "fromMainToHard", sender: self)
    }
    
    
    @IBAction func openEasyGame(_ sender: Any) {
        self.performSegue(withIdentifier: "fromMainToEasy", sender: self)
    }
    
    //   MARK: - Navigation
    
    //  In a storyboard-based application, you will often //want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromMainToHard") {
            let hardGameBoard = segue.destination as! HardGame
            hardGameBoard.lat = lati ?? 0
            hardGameBoard.lng = lngi ?? 0
        }
        
        if(segue.identifier == "fromMainToEasy") {
            let easyGameBoard = segue.destination as! ViewController
            easyGameBoard.lat = lati ?? 0
            easyGameBoard.lng = lngi ?? 0 
        }
    }
    
    
}

extension FirstPage: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            lati = location.coordinate.latitude
            lngi = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error=\(error)")
    }
}

