//
//  ThoughtListViewModel.swift
//  ThoughtsGoHere
//
//  Created by Grant Rosen on 10/3/20.
//

import Foundation
import Combine
import FirebaseFirestore

class ThoughtListViewModel: ObservableObject {
    @Published var thoughtCellVMs = [ThoughtCellViewModel]()
    @Published var showSheet = false
    @Published var selectedThoughtCellVM: ThoughtCellViewModel?
    @Published var newThoughtTitle = ""
    @Published var newThoughtBody = ""
    @Published var inEditMode = false
    @Published var thoughts = [Thought]()
    
    private var cancellables = Set<AnyCancellable>()
    private var db = Firestore.firestore()
    
    
    /*
    init() {
        self.thoughtCellVMs = thoughts.map { thought in
            ThoughtCellViewModel(thought: thought)
        }
    }
    */
    init() {
        self.fetchData()
    }
    
    
    func deleteThought(thought: Thought) {
        //thoughtCellVMs = thoughtCellVMs.filter() { $0 !== element }
        db.collection("thoughts").document(thought.id).delete() { err in
            if let err = err {
              print("Error removing document: \(err)")
            }
            else {
                self.fetchData()
            
              print("Document successfully removed!")
            }
          }
        //thoughts = thoughts.filter() {$0.title !== thought.title}
        //thoughts.remove(at: )
    
    }
    
    func fetchData() {
            db.collection("thoughts").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.thoughts = documents.map { (queryDocumentSnapshot) -> Thought in
                    let data = queryDocumentSnapshot.data()
                    let title = data["title"] as? String ?? ""
                    let body = data["body"] as? String ?? ""
                    return Thought(title: title, body: body)
                }
            }
        }
    
    func addThought(title: String, body: String) {
            do {
                let data = ["title": title, "body": body] as [String : Any]
                try db.collection("thoughts").addDocument(data: data)
            }
            catch {
                print(error.localizedDescription)
            }
        }
}
