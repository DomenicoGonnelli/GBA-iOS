//
//  RouletteViewLayout.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 03/09/2019.
//  Copyright © 2019 Domenico Gonnelli. All rights reserved.
//

import Foundation
import UIKit

class RouletteViewLayout: UICollectionViewLayout {
    
    // MARK: Getting the Collection View Information
    
    override var collectionViewContentSize: CGSize {
        return collectionView?.bounds.size ?? .zero
    }
    
    // MARK: Invalidating the Layout
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    // MARK: Providing Layout Attributes
    
    private var layoutCircleFrame = CGRect.zero
    private let layoutInsets = UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)
    private var itemLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        itemLayoutAttributes.removeAll()
        
        let itemSizeReductor = SettingManager.cellDimensionFactor
        
        let width = collectionView.bounds.width / CGFloat(Double(collectionView.numberOfItems(inSection: 0))/itemSizeReductor)
        let height = collectionView.bounds.height / CGFloat(Double(collectionView.numberOfItems(inSection: 0))/itemSizeReductor)
        
        let itemSize = CGSize(width: width, height: height)
        layoutCircleFrame = CGRect(origin: .zero, size: collectionViewContentSize)
            .inset(by: layoutInsets)
            .insetBy(dx: itemSize.width / 2.0, dy: itemSize.height / 2.0)
            .offsetBy(dx: collectionView.contentOffset.x, dy: collectionView.contentOffset.y)
            .insetBy(dx: -collectionView.contentOffset.x, dy: -collectionView.contentOffset.y)
        
        for section in 0..<collectionView.numberOfSections {
            switch section {
            case 0:
                let itemCount = collectionView.numberOfItems(inSection: section)
                itemLayoutAttributes = (0..<itemCount).map({ (index) -> UICollectionViewLayoutAttributes in
                    let angleStep: CGFloat = 2.0 * CGFloat.pi / CGFloat(itemCount)
                    var position = layoutCircleFrame.center
                    position.x += layoutCircleFrame.size.innerRadius * cos(angleStep * CGFloat(index))
                    position.y += layoutCircleFrame.size.innerRadius * sin(angleStep * CGFloat(index))
                    let indexPath = IndexPath(item: index, section: section)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = CGRect(center: position, size: itemSize)
                    return attributes
                })
            default:
                fatalError("Unhandled section \(section).")
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let numberOfItems = collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
        guard numberOfItems > 0 else { return nil }
        switch indexPath.section {
        case 0:
            return itemLayoutAttributes[indexPath.item]
        default:
            fatalError("Unknown section \(indexPath.section).")
        }
    }
    

}
