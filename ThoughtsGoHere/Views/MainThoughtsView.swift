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
        
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        self.thoughtListVM.inEditMode.toggle()
                    }
                }){
                    Text(self.thoughtListVM.inEditMode ? "done" : "edit")
                        .padding([.vertical, .trailing])
                }
                Spacer()
                Button(action: {
                    NSLog("New note created")
                    let newThoughtModel = ThoughtCellViewModel(thought: Thought(title: self.thoughtListVM.newThoughtTitle, body: self.thoughtListVM.newThoughtBody))
                    self.thoughtListVM.thoughtCellVMs.append(newThoughtModel)
                    self.thoughtListVM.selectedThoughtCellVM = newThoughtModel
                    self.thoughtListVM.showSheet = true
                }) {
                    Image(systemName: "square.and.pencil").font(.system(size: 30.0))
                }
            }
            HStack {
                Text("Thoughts").font(.largeTitle).bold()
                Spacer()
            }
            ScrollView {
                ForEach(thoughtListVM.thoughtCellVMs) { thoughtCellVM in
                    HStack {
                        ThoughtCell(thoughtListVM: self.thoughtListVM, thoughtCellVM: thoughtCellVM)
                            .clipped()
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 0)
                            .padding(.bottom, 5)
                        
                        if self.thoughtListVM.inEditMode {
                            Button(action: {
                                NSLog("Deleted thought: \(thoughtCellVM.thought.title)")
                                withAnimation {
                                    self.thoughtListVM.deleteItem(element: thoughtCellVM)
                                }
                            }) {
                                Image(systemName: "trash.fill").font(.title).foregroundColor(Color.red.opacity(0.8))
                                    .padding()
                            }
                        }
                    }
                }
            }
        }
        .foregroundColor(offBlack)
        .padding(.horizontal)
        .padding(.top, 30)
        .background(gradientOrangeBlue).edgesIgnoringSafeArea(.all)
        .sheet(isPresented: self.$thoughtListVM.showSheet) {
            ThoughtDetail(thoughtListVM: self.thoughtListVM, thoughtCellVM: thoughtListVM.selectedThoughtCellVM ?? ThoughtCellViewModel(thought: Thought(title: "", body: "")))
                .background(gradientOrangeBlue).edgesIgnoringSafeArea(.all)
        }
    }
}

struct ThoughtDetail : View {
    
    @ObservedObject var thoughtListVM : ThoughtListViewModel
    @ObservedObject var thoughtCellVM : ThoughtCellViewModel
    
    var body: some View {
        
        GeometryReader {geometry in
            VStack {
                HStack(alignment: .center) {
                    
                    TextField("New thought", text: self.$thoughtCellVM.thought.title)
                        .font(.system(size: 30))
                    Spacer()
                    
                    Button(action: {
                        self.thoughtListVM.showSheet = false
                        self.thoughtListVM.selectedThoughtCellVM = nil
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(offBlack)
                            .font(.system(size: 35))
                            .padding(5)
                    }
                }.padding(5)
                .padding([.top, .horizontal])
                
                ZStack {
                    Image(systemName: "lightbulb").font(.system(size: 60)).foregroundColor(offBlack).opacity(0.1)
                    HStack {
                        TextEditor(text: self.$thoughtCellVM.thought.body)
                            .font(.system(size: 20))
                            .foregroundColor(Color.black.opacity(0.65))
                            .padding(.leading, 5)
                        Spacer()
                    }
                }
                .padding(5)
                .background(Color.white.opacity(0.6))
                .cornerRadius(5)
                .padding(.horizontal, 10)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white.opacity(0.4))
            
        }
        
    }
}

struct ThoughtCell: View {
    
    @ObservedObject var thoughtListVM : ThoughtListViewModel
    @ObservedObject var thoughtCellVM : ThoughtCellViewModel
    
    var body: some View {
        
        VStack {
            
            HStack {
                if thoughtCellVM.thought.title != "" {
                    Text(thoughtCellVM.thought.title).foregroundColor(offBlack)
                        .font(.system(size: 30))
                } else {
                    Text("New thought").foregroundColor(Color.secondary)
                        .font(.system(size: 30))
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.vertical, 10)
            
            HStack {
                Text(thoughtCellVM.thought.body)
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
                    .lineLimit(1)
                Spacer()
            }.padding()
            .background(Color.white.opacity(0.65))
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
        }
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
