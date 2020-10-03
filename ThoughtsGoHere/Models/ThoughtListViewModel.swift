//
//  ThoughtListViewModel.swift
//  ThoughtsGoHere
//
//  Created by Grant Rosen on 10/3/20.
//

import Foundation
import Combine

class ThoughtListViewModel: ObservableObject {
    @Published var thoughtCellVMs = [ThoughtCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.thoughtCellVMs = testThoughts.map { thought in
            ThoughtCellViewModel(thought: thought)
        }
    }
}
