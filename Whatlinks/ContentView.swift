//
//  ContentView.swift
//  Whatlinks
//
//  Created by Jhon Freiman Arias on 31/01/23.
//

import SwiftUI

struct ContentView: View {
    @State var phoneNumber: String = ""
    @StateObject var notesViewModel = NotesViewModel()
    @State var showValidation: Bool = false
    @State var msgAlert: String = ""
    @State var colorAlert: Color = .gray
    @State var isNumberValid: Bool = false
    
    
    private enum Field: Int, CaseIterable {
            case phoneNumber
        }
    
    @FocusState private var focusedField: Field?
    
    private func sendLink() {
        if let url = URL(string: "https://wa.me/57\(phoneNumber)") {
            UIApplication.shared.open(url)
            notesViewModel.saveNote(description: phoneNumber)
            phoneNumber = ""
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Inicia conversaciones más rápidas en Whatsapp sin necesidad de guardar contactos innecesarios.")
                    .foregroundColor(.gray)
                    .fontWeight(.light)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("No hace falta agregar el indicativo del país.")
                    .underline()
                    .font(.system(size: 14.0))
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                HStack{
                    TextField("Ingresa un número de teléfono",text: $phoneNumber)
                        .padding()
                        .foregroundColor(colorAlert)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .phoneNumber)
                        .onChange(of: phoneNumber) { phoneNumber in
                            let countPhoneNumber = phoneNumber.count
                            
                            switch countPhoneNumber {
                            case 11...100:
                                msgAlert = "exclamationmark.circle"
                                colorAlert = .red
                                showValidation = true
                                isNumberValid = false
                            case 1..<10:
                                msgAlert = "exclamationmark.circle"
                                colorAlert = .orange
                                showValidation = true
                                isNumberValid = false
                            case 10:
                                msgAlert = "checkmark.circle"
                                colorAlert = .green
                                showValidation = true
                                isNumberValid = true
                            default:
                                showValidation = false
                                isNumberValid = false
                                colorAlert = .gray
                            }
                        }
                    
                        if showValidation {
                            Image(systemName: msgAlert)
                                .padding()
                                .foregroundColor(colorAlert)
                        }
                }
                .overlay(RoundedRectangle(cornerRadius: 50.0).strokeBorder(colorAlert, style: StrokeStyle(lineWidth: 0.4)))
                .padding()
                .padding(.bottom, 0)

                
                Button("ir a whatsapp"){
                    sendLink()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .cornerRadius(25.0)
                .frame(height: 50)
                .tint(.green)
                .disabled(!isNumberValid)
                .padding(.bottom, 18.0)
                
                if notesViewModel.notes.count > 0 {
                    List {
                        Section(header: Text("Historial"), footer: Text("Total registrados: \(notesViewModel.getNumbersOfNotes())")) {
                            ForEach($notesViewModel.notes, id: \.id) {$note in
                                HStack {
                                    if note.isFavorited {
                                        Text("⭐️")
                                    }
                                    Text(note.description)
                                    Spacer()
                                    Button{
                                      phoneNumber = note.description
                                      sendLink()
                                    } label: {
                                      Image(systemName: "arrowshape.turn.up.right")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        notesViewModel.updateFavoriteNote(note: $note)
                                    } label : {
                                        Label("Favorito", systemImage: "star.fill")
                                    }
                                    .tint(.yellow)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        notesViewModel.removeNote(id: note.id)
                                    } label : {
                                        Label("Eliminar", systemImage: "trash.fill")
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                    }
                    .listStyle(.grouped)
                }

                
                Spacer()
            }
            .navigationTitle("WhatLinks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                  Spacer()
                }
                ToolbarItem(placement: .keyboard) {
                  Button("Listo") {
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
    }
}
