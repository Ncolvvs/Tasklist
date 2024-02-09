//
//  User.swift
//  TaskList
//
//  Created by Nicolas Santiago on 06-02-24.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var fullName: String
    var email: String
}
