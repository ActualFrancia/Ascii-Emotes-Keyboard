//
//  KeyboardViewController.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/11/24.
//

import UIKit

// Haptics
import AVFoundation

class KeyboardViewController: UIInputViewController {
    let sections = AppConstants.sections
    
    var sectionTitle: String = "Frequently Used" {
        didSet {
            titleLabel?.text = sectionTitle
        }
    }
    var previousSelectedSection: String?
    
    var data: [(String, Int)] = []

    var titleLabel: UILabel!
    var emoteCollectionView: UICollectionView!
    var sectionCollectionView: UICollectionView!
    var hStack: UIStackView!
    
    var freqButton: UIButton!
    var isFreqSelected: Bool = true {
        didSet {
            updateFreqBackgroundColor()
        }
    }
    
    var backspaceTimer: Timer?
    var backspaceWorkItem: DispatchWorkItem?
    
    // Haptic Engine
    let buttonHapticFeedback = UIImpactFeedbackGenerator(style: .light)
    let switchHapticFeedback = UISelectionFeedbackGenerator()

    // Loading Overrides
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fix for Height Jitter
        // TODO: Figure out how to remove previous constraint
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
            constant: AppConstants.keyboardHeight
        )
            
        view.addConstraint(heightConstraint)
        
        // Fix for Touch and Gesture Timeouts new Screen Edges
        let window = view.window!
        let gr0 = window.gestureRecognizers![0] as UIGestureRecognizer
        let gr1 = window.gestureRecognizers![1] as UIGestureRecognizer
        gr0.delaysTouchesBegan = false
        gr1.delaysTouchesBegan = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial Data
        setupData(selectedSection: "Frequently Used")
        
        // Setup keyboard
        setupKeyboard()
        
    }
    
    
    // DATA LOADING AND SWITCHING
    // -------------------------------------------------------------------------------
    func setupData(selectedSection: String) {
        // Check if keyboardState is same as previous
        if selectedSection != previousSelectedSection {
            
            self.sectionTitle = selectedSection
            
            if selectedSection == "Frequently Used" {
                isFreqSelected = true
                loadFrequentlyUsedEmotes()
            } else {
                isFreqSelected = false
                loadEmotesFromJSON()
            }
    
            previousSelectedSection = sectionTitle
        } else {
            print("Same Section Selected!")
        }
    }
    
    func loadFrequentlyUsedEmotes() {
        // Loads and Sorts
        let frequentlyUsedEmotesDict = UserDefaults.standard.dictionary(forKey: "frequentlyUsedEmotes") as? [String: Int] ?? [:]
        
        // Sort the emotes
        let sortedPairs = frequentlyUsedEmotesDict.sorted(by: { (pair1, pair2) in
            if pair1.value != pair2.value {
                return pair1.value > pair2.value // Sort by frequency
            } else {
                return pair1.key < pair2.key // alphabetically tiebreaker if equal
            }
        })
        
        // Convert the sorted pairs into an array of tuples
        data = sortedPairs.map { ($0.key, $0.value) }
        
        // If the array has more than 20 emotes, remove the less frequently used ones
        if data.count > 20 {
            print("Triming to top 20 used emotes")
            data.removeLast(data.count - 20)
        }
        
        // Update UI on main thread
        DispatchQueue.main.async {
            self.emoteCollectionView.reloadData() // Reload collection view data
        }
    }
    
    func loadEmotesFromJSON() {
        guard let path = Bundle.main.path(forResource: sectionTitle, ofType: "json") else {
            print("ERROR WITH JSON PATH FOR \(sectionTitle)")
            return
        }
        
        let filePath = URL(fileURLWithPath: path)

        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let fileData = try Data(contentsOf: filePath)
                let emotes = try JSONDecoder().decode([String].self, from: fileData)
                
                // Map to Data
                self.data = emotes.map { ($0, 0) } // Update self.data
                
                // Update UI on main thread
                DispatchQueue.main.async {
                    self.emoteCollectionView.reloadData() // Reload collection view data
                }
            } catch {
                print("ERROR LOADING JSON: \(error)")
            }
        }
    }
    
    // UPDATE FREQUENTLY USED EMOTES
    // -------------------------------------------------------------------------------
    func increaseFrequentlyUsedEmotes(emote: String) {
        print("Updating Emote Fequency Count for \(emote)!")
        // Retrieve the current frequency from UserDefaults
        var frequentlyUsedEmotesDict = UserDefaults.standard.dictionary(forKey: "frequentlyUsedEmotes") as? [String: Int] ?? [:]
        
        // Increment the count for the emote
        let count = frequentlyUsedEmotesDict[emote, default: 0] + 1
        frequentlyUsedEmotesDict[emote] = count
        
        // Save the updated dictionary to UserDefaults
        UserDefaults.standard.set(frequentlyUsedEmotesDict, forKey: "frequentlyUsedEmotes")
    }

    
    // SETUP KEYBOARD
    // -------------------------------------------------------------------------------
    func setupKeyboard() {
        setupLabel()
        setupControlButtons()
        setupEmoteCollection()
    }
    
    func setupLabel() {
        print("\(sectionTitle)")
        titleLabel = UppercaseLabel()
        titleLabel.text = sectionTitle
        
        titleLabel.font = UIFont.systemFont(ofSize: AppConstants.titleSize, weight: .semibold)
        titleLabel.textColor = UIColor(named: "BoldTextColor")
        titleLabel.textAlignment = .left
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: AppConstants.titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.emoteCollectionHorizontalPadding),
        ])
    }
    
    func setupEmoteCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = AppConstants.emoteCollectionInternalSpacing
        layout.minimumInteritemSpacing = AppConstants.emoteCollectionInternalSpacing
        layout.sectionInset = UIEdgeInsets(top: AppConstants.emoteCollectionVertialPadding, left: AppConstants.emoteCollectionHorizontalPadding, bottom: AppConstants.emoteCollectionVertialPadding, right: AppConstants.emoteCollectionHorizontalPadding) // Padding
        
        emoteCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        emoteCollectionView.delegate = self
        emoteCollectionView.dataSource = self
        
        emoteCollectionView.backgroundColor = .clear
        
        emoteCollectionView.alwaysBounceHorizontal = true
        emoteCollectionView.clipsToBounds = false
        emoteCollectionView.showsHorizontalScrollIndicator = false
        
        emoteCollectionView.register(EmoteCell.self, forCellWithReuseIdentifier: "EmoteCell")

        view.addSubview(emoteCollectionView)
        emoteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emoteCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: AppConstants.emoteCollectionTopAnchorAdjustment),
            emoteCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emoteCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emoteCollectionView.bottomAnchor.constraint(equalTo: hStack.topAnchor, constant: AppConstants.emoteCollectionBottomAnchorAdjustment)
        ])
    }
    
    func setupSectionCollection() -> UICollectionView {
        let layout = DividedCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        // TESTING ------------------------------------------------------------------------------------------
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = AppConstants.sectionCollectionInterSpacing
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // Padding
        
        sectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        sectionCollectionView.delegate = self
        sectionCollectionView.dataSource = self
        
        sectionCollectionView.alwaysBounceHorizontal = true
        sectionCollectionView.clipsToBounds = true
        sectionCollectionView.showsHorizontalScrollIndicator = false
        sectionCollectionView.layer.cornerRadius = (AppConstants.hStackHeight - (2 * AppConstants.sectionCollectionVerticalPadding)) / 2
        
        sectionCollectionView.backgroundColor = UIColor(named: "ScrollColor")
        
        sectionCollectionView.register(SectionCell.self, forCellWithReuseIdentifier: "SectionCell")

        sectionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return sectionCollectionView
    }
    
    func setupControlButtons() {
        // Control Buttons
        var arrangedSubviews: [UIView] = []
        
        if needsInputModeSwitchKey {
            let switchButton = setupSwitchButton()
            arrangedSubviews.append(switchButton)
            
            NSLayoutConstraint.activate([
                switchButton.widthAnchor.constraint(equalToConstant: AppConstants.hStackHeight),
            ])
        }
        
        let freqButton = setupFreqButton()
        sectionCollectionView = setupSectionCollection()
        let returnButton = setupReturnButton()
        let backspaceButton = setupBackspaceButton()
        
        hStack = UIStackView(arrangedSubviews: arrangedSubviews + [freqButton, sectionCollectionView, returnButton, backspaceButton])
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .center
        hStack.spacing = AppConstants.hStackSpacing
                
        view.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            freqButton.widthAnchor.constraint(equalToConstant: AppConstants.hStackHeight - (2 * AppConstants.sectionCollectionVerticalPadding)),
            freqButton.heightAnchor.constraint(equalToConstant: AppConstants.hStackHeight - (2 * AppConstants.sectionCollectionVerticalPadding)),
            
            returnButton.widthAnchor.constraint(equalToConstant: AppConstants.hStackHeight),
            backspaceButton.widthAnchor.constraint(equalToConstant: AppConstants.hStackHeight),

            // section collection padding
            sectionCollectionView.topAnchor.constraint(equalTo: hStack.topAnchor, constant: AppConstants.sectionCollectionVerticalPadding),
            sectionCollectionView.bottomAnchor.constraint(equalTo: hStack.bottomAnchor, constant: -AppConstants.sectionCollectionVerticalPadding),
            
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.hStackHortizonalPadding),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.hStackHortizonalPadding),
            hStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hStack.heightAnchor.constraint(equalToConstant: AppConstants.hStackHeight),
        ])
    }
    
    // BUTTONS
    // -------------------------------------------------------------------------------
    // Switch Keyboard Button
    private func setupSwitchButton() -> UIButton {
        let switchButton = UIButton(type: .system)
        switchButton.imageView?.contentMode = .center
        
        switchButton.setImage(UIImage(systemName: "globe", withConfiguration: UIImage.SymbolConfiguration(pointSize: AppConstants.switchImageSize, weight: .regular)), for: .normal)
        switchButton.tintColor = UIColor(named: "ControlColor")
        
        switchButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
       
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        return switchButton
    }
    
    // Frequently Used Button
    private func setupFreqButton() -> UIButton {
        freqButton = UIButton(type: .custom)
        freqButton.imageView?.contentMode = .center
        
        freqButton.backgroundColor = UIColor(named: "SelectedSectionCell")
        
        freqButton.layer.cornerRadius = (AppConstants.hStackHeight - (2 * AppConstants.sectionCollectionVerticalPadding)) / 2

        freqButton.setImage(UIImage(systemName: "clock", withConfiguration: UIImage.SymbolConfiguration(pointSize: AppConstants.freqImageSize, weight: .regular)), for: .normal)
        freqButton.setImage(UIImage(systemName: "clock.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: AppConstants.freqImageSize, weight: .regular)), for: .highlighted)
        freqButton.tintColor = UIColor(named: "PressedFreqColor")
        
        freqButton.addTarget(self, action: #selector(freqButtonTouchDown(sender:)), for: .touchDown)
        freqButton.addTarget(self, action: #selector(freqButtonTouchUp(sender:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        freqButton.translatesAutoresizingMaskIntoConstraints = false
        
        return freqButton
    }
    
    private func updateFreqBackgroundColor() {
        freqButton?.backgroundColor = isFreqSelected ? UIColor(named: "SelectedSectionCell") : .clear
        freqButton?.tintColor = isFreqSelected ? UIColor(named: "PressedControlColor") : UIColor(named: "ControlColor")

    }
    
    @objc private func freqButtonTouchDown(sender: UIButton) {
        sender.isHighlighted = true
        sender.tintColor = UIColor(named: "PressedControlColor")
     }
     
     @objc private func freqButtonTouchUp(sender: UIButton) {
         sender.isHighlighted = false
         
         // Haptic Feedback
         self.switchHapticFeedback.selectionChanged()

         // Setup Data
         setupData(selectedSection: "Frequently Used")
         
         if isFreqSelected {
             sender.tintColor = UIColor(named: "PressedFreqColor")
         } else {
             sender.tintColor = UIColor(named: "ControlColor")

         }
         
         for (index, _) in sections.enumerated() {
              if let cell = sectionCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SectionCell {
                  cell.isUnFocuedSelectedSection = true
              }
          }
    }
    
    // Return Button
    private func setupReturnButton() -> UIButton {
        let returnButton = UIButton(type: .custom)
        returnButton.imageView?.contentMode = .center

        returnButton.setImage(UIImage(systemName: "return.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: AppConstants.returnImageSize, weight: .regular)), for: .normal)
        returnButton.setImage(UIImage(systemName: "return.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: AppConstants.returnImageSize, weight: .regular)), for: .highlighted)
        returnButton.tintColor = UIColor(named: "ControlColor")

        returnButton.addTarget(self, action: #selector(returnButtonTouchDown(sender:)), for: .touchDown)
        returnButton.addTarget(self, action: #selector(returnButtonTouchUp(sender:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
       
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        return returnButton
    }
    
    @objc private func returnButtonTouchDown(sender: UIButton) {
        sender.isHighlighted = true
        sender.tintColor = UIColor(named: "PressedControlColor")
        self.switchHapticFeedback.selectionChanged()
        textDocumentProxy.insertText("\n")
    }

    @objc private func returnButtonTouchUp(sender: UIButton) {
        sender.isHighlighted = false
        sender.tintColor = UIColor(named: "ControlColor")
    }
    
    // Back Space Button
    private func setupBackspaceButton() -> UIButton {
        let backspaceButton = UIButton(type: .custom)
        backspaceButton.imageView?.contentMode = .center

        backspaceButton.setImage(UIImage(systemName: "delete.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: AppConstants.backspaceImageSize, weight: .regular)), for: .normal)
        backspaceButton.setImage(UIImage(systemName: "delete.left.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: AppConstants.backspaceImageSize, weight: .regular)), for: .highlighted)
        backspaceButton.tintColor = UIColor(named: "ControlColor")
        
        backspaceButton.addTarget(self, action: #selector(backspaceButtonTouchDown(sender:)), for: .touchDown)
        backspaceButton.addTarget(self, action: #selector(backspaceButtonTouchUp(sender:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        backspaceButton.translatesAutoresizingMaskIntoConstraints = false
        return backspaceButton
    }
            
    @objc private func backspaceButtonTouchDown(sender: UIButton) {
        sender.isHighlighted = true
        sender.tintColor = UIColor(named: "PressedControlColor")

        // Always backspace once
        textDocumentProxy.deleteBackward()
        self.switchHapticFeedback.selectionChanged()

        backspaceWorkStart()
    }
    
    @objc private func backspaceButtonTouchUp(sender: UIButton) {
        sender.isHighlighted = false
        sender.tintColor = UIColor(named: "ControlColor")
        
        backspaceWorkStop()
    }
    
    private func backspaceWorkStart() {
        // Create work item
        backspaceWorkItem = DispatchWorkItem { [weak self] in
            self?.backspaceTimer = Timer.scheduledTimer(withTimeInterval: AppConstants.backspaceTimerInterval, repeats: true) { [weak self] _ in
                self?.switchHapticFeedback.selectionChanged()
                self?.textDocumentProxy.deleteBackward()
            }
        }
        // Distpatch work item
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.backspaceDisptachAfter, execute: backspaceWorkItem!)
    }
    
    private func backspaceWorkStop() {
        // Cancel work item if not yet executed
        backspaceWorkItem?.cancel()
        
        // Stop the timer
        backspaceTimer?.invalidate()
        backspaceTimer = nil
    }
}


// DELEGATE FUNCTION EXTENSIONS
// -------------------------------------------------------------------------------
extension KeyboardViewController: SectionCellDelegate {
    func didSelectEmoteSection(sectionTitle: String) {
        // Haptic Feedback
        self.switchHapticFeedback.selectionChanged()
        
        // Iterate through section cells to update their selection state
        for (index, section) in sections.enumerated() {
            let isSelected = section.title == sectionTitle
            if let cell = sectionCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SectionCell {
                cell.isSelectedSection = isSelected
            }
        }
        
        // Setup Data
        setupData(selectedSection: sectionTitle)
    }
}

extension KeyboardViewController: EmoteCellDelegate {
    func didPressEmote(emote: String) {
        textDocumentProxy.insertText(emote)

        increaseFrequentlyUsedEmotes(emote: emote)
    }
}

// UICOLLECTION EXTENSIONS
// -------------------------------------------------------------------------------

extension KeyboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emoteCollectionView {
            return data.count
        } 
        else if collectionView == sectionCollectionView {
            return sections.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emoteCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmoteCell", for: indexPath) as! EmoteCell
            let emote = data[indexPath.item].0
            cell.configure(with: emote)
            cell.delegate = self
            return cell
        } 
        else if collectionView == sectionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! SectionCell
            let section = sections[indexPath.item]
            cell.configure(with: section.title)
            cell.delegate = self
            return cell
        }
        // Handle other collection views if needed
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == emoteCollectionView {
            return CGSize(width: AppConstants.emoteCellWidth, height: AppConstants.emoteCellHeight)
        }
        else if collectionView == sectionCollectionView {
            let section = sections[indexPath.item]
            let sectionTitle = NSLocalizedString(section.title, comment: "") // Get localized section title
            let sectionWidth = sectionTitle.size(withAttributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: AppConstants.sectionCellFontSize, weight: AppConstants.sectionCellWeight)
            ]).width + AppConstants.sectionCellPadding
            return CGSize(width: sectionWidth, height: collectionView.bounds.height)
        }
        return CGSize.zero
    }
}

// CUSTOM UILABEL
class UppercaseLabel: UILabel {
    override var text: String? {
        get {
            return super.text
        }
        set {
            super.text = NSLocalizedString(newValue!, comment: "").uppercased()
        }
    }
}

// CUSTOM DIVIDED UICOLLECTIONVIEW
class DividedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private let dividerWidth = AppConstants.dividerWidth
    private let dividerHeight = AppConstants.dividerHeight
    
    override func prepare() {
        super.prepare()
        register(DividerView.self, forDecorationViewOfKind: "Divider")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var updatedAttributes = superAttributes
        
        // Iterate through each attribute to add dividers
        for (_, attributes) in superAttributes.enumerated() {
            let indexPath = attributes.indexPath
            
            // Check if it's not the first item in a section
            if indexPath.item > 0 {
                // Add divider before
                let dividerAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "Divider", with: indexPath)
                let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
                
                if let previousAttributes = self.layoutAttributesForItem(at: previousIndexPath) {
                    // Calculate position
                    let dividerX = previousAttributes.frame.maxX + (attributes.frame.minX - previousAttributes.frame.maxX - dividerWidth) / 2
                    let dividerY = attributes.frame.minY + (attributes.frame.height - dividerHeight) / 2
                    dividerAttributes.frame = CGRect(x: dividerX, y: dividerY, width: dividerWidth, height: dividerHeight)
                    
                    updatedAttributes.append(dividerAttributes)
                }
            }
        }
        return updatedAttributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // Return layout attributes for divider
        if elementKind == "Divider" {
            return UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
}
