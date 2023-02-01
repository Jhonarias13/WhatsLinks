//
//  ContentView.swift
//  Whatlinks
//
//  Created by Jhon Freiman Arias on 31/01/23.
//

import SwiftUI

struct ContentView: View {
    @State var descriptionNote: String = ""
    @State var phoneNumber: String = ""
    @StateObject var notesViewModel = NotesViewModel()
    private enum Field: Int, CaseIterable {
            case phoneNumber
        }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Ingresa un numero de teléfono")
                    .underline()
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                TextEditor(text: $phoneNumber)
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .font(.system(size: 24.0))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.green, lineWidth: 2)
                    )
                    .focused($focusedField, equals: .phoneNumber)
                    .padding(.horizontal, 12)
                    .cornerRadius(3.0)
                Button("Click para chatear"){
                    if let url = URL(string: "https://api.whatsapp.com/send/?phone=57\(phoneNumber)") {
                        UIApplication.shared.open(url)
                        phoneNumber = ""
                        focusedField = nil
                    }
                }
                .buttonStyle(.bordered)
                .tint(.green)
                .padding(.top, 12)
                Spacer()
                List {
                    ForEach($notesViewModel.notes, id: \.id) { $note in
                        HStack {
                            if note.isFavorited {
                                Text("⭐️")
                            }
                            Text(note.description)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                notesViewModel.updateFavoriteNote(notes: $note)
                            } label: {
                                Label("Favorito", systemImage: "star.fill")
                            }
                            .tint(.yellow)
                        }.swipeActions(edge: .leading) {
                            Button {
                                notesViewModel.removeNote(id:  note.id)
                            } label : {
                                Label("Borrar", systemImage: "trash.fill")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            .navigationTitle("WhatLinks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
