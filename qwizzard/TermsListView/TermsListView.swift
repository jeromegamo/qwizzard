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
	
	let deleteTerm: TermRepository.Delete
	
	init(deleteTerm: @escaping TermRepository.Delete) {
		self.deleteTerm = deleteTerm
	}
	
	func delete(indexSet: IndexSet) {
		guard let index = indexSet.first else {
			return
		}
		
		let toDelete = terms[index]
		if case .none = self.deleteTerm(toDelete) {
			terms.remove(atOffsets: indexSet)
		}
	}
	
	func move(from indicies: IndexSet, to destination: Int) {
		terms.move(fromOffsets: indicies, toOffset: destination)
	}
}

struct TermsListView: View {
	@ObservedObject var vm: TermsListViewModel
	
	let getAllTerms: TermRepository.GetAll
	let saveTerm: TermRepository.Save
	let createTerm: TermRepository.Create
	
	init(getAllTerms: @escaping TermRepository.GetAll,
			 saveTerm: @escaping TermRepository.Save,
			 createTerm: @escaping TermRepository.Create,
			 _ vm: TermsListViewModel) {
		self.vm = vm
		self.getAllTerms = getAllTerms
		self.saveTerm = saveTerm
		self.createTerm = createTerm
	}
	
	var body: some View {
		NavigationView {
				List {
					ForEach(vm.terms.indices, id: \.self) { idx in
							ZStack {
								TermsListRowView(term: self.vm.terms[idx])
								
								NavigationLink(destination:
									
									TermEditingView(
										viewModel: TermEditingViewModel(
											saveTerm: self.saveTerm,
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
					.onMove(perform: vm.move)
			}
			.navigationBarTitle(Text("Questions"), displayMode: .inline)
			.navigationBarItems(trailing:
				HStack(spacing: 20) {
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
						TermCreationView(
							createTerm: self.createTerm,
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
			self.vm.terms = self.getAllTerms()
		}
	}

}

struct TermsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			TermsListView(
				getAllTerms: JSONTermsRepository.getAll,
				saveTerm: JSONTermsRepository.save,
				createTerm: JSONTermsRepository.create,
				TermsListViewModel(deleteTerm: JSONTermsRepository.delete)
			)
		}
	}
}
