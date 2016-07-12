//
//  ChatRightTextCellNode.swift
//  Yep
//
//  Created by NIX on 16/7/5.
//  Copyright © 2016年 Catch Inc. All rights reserved.
//

import UIKit
import YepKit
import AsyncDisplayKit

class ChatRightTextCellNode: ChatRightBaseCellNode {

    static let textAttributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont.chatTextFont(),
    ]

    static let tempTextAttributes = [
        NSForegroundColorAttributeName: UIColor.greenColor(),
        NSFontAttributeName: UIFont.chatTextFont(),
    ]

    lazy var tailImageNode: ASImageNode = {
        let node = ASImageNode()
        node.image = UIImage(named: "bubble_right_tail")?.imageWithRenderingMode(.AlwaysOriginal)
        return node
    }()

    lazy var bubbleNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.layerBacked = true
        node.clipsToBounds = true
        node.cornerRadius = 20
        node.backgroundColor = UIColor.rightBubbleTintColor()
        return node
    }()

    lazy var textNode = ASTextNode()

    override init() {
        super.init()

        addSubnode(tailImageNode)
        addSubnode(bubbleNode)
        addSubnode(textNode)

        textNode.delegate = self
        textNode.userInteractionEnabled = true
        textNode.linkAttributeNames = ["TextLinkAttributeName"]
        textNode.passthroughNonlinkTouches = true
    }

    func configure(withMessage message: Message, text: String? = nil) {

        self.user = message.fromFriend

        if let text = text {
            textNode.attributedText = NSAttributedString(string: text, attributes: ChatRightTextCellNode.tempTextAttributes)
            return
        }
        
        do {
            let text = message.textContent
            let attributedText = NSMutableAttributedString(string: text, attributes: ChatRightTextCellNode.textAttributes)

            

            textNode.attributedText = attributedText
        }
    }

    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {

        let textMaxWidth = constrainedSize.width - ((15 + 10) + ChatBaseCellNode.avatarSize.width + (5 + 7 + 10) + 15)
        textNode.measure(CGSize(width: textMaxWidth, height: CGFloat.max))

        let height = max(textNode.calculatedSize.height + (7 + 7), ChatBaseCellNode.avatarSize.height)

        return CGSize(width: constrainedSize.width, height: height + ChatBaseCellNode.verticalPadding)
    }

    override func layout() {
        super.layout()

        let bubbleNodeHeight = calculatedSize.height - ChatBaseCellNode.verticalPadding
        let y = (bubbleNodeHeight - textNode.calculatedSize.height) / 2 + ChatBaseCellNode.topPadding
        let bubbleNodeMinWidth: CGFloat = 40
        let textNodeMinWidth = bubbleNodeMinWidth - (10 + 10)
        let bubbleNodeX = calculatedSize.width - (10 + max(textNodeMinWidth, textNode.calculatedSize.width) + (10 + 7 + 5) + ChatBaseCellNode.avatarSize.width + 15)
        let offsetX = min(textNodeMinWidth, textNode.calculatedSize.width) < textNodeMinWidth ? ((textNodeMinWidth - textNode.calculatedSize.width) / 2) : 0
        let origin = CGPoint(x: bubbleNodeX + 10 + offsetX, y: y)
        textNode.frame = CGRect(origin: origin, size: textNode.calculatedSize)

        bubbleNode.frame = CGRect(x: bubbleNodeX, y: ChatBaseCellNode.topPadding, width: max(textNodeMinWidth, textNode.calculatedSize.width) + (10 + 10), height: bubbleNodeHeight)

        do {
            let x = calculatedSize.width - ((13 + 5) + ChatBaseCellNode.avatarSize.width + 15)
            tailImageNode.frame = CGRect(x: x, y: 20 - (14 / 2) + ChatBaseCellNode.topPadding, width: 13, height: 14)
        }
    }
}

extension ChatRightTextCellNode: ASTextNodeDelegate {

    func textNode(textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: AnyObject, atPoint point: CGPoint) -> Bool {

        return true
    }

    func textNode(textNode: ASTextNode, tappedLinkAttribute attribute: String, value: AnyObject, atPoint point: CGPoint, textRange: NSRange) {

        print("tappedLinkAttribute")
    }
}
