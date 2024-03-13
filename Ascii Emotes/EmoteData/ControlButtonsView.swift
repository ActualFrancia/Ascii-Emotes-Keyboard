//
//  ControlButtonsView.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/12/24.
//

import UIKit

class ControlButtonsView: UIView {
    let textDocumentProxy: UITextDocumentProxy
    var action: (() -> Void)?
    var actionType: String
    
    var controlStackView: UIStackView!
    
    init(textDocumentProxy: UITextDocumentProxy, actionType: String) {
        self.textDocumentProxy = textDocumentProxy
        self.actionType = actionType
        super.init(frame: .zero)
        
        setupControlButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupControlButtons() {
        let switchButton = setupSwitchButton(imageSize: 19)
        let returnButton = setupReturnButton(imageSize: 17)
        let backButton = setupBackButton(imageSize: 21)
        let sectionButton = setupSectionButton(imageSize: 18)
        
        controlStackView = UIStackView(arrangedSubviews: [switchButton, sectionButton, returnButton, backButton])
        controlStackView.axis = .horizontal
        controlStackView.distribution = .equalCentering
        controlStackView.spacing = 0
        
        controlStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(controlStackView) // Add the controlStackView as a subview
        
        NSLayoutConstraint.activate([
            controlStackView.topAnchor.constraint(equalTo: topAnchor),
            controlStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            controlStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            controlStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // Section Button -------------------------------------------------------------
    private func setupSectionButton(imageSize: CGFloat) -> UIButton {
        let sectionButton = UIButton(type: .custom)
        sectionButton.layer.cornerRadius = 10
        sectionButton.layer.masksToBounds = true
        sectionButton.backgroundColor = UIColor(named: "SecondaryButtonColor")
        sectionButton.tintColor = UIColor(named: "TextColor")
        
        if (actionType == "present") {
            // Image
            sectionButton.setImage(UIImage(systemName: "square.grid.3x2", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
            sectionButton.setImage(UIImage(systemName: "square.grid.3x2.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .highlighted)
            // Text
            sectionButton.setTitle("Categories", for: .normal)
        } else {
            // Image
            sectionButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
            sectionButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .highlighted)
            // Text
            sectionButton.setTitle("Back", for: .normal)
        }
        
        sectionButton.addTarget(self, action: #selector(sectionButtonTouchDown(sender:)), for: .touchDown)
        sectionButton.addTarget(self, action: #selector(sectionButtonTouchUp(sender:)), for: .touchUpInside)
        sectionButton.addTarget(self, action: #selector(sectionButtonTouchCancel(sender:)), for: [.touchUpOutside, .touchCancel])
        
        sectionButton.translatesAutoresizingMaskIntoConstraints = false
        
        return sectionButton
    }
    
    @objc private func sectionButtonTouchDown(sender: UIButton) {
        sender.isHighlighted = true
                sender.backgroundColor = UIColor(named: "PressedSecondaryButtonColor")
    }
    
    @objc private func sectionButtonTouchUp(sender: UIButton) {
        sender.isHighlighted = false
        sender.backgroundColor = UIColor(named: "SecondaryButtonColor")

        let emoteViewController = EmoteViewController()
        emoteViewController.modalPresentationStyle = .fullScreen
        emoteViewController.textDocumentProxy = self.textDocumentProxy
        
        //self.present(emoteViewController, animated: false, completion: nil)
        if let action = action {
            action()
        }
    }
    
    @objc private func sectionButtonTouchCancel(sender: UIButton) {
        sender.isHighlighted = false
        sender.backgroundColor = UIColor(named: "SecondaryButtonColor")
    }
    
    // Back Button -------------------------------------------------------------
    private func setupBackButton(imageSize: CGFloat) -> UIButton {
        let backButton = UIButton(type: .custom)
        
        backButton.setImage(UIImage(systemName: "delete.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
        backButton.setImage(UIImage(systemName: "delete.left.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .highlighted)
        backButton.tintColor = UIColor(named: "ControlColor")
        

        backButton.translatesAutoresizingMaskIntoConstraints = false

        backButton.addTarget(self, action: #selector(backButtonTouchDown(sender:)), for: .touchDown)
        backButton.addTarget(self, action: #selector(backButtonTouchUp(sender:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        return backButton
    }
    
    @objc private func backButtonTouchDown(sender: UIButton) {
        sender.isHighlighted = true
        sender.tintColor = UIColor(named: "PressedControlColor")
        
        print("BackButton")
    }

    @objc private func backButtonTouchUp(sender: UIButton) {
        sender.isHighlighted = false
        sender.tintColor = UIColor(named: "ControlColor")
    }
    
    // Switch Button -------------------------------------------------------------
    private func setupSwitchButton(imageSize: CGFloat) -> UIButton {
        let switchButton = UIButton(type: .system)
        switchButton.setImage(UIImage(systemName: "globe", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
        switchButton.tintColor = UIColor(named: "ControlColor")
        
        switchButton.addTarget(self, action: #selector(KeyboardViewController.handleInputModeList(from:with:)), for: .allTouchEvents)
       
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        return switchButton
    }
    
    // Return Button -------------------------------------------------------------
    private func setupReturnButton(imageSize: CGFloat) -> UIButton {
        let returnButton = UIButton(type: .custom)
        
        returnButton.setImage(UIImage(systemName: "return.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
        returnButton.setImage(UIImage(systemName: "return.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .highlighted)
        returnButton.tintColor = UIColor(named: "ControlColor")
        

        returnButton.translatesAutoresizingMaskIntoConstraints = false

        returnButton.addTarget(self, action: #selector(returnButtonTouchDown(sender:)), for: .touchDown)
        returnButton.addTarget(self, action: #selector(returnButtonTouchUp(sender:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
       
        return returnButton
    }
    
    @objc private func returnButtonTouchDown(sender: UIButton) {
        sender.isHighlighted = true
        sender.tintColor = UIColor(named: "PressedControlColor")
        textDocumentProxy.insertText("\n")
    }

    @objc private func returnButtonTouchUp(sender: UIButton) {
        sender.isHighlighted = false
        sender.tintColor = UIColor(named: "ControlColor")
    }

}

