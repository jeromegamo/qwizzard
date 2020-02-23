//
//  QuizListView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/2/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI



struct TermsView: View {
    
    @State var terms: [Term]
    
    var body: some View {
        NavigationView {
            List(terms.indices, id: \.self) { idx in
                
                NavigationLink(destination:
                    TermEditingView(toEdit: self.terms[idx],
                                    didEditTerm: { editedTerm in
                      
                    self.terms[idx] = editedTerm
                                        
                })) {
                    Text("\(self.terms[idx].question) - \(self.terms[idx].answer)")
                }
            }
            .navigationBarTitle(Text("Questions"), displayMode: .inline)
            .navigationBarItems(trailing:
                
                HStack {
                    NavigationLink(destination:
                        
                        LearnView(viewModel: LearnViewModel())
                        
                    ) {
                        Image(systemName: "play")
                    }
                    NavigationLink(destination:
                        
                        TermCreationView(didCreateTerm: { v in
                            self.terms.append(v)
                        })
                        
                    ) {
                        Image(systemName: "plus")
                    }
                }
            )        
        }
    }
    
    init(getTerms: () -> [Term]) {
        self._terms = State(initialValue: getTerms())
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TermsView(getTerms: {
                return []
            })
        }
    }
}
