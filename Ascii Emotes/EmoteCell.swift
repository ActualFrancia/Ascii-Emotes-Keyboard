//
//  EmoteCell.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/13/24.
//

import UIKit

protocol EmoteCellDelegate: AnyObject {
    func didPressEmote(emote: String)
}

class EmoteCell: UICollectionViewCell {
    weak var delegate: EmoteCellDelegate?
    var emoteLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emote: String) {
        emoteLabel.text = emote
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "PrimaryButtonColor")
        layer.cornerRadius = AppConstants.emoteCellCornerRadius
        
        // Drop Shadow
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1.25)
        layer.shadowRadius = 0
        
        emoteLabel = UILabel()
        emoteLabel.font = UIFont.systemFont(ofSize: AppConstants.emoteCellFontSize, weight: .regular)
        emoteLabel.textColor = UIColor(named: "TextColor")
        emoteLabel.textAlignment = .center
        
        addSubview(emoteLabel)
        emoteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emoteLabel.topAnchor.constraint(equalTo: topAnchor),
            emoteLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            emoteLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            emoteLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Show Box
        self.backgroundColor = UIColor(named: "PressedPrimaryButtonColor")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        delegate?.didPressEmote(emote: emoteLabel.text!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.animationDelay) {
            // Close Box
            self.backgroundColor = UIColor(named: "PrimaryButtonColor")
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.animationDelay) {
            // Close Box
            self.backgroundColor = UIColor(named: "PrimaryButtonColor")
        }
    }
}
