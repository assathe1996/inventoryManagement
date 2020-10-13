//
//  QuantityView.swift
//  Inventory
//
//  Created by Atharv Sathe on 30/08/19.
//  Copyright © 2019 Atharv Sathe. All rights reserved.
//

import UIKit

class QuantityView: UIView {
    public var quantity: Int = 3
        
    private lazy var quantityLabel: UILabel = genericLabel()
    
    private var quantityString: NSAttributedString {
        return generalAtrributedString(String(quantity), fontsize: generalFontSize)
    }
    
    private func genericLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func generalAtrributedString(_ string: String, fontsize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontsize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle,.font:font])
    }
    
    private func configureLabel(_ label: UILabel, with string: NSAttributedString) {
        label.attributedText = string
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = false
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLabel(quantityLabel, with: quantityString)
        quantityLabel.transform = CGAffineTransform.identity.translatedBy(x: bounds.width/2, y: bounds.height/2).translatedBy(x: -quantityLabel.bounds.width/2, y: -quantityLabel.bounds.height/2)
    }
      
    override func draw(_ rect: CGRect) {
        let displayRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        displayRect.addClip()
        
        if quantity < 0 { quantityUIAttributes.color[.output]?.setFill() }
        else if quantity > 0 { quantityUIAttributes.color[.input]?.setFill() }
        displayRect.fill()
    }
    
    
}

extension QuantityView {
    private struct sizeRatio{
        static let fontToBoundsWidth: CGFloat = 0.35
        static let cornerRadiusToBoundsHeight: CGFloat = 0.07
    }
    private var generalFontSize: CGFloat {
        return bounds.size.width * sizeRatio.fontToBoundsWidth
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * sizeRatio.cornerRadiusToBoundsHeight
    }
    
    enum backgroundColor: Int {
        case input
        case output
        static let allCases: [backgroundColor] = [.input, .output]
    }
    
    private struct quantityUIAttributes {
        static let color:[backgroundColor: UIColor] = [.input:#colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1), .output: #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)]
    }
}
