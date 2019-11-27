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

let defaultContentFile = ".bgpage.html"
let fileManager = FileManager.default
let contentFileUrl = fileManager.homeDirectoryForCurrentUser.appendingPathComponent(defaultContentFile)

if (!fileManager.fileExists(atPath: contentFileUrl.path)) {
    print("Content file not found: \(contentFileUrl.path)")
    exit(1)
}

let webView = WKWebView()
webView.setValue(false, forKey: "drawsBackground")
webView.loadFileURL(contentFileUrl, allowingReadAccessTo: contentFileUrl)

let contentChanged: FSEventStreamCallback = { (streamRef, clientCallbackInfo, numEvents, eventPaths, eventFlags, eventIds) in
    webView.reload()
}

var fsEventStreamContext = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
if let fsEventStream = FSEventStreamCreate(kCFAllocatorDefault, contentChanged, &fsEventStreamContext, [contentFileUrl.path] as CFArray, UInt64(kFSEventStreamEventIdSinceNow), 0, UInt32(kFSEventStreamCreateFlagFileEvents)) {
    FSEventStreamScheduleWithRunLoop(fsEventStream, CFRunLoopGetMain(), "kCFRunLoopDefaultMode" as CFString)
    FSEventStreamStart(fsEventStream)
}

let screenRect = screen.frame
let windowRect = NSRect(x: 0, y: 0, width: screenRect.width, height: screenRect.height)
let windowStyle: NSWindow.StyleMask = [.borderless]
let window = NSWindow(contentRect: windowRect, styleMask: windowStyle, backing: .buffered, defer: false)
window.isOpaque = false
window.backgroundColor = .clear
window.collectionBehavior = [.transient, .canJoinAllSpaces, .ignoresCycle]
window.displaysWhenScreenProfileChanges = true
window.isReleasedWhenClosed = false
window.isRestorable = false
window.disableSnapshotRestoration()
// kCGDesktopWindowLevel is not exposed to Swift, so manually using the calculations found in CGWindowLevel.h:
// kCGDesktopWindowLevel = ((CGWindowLevel)(kCGMinimumWindowLevel + 20))
// kCGMinimumWindowLevel = ((CGWindowLevel)(kCGBaseWindowLevel + kCGNumReservedBaseWindowLevels))
// kCGBaseWindowLevel = ((CGWindowLevel)INT32_MIN)
// kCGNumReservedBaseWindowLevels = (5)
window.level = NSWindow.Level.init(Int(Int32.min + 5 + 20))
window.orderFrontRegardless()
window.contentView = webView

app.run()
