//
//  NotificationListCell.swift
//  Project
//
//  Created by Domenico Gonnelli on 11/03/25.
//

import Foundation
import UIKit

class NotificationListCell: UITableViewCell{
    
    static var identifier = "NotificationListCell"
    
  
    @IBOutlet weak var notifictionTitle: UILabel!
    @IBOutlet weak var notifictionBody: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    func setView(push: PushNotification){
        notifictionTitle.localizedKey = push.title
        notifictionBody.localizedKey = push.body
        date.localizedKey = push.date?.yyyyMMddHHmmss() ?? ""
        
    }
}
