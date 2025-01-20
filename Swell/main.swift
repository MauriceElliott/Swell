//
//  main.swift
//  Swell
//
//  Created by Maurice Elliott on 19/01/2025.
//

import Foundation

print("Swell")

var runSwell = true

let environment = [
  "TERM": "xterm",
  "HOME": "/Users/mauriceelliott",
  "PATH":
    "Users/mauriceelliott/.bun/bin:/Users/mauriceelliott/path_src:/usr/local/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/usr/local/share/dotnet:~/.dotnet/tools:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/Applications/Ghostty.app/Contents/MacOS",
]

while runSwell {
  let input = readLine()!.split(separator: " ")
  let command = input.first!

  if command == "exit" {
    runSwell = false
  } else {
    let process = Process()
    process.launchPath = "/bin/sh"
    process.environment = environment
    process.arguments = ["-c", String(command)]
    try! process.run()
    let pipe = Pipe()
    process.standardError = pipe
    process.standardOutput = pipe

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""

    print(output)
  }
}
