//
//  AliceHomeViewController.swift
//  Project
//
//  Created by Domenico Gonnelli on 12/07/25.
//

//
//  UpdateViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 11/01/23.
//

import Foundation
import UIKit

class AliceHomeViewController: BaseViewController {
    
    @IBOutlet weak var wellnessHelfDay: UIView!
    @IBOutlet weak var wellnessHelfDayButton: UIButton!
    @IBOutlet weak var wellnessAllDay: UIView!
    @IBOutlet weak var wellnessAllDayButton: UIButton!
    @IBOutlet weak var yoga: UIView!
    @IBOutlet weak var yogaButton: UIButton!
    @IBOutlet weak var massages: UIView!
    @IBOutlet weak var massagesButton: UIButton!
    @IBOutlet weak var noAddOn: UIView!
    @IBOutlet weak var noAddOnButton: UIButton!
    
    @IBOutlet weak var titleText: UILabel!
    
    var isSecondStep = false
    var selectedItem : AliceOptions = .null
    var addOn : AliceOptions = .null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noAddOn.isHidden = true
        titleText.localizedKey = "selectOptionTitle"
        navigationBar?.isHidden = true
        if isSecondStep {
            titleText.localizedKey = "addOptionTitle"
            wellnessHelfDay.isHidden = true
            wellnessAllDay.isHidden = true
            noAddOn.isHidden = false
            navigationBar?.isHidden = false
        }
        
    }
    
    func getOption(sender: UIButton) -> AliceOptions{
        switch sender {
        case wellnessHelfDayButton:
            return .halfDay
        case wellnessAllDayButton:
            return .allDay
        case yogaButton:
            return .yoga
        case massagesButton:
            return .massages
        default:
            return .null
        }
        
        
    }
    
    @IBAction func goToNextPage(sender: UIButton){
        if isSecondStep {
            addOn = getOption(sender: sender)
            AliceSelectDaysVC.push(prensenter: self, selectedOption: selectedItem, addOn: addOn)
        } else {
            selectedItem = getOption(sender: sender)
            if selectedItem == .allDay || selectedItem == .halfDay {
                let vc = AliceHomeViewController.instance
                vc.isSecondStep = true
                vc.selectedItem = self.selectedItem
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                AliceSelectDaysVC.push(prensenter: self, selectedOption: selectedItem, addOn: addOn)
            }
        }
    }
    
    static var instance: AliceHomeViewController{
        var viewController = UIStoryboard(name: "AliceHome", bundle: nil).instantiateViewController(withIdentifier: "AliceHomeViewController") as! AliceHomeViewController
        viewController.modalPresentationStyle = .overFullScreen
        return viewController
    }
    
    static func present(from presenter : UIViewController?){
        presenter?.present(AliceHomeViewController.instance, animated: true, completion: nil)
    }
    
    static func push(from presenter : UIViewController?){
        presenter?.navigationController?.pushViewController(AliceHomeViewController.instance, animated: true)
    }
}
