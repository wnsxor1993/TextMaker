//
//  ViewController.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    private var titleView = UITextField().then {
        $0.isEnabled = false
        $0.text = "Text Maker"
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 40, weight: .semibold)
        $0.sizeToFit()
    }
    
    private var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        
        $0.collectionViewLayout = layout
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
//        $0.register(TotalFoodCell.self, forCellWithReuseIdentifier: TotalFoodCell.reuseIdentifier)
    }
    
    private var plusImageButton = UIButton().then {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfiguration)
        image?.withRenderingMode(.alwaysTemplate)
        
        $0.setImage(image, for: .normal)
        $0.tintColor = .green
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.configureLayouts()
    }
}

private extension MainViewController {
    
    func configureLayouts() {
        self.view.addSubviews(titleView, mainCollectionView, plusImageButton)
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        plusImageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-80)
            make.width.height.equalTo(80)
        }
    }
}
