//
//  AppConstants.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/13/24.
//

import UIKit

struct AppConstants {
    // Emote Sections
    static let sections: [(title: String, symbol: String)] = [
        ("Happy", "😊"),
        ("Sad", "😢"),
        ("Love", "❤️"),
        ("Angry", "😡"),
        ("Bear", "🐻"),
        ("Cat", "🐱")
    ]
    
    // Keyboard Height
    static let keyboardHeight: CGFloat = 250
    static let controlBarHeight: CGFloat = 40
    
    // Title Label
    static let titleSize: CGFloat = 13
    static let titleTopPadding: CGFloat = 5
    
    // EmoteCollectionView
    static let emoteCollectionTopAnchorAdjustment: CGFloat = 25
    static let emoteCollectionBottomAnchorAdjustment: CGFloat = -8
    
    static let emoteCollectionVertialPadding: CGFloat = 0
    static let emoteCollectionHorizontalPadding: CGFloat = 5
    static let emoteCollectionInternalSpacing: CGFloat = 5
    
    // SectionCollectionView
    static let sectionCollectionCornerRadius: CGFloat = 15
    
    // Control Buttons
    static let controlButtonFrame: CGFloat = 35
    
    static let switchImageSize: CGFloat = 18
    static let returnImageSize: CGFloat = 17.5
    static let backspaceImageSize: CGFloat = 21
    static let freqImageSize: CGFloat = 20
    
    // EmoteCell
    static let emoteCellWidth: CGFloat = 100
    static let emoteCellHeight: CGFloat = 30
    static let emoteCellCornerRadius: CGFloat = 5
    
    // SectionCell
    static let sectionCellCornerRadius: CGFloat = 15
    static let sectionCellPadding: CGFloat = 25
    static let sectionCellFontSize: CGFloat = 16
    static let sectionCellWeight:UIFont.Weight = .regular
    
    // Animation Delay for Cells
    static let animationDelay = 0.01
    
    // Backspace Timer
    static let backspaceTimerInterval = 0.1
    static let backspaceDisptachAfter = 0.4
}
