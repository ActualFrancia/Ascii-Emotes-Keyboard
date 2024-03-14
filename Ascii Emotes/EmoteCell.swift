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
        emoteLabel = UILabel()
        emoteLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        emoteLabel.textColor = UIColor(named: "TextColor")
        emoteLabel.textAlignment = .center
        
        backgroundColor = .green
        emoteLabel.layer.cornerRadius = 10
        
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
    
        // Style on Touch
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        delegate?.didPressEmote(emote: emoteLabel.text!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.animationDelay) {
            // Close Box
            // End Touch
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.animationDelay) {
            // Close Box
        }
    }
}
