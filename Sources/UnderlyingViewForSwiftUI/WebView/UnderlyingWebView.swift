//
//  File.swift
//  
//
//  Created by TriBQ on 28/04/2023.
//

import Foundation
import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
    public init(url: String) {
        self.url = url
    }

    var url: String

    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scalesLargeContentImage = true

        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear

        let config = WKWebViewConfiguration()
        config.dataDetectorTypes = [.all]

        webView.navigationDelegate = context.coordinator
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        if context.coordinator.data == url {
            return
        }

        context.coordinator.data = url

        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public class Coordinator: NSObject, WKNavigationDelegate {
        var data = ""
    }
}
