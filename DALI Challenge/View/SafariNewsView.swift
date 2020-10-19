//
//  SafariNewsView.swift
//  Stock Bento
//
//  Created by Barkin Cavdaroglu on 10/11/20.
//

import SwiftUI
import SafariServices

struct SafariNewsView: View {
    @State var showSafari = false
    var urlString: String

    var body: some View {
        Button(action: {
            self.showSafari = true
        }) {
            HStack {
                Text("Read more...")
                    .font(.system(size: 13))
                    .padding(.bottom, 15)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url:URL(string: self.urlString)!)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}


