//
//  PhotoCollectionViewLayout.swift
//  EQueoTest
//
//  Created by Alexander Filippov on 8/7/19.
//  Copyright © 2019 Alexander Filippov. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoCollectionViewLayoutDelegate: class {
    
    func ratio(forItemAt indexPath: IndexPath) -> CGFloat
}

class PhotoCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: PhotoCollectionViewLayoutDelegate?
    
    private var cache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    override var collectionViewContentSize: CGSize {
        var maxX: CGFloat = 0.0
        var maxY: CGFloat = 0.0
        for attribute in self.cache.values {
            if maxX < attribute.frame.maxX {
                maxX = attribute.frame.maxX
            }
            if maxY < attribute.frame.maxY {
                maxY = attribute.frame.maxY
            }
        }
        return CGSize(width: maxX, height: maxY)
    }
    
    override func prepare() {
        super.prepare()
        self.cache = [:]
        guard let collectionView = self.collectionView
            , let delegate = self.delegate else {
                return
        }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let cellWidth = collectionView.frame.width / 2
        
        var firstColumnHeight: CGFloat = 0.0
        var secondColumnHeight: CGFloat = 0.0
        var allAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
        for itemIndex in 0..<numberOfItems {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let ratio = delegate.ratio(forItemAt: indexPath)
            let cellHeight = cellWidth / ratio
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let isForFirstColumn = firstColumnHeight <= secondColumnHeight
            let x = isForFirstColumn ? 0.0 : cellWidth
            let y = isForFirstColumn ? firstColumnHeight : secondColumnHeight
            attributes.frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            allAttributes[indexPath] = attributes
            
            if isForFirstColumn {
                firstColumnHeight += cellHeight
            } else {
                secondColumnHeight += cellHeight
            }
        }
        self.cache = allAttributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cache.values.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath]
    }
}
