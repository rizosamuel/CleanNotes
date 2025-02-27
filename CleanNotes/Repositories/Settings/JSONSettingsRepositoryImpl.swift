//
//  JSONSettingsRepositoryImpl.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 24/01/25.
//

import Foundation

class JSONSettingsRepositoryImpl: SettingsRepository {
    
    private let bundle: Bundle
    private let fileName: String
    
    init(bundle: Bundle = Bundle.main, fileName: String = "Settings") {
        self.bundle = bundle
        self.fileName = fileName
    }
    
    func fetchSettings(completion: @escaping ([SettingSection]) -> Void) {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            print("Failed to locate \(fileName).json in bundle.")
            completion([])
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let sections = try JSONDecoder().decode([SettingSection].self, from: data)
            completion(sections)
        } catch {
            print("Failed to decode \(fileName).json: \(error)")
            completion([])
        }
    }
}
