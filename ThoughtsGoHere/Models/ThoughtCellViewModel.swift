//
//  ThoughtCellViewModel.swift
//  ThoughtsGoHere
//
//  Created by Grant Rosen on 10/3/20.
//

import Foundation
import Combine

class ThoughtCellViewModel: ObservableObject, Identifiable {
    @Published var thought: Thought
    var id = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(thought: Thought) {
        self.thought = thought
        
        $thought.map {thought in
            thought.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
    }
}
