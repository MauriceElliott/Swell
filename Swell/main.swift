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
  let process = Process()
  print("\u{001B}[3;32m 󰶟 => \u{001B}[0;39m", terminator: "")
  let input = readLine()
  let pipe = Pipe()

  if input == "exit" {
    runSwell = false
  } else {
    process.executableURL = URL.init(filePath: "/bin/ls")
    process.environment = environment
    process.arguments = ["-c", String(input!)]
    process.standardError = pipe
    process.standardOutput = pipe

    try! process.run()
    

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""

    print(output)
  }
}
