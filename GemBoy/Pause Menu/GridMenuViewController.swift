//
//  GridMenuViewController.swift
//  Delta
//
//  Created by Darlion on 12/21/15.
//  Copyright © 2015 Riley Testut. All rights reserved.
//

import UIKit
import Roxas

class GridMenuViewController: UICollectionViewController
{ 
    
    var cellWidht: CGFloat = 80
    var cellHeight: CGFloat {
        cellWidht*1.1
    }
    
    var items: [MenuItem] {
        get { return self.dataSource.items }
        set {
            self.dataSource.items = newValue; self.updateItems() }
    }
    
    var isVibrancyEnabled = true
    
    var itemWidth: Double {
        get {
            let layout = self.collectionViewLayout as! GridCollectionViewLayout
            return layout.itemWidth
        }
        set {
            let layout = self.collectionViewLayout as! GridCollectionViewLayout
            layout.itemWidth = newValue
            
            self.prototypeCellWidthConstraint?.constant = newValue
            
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
    @IBOutlet private(set) var closeButton: UIBarButtonItem?
    
    override var preferredContentSize: CGSize {
        set { }
        get {
            let itemsRows =  Int(floor(self.view.frame.width / (cellWidht*1.2) ))
            let n_row = Int(ceil(CGFloat(dataSource.items.count) / CGFloat(itemsRows)))
            return CGSize(width: self.view.frame.width, height: CGFloat(n_row * 120 + 50))
        }
    }
    
    private let dataSource = RSTArrayCollectionViewDataSource<MenuItem>(items: [])
    
    private var prototypeCellWidthConstraint: NSLayoutConstraint?
    
    private var previousIndexPath: IndexPath? = nil
    
    private var registeredKVOObservers = Set<NSKeyValueObservation>()
    
    init()
    {
        let collectionViewLayout = GridCollectionViewLayout()
        let cellWidht: CGFloat = self.cellWidht
        let cellHeight = cellWidht * 1.1
        collectionViewLayout.itemSize = CGSize(width: cellWidht, height: cellHeight)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        // Crashes on iOS 10 if not explicitly invalidated.
        self.registeredKVOObservers.forEach { $0.invalidate() }
    }
}

extension GridMenuViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let collectionViewLayout = self.collectionViewLayout as! GridCollectionViewLayout
        collectionViewLayout.itemWidth = cellWidht
        collectionViewLayout.usesEqualHorizontalSpacingDistributionForSingleRow = true
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if let indexPath = self.previousIndexPath
        {
            UIView.animate(withDuration: 0.2) {
                let item = self.items[indexPath.item]
                item.isSelected = !item.isSelected
            }
        }
    }
}

private extension GridMenuViewController
{
    func configure(_ cell: MenuCell, for indexPath: IndexPath)
    {
        let pauseItem = self.items[indexPath.item]
        
        cell.configureCell(item: pauseItem)
        
        cell.selection(isSelected: pauseItem.isSelected)
        
//        cell.isImageViewVibrancyEnabled = self.isVibrancyEnabled
//        cell.isTextLabelVibrancyEnabled = self.isVibrancyEnabled
    }
    
    func updateItems()
    {
        self.registeredKVOObservers.removeAll()
        
        for (index, item) in self.items.enumerated()
        {
            let observer = item.observe(\.isSelected, changeHandler: { [unowned self] (item, change) in
                let indexPath = IndexPath(item: index, section: 0)
                
                if let cell = self.collectionView?.cellForItem(at: indexPath) as? MenuCell
                {
                    self.configure(cell, for: indexPath)
                }
            })
            
            self.registeredKVOObservers.insert(observer)
        }
    }
}

extension GridMenuViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let size = CGSize(width: cellWidht, height: cellHeight)
        return size
    }
}

extension GridMenuViewController
{
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath)
    {
        let item = self.items[indexPath.item]
        item.isSelected = !item.isSelected
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath)
    {
        let item = self.items[indexPath.item]
        item.isSelected = !item.isSelected
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.previousIndexPath = indexPath
        
        let item = self.items[indexPath.item]
        item.isSelected = !item.isSelected
        item.action(item)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.itemCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        self.configure(cell , for: indexPath)
        return cell
        
    }
}

extension GridMenuViewController
{
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        let item = self.dataSource.item(at: indexPath)
        guard let menu = item.menu else { return nil }
        
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in menu }
    }
    
    override func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCell else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(rect: cell.contentView.bounds)
        
        let preview = UITargetedPreview(view: cell.contentView, parameters: parameters)
        return preview
    }
    
    override func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    {
        return self.collectionView(collectionView, previewForHighlightingContextMenuWithConfiguration: configuration)
    }
}
