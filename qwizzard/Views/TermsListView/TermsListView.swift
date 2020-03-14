//
//  QuizListView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/2/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI



struct TermsListView: View {
	@ObservedObject var vm: TermsListViewModel

	init(_ vm: TermsListViewModel) {
		self.vm = vm
	}
	
	var body: some View {
		NavigationView {
				List {
					ForEach(vm.terms.indices, id: \.self) { idx in
							ZStack {
								TermsListRowView(term: self.vm.terms[idx])
								
								NavigationLink(destination:
									
									TermEditingView(
										TermEditingViewModel(
											saveTerm: self.vm.saveTerm,
											didEditTerm: { (term) in
												self.vm.terms[idx] = term
												
											}, term: self.vm.terms[idx])
									)
								) {
									EmptyView()
								}
							}
					}
					.onDelete(perform: vm.delete)
			}
			.navigationBarTitle(Text("Questions"), displayMode: .inline)
			.navigationBarItems(trailing:
				HStack(spacing: 20) {
					NavigationLink(destination:
						LearnView(
							LearnViewModel(getAllTerms: { () -> [Term] in
								[]
							})
						)
					) {
						Image(systemName: "play")
					}
					NavigationLink(destination:
						TermCreationView(
							createTerm: self.vm.createTerm,
							didCreateTerm: { v in
							self.vm.terms.append(v)
						}, TermCreationViewModel())
					) {
						Image(systemName: "plus")
					}
					EditButton()
				}
			)
		}
		.onAppear {
			self.vm.loadTerms()
		}
	}

}

struct TermsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			TermsListView(
				TermsListViewModel(
					getAllTerms: JSONTermsRepository.getAll,
					saveTerm: JSONTermsRepository.save,
					createTerm: JSONTermsRepository.create,
					deleteTerm: JSONTermsRepository.delete)
			)
		}
	}
}
