//
//  SharedTask.swift
//  TaskList
//
//  Created by Nicolas Santiago on 06-02-24.
//

import Foundation

struct SharedTask: Identifiable, Hashable, Encodable {
    var id: String
    var task_id: String
    var user_id: String
        
    enum CodingKeys: String, CodingKey {
        case task_id
        case user_id
    }
}
