//
//  TextEditorCollectionViewCell.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 13.08.2024.
//

import UIKit

final class TextEditorCollectionViewCell: UICollectionViewCell {

    lazy var textField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .textFieldTintColor
        textField.layer.cornerRadius = 12
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .textPrimary
        textField.isEditable = true
        textField.delegate = self
        textField.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 0)
        return textField
    }()

    var textChangeHandler: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setText(text: String) {
        textField.text = text
    }
}

extension TextEditorCollectionViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Передаем текст во внешний контроллер
        textChangeHandler?(textView.text)
        if let collectionView = self.superview as? UICollectionView {
            collectionView.performBatchUpdates(nil, completion: nil)
        }
    }
}
