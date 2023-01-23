//
//  ContentView.swift
//  CrosswordHelper
//
//  Created by DanielJohns on 2021-10-03.
//

import SwiftUI

enum WebSearch {
    case dictionary
    case thesaurus
    case wikipedia
    
    func url(forTerm term: String) -> URL? {
        switch self {
        case .dictionary:
            return URL(string: "https://www.dictionary.com/browse")?.appendingPathComponent(term)
        case .thesaurus:
            return URL(string: "https://www.thesaurus.com/browse")?.appendingPathComponent(term)
        case .wikipedia:
            return URL(string: "https://en.wikipedia.org/wiki")?.appendingPathComponent(term)
        }
    }
}

struct SearchView: View {
    let wordList = try! String(contentsOf: Bundle.main.url(forResource: "wordlist", withExtension: "")!)
    
    @State private var searchTerm = ""
    @State private var results: [String] = []
    
    @State private var selectedTerm: String?
    @State private var url: URL?
    
    var body: some View {
        VStack {
            TextField("Word", text: $searchTerm)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onChange(of: searchTerm, perform: performSearch(_:))
            
            if !searchTerm.isEmpty {
                HStack {
                    Button {
                        if let url = URL(string: "https://www.dictionary.com/browse")?.appendingPathComponent(searchTerm) {
                            self.url = url
                        }
                    } label: { Image("Dictionary") }
                    
                    Button {
                        if let url = URL(string: "https://www.thesaurus.com/browse")?.appendingPathComponent(searchTerm) {
                            self.url = url
                        }
                    } label: { Image("Thesaurus") }
                    
                    Button {
                        if let url = URL(string: "https://en.wikipedia.org/wiki")?.appendingPathComponent(searchTerm) {
                            self.url = url
                        }
                    } label: { Image("Wikipedia") }
                    
                    Button {
                        selectedTerm = searchTerm
                    } label: { Image("Apple") }
                }
            }
            
            Spacer()
            List(results, id: \.self) { word in
                Button(word) {
                    selectedTerm = word
                }
            }
        }
        .padding()
        .sheet(item: $selectedTerm) {
            DefinitionView(term: $0)
        }
        .sheet(item: $url) {
            SafariView(url: $0)
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = .always
        }
    }
    
    func performSearch(_ text: String) {
        let nsString = wordList as NSString
        guard let regex = try? NSRegularExpression(pattern: "^\(text.replacingOccurrences(of: "…", with: "..."))$", options: [.anchorsMatchLines]) else { return }
        results = regex.matches(in: wordList, options: [], range: NSRange(location: 0, length: nsString.length)).map { nsString.substring(with: $0.range) }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}
