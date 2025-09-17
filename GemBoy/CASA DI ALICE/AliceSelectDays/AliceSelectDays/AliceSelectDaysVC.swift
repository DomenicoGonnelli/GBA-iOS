//
//  AliceSelectDaysVC.swift
//  Project
//
//  Created by Domenico Gonnelli on 12/07/25.
//

import Foundation
import UIKit
import GoogleMobileAds

class AliceSelectDaysVC: TabBarItemViewController {
    
    static let identifier = "AliceSelectDaysVC"
    
    @IBOutlet weak var tableViw: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var list : [Date] = []
    var selectedOption: AliceOptions = .null
    var optionAddOn: AliceOptions = .null
    
    var selectedRangeOption: Int?{
        didSet{
            confirmButton.enable(selectedRangeOption != nil || selectedRangeAddOn != nil)
        }
    }
    var selectedRangeAddOn: Int?{
        didSet{
            confirmButton.enable(selectedRangeOption != nil || selectedRangeAddOn != nil)
        }
    }
    
    
    var selectedEvent : Date?{
        if currentItem < list.count  {
            return list[currentItem]
        }
        return nil
    }
    
    let refreshControl = UIRefreshControl()
    let collectionMargin = CGFloat(40)
    let itemSpacing = CGFloat(20)
    var itemHeight = CGFloat(0)
    var itemWidth = CGFloat(0)
    var currentItem = -1 {
        didSet{
            setView()
        }
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        setCollectionView()
        callServices()
    }
    
    func callServices(){
        showLoader()
        //        AliceSelectDaysServices.getAllEventsResults(){ [weak self] events in
       // guard let self = self else {return}
        self.hideLoader()
        list = Date().generateDateList(days: 15)
        self.collectionView.reloadData()
        
        if self.currentItem == -1 {
            self.currentItem = 0
        }
        self.tableViw.reloadData()
        //        }
    }
    
    @IBAction func confirmBookingAction(_ sender: Any){
        
        if selectedRangeOption == nil && selectedRangeAddOn == nil {
            showAlerOk(title: "Ops, qualcosa non sta funzionando", message: "Assicurati di aver selezionato almeno una fascia oraria")
        }
        
        showLoader()
        
        FirestoreHelper.getBookingData(oneTime: true) { list in
            
            var newList = list ?? AliceBookingList()
                
            if let range = self.selectedRangeOption, let selectedEvent = self.selectedEvent{
                //aggiungere logica di conferma
                let newBooking =  AliceBooking()
                newBooking.day = selectedEvent
                newBooking.optionType = self.selectedOption
                newBooking.range = self.selectedOption.hourRange(day: selectedEvent.getDayOfWeek())[range]
                newList.booking.append(newBooking)
            }
            
            if self.optionAddOn != .null, let range = self.selectedRangeAddOn, let selectedEvent = self.selectedEvent{
                //aggiungere logica di conferma
                let newBooking =  AliceBooking()
                newBooking.day = selectedEvent
                newBooking.optionType = self.optionAddOn
                newBooking.range = self.optionAddOn.hourRange(day: selectedEvent.getDayOfWeek())[range]
                newList.booking.append(newBooking)
            }
            
            FirestoreHelper.updateBooking(item: newList)
            LoginManager.shared.booking = newList
            self.hideLoader()
            
            self.showAlerOk(title: "Prenotazione Avvenuta con successo", message: "Complimenti! Hai appena prenotato le tue attività presso Agriwellness Alice. Accedi alla sezione prenotazione per gestirle", onOk: {
                self.navigationController?.popToRootViewController(animated: true)
            })
            
            
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        if currentItem == -1 {
            currentItem = 0
        }
    }
    
    func setView(){
        tableViw.isHidden = false
        tableViw.reloadData()
        selectedRangeOption = nil
        selectedRangeAddOn = nil
        collectionView.reloadData()
        
    }
    
    static func instance() -> AliceSelectDaysVC{
        let vc = UIStoryboard(name: "AliceSelectDays", bundle: nil).instantiateViewController(withIdentifier: identifier) as! AliceSelectDaysVC
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func push(prensenter: UIViewController?, selectedOption: AliceOptions, addOn: AliceOptions) {
        let vc = instance()
        vc.selectedOption = selectedOption
        vc.optionAddOn = addOn
        prensenter?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AliceSelectDaysVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if let day = selectedEvent?.getDayOfWeek() {
                return selectedOption.hourRange(day: day).count
            }
        } else {
            if let day = selectedEvent?.getDayOfWeek() {
                return optionAddOn.hourRange(day: day).count
            }
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let day = selectedEvent, optionAddOn.isAvailable(day) {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return selectedOption.shortName.localizable
        } else {
            return optionAddOn.shortName.localizable
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: AliceHoursCell.identifier, for: indexPath) as! AliceHoursCell
        
        if indexPath.section == 0 {
            if let day = selectedEvent?.getDayOfWeek() {
                let list = selectedOption.hourRange(day: day)
                let val = list[indexPath.row]
                cell.setTitle(text: val)
                let isMine = selectedRangeOption == indexPath.row
                cell.setData(isMine: isMine, isAvailable: selectedOption.isAvailable(selectedEvent!))
            }
        } else {
            if let day = selectedEvent?.getDayOfWeek() {
                let list = optionAddOn.hourRange(day: day)
                let val = list[indexPath.row]
                cell.setTitle(text: val)
                let isMine = selectedRangeAddOn == indexPath.row
                cell.setData(isMine: isMine, isAvailable: optionAddOn.isAvailable(selectedEvent!))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if !selectedOption.isAvailable(selectedEvent!) {
                showAlerOk(title: "Orario non selezionabile", message: "Non è possibile scegliere questo range orario per l'attività desiderata")
                return
            }
            
            if selectedRangeOption == indexPath.row {
                selectedRangeOption = nil
            } else {
                selectedRangeOption = indexPath.row
            }
            
        } else {
            if selectedRangeAddOn == indexPath.row {
                selectedRangeAddOn = nil
            } else {
                selectedRangeAddOn = indexPath.row
            }
        }
        
        tableView.reloadData()
        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension AliceSelectDaysVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register offer cell
        let itemHeight = self.view.frame.height*0.3*0.8
        //itemHeight = max(itemHeight, 120)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        collectionView?.collectionViewLayout = layout
        collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableViw.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        callServices()
        refreshControl.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AliceScrollableCell.identifier, for: indexPath) as! AliceScrollableCell
        if let day = selectedEvent {
            cell.setData(event: selectedOption, addon: optionAddOn, day: day)
        }
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard scrollView == collectionView else {return}
       
        let layoutAttributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: collectionView.bounds)
        
        if layoutAttributes?.count == 0 {
            return
        }
        
        var selectedCell: UICollectionViewLayoutAttributes?
        
        if velocity.x == 0 {
            if (scrollView.contentOffset.x + collectionView.bounds.width/2) > (layoutAttributes?.last?.frame.x)! {
                selectedCell = layoutAttributes?.last
            } else if ((scrollView.contentOffset.x + collectionView.frame.width / 2) < ((layoutAttributes?[0].frame.x)! + collectionView.frame.width))
            {
                selectedCell = layoutAttributes?.first
            }
            else
            {
                targetContentOffset.pointee = CGPoint(x: (CGFloat(currentItem) * collectionView.frame.width) - collectionView.frame.width / 2, y: 0.0)
                return
            }
        } else if velocity.x > 0.0 {
            
            selectedCell = layoutAttributes?.last
            if let nextIndex = selectedCell?.indexPath.row, nextIndex > currentItem {
                currentItem = nextIndex
            }
        } else {
            selectedCell = layoutAttributes?.first
            if let nextIndex = selectedCell?.indexPath.row, nextIndex < currentItem {
                currentItem = nextIndex
            }
        }
    
        if let selectedCell = selectedCell {
            let a = collectionView.bounds.width / 2.0
            let offset = CGPoint(x: selectedCell.center.x - a, y: 0.0)
            targetContentOffset.pointee = offset
            currentItem = selectedCell.indexPath.row
        }
    }
}
