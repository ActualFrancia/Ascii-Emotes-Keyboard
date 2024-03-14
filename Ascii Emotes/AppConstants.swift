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
    static let titleLabelSize: CGFloat = 10
    
    // EmoteCollectionView
    static let emoteCollectionTopAnchorAdjustment: CGFloat = 18
    
    static let emoteCollectionVertialPadding: CGFloat = 0
    static let emoteCollectionHorizontalPadding: CGFloat = 5
    static let emoteCollectionInternalSpacing: CGFloat = 5
    
    // Control Buttons
    static let switchImageSize: CGFloat = 19
    static let returnImageSize: CGFloat = 17
    static let backspaceImageSize: CGFloat = 21
    static let freqImageSize: CGFloat = 19
    
    // EmoteCell
    static let emoteCellWidth: CGFloat = 100
    static let emoteCellHeight: CGFloat = 30
    
    // SectionCell
    static let sectionCellWidth: CGFloat = 100
    
    // Animation Delay for Cells
    static let animationDelay = 0.5
    
    // Backspace Timer
    static let backspaceTimerInterval = 0.1
    static let backspaceDisptachAfter = 0.4
}
