//
//  RxDataSourceManager.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/22.
//

import RxDataSources
import RxRelay

final class RxDataSourceManager {
    
    static let shared: RxDataSourceManager = .init()
    
    private let txtFileManger: TextFileManager = .init()
    
    private var allSections: [SectionModel] = []
    private var mainSection: SectionModel?
    private var mainSectionItems: [TxtFileModel] = []
    
    private init() {
        self.fetchFileDatas()
    }
    
    func fetchSectionModels() -> [SectionModel] {
        return self.allSections
    }
    
    func createFileData(title: String, context: String) {
        guard let fileURL = self.txtFileManger.createTextFile(title: title, context: context) else { return }
        
        let newItem: TxtFileModel = .init(fileUrl: fileURL, title: title, subText: context)
        self.mainSectionItems.append(newItem)
        
        guard let mainSection else { return }
        
        let newSection: SectionModel = .init(original: mainSection, items: self.mainSectionItems)
        self.mainSection = newSection
        self.allSections = [newSection]
    }
    
    func removeFileData(with indexPath: [IndexPath]) {
        guard let sectionIndex = indexPath.first?.section, let rowIndex = indexPath.first?.row, var section = allSections[safe: sectionIndex], let item = section.items[safe: rowIndex] else { return }
        
        if self.txtFileManger.removeTextFile(with: item.fileUrl) {
            section.items.remove(at: sectionIndex)
            
            guard let mainSection else { return }
            
            let newSection: SectionModel = .init(original: mainSection, items: section.items)
            self.mainSection = newSection
            self.allSections[sectionIndex] = newSection
        }
    }
}

private extension RxDataSourceManager {
    
    func fetchFileDatas() {
        guard let fileURLs = self.txtFileManger.fetchAllTextFilesURL() else { return }
        
        var sectionItems: [TxtFileModel] = []
        
        fileURLs.forEach {
            guard let content = try? String(contentsOf: $0, encoding: .utf8) else { return }
            
            let title = $0.lastPathComponent
            let item: TxtFileModel = .init(fileUrl: $0, title: title, subText: content)
            
            sectionItems.append(item)
        }
        
        self.mainSectionItems = sectionItems
        
        let section: SectionModel = .init(header: "Main", items: sectionItems)
        self.mainSection = section
        self.allSections = [section]
    }
}
