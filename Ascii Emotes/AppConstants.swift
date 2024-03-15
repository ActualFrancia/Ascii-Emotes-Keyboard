//
//  AppConstants.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/13/24.
//

import UIKit

/* TODO LIST
   - Localize to JP, SP, FR, etc.
   - DESIGN AND CODE THE ACTUAL APP WITH INSTRUCTIOSN FOR FULL ACESS AND ETC. INCLUDE DIRECT LINKS TO THE SWITCH.
   - Section Symbols?
*/

struct AppConstants {
    // Emote Sections
    static let sections: [(title: String, symbol: String)] = [
        ("Happy", ""),
        ("Love", ""),
        ("Embarrassed", ""),
        ("Dissatisfied", ""),
        ("Angry", ""),
        ("Sad", ""),
        ("Pain", ""),
        ("Fear", ""),
        ("Doubt", ""),
        ("Surprise", ""),
        ("Greeting", ""),
        ("Hug", ""),
        ("Wink", ""),
        ("Sleeping", ""),
        ("Cat", ""),
        ("Bear", ""),
        ("Dog", ""),
        ("Bunny", ""),
        ("Lenny", "")
    ]
    
    // Keyboard Height
    static let keyboardHeight: CGFloat = 275 + hStackAdditionalBottomSpacing
    
    // Title Label
    static let titleSize: CGFloat = 12
    static let titleTopPadding: CGFloat = 7
    
    // EmoteCollectionView
    static let emoteCollectionTopAnchorAdjustment: CGFloat = 29
    static let emoteCollectionBottomAnchorAdjustment: CGFloat = -10
    
    static let emoteCollectionVertialPadding: CGFloat = 0
    static let emoteCollectionHorizontalPadding: CGFloat = 10
    static let emoteCollectionInternalSpacing: CGFloat = 9.5
    
    // SectionCollectionView
    static let sectionCollectionVerticalPadding: CGFloat = 1 // Adjust height of SectionCollectionView = 0
    static let sectionCollectionInterSpacing: CGFloat = 10
    
    static let dividerWidth:CGFloat = 0.5
    static let dividerHeight:CGFloat = 20
    static let dividerOpacity = 0.6
    
    // Control Buttons    
    static let switchImageSize: CGFloat = 18
    static let returnImageSize: CGFloat = 17.5
    static let backspaceImageSize: CGFloat = 21
    static let freqImageSize: CGFloat = 21
    
    // HStack
    static let hStackHeight: CGFloat = 40
    static let hStackSpacing: CGFloat = 5
    static let hStackAdditionalBottomSpacing: CGFloat = 2 // BOTTOM ADDED SPACING
    
    // EmoteCell
    static let emoteCellFontSize: CGFloat = 13
    static let emoteCellWidth: CGFloat = 130
    static let emoteCellHeight: CGFloat = 31
    static let emoteCellCornerRadius: CGFloat = 5
    
    // SectionCell
    static let sectionCellPadding: CGFloat = 25
    static let sectionCellFontSize: CGFloat = 16
    static let sectionCellWeight:UIFont.Weight = .regular
    static let unfocusedSelectedCellOpacity = 0.0
    
    // Animation Delay for Cells
    static let animationDelay = 0.01
    
    // Backspace Timer
    static let backspaceTimerInterval = 0.1
    static let backspaceDisptachAfter = 0.4
}
