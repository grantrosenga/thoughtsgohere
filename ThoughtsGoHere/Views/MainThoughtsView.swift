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
                                        let newThoughtModel = ThoughtCellViewModel(thought: Thought(title: self.thoughtListVM.newThoughtTitle, body: self.thoughtListVM.newThoughtBody))
                                        self.thoughtListVM.thoughtCellVMs.append(newThoughtModel)
                                        self.thoughtListVM.selectedThoughtCellVM = newThoughtModel
                                        self.thoughtListVM.showSheet = true
                                    }) {
                                        Image(systemName: "square.and.pencil").font(.system(size: 30.0))
                                    }
            )
        }.foregroundColor(Color.black)
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
                    Image(systemName: "doc.plaintext").font(.system(size: 40)).foregroundColor(offBlack)
                    TextField("New thought", text: self.$thoughtCellVM.thought.title)
                        .font(.system(size: 30, weight: .heavy, design: .default))
                        .padding(.leading, 5)
                    Spacer()
                    
                    Button(action: {
                        self.thoughtListVM.showSheet = false
                        self.thoughtListVM.selectedThoughtCellVM = nil
                    }) {
                        Text("D O N E")
                            .foregroundColor(.blue)
                            .font(.system(size: 15))
                            .bold()
                            .padding(5)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(10)
                            .clipped()
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 0)
                    }
                }.padding()
                .padding(.top)
                
                HStack {
                    TextEditor(text: self.$thoughtCellVM.thought.body)
                        .font(.system(size: 20))
                        .foregroundColor(Color.black.opacity(0.5))
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.65))
                .padding(.horizontal)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white.opacity(0.5))
            
        }
        
    }
}

struct ThoughtCell: View {
    
    @ObservedObject var thoughtListVM : ThoughtListViewModel
    @ObservedObject var thoughtCellVM : ThoughtCellViewModel
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "doc.plaintext").font(.system(size: 40)).foregroundColor(offBlack)
                if thoughtCellVM.thought.title != "" {
                    Text(thoughtCellVM.thought.title).foregroundColor(Color.black)
                        .font(.system(size: 30, weight: .heavy, design: .default))
                        .padding(.leading, 5)
                } else {
                    Text("New thought").foregroundColor(Color.secondary)
                        .font(.title).bold()
                        .font(.system(size: 30, weight: .heavy, design: .default))
                        .padding(.leading, 5)
                }
                Spacer()
            }.padding()
            
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
