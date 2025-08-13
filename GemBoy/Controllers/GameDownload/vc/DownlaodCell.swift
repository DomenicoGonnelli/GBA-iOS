//
//  ChartCell.swift
//  Project
//
//  Created by EGONNEDGJ on 20/01/24.
//

import Foundation
import Kingfisher
import UIKit

import SafariServices

class DownlaodCell: UITableViewCell{
    
    static var indetifier = "DownlaodCell"
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var imageGame: UIImageView!
    
    var item : GameDownloadModel?
    var controller: UIViewController?
    
    func configureView(_ item: GameDownloadModel?){
        self.item = item
        
        titleLabel.text = item?.title
        
        if let url = item?.imageName {
            imageGame.image = UIImage(named: url)
        }else if let url = item?.imageLink {
            imageGame.kf.setImage(with: URL(string: url))
        }
    }
    
    @IBAction func openLink(_ sender: Any){
        openInSafariViewController(urlString:  item?.downloadLink)
    }
    
    func openInSafariViewController(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        
        UIApplication.shared.open(url)
//        let safariVC = SFSafariViewController(url: url)
//        controller?.present(safariVC, animated: true, completion: nil)
    }
    
    
    
}

