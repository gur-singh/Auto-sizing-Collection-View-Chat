//
//  ChatBubbleCell.swift
//  ChatBubble
//
//  Created by PrabSharan on 05/02/22.
//

import UIKit

class RightChatBubbleCell: UICollectionViewCell {

    @IBOutlet weak var rightMarginConst: NSLayoutConstraint!
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageTitle: UILabel!
    static var totalWidth: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()
        addRoundToContainer()
        RightChatBubbleCell.totalWidth = self.contentView.frame.width * 0.80 - SizeForBubble.RightInsetForCell
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func addRoundToContainer() {
        containerView.layer.cornerRadius = 15
    }
    override func preferredLayoutAttributesFitting(
            _ layoutAttributes: UICollectionViewLayoutAttributes
        ) -> UICollectionViewLayoutAttributes {
            layoutAttributes.bounds.size.height = check()
            return layoutAttributes
        }
    func check() -> CGFloat {

        let size = CGSize(width: RightChatBubbleCell.totalWidth - 5, height: 1000)

        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)]

        let sizeCalulated  = String(messageTitle.text ?? "").boundingRect(with: size, options: options, attributes: attributes, context: nil)

            let height = sizeCalulated.height + SizeForBubble.BottomPadding +  SizeForBubble.TopPadding
            let diff = RightChatBubbleCell.totalWidth - sizeCalulated.width
            addRoundToContainer()
            if diff <= 5 { // Means it reaches to full width  {
                if sizeCalulated.height <= 38 {
                    return 39
                } else {
                    return height
                }
            } else {
                return height
            }
    }
}

