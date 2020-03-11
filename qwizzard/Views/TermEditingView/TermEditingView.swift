//
//  TermEditingView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/3/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//
import SwiftUI

struct TermEditingView: View {
	@ObservedObject var vm: TermEditingViewModel
	@Environment(\.presentationMode) var presentationMode
	
	init(_ viewModel: TermEditingViewModel) {
		self.vm = viewModel
	}
	
	var body: some View {
		VStack {
			Group {
				TextField("Question: ", text: $vm.question)
				TextField("Answer: ", text: $vm.answer)
			}
			.textFieldStyle(RoundedBorderTextFieldStyle())
		}
		.navigationBarTitle(Text("Create"),
												displayMode: .inline)
		.navigationBarItems(trailing:
			Button(action: {
				self.vm.save()
				//TODO:- Show errors?
				self.presentationMode.wrappedValue.dismiss()
			}, label: {
				Text("Save")
			})
		)
	}
}


struct TermEditingView_Previews: PreviewProvider {
	static var previews: some View {
		
		let saveTerm: (Term) -> TermRepository.SaveError? = { term in .none }
		let term = Term(question: "", answer: "")
		let editTerm: (Term) -> () = {t in }
		
		return NavigationView {
			TermEditingView(
					TermEditingViewModel(
					saveTerm: saveTerm,
					didEditTerm: editTerm,
					term: term)
			)
		}
	}
}

