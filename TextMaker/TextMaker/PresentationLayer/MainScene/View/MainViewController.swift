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
import RxGesture

class MainViewController: UIViewController {

    private var titleView: UILabel = .init().then {
        $0.text = "Text Maker"
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 40, weight: .semibold)
        $0.sizeToFit()
    }
    
    private lazy var mainCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init()).then {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width, height: 70)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        
        $0.backgroundColor = .white
        $0.collectionViewLayout = layout
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(TxtFileCell.self, forCellWithReuseIdentifier: TxtFileCell.reuseIdentifier)
    }
    
    private var plusImageButton: UIButton = .init().then {
        // MARK: 이미지의 크기를 포인트로 설정해줄 수 있는 컴포넌트
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 60)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfiguration)
        image?.withRenderingMode(.alwaysTemplate)
        
        $0.setImage(image, for: .normal)
        $0.tintColor = .green
    }
    
    weak var navigationDelegate: PushNavigateDelegate?
    
    private let mainVM: MainViewModel
    private let disposeBag: DisposeBag = .init()
    
    private var collectionViewDataSource: RxCollectionViewSectionedAnimatedDataSource<SectionModel>?
    
    init(_ viewModel: MainViewModel, pushNavigateDelegate: PushNavigateDelegate) {
        self.mainVM = viewModel
        self.navigationDelegate = pushNavigateDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Does not use this initializer")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.configureLayouts()
        self.configureCollectionViewDataSource()
        self.bindInnerAction()
        self.bindWithViewModel()
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_: [UIMenuElement]) -> UIMenu? in
            let deleteAction = UIAction(title: "파일 삭제", image: UIImage(systemName: "trash")) { _ in
                self.mainVM.removeCell(with: indexPaths)
            }
            
            return UIMenu(children: [deleteAction])
        }
    }
}

// MARK: View Layout Configure
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
        self.collectionViewDataSource = RxCollectionViewSectionedAnimatedDataSource<SectionModel>(animationConfiguration: .init(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TxtFileCell.reuseIdentifier, for: indexPath) as? TxtFileCell else {
                
                return .init()
            }
            
            cell.setProperties(with: item)
            
            return cell
        }
    }
}

// MARK: View Binding
private extension MainViewController {
    
    func bindInnerAction() {
        // TODO: Observable이랑 collectionView items 바인딩
        self.mainCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.mainCollectionView.rx.modelSelected(TxtFileModel.self)
            .subscribe { [weak self] model in
                guard let modelData = model.element else { return }
                
                self?.navigationDelegate?.push(modelData)
            }
            .disposed(by: disposeBag)
        
        self.plusImageButton.rx.tap
            .asDriver()
            .throttle(.seconds(1), latest: false)
            .drive { [weak self] _ in
                self?.navigationDelegate?.push(nil)
            }
            .disposed(by: disposeBag)
    }
    
    func bindWithViewModel() {
        guard let collectionViewDataSource else { return }
        
        let input: MainViewModel.Input = .init(viewWillAppearDriver: self.rx.viewWillAppear.asDriver(onErrorJustReturn: false))
        let output = mainVM.transform(with: input)
        
        output.collectionSectionModels
            .bind(to: mainCollectionView.rx.items(dataSource: collectionViewDataSource))
            .disposed(by: disposeBag)
    }
}
