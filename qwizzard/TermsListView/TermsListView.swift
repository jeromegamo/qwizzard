//
//  QuizListView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/2/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

class TermsListViewModel: ObservableObject {
	@Published var terms: [Term] = []
}

struct TermsListView: View {
	@ObservedObject var vm: TermsListViewModel
	@Environment(\.presentationMode) var presentationMode
	
	var body: some View {
		NavigationView {
			List(vm.terms.indices, id: \.self) { idx in
				ZStack {
					TermsListRowView(term: self.vm.terms[idx])
					
					NavigationLink(destination:
						
						TermEditingView(
							viewModel: TermEditingViewModel(
								saveTerm: { (term) -> TermRepository.SaveError? in
									.none
								}, didEditTerm: { (term) in
								
								}, term: self.vm.terms[idx])
						)
					) {
						EmptyView()
					}
				}
			}
			.navigationBarTitle(Text("Questions"), displayMode: .inline)
			.navigationBarItems(trailing:
				HStack {
					NavigationLink(destination:
						LearnView(viewModel:
							LearnViewModel(getAllTerms: { () -> [Term] in
								[]
							})
						)
					) {
						Image(systemName: "play")
					}
					NavigationLink(destination:
						TermCreationView(didCreateTerm: { v in
							self.vm.terms.append(v)
						})
					) {
						Image(systemName: "plus")
					}
				}
			)
		}
		.onAppear {
			self.vm.terms = self.getAllTerms()
		}
	}
	
	let getAllTerms: TermRepository.GetAll
	let saveTerm: TermRepository.Save
	
	init(getAllTerms: @escaping TermRepository.GetAll,
			 saveTerm: @escaping TermRepository.Save,
			 _ vm: TermsListViewModel) {
		self.vm = vm
		self.getAllTerms = getAllTerms
		self.saveTerm = saveTerm
	}
}

struct TermsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			TermsListView(
				getAllTerms: { () -> [Term] in
					[]
				}, saveTerm: { (term) -> TermRepository.SaveError? in
					.none
				},
				TermsListViewModel()
			)
		}
	}
}
