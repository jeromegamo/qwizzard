//
//  CardViewModel.swift
//  qwizzard
//
//  Created by Jerome Gamo on 3/11/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import Foundation

class CardViewModel: ObservableObject, Identifiable {
	@Published var side: Side = .front
	
	let term: Term
	
	init(term: Term) {
		self.term = term
	}
}
