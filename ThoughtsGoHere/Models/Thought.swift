//
//  Thought.swift
//  ThoughtsGoHere
//
//  Created by Grant Rosen on 10/3/20.
//

import Foundation

struct Thought: Identifiable {
    var id: String = UUID().uuidString
    var title : String
    var body : String
}

#if DEBUG
let testThoughts = [
    Thought(title: "test", body: "this is a test"),
    Thought(title: "grants goodies", body: "cookies, swag, gelatin"),
    Thought(title: "test2", body: "this is a test2")
]
#endif
