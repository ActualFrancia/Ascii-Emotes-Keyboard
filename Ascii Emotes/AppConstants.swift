//
//  AppConstants.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/13/24.
//

import UIKit

/* TODO LIST
   - Tapic Feedback
   - Press instant animation
   - Localize
   - Transparent Color Matching
   - Section Symbols?
*/

struct AppConstants {
    // Emote Sections
    static let sections: [(title: String, symbol: String)] = [
        ("Happy", "placeHolder"),
        ("Sad", "placeHolder"),
        ("Love", "placeHolder"),
        ("Angry", "placeHolder"),
        ("Bear", "placeHolder"),
        ("Cat", "placeHolder")
    ]
    
    // Keyboard Height
    static let keyboardHeight: CGFloat = 275
    
    // Title Label
    static let titleSize: CGFloat = 12
    static let titleTopPadding: CGFloat = 9
    
    // EmoteCollectionView
    static let emoteCollectionTopAnchorAdjustment: CGFloat = 30
    static let emoteCollectionBottomAnchorAdjustment: CGFloat = -10
    
    static let emoteCollectionVertialPadding: CGFloat = 0
    static let emoteCollectionHorizontalPadding: CGFloat = 10
    static let emoteCollectionInternalSpacing: CGFloat = 10
    
    // SectionCollectionView
    static let sectionCollectionVerticalPadding: CGFloat = 3 // Adjust height of SectionCollectionView
    static let sectionCollectionInterSpacing: CGFloat = 10
    
    static let dividerWidth:CGFloat = 0.75
    static let dividerHeight:CGFloat = 18
    static let dividerOpacity = 0.8
    
    // Control Buttons    
    static let switchImageSize: CGFloat = 18
    static let returnImageSize: CGFloat = 17.5
    static let backspaceImageSize: CGFloat = 21
    static let freqImageSize: CGFloat = 21
    
    // HStack
    static let hStackHeight: CGFloat = 40
    static let hStackHortizonalPadding: CGFloat = 5
    static let hStackSpacing: CGFloat = 5
    
    // EmoteCell
    static let emoteCellFontSize: CGFloat = 13
    static let emoteCellWidth: CGFloat = 130
    static let emoteCellHeight: CGFloat = 30
    static let emoteCellCornerRadius: CGFloat = 5
    
    // SectionCell
    static let sectionCellPadding: CGFloat = 25
    static let sectionCellFontSize: CGFloat = 16
    static let sectionCellWeight:UIFont.Weight = .regular
    static let unfocusedSelectedCell = 0.7
    
    // Animation Delay for Cells
    static let animationDelay = 0.01
    
    // Backspace Timer
    static let backspaceTimerInterval = 0.1
    static let backspaceDisptachAfter = 0.4
}
