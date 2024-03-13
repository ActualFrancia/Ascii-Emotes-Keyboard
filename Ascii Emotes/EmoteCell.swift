//
//  EmoteCell.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/12/24.
//

import UIKit

protocol EmoteCellDelegate: AnyObject {
    func didSelectEmote(emote: String)
}

class EmoteCell: UICollectionViewCell {
    weak var delegate: EmoteCellDelegate?
    var emoteLabel: UILabel!
    var emoteBox: UIView?
    var emote: String?
    
    // Style
    let emoteShadowOpacity: Float = 0.2
    let shadowOpacity: Float = 1
    let cornerRadius: CGFloat = 8
    let animationDelay = 0.1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        emoteLabel = UILabel()
        emoteLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        emoteLabel.textAlignment = .center
        
        emoteLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emoteLabel)
        
        // Label Style
        emoteLabel.layer.shadowColor = UIColor.black.cgColor
        emoteLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        emoteLabel.layer.shadowOpacity = emoteShadowOpacity
        emoteLabel.layer.shadowRadius = 2
        
        NSLayoutConstraint.activate([
            emoteLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emoteLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        backgroundColor = .clear
        // Drop Shadow
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Show Box
        if let emote = emote {
            emoteBox = boxView(with: emote)
        }
        
        // Style on Touch
        emoteLabel.layer.shadowOpacity = 0
        backgroundColor = UIColor(named: "PrimaryButtonColor")
        layer.shadowOpacity = shadowOpacity
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        
        // Type Emote
        if let emote = emote {
            delegate?.didSelectEmote(emote: emote)
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            // Close Box
            self.emoteBox?.removeFromSuperview()
            
            // End Touch
            self.emoteLabel.layer.shadowOpacity = self.emoteShadowOpacity
            self.backgroundColor = .clear
            self.layer.shadowOpacity = 0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            // Close Box
            self.emoteBox?.removeFromSuperview()
            
            // End Touch
            self.emoteLabel.layer.shadowOpacity = self.emoteShadowOpacity
            self.backgroundColor = .clear
            self.layer.shadowOpacity = 0
        }
    }
    
    private func boxView(with emote: String) -> UIView {
        let boxView = UIView(frame: CGRect(x: 0, y: -60, width: bounds.width, height: 50))
        boxView.backgroundColor = .green
        boxView.layer.cornerRadius = 10
        boxView.layer.masksToBounds = true

        let emoteLabel = UILabel(frame: boxView.bounds)
        emoteLabel.text = emote
        emoteLabel.textAlignment = .center
        boxView.addSubview(emoteLabel)

        contentView.addSubview(boxView)
        
        boxView.frame.origin.y = -30
        boxView.layer.zPosition = 99
        
        return boxView
    }
    
    func configure(with emote: String) {
        self.emote = emote
        emoteLabel.text = emote
    }
}
