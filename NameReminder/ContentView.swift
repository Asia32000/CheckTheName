//
//  ContentView.swift
//  Instafilter
//
//  Created by Joanna Staleńczyk on 11/01/2022.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var showingFilterSheet = false
    
    @State private var personName = ""
    
    @State var people = [Person]()
    
    @State var jpegData: Data
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPeople")
    
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add a new person")) {
                    ZStack {
                        if let image = image {
                            showImage
                        } else {
                            addPerson
                                .onTapGesture {
                                    showingImagePicker = true
                                }
                        }
                    }
                    .padding()
                    .onChange(of: inputImage) { _ in loadImage() }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $inputImage)
                    }
                }
                Section(header: Text("People")) {
                    ForEach(people.sorted(), id: \.id) {
                        NavigationLink($0.name, destination: DetailView(name: $0.name, data: $0.image ?? Data()))
                    }
                }
            }
            
            .navigationTitle("Check the name")
            .onAppear(perform: readData)
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
    
    @ViewBuilder
    var addPerson: some View {
        HStack {
            Image(systemName: "hand.tap")
            Text("Tap to select a picture")
        }
        .foregroundColor(.blue)
    }
    
    @ViewBuilder
    var showImage: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    showingImagePicker = true
                }
            TextField("Name:", text: $personName)
            Button {
                if !personName.isEmpty {
                    save(name: personName)
                }
            } label: {
                Text("Save")
                    .foregroundColor(.blue)
            }
        }
    }
}





