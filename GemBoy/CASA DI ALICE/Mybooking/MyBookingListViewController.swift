//
//  UserClassificationViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 17/01/23.
//

import Foundation
import UIKit

class MyBookingListViewController: BaseViewController {
    
    static let identifier = "MyBookingListViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var list : [AliceBooking] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        showLoader()
        FirestoreHelper.getBookingData(oneTime: true){ items in
            self.list = items?.booking.filter({$0.day != nil}) ?? []
            self.hideLoader()
            self.tableView.reloadData()
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let list = LoginManager.shared.booking?.booking {
            self.list = list
            self.tableView.reloadData()
        }
    }
    
    
    
    static func instance() -> MyBookingListViewController{
        let vc = UIStoryboard(name: "MyBookingList", bundle: nil).instantiateViewController(withIdentifier: identifier) as! MyBookingListViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func push(prensenter: UIViewController?) {
        let vc = instance()
        
        prensenter?.navigationController?.pushViewController(vc, animated: true)
    }

}


extension MyBookingListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if list.count == 0 {
            return 1
        }
        
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if list.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: GrandPrixNotStartedCell.identifier, for: indexPath) as! GrandPrixNotStartedCell
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyBookingCell.identifier, for: indexPath) as! MyBookingCell
        let team = list[indexPath.row]
        cell.setData(item: team)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        
        
        let delete = UIContextualAction(style: .destructive, title: "Remove".localizable) { action, view, complete in
            
            self.list.remove(at: indexPath.row)
            LoginManager.shared.booking?.booking = self.list
            FirestoreHelper.updateBooking(item: LoginManager.shared.booking)
            self.tableView.reloadData()
            
            
        }
        
        delete.image = UIImage(named: "delete")?.imageWithColor(color: .white)
        delete.backgroundColor = .red
        
        
        return UISwipeActionsConfiguration(actions: [delete])
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        show{
//            DetailUsersTeamViewController.push(prensenter: self, team: self.list[indexPath.row])
//        }
//    }
}
