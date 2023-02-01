//
//  NoteModel.swift
//  Whatlinks
//
//  Created by Jhon Freiman Arias on 31/01/23.
//

import Foundation

// crea modelo de datos de la nota
struct NoteModel: Codable {
    let id: String
    var isFavorited: Bool
    let description: String
    
    init(id: String = UUID().uuidString, isFavorited: Bool = false, description: String) {
        self.id = id
        self.isFavorited = isFavorited
        self.description = description
    }
}
