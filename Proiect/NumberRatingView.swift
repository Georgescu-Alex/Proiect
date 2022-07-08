//
//  NumberRatingView.swift
//  Proiect
//
//  Created by m1 on 07/07/2022.
//

import SwiftUI

struct NumberRatingView: View
{
    let rating: Int16

    var body: some View
    {
        switch rating
        {
            case 1:
                return Text("1")
            case 2:
                return Text("2")
            case 3:
                return Text("3")
            case 4:
                return Text("4")
            default:
                return Text("5")
        }
    }
}

struct NumberRatingView_Previews: PreviewProvider {
    static var previews: some View {
        NumberRatingView(rating: 3)
    }
}
