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
    var count = 0
    
    var animation: Animation {
        Animation.easeInOut(duration: 5)
            .repeatForever(autoreverses: false)
    }
    
    var animation2: Animation {
        Animation.linear(duration: 5)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                VStack {
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
                    
                    HStack {
                        Text("Thoughts").font(.system(size: 25)).bold()
                        Spacer()
                    }
                    
                    ScrollView {
                        
                        ForEach(self.thoughtListVM.thoughts) { thought in
                            HStack {
                                ThoughtCell(thoughtListVM: self.thoughtListVM, thoughtCellVM: ThoughtCellViewModel(thought: thought))
                                .clipped()
                                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 0)
                                .padding(.bottom, 5)
                                
                                if self.thoughtListVM.inEditMode {
                                    Button(action: {
                                        //NSLog("Deleted thought: \(thoughtVM.thought.title)")
                                        withAnimation {
                                            thoughtListVM.deleteThought(thought: thought)
                                            thoughtListVM.thoughts.removeAll {
                                                $0.id == thought.id
                                            }
                                        }
                                    }) {
                                        Image(systemName: "trash.fill").font(.title).foregroundColor(Color.red.opacity(0.8))
                                            .padding()
                                    }
                                }
                            }
                        }
                    }.background(gradientOrangeBlue).edgesIgnoringSafeArea(.all)
                    .cornerRadius(15)
                }.zIndex(3)
                .padding(.top)
                
                VStack {
                    ZStack {
                        Image("thoughts-logo-flares")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .rotationEffect(Angle.degrees(isRotated ? 360 : 0))
                            .animation(animation2)
                        Image("thoughts-logo-flares")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                            .rotationEffect(Angle.degrees(isRotated ? 360 : 0))
                            .animation(animation)
                        Image(systemName: "lightbulb.fill").foregroundColor(Color.black)
                            .font(.system(size: 30))
                    }
                    Spacer()
                }
                .zIndex(2)
            }
        }
        .foregroundColor(offBlack)
        .padding(.horizontal)
        .background(gradientOrangeBlue).edgesIgnoringSafeArea(.all)
        
        
        .sheet(isPresented: self.$thoughtListVM.showSheet) {
            ThoughtDetail(thoughtListVM: self.thoughtListVM, thoughtCellVM: thoughtListVM.selectedThoughtCellVM ?? ThoughtCellViewModel(thought: Thought(title: "", body: "")))
                .background(gradientOrangeBlue).edgesIgnoringSafeArea(.all)
        }
        
        .onAppear() {
            self.isRotated = true
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
                        if !thoughtListVM.thoughtCellVMs.contains(where: {$0.thought.id == self.thoughtCellVM.thought.id}) {
                            self.thoughtListVM.addThought(title: self.thoughtCellVM.thought.title, body: self.thoughtCellVM.thought.body)
                        }
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


/*
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
 
*/

struct MainThoughtsView_Previews: PreviewProvider {
    static var previews: some View {
        MainThoughtsView()
    }
}
