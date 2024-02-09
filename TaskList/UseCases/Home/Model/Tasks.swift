//
//  Home.swift
//  TaskList
//
//  Created by Nicolas Santiago on 05-02-24.
//

import Foundation

struct Tasks: Identifiable, Hashable, Encodable {
    var id: String
    var title: String
    var completed: Bool
    var user_id: String
        
    enum CodingKeys: String, CodingKey {
        case title
        case completed
        case user_id
    }
}
