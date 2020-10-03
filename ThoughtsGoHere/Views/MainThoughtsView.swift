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
                    ThoughtCell(thoughtListVM: self.thoughtListVM, thoughtCellVM: thoughtCellVM)
                }
            }
            .padding(.horizontal)
            .padding(.top, 120)
            .background(gradientOrangeBlue).edgesIgnoringSafeArea(.all)
            .navigationTitle("Thoughts")
            .navigationBarItems(trailing:
                                    
                                    Button(action: {
                                        NSLog("New note created")
                                        //self.showNewThought.toggle()
                                        self.thoughtListVM.thoughtCellVMs.append(ThoughtCellViewModel(thought: Thought(title: "-untitled-", body: "")))
                                        self.thoughtListVM.selectedThoughtCellVM =
                                            ThoughtCellViewModel(thought: Thought(title: "", body: ""))
                                            
                                        self.thoughtListVM.showSheet = true
                                        
                                    }) {
                                        Image(systemName: "square.and.pencil").font(.system(size: 30.0))
                                    }
            )
        }.foregroundColor(Color.black)
        .sheet(isPresented: self.$thoughtListVM.showSheet) {
            ThoughtDetail(thoughtListVM: self.thoughtListVM, thoughtCellVM: thoughtListVM.selectedThoughtCellVM ?? ThoughtCellViewModel(thought: Thought(title: "", body: "")))
        }
    }
}

struct ThoughtDetail : View {
    
    @ObservedObject var thoughtListVM : ThoughtListViewModel
    @ObservedObject var thoughtCellVM : ThoughtCellViewModel
    
    var body: some View {
        
        VStack {
            
            HStack {
                TextField("thought title...", text: self.$thoughtCellVM.thought.title)
                    .font(.system(size: 30, weight: .heavy, design: .default))
                    .padding(.leading)
                Spacer()
                Button(action: {
                    self.thoughtListVM.showSheet = false
                    self.thoughtListVM.selectedThoughtCellVM = nil
                }) {
                    Text("done")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                        .padding()
                }
            }
            
            TextEditor(text: self.$thoughtCellVM.thought.body)
                .font(.system(size: 15))
                .foregroundColor(Color.black)
                .padding()
                //.disabled(isEditing)
                .background(Color.white.opacity(0.6))
                .cornerRadius(10)
                .clipped()
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 0)
                
            Spacer()
            
        }.padding([.top, .horizontal])
        .background(peach).edgesIgnoringSafeArea(.all)
    }
}

struct ThoughtCell: View {
    
    @ObservedObject var thoughtListVM : ThoughtListViewModel
    @ObservedObject var thoughtCellVM : ThoughtCellViewModel
    
    var body: some View {
        
        HStack {
            Image(systemName: "doc.text.viewfinder").font(.largeTitle)
            Text(thoughtCellVM.thought.title)
            Spacer()
        }.padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(15)
        .onTapGesture {
            self.thoughtListVM.selectedThoughtCellVM = thoughtCellVM
            self.thoughtListVM.showSheet = true
        }
    }
}

struct MainThoughtsView_Previews: PreviewProvider {
    static var previews: some View {
        MainThoughtsView()
    }
}
