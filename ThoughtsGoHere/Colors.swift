//
//  Colors.swift
//  ThoughtsGoHere
//
//  Created by Grant Rosen on 10/2/20.
//

import SwiftUI

let lightOrange = Color(red: 255/255, green: 216/255, blue: 190/255)
let peach = Color(red: 255/255, green: 238/255, blue: 221/255)
let offWhite = Color(red: 245/255, green: 245/255, blue: 245/255)
let offBlack = Color(red: 50/255, green: 50/255, blue: 50/255)
let lightBlue = Color(red: 184/255, green: 184/255, blue: 255/255)
let darkBlue = Color(red: 147/255, green: 129/255, blue: 255/255)

let gradientOrangeBlue = LinearGradient(gradient: Gradient(colors: [lightBlue, lightOrange]), startPoint: .topLeading, endPoint: .bottomTrailing)

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
