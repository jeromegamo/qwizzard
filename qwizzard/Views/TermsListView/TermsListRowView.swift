//
//  TermsListRowView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 3/8/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

struct TermsListRowView: View {
    let term: Term
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(term.question)
            Text(term.answer)
                .lineLimit(3)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TermsListRowView_Previews: PreviewProvider {
    static var previews: some View {
				Group {
						TermsListRowView(
								term: Term(question: "matron",
													 answer: "an older married woman.")
						)
						.previewLayout(.fixed(width: 400, height: 130))
						.previewDisplayName("Short definition")
						
						TermsListRowView(
								term: Term(question: "paradox",
													 answer: "a self-contradictory statement or proposition, that when investigated or explained, may prove to be well founded or true.")
						)
						.previewLayout(.fixed(width: 400, height: 130))
						.previewDisplayName("Long definition")
				}
				.padding(15)
    }
}
