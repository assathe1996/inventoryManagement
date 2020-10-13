//
//  CoirDetailView.swift
//  Inventory
//
//  Created by Atharv Sathe on 30/08/19.
//  Copyright © 2019 Atharv Sathe. All rights reserved.
//

import UIKit

class CoirDetailView: UIView {
    var date: String = ""
    var quantity: Int = 0
    var balance: Int = 0
    
    private lazy var dateLabel: UILabel = genericLabel()
    private lazy var balanceLabel: UILabel = genericLabel()
    private lazy var quantityView: QuantityView = generateQuantityView()
    
    private var dateString: NSAttributedString {
        return dateAttributedString(date, fontsize: generalFontSize)
    }
    
    private var balanceString: NSAttributedString {
        return generalAtrributedString(String(balance), fontsize: generalFontSize)
    }
    
    private func genericLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func generateQuantityView() -> QuantityView {
        let embeddedQuantityView = QuantityView()
        addSubview(embeddedQuantityView)
        return embeddedQuantityView
    }
    
    private func dateAttributedString(_ string: String, fontsize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(fontsize)
        font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle,.font:font])
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
    
    private func configureQuantityView(_ quantityDisplay: QuantityView) {
        quantityDisplay.quantity = quantity
        quantityDisplay.frame.size = CGSize.init(width: quantityViewWidth, height: quantityViewHeight)
        quantityDisplay.sizeToFit()
        quantityDisplay.isHidden = false
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLabel(dateLabel, with: dateString)
        dateLabel.transform = CGAffineTransform.identity.translatedBy(x: dateLabelXOffset, y: generalLabelYOffset).translatedBy(x: dateLabel.bounds.size.width/2, y: dateLabel.bounds.size.height/2)
        
        configureQuantityView(quantityView)
        quantityView.transform = CGAffineTransform.identity.translatedBy(x: quantityViewXOffset, y: CGFloat.zero)
        
        configureLabel(balanceLabel, with: balanceString)
        balanceLabel.transform = CGAffineTransform.identity.translatedBy(x: balanceLabelXOffset, y: generalLabelYOffset).translatedBy(x: balanceLabel.bounds.size.width/2, y: balanceLabel.bounds.size.height/2)
    }
    
    override func draw(_ rect: CGRect) {
        let displayRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        displayRect.addClip()
        #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).setFill()
        displayRect.fill()
    }
}

extension CoirDetailView {
    private struct sizeRatio{
        static let fontToBoundsWidth: CGFloat = 0.07
        static let cornerRadiusToBoundsHeight: CGFloat = 0.07
        static let quantityViewWidthToBoundsWidth: CGFloat = 0.2
        static let dateLabelOffsetToBoundsWidth: CGFloat = 0.1
        static let quantityViewOffsetToBoundsWidth: CGFloat = 0.53
        static let balanceLabelOffsetToBoundsWidth: CGFloat = 0.85
        static let generalLabelOffsetToBoundsHeight: CGFloat = 0.1
    }
    private var generalFontSize: CGFloat {
        return bounds.size.width * sizeRatio.fontToBoundsWidth
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * sizeRatio.cornerRadiusToBoundsHeight
    }
    private var quantityViewHeight: CGFloat {
        return CGFloat(40) //same as coirDetailTableViewController cell height
    }
    private var quantityViewWidth: CGFloat {
        return bounds.size.width * sizeRatio.quantityViewWidthToBoundsWidth
    }
    private var dateLabelXOffset: CGFloat {
        return bounds.size.width * sizeRatio.dateLabelOffsetToBoundsWidth
    }
    private var quantityViewXOffset: CGFloat {
        return bounds.size.width * sizeRatio.quantityViewOffsetToBoundsWidth
    }
    private var balanceLabelXOffset: CGFloat {
        return bounds.size.width * sizeRatio.balanceLabelOffsetToBoundsWidth
    }
    private var generalLabelYOffset: CGFloat {
        return bounds.size.height * sizeRatio.generalLabelOffsetToBoundsHeight
    }
}


    
