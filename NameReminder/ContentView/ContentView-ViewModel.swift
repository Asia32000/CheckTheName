//
//  ContentView-ViewModel.swift
//  NameReminder
//
//  Created by Joanna Staleńczyk on 21/01/2022.
//

import Foundation
import SwiftUI
import UIKit

extension ContentView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published var image: Image?
        
        @Published var showingImagePicker = false
        @Published var inputImage: UIImage?
        
        @Published var showingFilterSheet = false
        
        @Published var personName = ""
        
        @Published var people: [Person]
        
        @Published var jpegData = Data()
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPeople")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                people = try JSONDecoder().decode([Person].self, from: data)
            } catch {
                people = []
            }
        }
        
        func loadImage() {
            if let inputImage = inputImage {
                image = Image(uiImage: inputImage)
            }
        }
        
        func createPerson(name: String) -> Person {
            if let inputImage = inputImage {
                jpegData = inputImage.jpegData(compressionQuality: 0.8) ?? Data()
                let newPerson = Person(id: UUID(), name: name, image: jpegData)
                return newPerson
            }
            return Person(id: UUID(), name: "", image: Data())
            
        }
        
        func save(name: String) {
            if let inputImage = inputImage {
                let jpegData = inputImage.jpegData(compressionQuality: 0.8)
                let newPerson = Person(id: UUID(), name: name, image: jpegData)
                people.append(newPerson)
                try? jpegData?.write(to: savePath, options: [.atomic, .completeFileProtection])
                do {
                    let data = try JSONEncoder().encode(people)
                    try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
                    personName = ""
                    image = nil
                } catch {
                    print("Unable to save data.")
                }
            }
        }
        
        func readData() {
            do {
                let data = try Data(contentsOf: savePath)
                people = try JSONDecoder().decode([Person].self, from: data)
            } catch {
                people = []
            }
        }
    }
}
