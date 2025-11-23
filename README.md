## Swell

<img src="resources/Swell_logo.png" align="right" />

A shell written in swift.

My intent with Swell is to make a scripting language I can use and enjoy for daily DevOps needs. Using Swift as the basis for the syntax, which takes a lot of stylistic choices from C and Pascal, as well as a lot of mordern improvements, we will be aiming to implement a simple procedural language for interacting with API endpoints, chaining together command line tools and utilising modern facilities provided by up to date terminal emulators.

Swell shell as I like to think of it takes influences from the my daily work, I do DevOps for a day job, and while I do that job, I drink a lot of tea. The name Swell comes from Swift and Shell, and Swell in Bri'ish means good, i.e. "Swell weather we're having today old chap!". For this reason alone, I want swell to be tea themed as it makes up a large part of my day and feels right.

## Use

To build and install Swell, run `./build.sh` from the project root. This will build the project in release mode and copy the binary to `/usr/local/bin/swell`, adding it to your path. Please adjust the script for your needs if you want to install it elsewhere.

## Structure

Swell is a Swift-based shell for all your development and DevOps needs. The codebase is structured as follows:

- **Swell/main.swift** - Entry point for the shell
- **Swell/Parser/** - Tokenization and parsing of shell commands into an AST
- **Swell/Models/** - Core data structures (Command, ASTNode, PromptState)
- **Swell/IO/** - Input handling, key handlers, and process spawning
- **Swell/BuiltIns/** - Built-in commands like cd, exit, and alias
- **Swell/Config/** - Configuration management

The shell reads input character by character in raw mode, parses commands, and either executes built-ins or spawns external processes. We're building something practical and enjoyable for daily use, not an academic exercise.

## Goals

Swell is still early days. Here's what needs to be implemented:

- **Pipes** - The `|` operator to chain commands
- **Variables** - Setting and using shell variables
- **If statements** - Conditional execution
- **Loops** - For and while loops
- **Functions** - User-defined functions
- **Closures** - First-class functions
- **POSIX mode** - Compatibility with standard shell scripts when needed


