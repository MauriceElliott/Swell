## Swell

<img src="resources/logo_v7.png" align="right" />

A shell written for the joy of programming.

My intent with Swell is to make a scripting language I can use and enjoy for daily DevOps needs. Using Odin, lua, Swift, and other influences as the basis for the syntax we will be aiming to implement a simple procedural language for interacting with API endpoints, chaining together command line tools and utilising modern facilities provided by up to date terminal emulators.

"Swell shell" as I like to think of it takes influences from the my daily work, I do DevOps for a day job. The name Swell comes from Swift and Shell, and Swell in Bri'ish means good, i.e. "Swell weather we're having today old chap!". Its really not important, but like most unimportant things, its spent far too much time living rent free in my head.

This project started off as something I thought might go somewhere, but as soon as I'd finished implementing a lot of the core functionality, I realised I'd hit a roadblock in terms of further implementation. The structure and procedural nature was just too restrictive. After about 10 months of it being out of mind I decided to work on Swell again. I then updated it to the latest version of Swift, remove its dependency on xcode and re-design the structure for better extensibility. It has gained new life and the programming I've done on this project so far has been some of the most enjoyable of my career.

Now, a few months later without it ever really leaving my head I have decided to switch implementation language, I love Swift, but it has been a struggle using it on Linux and after another instance of my toolchain completely breaking after an upgrade I've decided to switch. It took a lot of deep thought and agonising over it, but Odin is the choice I've landed on. There was a hole left by my time with lua while developing a game in Picotron, that Odin has now filled. The language is simple, well designed, and doesn't try to be anything special, while at the same time working hard to make a concise, modern, C replacement that can be used for all aspects of the development I like to do, while not sacrificing on performance or tooling.

## Use

To build and install Swell, from the project root run:

`./build.sh`.

use `./build.sh install` to add swell to `/usr/local/bin`

## Structure

Swell is a Swift-based shell for all your development and DevOps needs. The codebase is structured as follows:

- **Swell/main** - Entry point for the shell
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

