//
//  StatisticsService.swift
//  Project
//
//  Created by EGONNEDGJ on 20/01/24.
//

import Foundation


class StatisticsService {
    
    
    static func getData(_ completion: @escaping ([ChartModel])->Void){
        
        let url = AppManager.shared.links?.statistics ?? "https://www.dropbox.com/scl/fi/tcat30ghcc81b72sniqog/chartData.json?rlkey=5byeq2f7v9qmxviv4ag5a1r2y&dl=1"
        ServiceHelper.instance.driveService(url: url){ resp in
            
            var list : [ChartModel] = []
            
            if let data = resp?["statistics"] as? [Dictionary<String,Any>] {
                
                for item in data {
                    list.append(ChartModel(value: item))
                }
                completion(list)
            } else {
                completion([])
            }
        }
        
    }
}
