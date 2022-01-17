//
//  MainThoughtsView.swift
//  ThoughtsGoHere
//
//  Created by Grant Rosen on 10/2/20.
//

import SwiftUI

struct MainThoughtsView: View {
    
    @ObservedObject var thoughtListVM = ThoughtListViewModel()
    
    //let thoughts = testThoughts
    
    @State var showNewThought = false
    @State private var isRotated = false
    var newThought = Thought(title: "", body: "")
    
    var body: some View {
        
        NavigationView {
        VStack {
            ZStack {
                VStack {
                    /*
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.thoughtListVM.inEditMode.toggle()
                            }
                        }){
                            Text(self.thoughtListVM.inEditMode ? "done" : "edit")
                                .padding([.vertical, .trailing])
                                .padding(.leading, 15)
                        }.foregroundColor(offWhite)
                        
                        Spacer()
                        Button(action: {
                            NSLog("New note created")
                            self.thoughtListVM.showSheet = true
                        }) {
                            Image(systemName: "square.and.pencil").font(.system(size: 30.0))
                        }
                    }
                    */
                    /*
                    HStack {
                        Text("Thoughts").font(.system(size: 25)).bold()
                        Spacer()
                    }
                    */
                    
                    
                    List {
                        ForEach(self.thoughtListVM.thoughts) { thought in
                            Text(thought.title ?? "")
                        }
                    }
                    
                }.zIndex(3)
                .padding(.top)
                
                VStack {
                    ZStack {
                        Image("thoughts-logo-flares")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                        Image("thoughts-logo-flares")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                        Image(systemName: "lightbulb.fill").foregroundColor(Color.black)
                            .font(.system(size: 30))
                    }
                    Spacer()
                }
                .zIndex(2)
            }
        }
        .foregroundColor(offBlack)
        //.background(gradientOrangeBlue)
        .navigationTitle("Thoughts")
        }
        .sheet(isPresented: self.$thoughtListVM.showSheet) {
            ThoughtDetail(thoughtListVM: self.thoughtListVM, thought: self.newThought)
                .background(gradientOrangeBlue).edgesIgnoringSafeArea(.all)
        }
        
        .onAppear() {
            self.isRotated = true
        }
    }
}

struct ThoughtDetail : View {
    
    @ObservedObject var thoughtListVM : ThoughtListViewModel
    @State var thought: Thought
    
    var body: some View {
        
        GeometryReader {geometry in
            VStack {
                HStack(alignment: .center) {
                    
                    TextField("New thought", text: self.$thoughtListVM.newThoughtTitle)
                        .font(.system(size: 30))
                    Spacer()
                    
                    Button(action: {
                        self.thoughtListVM.addThought(title: self.thoughtListVM.newThoughtTitle, body: self.thoughtListVM.newThoughtBody)
                        self.thoughtListVM.showSheet = false
                        /*
                        self.thoughtListVM.selectedThoughtCellVM = nil
                        */
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
                        TextEditor(text: self.$thoughtListVM.newThoughtBody)
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
    @State var thought: Thought
    
    var body: some View {
        
        VStack {
            
            HStack {
                if self.thought.title != "" {
                    Text(self.thought.title ?? "").foregroundColor(offBlack)
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
                Text(self.thought.body ?? "")
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
            //self.thoughtListVM.selectedThoughtCellVM = thoughtCellVM
            self.thoughtListVM.showSheet = true
        }
    }
}

struct MainThoughtsView_Previews: PreviewProvider {
    static var previews: some View {
        MainThoughtsView()
    }
}
