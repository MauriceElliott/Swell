# Swell Shell Architecture

## Overview

Swell follows a **Functional Core + Imperative Shell** architecture, combining Swift's functional capabilities with structured side effects. This hybrid approach provides:

- **Clear separation** between pure logic and side effects
- **Ease of testing** through immutable, composable data structures
- **Extensibility** via protocol-oriented design for built-in commands
- **Maintainability** with focused, single-responsibility modules

---

## Directory Structure

```
Swell/
├── models/              (Functional - Value Types)
│   ├── Command.swift
│   └── ASTNode.swift
├── parser/              (Functional - Pure Transformation)
│   └── Parser.swift
├── core/                (Functional + Procedural - Business Logic)
│   ├── ShellState.swift
│   └── Evaluator.swift
├── builtins/            (OOP - Extensible Built-in Commands)
│   ├── BuiltinCommand.swift (protocol)
│   ├── BuiltinRegistry.swift
│   ├── CdCommand.swift
│   ├── AliasCommand.swift
│   └── ExitCommand.swift
├── io/                  (Procedural - I/O & Side Effects)
│   ├── InputHandler.swift
│   └── ProcessSpawner.swift
├── config/              (Procedural - Configuration)
│   └── ConfigManager.swift
└── main.swift           (Procedural - REPL Loop)
```

---

## Layer Breakdown

### 1. Models (`models/`)

**Paradigm:** Functional / Value Types  
**Purpose:** Immutable data structures representing shell concepts

#### `Command.swift`
```swift
struct Command {
    let name: String
    let arguments: [String]
}
```
- Pure data representation of a parsed command
- Immutable, easy to transform or pass around
- No side effects

#### `ASTNode.swift`
```swift
enum ASTNode {
    case command(Command)
    case pipeline([ASTNode])
    // Future: redirection, background jobs, etc.
}
```
- Abstract syntax tree representing parsed input
- Extensible enum for future constructs (pipelines, redirections, conditionals)
- Enables pretty-printing, validation, and composition

---

### 2. Parser (`parser/`)

**Paradigm:** Functional / Pure Transformation  
**Purpose:** Convert user input into AST

#### `Parser.swift`
```swift
func parse(input: String) throws -> ASTNode
```
- Takes raw user input string
- Returns `ASTNode` or throws `ParseError`
- **Pure function** — no side effects, no mutable state
- Handles tokenization, validation, and AST construction
- Consolidates logic from old `sanitiseInput.swift`

**Key responsibilities:**
- Tokenize input by whitespace (respecting quotes, escapes, etc.)
- Validate command names
- Construct `Command` and `ASTNode` values

---

### 3. Core State (`core/`)

#### `ShellState.swift`
```swift
struct ShellState {
    var environment: [String: String]
    var currentDirectory: URL
    var aliases: [String: Command]
    var history: [Command]
    var historyIndex: Int
}
```
- Single source of truth for shell mutable state
- Replaces scattered state in old `Session.swift`
- Passed `inout` to functions that modify it
- Immutable snapshots between evaluations

---

### 4. Executor (`core/`)

**Paradigm:** Functional + Procedural (Boundary Layer)  
**Purpose:** Execute AST against shell state

#### `Evaluator.swift`
```swift
func evaluate(node: ASTNode, in state: inout ShellState) -> Int32
```
- Takes an `ASTNode` and `ShellState`
- Mutates `ShellState` as needed (environment, PWD, history)
- Returns exit code
- Consolidates logic from old `mainSwitch.swift`
- Delegates to `BuiltinRegistry` or `ProcessSpawner`

**Key responsibilities:**
- Route commands to built-ins or external processes
- Handle history updates
- Update working directory for `cd`
- Manage aliases

---

### 5. Built-in Commands (`builtins/`)

**Paradigm:** OOP / Protocol-Oriented  
**Purpose:** Polymorphic, extensible built-in commands

#### `BuiltinCommand.swift` (Protocol)
```swift
protocol BuiltinCommand {
    var name: String { get }
    func run(args: [String], state: inout ShellState) -> Int32
}
```
- Defines interface for all built-in commands
- Enables dynamic dispatch and extensibility
- Each built-in implements this protocol

#### `BuiltinRegistry.swift`
```swift
class BuiltinRegistry {
    private var commands: [String: BuiltinCommand] = [:]
    
    func register(command: BuiltinCommand) { … }
    func get(name: String) -> BuiltinCommand? { … }
}
```
- Singleton or dependency-injected registry
- Maps command names to implementations
- Looked up by `Evaluator` before spawning external process

#### `CdCommand.swift`, `AliasCommand.swift`, `ExitCommand.swift`
- Individual built-in implementations
- Each conforms to `BuiltinCommand`
- Contains all logic for that command
- Easy to add new built-ins without modifying core logic

**Example structure:**
```swift
class CdCommand: BuiltinCommand {
    let name = "cd"
    
    func run(args: [String], state: inout ShellState) -> Int32 {
        // Change directory logic
        // Update state.currentDirectory
        return 0
    }
}
```

---

### 6. I/O & Side Effects (`io/`)

**Paradigm:** Procedural  
**Purpose:** Isolated, well-defined side effects

#### `InputHandler.swift`
- Reads raw user input from terminal
- Handles arrow keys, backspace, tab completion
- Prints to screen
- Consolidates logic from old `readInput.swift`, `tabComplete.swift`, `readHistory.swift`

#### `ProcessSpawner.swift`
- Spawns external processes via `posix_spawnp`
- Manages file descriptors, environment variables
- Waits for child processes
- Consolidates logic from old `spawnProcess.swift`
- Called by `Evaluator` for non-built-in commands

---

### 7. Configuration (`config/`)

#### `ConfigManager.swift`
- Reads/parses config file on startup
- Loads aliases and environment customizations
- Uses `Parser` to parse config lines
- Populates initial `ShellState`

---

### 8. Main Loop (`main.swift`)

**Paradigm:** Procedural  
**Purpose:** REPL glue code

```swift
func runShell() {
    var state = ShellState(…)
    let builtins = BuiltinRegistry()
    
    // Register built-ins
    builtins.register(CdCommand())
    builtins.register(AliasCommand())
    builtins.register(ExitCommand())
    
    while let line = readInput() {
        do {
            let ast = try parse(line)
            _ = evaluate(ast, in: &state, builtins: builtins)
        } catch {
            print("Error: \(error)")
        }
    }
}
```

## Data Flow

```
User Input
    ↓
InputHandler.readInput()  [Procedural I/O]
    ↓
Parser.parse()  [Pure Functional]
    ↓
ASTNode (Immutable Data)
    ↓
Evaluator.evaluate()  [Functional + Procedural]
    ├─→ BuiltinRegistry.get()  [OOP Dispatch]
    │   └─→ BuiltinCommand.run()  [Polymorphic]
    └─→ ProcessSpawner.spawn()  [Procedural I/O]
    ↓
ShellState (Mutated)
    ↓
Output / Side Effects
```

## Design Principles

| Principle | Application |
|-----------|-------------|
| **Single Responsibility** | Each module has one clear purpose |
| **Immutability** | Models and parser outputs are immutable |
| **Pure Functions** | Parser and validation logic have no side effects |
| **Dependency Injection** | State passed explicitly, not via singletons (except registry) |
| **Polymorphism** | Built-ins extend via protocol, not inheritance |
| **Testability** | Pure functions are trivial to unit test |
| **Extensibility** | Add new built-ins without modifying core logic |

## Future Extensibility

This architecture naturally supports:

- **Pipelines** — Extend `ASTNode` enum with `.pipeline([ASTNode])`
- **Redirections** — Add `stdin`, `stdout`, `stderr` to `ASTNode`
- **Background Jobs** — Track in `ShellState.jobs`, handle in `Evaluator`
- **Scripting** — Reuse `Parser` and `Evaluator` for script execution
- **Plugins** — Load external `BuiltinCommand` implementations at runtime
- **Async Operations** — Extend `Evaluator` with async/await patterns
