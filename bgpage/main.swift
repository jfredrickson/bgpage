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

import AppKit
import WebKit

let app = NSApplication.shared

guard let screen = NSScreen.screens.first else {
    print("No screens found")
    exit(1)
}

let defaultFileName = ".bgpage.html"
let fileManager = FileManager.default
let url = fileManager.homeDirectoryForCurrentUser.appendingPathComponent(defaultFileName)

if (!fileManager.fileExists(atPath: url.path)) {
    print("Content file not found: \(url.path)")
    exit(1)
}

let webView = WKWebView()
let webViewInjector = WebViewInjector()
webView.navigationDelegate = webViewInjector
webView.setValue(false, forKey: "drawsBackground")
webView.loadFileURL(url, allowingReadAccessTo: url)

let contentChanged: FSEventStreamCallback = { (streamRef, clientCallbackInfo, numEvents, eventPaths, eventFlags, eventIds) in
    webView.reload()
}

var fsEventStreamContext = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
if let fsEventStream = FSEventStreamCreate(kCFAllocatorDefault, contentChanged, &fsEventStreamContext, [url.path] as CFArray, UInt64(kFSEventStreamEventIdSinceNow), 0, UInt32(kFSEventStreamCreateFlagFileEvents)) {
    FSEventStreamScheduleWithRunLoop(fsEventStream, CFRunLoopGetMain(), "kCFRunLoopDefaultMode" as CFString)
    FSEventStreamStart(fsEventStream)
}

let screenRect = screen.frame
let windowRect = NSRect(x: 0, y: 0, width: screenRect.width, height: screenRect.height)
let windowStyle: NSWindow.StyleMask = [.borderless]
let window = NSWindow(contentRect: windowRect, styleMask: windowStyle, backing: .buffered, defer: false)
window.contentView = webView
window.backgroundColor = .clear
window.level = NSWindow.Level.init(-1)
window.orderFrontRegardless()

app.run()
