//
//  TextFileManager.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/27.
//

import Foundation

struct TextFileManager {
    
    func fetchAllTextFilesURL() -> [URL]? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let fileLists = try? FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil) else { return nil }
        
        let txtFileLists = fileLists.filter { $0.lastPathComponent.hasSuffix(".txt") }
        
       return txtFileLists
    }
    
    func createTextFile(title: String, context: String) -> URL? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }

        var fileURL = documentURL

        if #available(iOS 16.0, *) {
            fileURL = documentURL.appending(path: "\(title).txt")
        } else {
            fileURL = documentURL.appendingPathComponent("\(title).txt")
        }
        
        do {
            try context.write(to: fileURL, atomically: true, encoding: .utf8)
            
            return fileURL
            
        } catch(let error) {
            NSLog("\(title) file can't create: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    func removeTextFile(with fileURL: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: fileURL)
            
            return true
            
        } catch(let error) {
            NSLog("This file can't remove: \(error.localizedDescription)")
            
            return false
        }
    }
}
