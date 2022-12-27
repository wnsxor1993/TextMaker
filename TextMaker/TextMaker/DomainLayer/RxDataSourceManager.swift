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
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentURL.appendingPathExtension("\(title).txt")
        
        do {
            try context.write(to: fileURL, atomically: true, encoding: .utf8)
            
            let newItem: TxtFileModel = .init(fileUrl: fileURL, title: title, subText: context)
            self.mainSectionItems.append(newItem)
            
            guard let mainSection else { return }
            
            let newSection: SectionModel = .init(original: mainSection, items: self.mainSectionItems)
            self.mainSection = newSection
            self.allSections = [newSection]
            
        } catch {
            NSLog("\(title) file can't create")
            
            return
        }
    }
    
    func removeFileData(with indexPath: [IndexPath]) {
        guard let sectionIndex = indexPath.first?.section, let rowIndex = indexPath.first?.row, var section = allSections[safe: sectionIndex], let item = section.items[safe: rowIndex] else { return }
        
        do {
            try FileManager.default.removeItem(at: item.fileUrl)
            
            section.items.remove(at: sectionIndex)
            
            guard let mainSection else { return }
            
            let newSection: SectionModel = .init(original: mainSection, items: section.items)
            self.mainSection = newSection
            self.allSections[sectionIndex] = newSection
            
        } catch {
            NSLog("\(item.title) file can't remove")
            
            return
        }
    }
}

private extension RxDataSourceManager {
    
    func fetchFileDatas() {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let fileLists = try? FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil) else { return }
        
        var sectionItems: [TxtFileModel] = []
        
        fileLists.forEach {
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
