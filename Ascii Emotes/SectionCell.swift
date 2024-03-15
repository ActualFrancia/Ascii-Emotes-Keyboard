//
//  SectionCell.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/13/24.
//

import UIKit

protocol SectionCellDelegate: AnyObject {
    func didSelectEmoteSection(sectionTitle: String)
}

class SectionCell: UICollectionViewCell {
    weak var delegate: SectionCellDelegate?
    var sectionLabel: UILabel!
    var sectionKey: String?
    
    var isSelectedSection: Bool = false {
        didSet {
            updateBackgroundColor()
        }
    }
    
    var isUnFocuedSelectedSection: Bool = false {
        didSet {
            updateOpacityBackgroundColor()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with section: String) {
        sectionKey = section
        sectionLabel.text = NSLocalizedString(section, comment: "")
    }
    
    private func setupView() {
        layer.cornerRadius = (AppConstants.hStackHeight - (2 * AppConstants.sectionCollectionVerticalPadding)) / 2

        
        sectionLabel = UILabel()
        sectionLabel.font = UIFont.systemFont(ofSize: AppConstants.sectionCellFontSize, weight: AppConstants.sectionCellWeight)
        sectionLabel.textColor = UIColor(named: "TextColor")
        sectionLabel.textAlignment = .center
            
        addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionLabel.topAnchor.constraint(equalTo: topAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // Blank
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.animationDelay) {
            // Open Section
            if let sectionKey = self.sectionKey {
                self.delegate?.didSelectEmoteSection(sectionTitle: sectionKey)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // Blank
    }
    
    func updateBackgroundColor() {
        backgroundColor = isSelected ? UIColor(named: "SelectedSectionCell") : .clear
    }
    
    func updateOpacityBackgroundColor() {
        backgroundColor = isSelected ? UIColor(named: "SelectedSectionCell")?.withAlphaComponent(AppConstants.unfocusedSelectedCellOpacity) : .clear
    }
}

// DIVIDER VIEW
class DividerView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "SelectedSectionCell")?.withAlphaComponent(AppConstants.dividerOpacity)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
