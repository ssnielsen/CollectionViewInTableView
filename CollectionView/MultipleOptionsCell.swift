//
//  MultipleOptionsCell.swift
//  CollectionView
//
//  Created by Soren Sonderby Nielsen on 19/03/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import UIKit

protocol MultipleOptionsCellDelegate: class {
    func numberOfOptions() -> Int
    func configure(_ cell: MultipleOptionsSelectionCell, for index: Int)
    func didSelectItemAt(index: Int)
}

class MultipleOptionsCell: UITableViewCell {

    weak var delegate: MultipleOptionsCellDelegate?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Setup layout options
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 30, height: 20)
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 4
        collectionView.collectionViewLayout = flowLayout

        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MultipleOptionsSelectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MultipleOptionsSelectionCell")
    }

    // http://stackoverflow.com/a/33364092/1177835
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        collectionView.frame = CGRect(x: leftConstraint.constant, y: topConstraint.constant, width: targetSize.width, height: 1000)
        collectionView.layoutIfNeeded()

        let collectionViewSize = collectionView.collectionViewLayout.collectionViewContentSize

        let horizontalConstraint = leftConstraint.constant + rightConstraint.constant
        let verticalConstraint = topConstraint.constant + bottomConstraint.constant

        return CGSize(
            width: collectionViewSize.width + horizontalConstraint,
            height: collectionViewSize.height + verticalConstraint
        )
    }

}

extension MultipleOptionsCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfOptions() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultipleOptionsSelectionCell", for: indexPath) as! MultipleOptionsSelectionCell
        delegate?.configure(cell, for: indexPath.row)
        return cell
    }
}

extension MultipleOptionsCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(index: indexPath.row)
    }
}


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // http://stackoverflow.com/a/36016798/1177835
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
