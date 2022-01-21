//
//  DetailView.swift
//  NameReminder
//
//  Created by Joanna Staleńczyk on 20/01/2022.
//

import SwiftUI

struct DetailView: View {
    let name: String
    let data: Data
    var body: some View {
        VStack {
            Text(name)
                .font(.title)
                .padding(.bottom, 36)
            if let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
            }
            Spacer()
        }
    }
}

