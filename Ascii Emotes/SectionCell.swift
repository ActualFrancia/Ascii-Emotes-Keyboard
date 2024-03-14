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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with section: String) {
        sectionLabel.text = section
    }
    
    private func setupView() {
        sectionLabel = UILabel()
        sectionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        sectionLabel.textColor = UIColor(named: "TextColor")
        sectionLabel.textAlignment = .center
        
        backgroundColor = .cyan
        sectionLabel.layer.cornerRadius = 10
        
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
        backgroundColor = UIColor(named: "PressedPrimaryButtonColor")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.animationDelay) {
            // Open Section
            if let sectionTitle = self.sectionLabel.text {
                self.delegate?.didSelectEmoteSection(sectionTitle: sectionTitle)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.animationDelay) {
                // Revert back to the original background color when released
                self.backgroundColor = UIColor(named: "PrimaryButtonColor")
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // Revert back to the original background color when canceled
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.animationDelay) {
            self.backgroundColor = UIColor(named: "PrimaryButtonColor")
        }
    }
}
