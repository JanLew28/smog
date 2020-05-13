//
//  ViewController.swift
//  smog
//
//  Created by Kuba  on 13/05/2020.
//  Copyright © 2020 Kuba . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pm10Label: UILabel!
    
    var smogManager = SmogManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smogManager.delegate = self
    }
}

extension ViewController: SmogManagerDelegate{
    func didUpdateWeather(_ smogManager: SmogManager, smog: SmogModel) {
        DispatchQueue.main.async {
            self.pm10Label.text = smog.p10String
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
