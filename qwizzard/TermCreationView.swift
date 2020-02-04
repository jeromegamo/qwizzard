//
//  ContentView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 1/31/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

struct TermCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var question: String = ""
    @State var answer: String = ""
    
    let didCreateTerm : (Term) -> ()
    
    var body: some View {
        VStack {
            Group {
                TextField("Question: ", text: $question)
                TextField("Answer: ", text: $answer)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                self.didCreateTerm(Term(
                    question: self.question, answer: self.answer))
                
                 self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
            })
            
        }.navigationBarTitle(Text("Create"), displayMode: .inline)
    }
    
    init(didCreateTerm: @escaping (Term) -> ()) {
        self.didCreateTerm = didCreateTerm
    }
}

struct TermCreationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TermCreationView(didCreateTerm: { q in })
        }
    }
}
