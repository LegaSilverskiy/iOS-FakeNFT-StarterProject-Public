//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 13.08.2024.
//

import UIKit

protocol SendProfileTextProtocol: AnyObject {
    var profileDescription: [String] { get set }
    func sendText(_ text: [String])
}

final class EditProfileViewController: UIViewController {
    
    weak var delegate: SendProfileTextProtocol?
    
    private var text: [String] {
        delegate?.profileDescription ?? []
    }
    
    private var editedText = [String]()
    
    private let tableHeaders = ["Имя", "Описание", "Сайт"]
    
    private let exitButton = {
        let exit = UIButton()
        exit.setImage(UIImage(named: "Cross"), for: .normal)
        exit.translatesAutoresizingMaskIntoConstraints = false
        exit.imageView?.tintColor = .textPrimary
        exit.addTarget(self, action: #selector(exitScreen), for: .touchUpInside)
        return exit
    }()
    
    private lazy var authorImage: UIButton = {
        let image = UIButton()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 32
        image.setBackgroundImage(UIImage(named: "User Pic"), for: .normal)
        
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .black.withAlphaComponent(0.6)
        overlay.layer.cornerRadius = 32
        overlay.isUserInteractionEnabled = false
        overlay.clipsToBounds = true
        
        image.addSubview(overlay)
        
        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: image.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: image.bottomAnchor)
        ])
        
        image.setTitle("Сменить фото", for: .normal)
        image.setTitleColor(.textOnPrimary, for: .normal)
        image.titleLabel?.font = .caption3
        image.titleLabel?.numberOfLines = 2
        image.titleLabel?.textAlignment = .center
        return image
    }()
    
    lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TextEditorCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TextEditorHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        editedText = text
        view.addSubview(exitButton)
        view.addSubview(authorImage)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -16),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: authorImage.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            authorImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            authorImage.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 22),
            authorImage.heightAnchor.constraint(equalToConstant: 70),
            authorImage.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    @objc private func exitScreen() {
        delegate?.sendText(editedText)
        self.dismiss(animated: true)
    }
}

extension EditProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TextEditorCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setText(text: editedText[indexPath.section])
        
        cell.textChangeHandler = { [weak self] text in
            self?.editedText[indexPath.section] = text
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TextEditorHeaderCollectionViewCell
        
        view.titleLabel.text = tableHeaders[indexPath.section]
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TextEditorCollectionViewCell {
            cell.textField.becomeFirstResponder()
            editedText[indexPath.section] = cell.textField.text
            
        }
        
    }
}

extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width - 32
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let textView = UITextView()
        textView.text = editedText[indexPath.section]
        textView.font = .bodyRegular
        let height = textView.sizeThatFits(maxSize).height
        
        return CGSize(width: width, height: height + 11)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 16, bottom: 24, right: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}
