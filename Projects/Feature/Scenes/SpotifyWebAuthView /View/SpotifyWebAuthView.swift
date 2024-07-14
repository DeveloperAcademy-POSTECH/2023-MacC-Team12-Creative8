//
//  SpotifyWebAuthView.swift
//  Feature
//
//  Created by A_Mcflurry on 7/13/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI
import WebKit

struct SpotifyWebAuthView: View {
  @StateObject private var viewModel = SpotifyWebAuthViewModel()
  
  var body: some View {
    Button("Test") {
      viewModel.spotifyManger.authorize()
    }
  }
}

struct WebView: UIViewRepresentable {
  let request: URLRequest
  
  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    webView.load(request)
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) { }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, WKNavigationDelegate {
    var parent: WebView
    
    init(_ parent: WebView) {
      self.parent = parent
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      if let url = navigationAction.request.url, url.absoluteString.starts(with: parent.request.url!.scheme!) {
        // Handle redirect URL here
      }
      decisionHandler(.allow)
    }
  }
}
