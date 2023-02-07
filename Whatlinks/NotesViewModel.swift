//
//  NotesViewModel.swift
//  Whatlinks
//
//  Created by Jhon Freiman Arias on 31/01/23.
//

import Foundation
import SwiftUI

final class NotesViewModel: ObservableObject {
    @Published var notes: [NoteModel] = []
    
    init() {
        notes = getAllNotes()
    }
    
    func saveNote(description: String) {
        let newNote = NoteModel(description: description) // inicializa el valor
        if !notes.contains(where: {$0.description == description}) {
            notes.insert(newNote, at: 0)
            encodeAndSaveAllNotes()
        }
        
    }
    
    private func encodeAndSaveAllNotes() {
        // JSONEncoder equal method JSON.Stringify in js
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
    
    func getAllNotes() -> [NoteModel] {
        if let notesData = UserDefaults.standard.object(forKey: "notes") as? Data {
            // JSONDecoder is equal at JSON.parse in js
            if let notes = try? JSONDecoder().decode([NoteModel].self, from: notesData) {
                return notes
            }
        }
        return []
    }
    
    func removeNote(id: String) {
        notes.removeAll(where: {$0.id == id})
        encodeAndSaveAllNotes()
    }
    
    func updateFavoriteNote(note: Binding<NoteModel>) {
        note.wrappedValue.isFavorited = !note.wrappedValue.isFavorited
        encodeAndSaveAllNotes()
    }
    
    func getNumbersOfNotes() -> String {
        return "\(notes.count)"
    }
}
