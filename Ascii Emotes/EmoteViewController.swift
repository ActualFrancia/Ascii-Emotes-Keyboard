//
//  EmoteViewController.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/11/24.
//

import UIKit

protocol EmoteViewControllerDelegate: AnyObject {
    func emoteViewControllerDidDismiss()
}

// Emote Section Selection UICollection
class EmoteViewController: UIViewController {
    var textDocumentProxy: UITextDocumentProxy?
    var collectionView: UICollectionView!
    var controlButtonView: ControlButtonsView!
    let sections: [(title: String, symbol: String)] = [
        ("Happy", "(＾▽＾)"),
        ("Sad", "｡：ﾟ(｡ﾉω＼｡)ﾟ･｡"),
        ("Love", "(｡♥‿♥｡)"),
        ("Angry", "(`皿´)"),
        ("Bear", "ʕ·ᴥ·ʔ"),
        ("Cat", "（＾・ω・＾）")
    ]
    // TESTING
    //let sections = (1...26).map { "section\($0)" }
    
    // Styling ---------------------------------------
    let numberOfRows: CGFloat = 3
    let spacing: CGFloat = 7
    
    let verticalPadding: CGFloat = 10
    let horizontalPadding: CGFloat = 10
    
    let cellWidth: CGFloat = 100
    // ------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @objc private func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func cancelDismissView() {
        // TODO: IMAGE AND COLOR CHANGE
    }
    
    func setupView() {
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Categories"
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
        controlButtonView = ControlButtonsView(textDocumentProxy: textDocumentProxy!, actionType: "dismiss")
        controlButtonView.action = {
            self.dismiss(animated: false, completion: nil)
        }
        
        view.addSubview(controlButtonView)
        controlButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        // Padding
        layout.sectionInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        
        // Bounce
        //collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = true
        
        // Clipping for the collection view
        collectionView.clipsToBounds = false
        
        collectionView.register(SectionCell.self, forCellWithReuseIdentifier: "SectionCell")
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

// EmoteViewController Extensions
extension EmoteViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! SectionCell
        cell.titleLabel.text = sections[indexPath.item].title
        cell.symbolLabel.text = sections[indexPath.item].symbol
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalVerticalPadding: CGFloat = verticalPadding * 2
        let totalSpacing = spacing * (numberOfRows - 1)
        
        let availableHeight = collectionView.bounds.height - totalVerticalPadding - totalSpacing
        let height = availableHeight / numberOfRows
        
        return CGSize(width: cellWidth, height: height)
    }
}

extension EmoteViewController: SectionCellDelegate {
    func didSelectEmoteSection(sectionTitle: String) {
        let sectionViewController = SectionViewController()
        sectionViewController.sectionTitle = sectionTitle
        sectionViewController.textDocumentProxy = self.textDocumentProxy!
        sectionViewController.modalPresentationStyle = .fullScreen
            
        present(sectionViewController, animated: false, completion: nil)
    }
}
