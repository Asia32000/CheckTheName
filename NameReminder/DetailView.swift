//
//  DetailView.swift
//  NameReminder
//
//  Created by Joanna Staleńczyk on 20/01/2022.
//

import SwiftUI
import MapKit

struct DetailView: View {
    let name: String
    let data: Data
    var longitude: Double
    var latitude: Double
    
    var body: some View {
        VStack {
            Text(name)
                .font(.title)
                .padding(.bottom, 18)
            if let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                    .padding(.bottom, 18)
            }
            Text("You met here:")
                .font(.title2)
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))
                
            Spacer()
        }
    }
}

