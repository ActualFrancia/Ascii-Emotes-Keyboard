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
    static let keyboardHeight: CGFloat = 275
    
    // Title Label
    static let titleSize: CGFloat = 11.25
    static let titleTopPadding: CGFloat = 10
    
    // EmoteCollectionView
    static let emoteCollectionTopAnchorAdjustment: CGFloat = 30
    static let emoteCollectionBottomAnchorAdjustment: CGFloat = -10
    
    static let emoteCollectionVertialPadding: CGFloat = 0
    static let emoteCollectionHorizontalPadding: CGFloat = 10
    static let emoteCollectionInternalSpacing: CGFloat = 10
    
    // SectionCollectionView
    static let sectionCollectionVerticalPadding: CGFloat = 5
    static let sectionCollectionInterSpacing: CGFloat = 10
    
    static let dividerWidth:CGFloat = 1
    static let dividerHeight:CGFloat = 15
    
    // Control Buttons    
    static let switchImageSize: CGFloat = 18
    static let returnImageSize: CGFloat = 17.5
    static let backspaceImageSize: CGFloat = 21
    static let freqImageSize: CGFloat = 21
    
    // HStack
    static let hStackHeight: CGFloat = 40
    static let hStackHortizonalPadding: CGFloat = 5
    static let hStackPadding: CGFloat = 5
    
    // EmoteCell
    static let emoteCellWidth: CGFloat = 100
    static let emoteCellHeight: CGFloat = 30
    static let emoteCellCornerRadius: CGFloat = 5
    
    // SectionCell
    static let sectionCellPadding: CGFloat = 25
    static let sectionCellFontSize: CGFloat = 16
    static let sectionCellWeight:UIFont.Weight = .regular
    static let unfocusedSelectedCell = 0.3
    
    // Animation Delay for Cells
    static let animationDelay = 0.01
    
    // Backspace Timer
    static let backspaceTimerInterval = 0.1
    static let backspaceDisptachAfter = 0.4
}
