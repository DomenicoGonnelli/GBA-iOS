//
//  NotificationListViewController.swift
//  Project
//
//  Created by Domenico Gonnelli on 11/03/25.
//

import Foundation
import UIKit

class NotificationListViewController:  BaseViewController {
    
    static let identifier = "NotificationListViewController"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nothingToDoLabel: UILabel!
    

    var list : [PushNotification] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        list = PushNotification.getNotification()
        reloadPage()
        nothingToDoLabel.attributedText = nil
        nothingToDoLabel.setAttributedWithTag(text: "pushNotificationEnded".localizable, boldSize: 80)
    }
    
    func reloadPage(){
        nothingToDoLabel.isHidden = list.count > 0
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    static func instance() -> NotificationListViewController{
        let vc = UIStoryboard(name: "NotificationList", bundle: nil).instantiateViewController(withIdentifier: identifier) as! NotificationListViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func push(prensenter: UIViewController?) {
        let vc = instance()
        prensenter?.navigationController?.pushViewController(vc, animated: true)
    }
}


extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationListCell.identifier, for: indexPath) as! NotificationListCell
        let push = list[indexPath.row]
        cell.setView(push: push)
        return cell
    }
    
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Remove".localizable) { action, view, complete in
            complete(true)
            self.list.remove(at: indexPath.row)
            self.list.saveNotification()
            self.reloadPage()
            
        }
        
        delete.image = UIImage(named: "delete")?.imageWithColor(color: .white)
        delete.backgroundColor = .red
        
        
        return UISwipeActionsConfiguration(actions: [delete])
        
    }
    
}
