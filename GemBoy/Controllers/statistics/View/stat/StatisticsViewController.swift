//
//  StatisticsViewController.swift
//  Project
//
//  Created by EGONNEDGJ on 20/01/24.
//

import Foundation
import UIKit
import GoogleMobileAds

class StatisticsViewController: BaseViewController {
    
    static let identifier = "StatisticsViewController"
   
    @IBOutlet weak var tableView: UITableView!

    var data: [ChartModel] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        activeCheck(className: "StatisticsViewController", numberLine: 22)
        showLoader()
        StatisticsService.getData(){ data in
            self.activeCheck(className: "StatisticsViewController", numberLine: 25)
            self.hideLoader()
            
            self.data = data
            self.tableView.reloadData()
            
        }
    }
    
   
    
    static func instance() -> StatisticsViewController{
        let vc = UIStoryboard(name: "Statistics", bundle: nil).instantiateViewController(withIdentifier: identifier) as! StatisticsViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func push(prensenter: UIViewController?, image: UIImage?) {
        let vc = instance()
        prensenter?.navigationController?.pushViewController(vc, animated: true)
    }
}


extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChartCell.indetifier, for: indexPath) as! ChartCell
        cell.configureView(data[indexPath.row])
        return cell
    }
    
}

