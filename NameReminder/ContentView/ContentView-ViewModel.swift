//
//  ContentView-ViewModel.swift
//  NameReminder
//
//  Created by Joanna Staleńczyk on 21/01/2022.
//

import Foundation
import SwiftUI
import UIKit
import MapKit

extension ContentView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published var image: Image?
        
        @Published var showingImagePicker = false
        @Published var inputImage: UIImage?
        
        @Published var showingFilterSheet = false
        
        @Published var personName = ""
        @Published var personLongitude = 0.0
        @Published var personLatitude = 0.0

        
        @Published var people: [Person]
        
        @Published var jpegData = Data()
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPeople")
        
        let locationFetcher = LocationFetcher()
        
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
                let newPerson = Person(id: UUID(), name: name, image: jpegData, longitude: personLongitude, latitude: personLatitude)
                return newPerson
            }
            return Person(id: UUID(), name: "", image: Data(), longitude: 0.0, latitude: 0.0)
            
        }
        
        func save(name: String) {
            if let inputImage = inputImage {
                let jpegData = inputImage.jpegData(compressionQuality: 0.8)
                let newPerson = Person(id: UUID(), name: name, image: jpegData, longitude: personLongitude, latitude: personLatitude)
                people.append(newPerson)
                try? jpegData?.write(to: savePath, options: [.atomic, .completeFileProtection])
                do {
                    let data = try JSONEncoder().encode(people)
                    try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
                    personName = ""
                    image = nil
                    print("Saved location: \(personLongitude), \(personLatitude)")
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
