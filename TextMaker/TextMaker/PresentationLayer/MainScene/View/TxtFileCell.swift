//
//  TxtFileCell.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import UIKit
import Then
import SnapKit

final class TxtFileCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TxtFileCell"
    
    private var imageView = UIImageView().then {
        let image = UIImage(systemName: "doc.text")
        image?.withRenderingMode(.alwaysTemplate)
        
        $0.contentMode = .scaleAspectFit
        $0.image = image
        $0.tintColor = .yellow
    }
    
    private var titleText = UITextField().then {
        $0.isEnabled = false
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
    }
    
    private var subText = UITextField().then {
        $0.isEnabled = false
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .darkGray
    }
    
    private(set) var fileURL: URL? = nil
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.resetDataForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureLayouts()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    func setProperties(with item: TxtFileModel) {
        self.fileURL = item.fileUrl
        self.titleText.text = item.title
        self.subText.text = item.subText
    }
}

private extension TxtFileCell {
    
    func configureLayouts() {
        self.addSubviews(imageView, titleText, subText)
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(self.snp.height)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        titleText.snp.makeConstraints { make in
            make.leading.equalTo(imageView).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        subText.snp.makeConstraints { make in
            make.leading.equalTo(imageView).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(titleText.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    func resetDataForReuse() {
        titleText.text = ""
        subText.text = ""
    }
}
