//
//  ContentView.swift
//  ThoughtsGoHere
//
//  Created by Grant Rosen on 10/2/20.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        MainThoughtsView().navigationBarHidden(true).edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
