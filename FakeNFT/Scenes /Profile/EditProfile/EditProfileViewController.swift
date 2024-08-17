//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 13.08.2024.
//

import UIKit

protocol EditProfileViewProtocol: AnyObject {
    func viewDidLoad()
    var authorImage: UIImageView { get set }
}

final class EditProfileViewController: UIViewController, EditProfileViewProtocol {
    
    weak var delegate: SendTextDelegate?
    
    var text = [String]()
    
    var presenter: EditProfilePresenterProtocol?
    
    private let exitButton = {
        let exit = UIButton()
        exit.setImage(UIImage(named: "Cross"), for: .normal)
        exit.translatesAutoresizingMaskIntoConstraints = false
        exit.imageView?.tintColor = .textPrimary
        exit.addTarget(self, action: #selector(exitScreen), for: .touchUpInside)
        return exit
    }()
    
    lazy var authorImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 35
        image.isUserInteractionEnabled = true
        
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .black.withAlphaComponent(0.6)
        overlay.layer.cornerRadius = 35
        overlay.isUserInteractionEnabled = false
        overlay.clipsToBounds = true
        
        image.addSubview(overlay)
        
        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: image.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: image.bottomAnchor)
        ])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(tapGesture)
        return image
    }()
    
    private lazy var titleForImage =  {
        let title = UILabel()
        title.text = "Сменить \nфото"
        title.textColor = .textOnPrimary
        title.font = .caption3
        title.numberOfLines = 2
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
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
    
    init(presenter: EditProfilePresenterProtocol?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text = convertToString()
        
        setupUI()
        setupConstraints()
        
    }
    
    private func setupUI() {
        
        presenter?.loadPhoto(with: presenter?.profile.avatar)
        isModalInPresentation = true
        view.backgroundColor = .systemBackground
        presenter?.editedText = text
        view.addSubview(exitButton)
        view.addSubview(authorImage)
        view.addSubview(collectionView)
        authorImage.addSubview(titleForImage)
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
            authorImage.widthAnchor.constraint(equalToConstant: 70),
            
            titleForImage.centerXAnchor.constraint(equalTo: authorImage.centerXAnchor),
            titleForImage.centerYAnchor.constraint(equalTo: authorImage.centerYAnchor)
        ])
    }
    
    @objc private func exitScreen() {
        guard let presenter = presenter else { return }
        
        presenter.updateAndNotify(text: presenter.editedText) { [weak self] in
            self?.delegate?.loadPresenter()
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func imageTapped() {
        guard let alert = presenter?.updatePhoto() else { return }
        present(alert, animated: true)
    }
    
    private func convertToString() -> [String] {
        guard let presenter else { return [] }
        return [presenter.profile.name, presenter.profile.description, presenter.profile.website]
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TextEditorCollectionViewCell, let presenter else { return UICollectionViewCell() }
        
        cell.setText(text: presenter.editedText[indexPath.section])
        
        cell.textChangeHandler = { [weak self] text in
            self?.presenter?.editedText[indexPath.section] = text
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TextEditorHeaderCollectionViewCell
        
        view.titleLabel.text = presenter?.tableHeaders[indexPath.section]
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TextEditorCollectionViewCell {
            cell.textField.becomeFirstResponder()
            presenter?.editedText[indexPath.section] = cell.textField.text
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
        textView.text = presenter?.editedText[indexPath.section]
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
