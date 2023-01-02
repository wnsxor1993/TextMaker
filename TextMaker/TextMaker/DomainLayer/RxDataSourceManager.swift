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
    private var mainSectionItems: [CellModel] = []
    
    private init() {
        self.fetchFileDatas()
    }
    
    func fetchSectionModels() -> [SectionModel] {
        
        return self.allSections
    }
    
    func createFileData(title: String, context: String) {
        guard let fileURL = self.txtFileManger.createTextFile(title: title, context: context) else { return }
        
        let newItem: TxtFileDTO = .init(fileUrl: fileURL, title: title, subText: context)
        self.mainSectionItems.insert(.textFile(newItem), at: 0)
        
        guard let mainSection else { return }
        
        let newSection: SectionModel = .init(original: mainSection, items: self.mainSectionItems)
        self.mainSection = newSection
        self.allSections = [newSection]
    }
    
    func modifyFileData(with model: CellModel, newTitle: String, newContext: String) {
        switch model {
        case .textFile(let txtFileDTO):
            guard self.txtFileManger.removeTextFile(with: txtFileDTO.fileUrl) else { return }
            
            for section in allSections {
                guard section.items.contains(.textFile(txtFileDTO)) else { break }
                
                let newItems = section.items.filter { $0 != .textFile(txtFileDTO) }
                self.mainSectionItems = newItems
                
                let newSection: SectionModel = .init(original: section, items: newItems)
                self.mainSection = newSection
                self.allSections = [newSection]
                
                self.createFileData(title: newTitle, context: newContext)
                
                return
            }
        }
    }
    
    func removeFileData(with indexPath: [IndexPath]) {
        guard let sectionIndex = indexPath.first?.section, let rowIndex = indexPath.first?.row, var section = allSections[safe: sectionIndex], let item = section.items[safe: rowIndex] else { return }
        
        switch item {
        case .textFile(let txtFileDTO):
            guard self.txtFileManger.removeTextFile(with: txtFileDTO.fileUrl) else { return }
            
            section.items.remove(at: rowIndex)
            self.mainSectionItems = section.items
            
            guard let mainSection else { return }
            
            let newSection: SectionModel = .init(original: mainSection, items: self.mainSectionItems)
            self.mainSection = newSection
            self.allSections = [newSection]
        }
    }
}

private extension RxDataSourceManager {
    
    func fetchFileDatas() {
        guard let fileURLs = self.txtFileManger.fetchAllTextFilesURL() else { return }
        
        var sectionItems: [CellModel] = []
        
        fileURLs.forEach {
            guard let content = try? String(contentsOf: $0, encoding: .utf8) else { return }
            
            let title = $0.lastPathComponent
            let originTitle = title.replacingOccurrences(of: ".txt", with: "")
            let item: TxtFileDTO = .init(fileUrl: $0, title: originTitle, subText: content)
            
            sectionItems.append(.textFile(item))
        }
        
        self.mainSectionItems = sectionItems
        
        let section: SectionModel = .init(header: "Main", items: sectionItems)
        self.mainSection = section
        self.allSections = [section]
    }
}
