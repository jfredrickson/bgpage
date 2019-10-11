// bgpage
// Copyright © 2019 Jeff Fredrickson
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import WebKit

class WebViewInjector: NSObject, WKNavigationDelegate {
    // Injects CSS that prevents text selection in the background overlay
    func preventTextSelection(in webView: WKWebView) {
        let css = "* { -webkit-user-select: none; }"
        let js = "const style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }

    // Injects JavaScript that prevents context menu interaction with the background overlay
    func preventContextMenu(in webView: WKWebView) {
        let js = "document.addEventListener('contextmenu', event => event.preventDefault());"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        preventTextSelection(in: webView)
        preventContextMenu(in: webView)
    }
}
