//
//  MainThoughtsView.swift
//  ThoughtsGoHere
//
//  Created by Grant Rosen on 10/2/20.
//

import SwiftUI

struct MainThoughtsView: View {
    
    @ObservedObject var thoughtListVM = ThoughtListViewModel()
    
    let thoughts = testThoughts
    
    @State var showNewThought = false
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                ForEach(thoughtListVM.thoughtCellVMs) { thoughtCellVM in
                    ThoughtCell(thoughtCellVM: thoughtCellVM)
                }
                if showNewThought {
                    //ThoughtCell(thoughtCellVM: ThoughtCellViewModel(thought: Thought(id: UUID().uuidString, title: "", body: "")))
                    ThoughtDetail(thought: Thought(title: "", body: ""))
                }
            }
            .padding(.horizontal)
            .padding(.top, 120)
            .background(gradientOrangeBlue).edgesIgnoringSafeArea(.all)
            .navigationTitle("Thoughts")
            .navigationBarItems(trailing:
                                    
                                    Button(action: {
                                            NSLog("New note created")
                                        self.showNewThought.toggle()
                                    }) {
                                        Image(systemName: "square.and.pencil").font(.system(size: 30.0))
                                    }
            )
        }.foregroundColor(Color.black)
        
    }
}

struct ThoughtDetail : View {
    
    @State var thought: Thought
    @State var isEditing = false
    
    var body: some View {
        
        TextEditor(text: $thought.body)
            .font(.subheadline)
            .foregroundColor(Color.black)
            .padding()
            .disabled(isEditing)
            .navigationBarTitle(thought.title)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.isEditing.toggle()
                                    }) {
                                        Text(isEditing ? "edit" : "done")
                                            .foregroundColor(.blue)
                                            .padding()
                                    }
            )
        
    }
}

struct ThoughtCell: View {
    
    @ObservedObject var thoughtCellVM : ThoughtCellViewModel
    
    var body: some View {
        NavigationLink(destination:
                        ThoughtDetail(thought: thoughtCellVM.thought)
                        .background(peach.opacity(0.5))
        ) {
            HStack {
                Image(systemName: "doc.text.viewfinder").font(.largeTitle)
                TextField("thought title...", text: $thoughtCellVM.thought.title)
                Spacer()
            }.padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(15)
        }
    }
}

struct MainThoughtsView_Previews: PreviewProvider {
    static var previews: some View {
        MainThoughtsView()
    }
}
