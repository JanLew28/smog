//
//  SmogManager.swift
//  smog
//
//  Created by Kuba  on 13/05/2020.
//  Copyright © 2020 Kuba . All rights reserved.
//

import Foundation

protocol SmogManagerDelegate {
    func didUpdateWeather(_ smogManager: SmogManager, smog: SmogModel)
    func didFailWithError(error: Error)
}

struct SmogManager {
    let smogURL = "http://192.168.1.27/api"
    
    var delegate: SmogManagerDelegate?
    
    func fetchPogoda() {
        let urlString = "\(smogURL)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeDate = data {
                    if let smog = self.parseJSON(safeDate) {
                        self.delegate?.didUpdateWeather(self, smog: smog)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ smogData: Data) -> SmogModel? {
        let decoder = JSONDecoder()
        do {
            let decodedDate = try decoder.decode(SmogData.self, from: smogData)
            
            let pm10 = decodedDate.pm10
            
            let pogoda = SmogModel(p10: pm10)
            return pogoda
        } catch {
            self.delegate?.didFailWithError(error: error)
            print(error)
            return nil
            
        }
    }
}
