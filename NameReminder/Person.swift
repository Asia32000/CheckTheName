//
//  Person.swift
//  NameReminder
//
//  Created by Joanna Staleńczyk on 20/01/2022.
//

import Foundation
import SwiftUI

struct Person: Identifiable, Codable, Equatable, Comparable {
    var id = UUID()
    var name: String
    var image: Data?
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
}
