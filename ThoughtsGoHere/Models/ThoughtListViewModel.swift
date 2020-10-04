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
    @Published var showSheet = false
    @Published var selectedThoughtCellVM: ThoughtCellViewModel?
    @Published var newThoughtTitle = ""
    @Published var newThoughtBody = ""
    @Published var inEditMode = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.thoughtCellVMs = testThoughts.map { thought in
            ThoughtCellViewModel(thought: thought)
        }
    }
    
    func deleteItem(element: ThoughtCellViewModel) {
        thoughtCellVMs = thoughtCellVMs.filter() { $0 !== element }
    }
}
