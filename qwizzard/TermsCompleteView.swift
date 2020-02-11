//
//  TermsCompleteView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/10/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

struct TermsCompleteView: View {
    var body: some View {
        VStack {
            Text("You've reached the end")
            Button(action: {},
                   label: {
                    Text("Retry?")
                }).padding()
                .background(Color.green)
                .foregroundColor(.white)
        }
    }
}

struct TermsCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        TermsCompleteView()
    }
}
