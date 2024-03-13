//
//  ControlButtonsView.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/12/24.
//

import UIKit

protocol ControlButtonViewDelegate: AnyObject {
    func didSelectSectionButton(withTitle title:String)
}

class ControlButtonsView: UIView {
    weak var delegate: ControlButtonViewDelegate?
    let textDocumentProxy: UITextDocumentProxy
    var sectionButtonAction: (() -> Void)?
    var sectionButtonActionType: String

    var controlStackView: UIStackView!
    
    init(textDocumentProxy: UITextDocumentProxy, actionType: String) {
        self.textDocumentProxy = textDocumentProxy
        self.sectionButtonActionType = actionType
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
        let sectionScroll = setupSectionScroll()
        
        controlStackView = UIStackView(arrangedSubviews: [switchButton, sectionButton, sectionScroll, returnButton, backButton])
        controlStackView.axis = .horizontal
        controlStackView.distribution = .equalCentering
        controlStackView.spacing = 0
        
        controlStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(controlStackView) // Add the controlStackView as a subview
        
        NSLayoutConstraint.activate([
            sectionScroll.widthAnchor.constraint(equalToConstant: 300),
            sectionScroll.heightAnchor.constraint(equalToConstant: 30)
        ])
        
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
        
        if (sectionButtonActionType == "present") {
            // Grid Image
            sectionButton.setImage(UIImage(systemName: "square.grid.2x2", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
            sectionButton.setImage(UIImage(systemName: "square.grid.2x2.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .highlighted)
        } else {
            // Back Image
            sectionButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .normal)
            sectionButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular)), for: .highlighted)
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

        let sectionViewController = SectionViewController()
        sectionViewController.modalPresentationStyle = .fullScreen
        sectionViewController.textDocumentProxy = self.textDocumentProxy
        
        if let action = sectionButtonAction {
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
    
    // Section Scroll ------------------------------------------------------------
    
    private func setupSectionScroll() -> UIView {
        let spacing:CGFloat = 10
        let verticalPadding:CGFloat = 1
        let horizontalPadding:CGFloat = 5

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        // Padding
        layout.sectionInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .green
        
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(SectionButtonCell.self, forCellWithReuseIdentifier: "SectionButtonCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
}

class SectionButtonCell: UICollectionViewCell {
    weak var delegate: ControlButtonViewDelegate?
    let animationDelay = 0.5
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "TextColor")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14) // Adjust font size as needed
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, delegate: ControlButtonViewDelegate?) {
        titleLabel.text = title
        self.delegate = delegate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = UIColor(named: "PressedPrimaryButtonColor")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            // Open Section
            if let sectionTitle = self.titleLabel.text {
                print("Delegate Call 1!")
                self.delegate?.didSelectSectionButton(withTitle: sectionTitle)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDelay) {
                // Revert back to the original background color when released
                self.backgroundColor = UIColor(named: "PrimaryButtonColor")
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // Revert back to the original background color when canceled
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            self.backgroundColor = UIColor(named: "PrimaryButtonColor")
        }
    }
}

extension ControlButtonsView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppConstants.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionButtonCell", for: indexPath) as! SectionButtonCell
        let section = AppConstants.sections[indexPath.item]
        cell.configure(with: section.title, delegate: self.delegate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = AppConstants.sections[indexPath.item]
        let size = (section.title as NSString).size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) // Adjust font size as needed
        ])
        return CGSize(width: size.width + 20, height: collectionView.bounds.height) // Adjust width and height as needed
    }

}

