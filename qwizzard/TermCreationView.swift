//
//  ContentView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 1/31/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

class TermCreationViewModel: ObservableObject {
	@Published var question: String = ""
	@Published var answer: String = ""
}

struct TermCreationView: View {
	@Environment(\.presentationMode) var presentationMode
	@ObservedObject var viewModel: TermCreationViewModel
	let didCreateTerm : (Term) -> ()
	let createTerm: TermRepository.Create
	
	var body: some View {
		VStack {
			Group {
				TextField("Question: ", text: $viewModel.question)
				TextField("Answer: ", text: $viewModel.answer)
			}
			.textFieldStyle(RoundedBorderTextFieldStyle())
			
			
			
		}
		.navigationBarTitle(Text("Create"), displayMode: .inline)
		.navigationBarItems(trailing:
			Button(action: creationAction, label: {
				Text("Done")
				})
		)
	}
	
	func creationAction() {
		let term = Term(
		question: self.viewModel.question,
		answer: self.viewModel.answer)
		
		switch self.createTerm(term) {
		case .none:
			self.didCreateTerm(term)
			self.presentationMode.wrappedValue.dismiss()
			break
		case .notCreated:
			//show error
			break
		}
	}
	
	init(createTerm: @escaping TermRepository.Create,
			didCreateTerm: @escaping (Term) -> (),
			 _ viewModel: TermCreationViewModel) {
		self.createTerm = createTerm
		self.viewModel = viewModel
		self.didCreateTerm = didCreateTerm
	}
}

struct TermCreationView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			NavigationView {
				TermCreationView(
					createTerm: JSONTermsRepository.create,
					didCreateTerm: { q in },
					TermCreationViewModel())
			}
		}
	}
}
