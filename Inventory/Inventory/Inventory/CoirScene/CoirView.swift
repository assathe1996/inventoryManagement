//
//  CoirView.swift
//  Inventory
//
//  Created by Atharv Sathe on 18/08/19.
//  Copyright © 2019 Atharv Sathe. All rights reserved.
//

import UIKit

class CoirView: UIView {
    var element: String = ""
    var quantity: Int = 0
    var isCoir: Bool = true
    
    private lazy var elementLabel: UILabel = genericLabel()
    private lazy var quantityLabel: UILabel = genericLabel()
    
    private var elementString: NSAttributedString {
        return elementAttributedString("Size: " + element, fontsize: elementFontSize)
    }
    private var quantityString: NSAttributedString {
        return quantityAtrributedString("Quantity: " + String(quantity), fontsize: quantityFontSize)
    }
    
    private func genericLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func elementAttributedString(_ string: String, fontsize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(fontsize)
        font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle,.font:font])
    }
    
    private func configureElementLabel(_ label: UILabel) {
        label.attributedText = elementString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = false
    }
    
    private func quantityAtrributedString(_ string: String, fontsize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontsize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle,.font:font])
    }
    
    private func configureQuantityLabel(_ label: UILabel) {
        label.attributedText = quantityString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = false
    }
    
    private func imageToDisplay() -> String {
        if isCoir {
            return "Coir"
        } else {
            return "Foam"
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureElementLabel(elementLabel)
        elementLabel.transform = CGAffineTransform.identity.translatedBy(x: elementOffsetX, y: elementOffsetY).translatedBy(x: elementLabel.bounds.width/2, y: elementLabel.bounds.height/2)
        
        configureQuantityLabel(quantityLabel)
        quantityLabel.transform = CGAffineTransform.identity.translatedBy(x: quantityOffsetX, y: quantityOffsetY).translatedBy(x: quantityLabel.bounds.width/2, y: quantityLabel.bounds.height/2)
    }
    
    override func draw(_ rect: CGRect) {
        let displayRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        let imageRect = CGRect(x: imageOffsetX, y: imageOffsetY, width: bounds.size.height - (2*imageOffsetY), height: bounds.size.height - (2*imageOffsetY))
        displayRect.addClip()
        
        if quantity <= UIAtrributes.threshold[.over]! {
            UIAtrributes.color[.over]?.setFill()
        } else if quantity <= UIAtrributes.threshold[.almostOver]! {
            UIAtrributes.color[.almostOver]?.setFill()
        } else {
            UIAtrributes.color[.normal]?.setFill()
        }
        displayRect.fill()
        
        if let coirImage = UIImage(named: imageToDisplay(), in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
            coirImage.draw(in: imageRect)
        }
    }
}

extension CoirView {
    private struct sizeRatio{
        static let elementFontToBoundsWidth: CGFloat = 0.07
        static let quantityFontToBoundsWidth: CGFloat = 0.05
        static let elementLabelOffsetXToBoundsWidth: CGFloat = 0.05//0.2
        static let elementLabelOffsetYToBoundsHeight: CGFloat = 0.2//0.33
        static let quantityLabelOffsetXToBoundsWidth: CGFloat = 0.05//0.255
        static let quantityLabelOffsetYToBoundsHeight: CGFloat = 0.6//0.66
        static let cornerRadiusToBoundsHeight: CGFloat = 0.07
        static let imageOffsetXToBoundsWidth: CGFloat = 0.025
        static let imageOffsetYToBoundsHeight: CGFloat = 0.1
    }
    private var elementFontSize: CGFloat {
        return bounds.size.width * sizeRatio.elementFontToBoundsWidth
    }
    private var quantityFontSize: CGFloat {
        return bounds.size.width * sizeRatio.quantityFontToBoundsWidth
    }
    private var elementOffsetX: CGFloat {
        return bounds.size.height + (bounds.size.width * sizeRatio.elementLabelOffsetXToBoundsWidth)
    }
    private var elementOffsetY: CGFloat {
        return bounds.size.height * sizeRatio.elementLabelOffsetYToBoundsHeight
    }
    private var quantityOffsetX: CGFloat {
        return bounds.size.height + (bounds.size.width * sizeRatio.quantityLabelOffsetXToBoundsWidth)
    }
    private var quantityOffsetY: CGFloat {
        return bounds.size.height * sizeRatio.quantityLabelOffsetYToBoundsHeight
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * sizeRatio.cornerRadiusToBoundsHeight
    }
    private var imageOffsetX: CGFloat {
        return bounds.size.width * sizeRatio.imageOffsetXToBoundsWidth
    }
    private var imageOffsetY: CGFloat {
        return bounds.size.height * sizeRatio.imageOffsetYToBoundsHeight
    }
    
    enum backgroundColor: Int {
        case normal
        case almostOver
        case over
        static let allCases: [backgroundColor] = [.normal, .almostOver, .over]
        
    }
    private struct UIAtrributes {
        static let color: [backgroundColor: UIColor] = [.normal:#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1), .almostOver:#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1), .over:#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)]
        static let threshold: [backgroundColor :Int] = [.almostOver:3, .over:1]
    }
    
}


