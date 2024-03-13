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
    var controlButtonView: ControlButtonsView!
    
    // Styling ---------------------------------------
    let numberOfRows: CGFloat = 4
    let spacing: CGFloat = 7
    
    let verticalCollectionPadding: CGFloat = 10
    let horizontalCollectionPadding: CGFloat = 10
    
    let cellHeight: CGFloat = 40
    let cellWidth: CGFloat = 100
    // -----------------------------------------------
    
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
    }
            
    // FREQ EMOTES
    //---------------------------------------------------------------------------------
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
        
        setupControlButtonView()
        setupCollectionView()
    }
    
    func setupControlButtonView() {
        controlButtonView = ControlButtonsView(textDocumentProxy: textDocumentProxy, actionType: "present")
        controlButtonView.delegate = self
        controlButtonView.sectionButtonAction = {
            let sectionViewController = SectionViewController()
            sectionViewController.modalPresentationStyle = .fullScreen
            sectionViewController.textDocumentProxy = self.textDocumentProxy
            self.present(sectionViewController, animated: false, completion: nil)
        }

        
        view.addSubview(controlButtonView)
        controlButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
             collectionView.bottomAnchor.constraint(equalTo: controlButtonView.topAnchor)
         ])
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
        let totalVerticalPadding: CGFloat = verticalCollectionPadding * 2
        let totalSpacing = spacing * (numberOfRows - 1)
        
        let availableHeight = collectionView.bounds.height - totalVerticalPadding - totalSpacing
        let height = availableHeight / numberOfRows
        
        return CGSize(width: cellWidth, height: height)
    }
}

extension KeyboardViewController: EmoteCellDelegate {
    func didSelectEmote(emote: String) {
        textDocumentProxy.insertText(emote)
        updateFrequentlyUsedEmotes(emote: emote)
    }
}

// CONTROL BUTTON SECTION SCROLL DELEGATE
// --------------------------------------------------------------------------------

extension KeyboardViewController: ControlButtonViewDelegate {
    func didSelectSectionButton(withTitle title: String) {
        print("Delegate Call 3!")
        let emotesViewController = EmotesViewController()
        emotesViewController.sectionTitle = title
        emotesViewController.textDocumentProxy = textDocumentProxy
        emotesViewController.modalPresentationStyle = .fullScreen
            
        present(emotesViewController, animated: false, completion: nil)
    }
}
