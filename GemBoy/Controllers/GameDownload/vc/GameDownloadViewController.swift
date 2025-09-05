//
//  GameDownloadViewController.swift
//  Project
//
//  Created by EGONNEDGJ on 29/07/25.
//

import Foundation
import UIKit

class GameDownloadViewController: BaseViewController {
    
    static let identifier = "GameDownloadViewController"
   
    @IBOutlet weak var tableView: UITableView!

    var data: [EmulatorDownloadModel] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        activeCheck(className: "GameDownloadViewController", numberLine: 21)
        showLoader()
    
        GameDownloadService.getData(){ data in
            self.hideLoader()
            self.activeCheck(className: "GameDownloadViewController", numberLine: 26)
            self.data = data
            self.tableView.reloadData()
        }
        self.title = "downloadGamesUserProfileTitle".localizable
    }
    
   
    
    static func instance() -> GameDownloadViewController{
        let vc = UIStoryboard(name: "GameDownload", bundle: nil).instantiateViewController(withIdentifier: identifier) as! GameDownloadViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func push(prensenter: UIViewController?) {
        let vc = instance()
        prensenter?.navigationController?.pushViewController(vc, animated: true)
    }
}


extension GameDownloadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        return self.data[section].emulator?.localizableName ?? ""
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data[section].games.count
        
    }
      
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DownlaodCell.indetifier, for: indexPath) as! DownlaodCell
        let item = self.data[indexPath.section].games[indexPath.row]
        cell.configureView(item)
        cell.controller = self
        return cell
    }
    
}

