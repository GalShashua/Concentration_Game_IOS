//
//  ViewController.swift
//  Concentration_HW1
//
//  Created by user167535 on 5/1/20.
//  Copyright © 2020 user167535. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var cardButtons: [UIButton]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("connect to  github succcess")

    }


    @IBAction func cardClicked(_ sender: UIButton) {
         print("clicked")
        let cardNumber = cardButtons.index(of: sender)
        print("\(cardNumber)")
    }
}

