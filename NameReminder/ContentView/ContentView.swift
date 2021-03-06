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
    
    @StateObject private var viewModel = ViewModel()
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button {
                        self.viewModel.locationFetcher.start()
                    } label: {
                        HStack {
                            Image(systemName: "location.circle")
                            Text("Start tracking location")
                        }
                    }
                    
                    Button("Read Location") {
                        if let location = self.viewModel.locationFetcher.lastKnownLocation {
                            print("Your location is \(location)")
                            viewModel.personLatitude = location.latitude
                            viewModel.personLongitude = location.longitude
                        } else {
                            print("Your location is unknown")
                        }
                    }
                }
                
                Section(header: Text("Add a new person")) {
                    ZStack {
                        if let image = viewModel.image {
                            showImage
                        } else {
                            addPerson
                                .onTapGesture {
                                    viewModel.showingImagePicker = true
                                }
                        }
                    }
                    .padding()
                    .onChange(of: viewModel.inputImage) { _ in viewModel.loadImage() }
                    .sheet(isPresented: $viewModel.showingImagePicker) {
                        ImagePicker(image: $viewModel.inputImage)
                    }
                }
                Section(header: Text("People")) {
                    ForEach(viewModel.people.sorted(), id: \.id) {
                        NavigationLink($0.name, destination: DetailView(name: $0.name, data: $0.image ?? Data(), longitude: $0.longitude ?? 0.0, latitude: $0.latitude ?? 0.0))
                    }
                }
            }
            .navigationTitle("Check the name")
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
            viewModel.image?
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    viewModel.showingImagePicker = true
                }
            TextField("Name:", text: $viewModel.personName)
            Button {
                if !viewModel.personName.isEmpty {
                    viewModel.save(name: viewModel.personName)
                }
            } label: {
                Text("Save")
                    .foregroundColor(.blue)
            }
        }
    }
}





