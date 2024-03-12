//
//  KeyboardViewController.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/11/24.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    private var defaultsObserver: NSKeyValueObservation?
    
    var buttonActions = [UIButton: () -> Void]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fix for Height Jitter
        // TODO: Figure out how to remove previous constraint
        let desiredHeight: CGFloat = 250
        
        view.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                view.removeConstraint(constraint)
            }
        }
            
        let heightConstraint = NSLayoutConstraint(
            item: view!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: desiredHeight
        )
            
        view.addConstraint(heightConstraint)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        //self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup keyboard
        setupKeyboard()
    }

    // BUTTONS -------------------------------------------------------------------------------
    
    // Common button action methods
    @objc private func buttonTouchDown(sender: UIButton) {
        sender.isHighlighted = true
        sender.tintColor = UIColor(named: "PressedControlColor")
        
        // Execute the associated action
        if let action = buttonActions[sender] {
            action()
        }
    }

    @objc private func buttonTouchUp(sender: UIButton) {
        sender.isHighlighted = false
        sender.tintColor = UIColor(named: "ControlColor")
    }
    
    private func keyButton(imageName: String, highlightedImageName: String, action: @escaping () -> Void, buttonSize: CGFloat) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .regular)), for: .normal)
        button.setImage(UIImage(systemName: highlightedImageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .regular)), for: .highlighted)
        button.tintColor = UIColor(named: "ControlColor")
        

        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(buttonTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(sender:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        buttonActions[button] = action

        // Add to View
        view.addSubview(button)
        
        return button
    }
    

    
    // SETUP KEYBOARD -------------------------------------------------------------------------------
    
    func setupKeyboard() {
        setupControlButtons()
    }
    
    func setupControlButtons() {
        let switchButton = setupSwitchButton(imageSize: 19)
        let returnButton = setupReturnButton(imageSize: 17)
        let backButton = setupBackButton(imageSize: 21)
        let sectionButton = setupSectionButton(imageSize: 18)
        
        // Button Constaints
        NSLayoutConstraint.activate([
            switchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            switchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            
            sectionButton.widthAnchor.constraint(equalToConstant: 310),
            sectionButton.heightAnchor.constraint(equalToConstant: 24),
            
            sectionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1),
            sectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            returnButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }
    
    // BUTTONS ------------------------------------------
    // Section Button
    private func setupSectionButton(imageSize: CGFloat) -> UIButton {
        let sectionButton = UIButton(type: .custom)
        sectionButton.layer.cornerRadius = 10
        sectionButton.layer.masksToBounds = true
        sectionButton.backgroundColor = UIColor(named: "SecondaryButtonColor")
        
        sectionButton.setImage(UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
        sectionButton.setImage(UIImage(systemName: "square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .highlighted)
        sectionButton.tintColor = UIColor(named: "TextColor")
        
        sectionButton.addTarget(self, action: #selector(sectionButtonTouchDown(sender:)), for: .touchDown)
        sectionButton.addTarget(self, action: #selector(sectionButtonTouchUp(sender:)), for: .touchUpInside)
        sectionButton.addTarget(self, action: #selector(sectionButtonTouchCancel(sender:)), for: [.touchUpOutside, .touchCancel])
        
        sectionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sectionButton)
        
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
        
        self.present(emoteViewController, animated: false, completion: nil)
    }
    
    @objc private func sectionButtonTouchCancel(sender: UIButton) {
        sender.isHighlighted = false
        sender.backgroundColor = UIColor(named: "SecondaryButtonColor")
    }
    
    // Back Button
    private func setupBackButton(imageSize: CGFloat) -> UIButton {
        let backButton = UIButton(type: .custom)
        
        backButton.setImage(UIImage(systemName: "delete.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
        backButton.setImage(UIImage(systemName: "delete.left.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .highlighted)
        backButton.tintColor = UIColor(named: "ControlColor")
        

        backButton.translatesAutoresizingMaskIntoConstraints = false

        backButton.addTarget(self, action: #selector(backButtonTouchDown(sender:)), for: .touchDown)
        backButton.addTarget(self, action: #selector(backButtonTouchUp(sender:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        // Add to View
        view.addSubview(backButton)
        
        return backButton
    }
    
    // Common button action methods
    @objc private func backButtonTouchDown(sender: UIButton) {
        sender.isHighlighted = true
        sender.tintColor = UIColor(named: "PressedControlColor")
        
        print("BackButton")
    }

    @objc private func backButtonTouchUp(sender: UIButton) {
        sender.isHighlighted = false
        sender.tintColor = UIColor(named: "ControlColor")
    }
    
    // Switch Button
    private func setupSwitchButton(imageSize: CGFloat) -> UIButton {
        let switchButton = UIButton(type: .system)
        switchButton.setImage(UIImage(systemName: "globe", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
        switchButton.tintColor = UIColor(named: "ControlColor")
        
        switchButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
       
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(switchButton)
        
        return switchButton
    }
    
    // Return Button
    private func setupReturnButton(imageSize: CGFloat) -> UIButton {
        let returnButton = UIButton(type: .custom)
        
        returnButton.setImage(UIImage(systemName: "return.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
        returnButton.setImage(UIImage(systemName: "return.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .highlighted)
        returnButton.tintColor = UIColor(named: "ControlColor")
        

        returnButton.translatesAutoresizingMaskIntoConstraints = false

        returnButton.addTarget(self, action: #selector(returnButtonTouchDown(sender:)), for: .touchDown)
        returnButton.addTarget(self, action: #selector(returnButtonTouchUp(sender:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        // Add to View
        view.addSubview(returnButton)
        
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
    
    
    // MISC ---------------------------------------------------------------------
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
}
