//
//  EmoteCell.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/12/24.
//

import UIKit

protocol SectionCellDelegate: AnyObject {
    func didSelectEmoteSection(sectionTitle: String)
}

class SectionCell: UICollectionViewCell {
    weak var delegate: SectionCellDelegate?
    var titleLabel: UILabel!
    var symbolLabel: UILabel!
    
    // Style
    let shadowOpacity: Float = 0.2
    let cornerRadius: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Vertical Stack
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        
        // Title
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        
        // Subtitle
        symbolLabel = UILabel()
        symbolLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        symbolLabel.textAlignment = .center
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(symbolLabel)
        
        // Add Stack to View
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        backgroundColor = UIColor(named: "PrimaryButtonColor")
        // Drop Shadow
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Store the original background color
        //originalBackgroundColor = backgroundColor
        
        // Change the background color when pressed
        backgroundColor = UIColor(named: "PressedPrimaryButtonColor")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        // Open Section
        if let sectionTitle = self.titleLabel.text {
            self.delegate?.didSelectEmoteSection(sectionTitle: sectionTitle)
        }
        
        // Revert back to the original background color when released
        backgroundColor = UIColor(named: "PrimaryButtonColor")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        // Revert back to the original background color when touch is cancelled
        backgroundColor = UIColor(named: "PrimaryButtonColor")
    }
}
