//
//  FileManagerNotesRepositoryImpl.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import Foundation

class FileManagerNotesRepositoryImpl: NotesRepository {
    
    private var fileManager: FileManager
    private var fileUrl: URL?
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        fileName: String = "notes.json",
        fileManager: FileManager = FileManager.default,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileManager = fileManager
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        self.fileUrl = fileName.isEmpty ? nil : documentDirectory?.appendingPathComponent(fileName)
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func add(note: Note) {
        var notes: [Note] = []
        fetchNotes { [weak self] result in
            notes = result
            notes.append(note)
            self?.saveNotesToFile(notes)
        }
    }
    
    func fetchNotes(completion: @escaping ([Note]) -> Void) {
        var notes: [Note] = []
        guard let fileUrl else {
            print("File URL does not exist")
            completion(notes)
            return
        }
        
        do {
            let notesData = try Data(contentsOf: fileUrl)
            notes = try decoder.decode([Note].self, from: notesData)
        } catch {
            print("There was trouble fetching notes from file \(error.localizedDescription)")
            notes = []
        }
        
        completion(notes)
    }
    
    private func saveNotesToFile(_ notes: [Note]) {
        guard let fileUrl else { return }
        do {
            let notesData = try encoder.encode(notes)
            try notesData.write(to: fileUrl)
        } catch {
            print("There was trouble saving notes to file \(error.localizedDescription)")
        }
    }
    
    func removeAllNotesFile() {
        guard let fileUrl else { return }
        do {
            try fileManager.removeItem(at: fileUrl)
        } catch {
            print("There was trouble removing file \(error.localizedDescription)")
        }
    }
}
