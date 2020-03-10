//
//  TermEditingView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/3/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//
import SwiftUI

class TermEditingViewModel: ObservableObject {
	@Published var question: String
	@Published var answer: String
	let id: UUID
	let didEditTerm : (Term) -> ()
	let saveTerm: TermRepository.Save
	
	init(saveTerm: @escaping TermRepository.Save,
			 didEditTerm: @escaping (Term) -> (),
			 term: Term) {
		self.saveTerm = saveTerm
		self.didEditTerm = didEditTerm
		self.id = term.id
		self.question = term.question
		self.answer = term.answer
	}
}

struct TermEditingView: View {
	@ObservedObject var viewModel: TermEditingViewModel
	@Environment(\.presentationMode) var presentationMode
	var body: some View {
		VStack {
			Group {
				TextField("Question: ", text: $viewModel.question)
				TextField("Answer: ", text: $viewModel.answer)
			}
			.textFieldStyle(RoundedBorderTextFieldStyle())
		}
		.navigationBarTitle(Text("Create"),
												displayMode: .inline)
		.navigationBarItems(trailing:
			Button(action: didSave, label: {
				Text("Save")
			}))
		
	}
	
	func didSave() {
		let term = Term(id: viewModel.id,
										question: viewModel.question,
										answer: viewModel.answer)
		
		if case (.none) = viewModel.saveTerm(term) {
			viewModel.didEditTerm(term)
			self.presentationMode.wrappedValue.dismiss()
		} else {
			//show error
		}
	}
}


struct TermEditingView_Previews: PreviewProvider {
	static var previews: some View {
		
		let saveTerm: (Term) -> TermRepository.SaveError? = { term in .none }
		let term = Term(question: "", answer: "")
		let editTerm: (Term) -> () = {t in }
		
		return NavigationView {
			TermEditingView(
			viewModel: TermEditingViewModel(
				saveTerm: saveTerm,
				didEditTerm: editTerm,
				term: term))
		}
	}
}

