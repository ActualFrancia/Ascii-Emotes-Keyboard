//
//  KeyboardViewController.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/11/24.
//

import UIKit

extension Notification.Name {
    static let frequentlyUsedEmotesDidChange = Notification.Name("FrequentlyUsedEmotesDidChange")
}

class KeyboardViewController: UIInputViewController {
    
    var collectionView: UICollectionView!
    var controlStackView: UIStackView!
    
    // Style
    let numberOfRows: CGFloat = 4
    let cellWidthPadding: CGFloat = 20
    let verticalCollectionPadding: CGFloat = 10
    let horizontalCollectionPadding: CGFloat = 10
    let spacing: CGFloat = 7
    let cellHeight: CGFloat = 49
    
    // Frequently Used
    var frequentlyUsedEmotesArray: [(emote: String, count: Int)] = []

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
        
        // Update Data before User Sees
        sortFrequentlyUsedEmotes()
        collectionView.reloadData()
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
        
        // Register observer for notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleFrequentlyUsedEmotesDidChange), name: .frequentlyUsedEmotesDidChange, object: nil)
        
        // Initial sort
        sortFrequentlyUsedEmotes()
        
        // Setup keyboard
        setupKeyboard()
        setupCollectionView()
   
        // Testing
        print("DEBUG VIEWING ----------------------------")
        for (emote, i) in frequentlyUsedEmotesArray {
            print("\(emote) : \(i)")
        }
    }
        
    // FREQ EMOTES -------------------------------------------------------------------------------
    // Handle Notification Post
    @objc func handleFrequentlyUsedEmotesDidChange() {
        sortFrequentlyUsedEmotes()
        collectionView.reloadData()
        print("NOTIFICAITON RECEIVED... RELOADING!")
    }
    
    func sortFrequentlyUsedEmotes() {
        print("sortFrequentlyUsedEmotes")
        let dictionary = UserDefaults.standard.dictionary(forKey: "frequentlyUsedEmotes") as? [String: Int] ?? [:]
        
        // Sort the emotes
        let sortedPairs = dictionary.sorted(by: { (pair1, pair2) in
            if pair1.value != pair2.value {
                return pair1.value > pair2.value // Sort by frequency
            } else {
                return pair1.key < pair2.key // alphabetically tiebreaker if equal
            }
        })
        
        // Convert the sorted pairs into an array of tuples
        frequentlyUsedEmotesArray = sortedPairs.map { ($0.key, $0.value) }
        
        // If the array has more than 20 emotes, remove the less frequently used ones
        if frequentlyUsedEmotesArray.count > 20 {
            print("removing last!")
            frequentlyUsedEmotesArray.removeLast(frequentlyUsedEmotesArray.count - 20)
        }
    }
    
    func updateFrequentlyUsedEmotes(emote: String) {
        print("updateFrequentlyUsedEmotes")
        
        // Retrieve the current frequency from UserDefaults
        var frequentlyUsedEmotesDict = UserDefaults.standard.dictionary(forKey: "frequentlyUsedEmotes") as? [String: Int] ?? [:]
        
        // Increment the count for the emote
        let count = frequentlyUsedEmotesDict[emote, default: 0] + 1
        frequentlyUsedEmotesDict[emote] = count
        
        // Save the updated dictionary to UserDefaults
        UserDefaults.standard.set(frequentlyUsedEmotesDict, forKey: "frequentlyUsedEmotes")
        
        // Update the array with top 20 frequently used emotes
        sortFrequentlyUsedEmotes()
    }
    
    // SETUP KEYBOARD -------------------------------------------------------------------------------
    
    func setupKeyboard() {
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Frequency Used"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Add constraints for the label
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 10),
        ])
        
        setupControlButtons()
    }
    
    func setupControlButtons() {
        let switchButton = setupSwitchButton(imageSize: 19)
        let returnButton = setupReturnButton(imageSize: 17)
        let backButton = setupBackButton(imageSize: 21)
        let sectionButton = setupSectionButton(imageSize: 18)
        
        controlStackView = UIStackView(arrangedSubviews: [switchButton, sectionButton, returnButton, backButton])
        controlStackView.axis = .horizontal
        controlStackView.distribution = .equalCentering
        controlStackView.spacing = 0
        
        controlStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlStackView)
        
        // Button Constraints
        NSLayoutConstraint.activate([
            controlStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            controlStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            controlStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 7
        
        // Padding
        layout.sectionInset = UIEdgeInsets(top: verticalCollectionPadding, left: horizontalCollectionPadding, bottom: verticalCollectionPadding, right: horizontalCollectionPadding)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        
        // Bounce
        //collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = true

        // Clipping for the collection view
        collectionView.clipsToBounds = false
        
        collectionView.register(EmoteCell.self, forCellWithReuseIdentifier: "EmoteCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: controlStackView.topAnchor)
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
}

// UICollectionView
extension KeyboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frequentlyUsedEmotesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmoteCell", for: indexPath) as! EmoteCell
        let emote = frequentlyUsedEmotesArray[indexPath.item].emote
        cell.configure(with: emote)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjusting width based on content
        let emote = frequentlyUsedEmotesArray[indexPath.item].emote
        let width = emote.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]).width + cellWidthPadding
        
        return CGSize(width: width, height: cellHeight)
    }
}

extension KeyboardViewController: EmoteCellDelegate {
    func didSelectEmote(emote: String) {
        textDocumentProxy.insertText(emote)
        updateFrequentlyUsedEmotes(emote: emote)
    }
}
