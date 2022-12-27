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
    
    func modifyFileData(with model: TxtFileModel, newTitle: String, newContext: String) {
        guard self.txtFileManger.removeTextFile(with: model.fileUrl) else { return }
        
        for section in allSections {
            guard section.items.contains(model) else { break }
            
            let newItems = section.items.filter { $0 != model }
            self.mainSectionItems = newItems
            
            let newSection: SectionModel = .init(original: section, items: newItems)
            self.mainSection = newSection
            self.allSections = [newSection]
            
            self.createFileData(title: newTitle, context: newContext)
            
            return
        }
    }
    
    func removeFileData(with indexPath: [IndexPath]) {
        guard let sectionIndex = indexPath.first?.section, let rowIndex = indexPath.first?.row, var section = allSections[safe: sectionIndex], let item = section.items[safe: rowIndex] else { return }
        
        if self.txtFileManger.removeTextFile(with: item.fileUrl) {
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
        
        var sectionItems: [TxtFileModel] = []
        
        fileURLs.forEach {
            guard let content = try? String(contentsOf: $0, encoding: .utf8) else { return }
            
            let title = $0.lastPathComponent
            let originTitle = title.replacingOccurrences(of: ".txt", with: "")
            let item: TxtFileModel = .init(fileUrl: $0, title: originTitle, subText: content)
            
            sectionItems.append(item)
        }
        
        self.mainSectionItems = sectionItems
        
        let section: SectionModel = .init(header: "Main", items: sectionItems)
        self.mainSection = section
        self.allSections = [section]
    }
}
