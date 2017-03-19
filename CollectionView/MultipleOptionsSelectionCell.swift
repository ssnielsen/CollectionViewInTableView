//
//  MultipleOptionsSelectionCell.swift
//  CollectionView
//
//  Created by Soren Sonderby Nielsen on 19/03/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import UIKit

class MultipleOptionsSelectionCell: UICollectionViewCell {


    private let selectedFillColor = UIColor.black.withAlphaComponent(0.5)
    private let fillColor = UIColor.black.withAlphaComponent(0.3)
    private var currentFillColor: UIColor {
        return isSelected ? selectedFillColor : fillColor
    }

    var text: String? {
        didSet {
            label.text = text
        }
    }

    @IBOutlet private weak var label: UILabel!

    override func draw(_ rect: CGRect) {
        let roundRectPath = UIBezierPath.init(roundedRect: rect, cornerRadius: rect.size.height / 2)
        currentFillColor.setFill()
        roundRectPath.fill()
    }

    override var isSelected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
}
