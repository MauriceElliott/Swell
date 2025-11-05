import Foundation

struct CdCommand: BuiltInCommand {
	let name = "cd"
	func run(args: [String], state: inout SessionState) {
		    let fm = FileManager.default
    	if args.count == 1 {
    	    if fm.changeCurrentDirectoryPath(state.homeDir) {
    	        state.curDir = state.homeDir
    	    } else {
    	        print("Failed to go home.")
    	        state.curDir = fm.currentDirectoryPath
    	    }
    	}
    	switch args[1] {
    	case "~":
    	    _ = fm.changeCurrentDirectoryPath(state.homeDir)
    	    state.curDir = state.homeDir
    	case "..":
    	    // TODO Needs to change to recursion so in the instance that there is a second .. we can just call change directory again and have it deal with the change.
    	    let currentDirList = state.curDir.split(separator: "/")
    	    if let sectionToRemove = currentDirList.last {
    	        let newDir = state.curDir.replacingOccurrences(of: "/\(sectionToRemove)", with: "")
    	        if fm.changeCurrentDirectoryPath(newDir) {
    	            state.curDir = newDir
    	        }
    	    } else {
    	        state.curDir = fm.currentDirectoryPath
    	    }
    	case "/":
    	    _ = fm.changeCurrentDirectoryPath(args[1])
    	    state.curDir = fm.currentDirectoryPath
    	default:
    	    let newDir = state.curDir + "/" + args[1]
    	    if fm.changeCurrentDirectoryPath(newDir) {
    	        state.curDir = newDir
    	    }
    	}
	}
}
