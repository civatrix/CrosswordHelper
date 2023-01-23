//
//  ResultsView.swift
//  CrosswordHelper
//
//  Created by DanielJohns on 2021-10-03.
//

import SwiftUI

struct DefinitionView: UIViewControllerRepresentable {
    let term: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DefinitionView>) -> UIReferenceLibraryViewController {
        return UIReferenceLibraryViewController(term: term)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
