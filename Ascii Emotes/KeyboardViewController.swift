//
//  KeyboardViewController.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/11/24.
//

import UIKit



class KeyboardViewController: UIInputViewController {
    
    // Testing Switch Override
    override var needsInputModeSwitchKey: Bool {
        get { return true } // Override the value for testing
    }
    
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
                loadFrequentlyUsedEmotes()
            } else {
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
        titleLabel = UILabel()
        titleLabel.text = sectionTitle
        
        titleLabel.font = UIFont.systemFont(ofSize: AppConstants.titleLabelSize, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
        
        emoteCollectionView.backgroundColor = .blue
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
            emoteCollectionView.bottomAnchor.constraint(equalTo: hStack.topAnchor)
        ])
    }
    
    func setupSectionCollection() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // Padding
        
        sectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        sectionCollectionView.delegate = self
        sectionCollectionView.dataSource = self
        
        sectionCollectionView.alwaysBounceHorizontal = true
        sectionCollectionView.clipsToBounds = true
        sectionCollectionView.showsHorizontalScrollIndicator = false
        
        // Testing
        sectionCollectionView.backgroundColor = .blue
        
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
        }
        
        let freqButton = setupFreqButton()
        sectionCollectionView = setupSectionCollection()
        
        hStack = UIStackView(arrangedSubviews: arrangedSubviews + [freqButton, sectionCollectionView])
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .fill
        hStack.spacing = 0
        
        // TESTING
        hStack.backgroundColor = .brown
        view.addSubview(hStack)
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hStack.heightAnchor.constraint(equalToConstant: AppConstants.controlBarHeight),
        ])
    }
    
    // BUTTONS
    // -------------------------------------------------------------------------------
    // Switch Keyboard Button
    private func setupSwitchButton() -> UIButton {
        let switchButton = UIButton(type: .system)
        switchButton.setImage(UIImage(systemName: "globe", withConfiguration: UIImage.SymbolConfiguration(pointSize: AppConstants.switchImageSize, weight: .regular)), for: .normal)
        switchButton.tintColor = UIColor(named: "ControlColor")
        
        switchButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
       
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        return switchButton
    }
    
    // Frequently Used Button
    private func setupFreqButton() -> UIButton {
        let freqButton = UIButton(type: .custom)
        freqButton.setImage(UIImage(systemName: "clock", withConfiguration: UIImage.SymbolConfiguration(pointSize: AppConstants.freqImageSize, weight: .regular)), for: .normal)
        freqButton.setImage(UIImage(systemName: "clock.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: AppConstants.freqImageSize, weight: .regular)), for: .highlighted)
        freqButton.tintColor = UIColor(named: "ControlColor")
        
        // TouchDown
        freqButton.addTarget(self, action: #selector(freqButtonTouchDown(sender:)), for: .touchDown)
        // TouchUpInside, TouchUpOutside, TouchCancel
        freqButton.addTarget(self, action: #selector(freqButtonTouchUp(sender:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        freqButton.translatesAutoresizingMaskIntoConstraints = false
        return freqButton
    }
    
    @objc private func freqButtonTouchDown(sender: UIButton) {
        sender.isHighlighted = true
        sender.backgroundColor = UIColor(named: "PressedSecondaryButtonColor")
     }
     
     @objc private func freqButtonTouchUp(sender: UIButton) {
         sender.isHighlighted = false
         sender.backgroundColor = UIColor(named: "SecondaryButtonColor")
         setupData(selectedSection: "Frequently Used")
     }
}


// DELEGATE FUNCTION EXTENSIONS
// -------------------------------------------------------------------------------
extension KeyboardViewController: SectionCellDelegate {
    func didSelectEmoteSection(sectionTitle: String) {
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
            let cellWidth: CGFloat = AppConstants.emoteCellWidth
            let cellHeight: CGFloat = AppConstants.emoteCellHeight
            return CGSize(width: cellWidth, height: cellHeight)
        } 
        else if collectionView == sectionCollectionView {
            let cellWidth: CGFloat = AppConstants.sectionCellWidth
            return CGSize(width: cellWidth, height: collectionView.bounds.height)
        }
        return CGSize.zero
    }
}
