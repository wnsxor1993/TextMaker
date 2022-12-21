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
import RxDataSources

class MainViewController: UIViewController {

    private var titleView = UITextField().then {
        $0.isEnabled = false
        $0.text = "Text Maker"
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 40, weight: .semibold)
        $0.sizeToFit()
    }
    
    private lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width, height: 40)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        
        $0.collectionViewLayout = layout
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(TxtFileCell.self, forCellWithReuseIdentifier: TxtFileCell.reuseIdentifier)
    }
    
    private var plusImageButton = UIButton().then {
        // MARK: 이미지의 크기를 포인트로 설정해줄 수 있는 컴포넌트
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfiguration)
        image?.withRenderingMode(.alwaysTemplate)
        
        $0.setImage(image, for: .normal)
        $0.tintColor = .green
    }
    
    private let disposeBag = DisposeBag()
    
    private var collectionViewDataSource: RxCollectionViewSectionedAnimatedDataSource<MainSectionModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.configureLayouts()
        self.configureCollectionViewDataSource()
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
    
    func configureCollectionViewDataSource() {
        self.collectionViewDataSource = RxCollectionViewSectionedAnimatedDataSource<MainSectionModel>(animationConfiguration: .init(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TxtFileCell.reuseIdentifier, for: indexPath) as? TxtFileCell else { return }
            
            cell.setProperties(with: item)
            
            return cell
        }
    }
    
    func bindInnerAction() {
        // TODO: Observable이랑 collectionView items 바인딩
        
    }
}
