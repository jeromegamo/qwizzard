//
//  Term.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/9/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//
import Foundation

struct Term: Identifiable, Encodable, Decodable {
	let id: UUID
	let question: String
	let answer: String
	let order: Int
	
	init(id: UUID = UUID(),
			 question: String,
			 answer: String,
			 order: Int) {
		self.id = id
		self.question = question
		self.answer = answer
		self.order = order
	}
	
	enum TermCodingKeys: String, CodingKey {
		case id
		case question
		case answer
		case order
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: TermCodingKeys.self)
		
		try container.encode(id, forKey: .id)
		try container.encode(question, forKey: .question)
		try container.encode(answer, forKey: .answer)
		try container.encode(order, forKey: .order)
	}
	
	init(from decoder: Decoder) throws {
		let value = try decoder.container(keyedBy: TermCodingKeys.self)
		id = try value.decode(UUID.self, forKey: .id)
		question = try value.decode(String.self, forKey: .question)
		answer = try value.decode(String.self, forKey: .answer)
		order = try value.decode(Int.self, forKey: .order)
	}
}
