# Swell → Odin Translation Plan

## Overview

Translate the Swell shell from Swift to Odin, preserving features and structure where possible. Odin is a systems-level language without classes, protocols, or a Foundation-like framework — so we must rethink certain patterns while keeping the spirit of the original design.

### Odin Version Target

We target **Odin Q1 2026+**, leveraging the new unified `core:os` package (formerly `os2`). This means:
- `^os.File` instead of raw handles
- Explicit allocators on allocation-performing functions
- `os.Error` returns instead of bools/platform-specific codes
- New `os.chdir`, `os.read_directory_iterator`, `os.getenv` APIs
- The old `core:os` API lives at `core:os/old` temporarily

---

## Directory Structure

Swift compiles everything into a single module with no import boundaries. Odin uses directory-based packages with explicit imports and **no circular dependencies allowed**. This forces a cleaner layering:

```
swell/
├── Odin.md                  ← this file
├── README.md
├── build_odin.sh            ← build script for Odin version
└── odin_src/
    ├── main.odin            ← package main (entry point)
    ├── types/
    │   └── types.odin       ← package types (shared data structures)
    ├── parser/
    │   └── parser.odin      ← package parser
    ├── shell_io/
    │   ├── raw_input.odin   ← package shell_io
    │   ├── handlers.odin
    │   ├── handler_registry.odin
    │   ├── prompt_handler.odin
    │   └── process_spawner.odin
    ├── builtins/
    │   ├── builtins.odin    ← package builtins (shared types + registry)
    │   ├── cd.odin
    │   ├── exit_cmd.odin
    │   └── alias.odin
    ├── core/
    │   ├── evaluator.odin   ← package core
    │   ├── prompt.odin
    │   └── alias.odin
    └── config/
        └── config.odin      ← package config
```

### Package Dependency Graph (acyclic)

```
types  ←──  parser
  ↑           ↑
  ├── shell_io ├── builtins
  ↑            ↑        ↑
  └──── core ──┘────────┘
          ↑
        config
          ↑
        main
```

No circular dependencies. `types` is the leaf package imported by everyone.

---

## Feature Translation Map

### 1. Classes → Structs + Procedures

Swift classes become Odin structs with associated free procedures. No methods, no inheritance.

| Swift | Odin |
|---|---|
| `class SessionState { var curDir: String ... }` | `Session_State :: struct { cur_dir: string, ... }` |
| `class ConfigManager { func load... }` | `load_configuration :: proc(state: ^Session_State) { ... }` |
| `class HandlerRegistry { private var handlers... }` | `Handler_Registry :: struct { handlers: map[string]Input_Handler }` |
| `class BuiltInRegistry { ... }` | `Builtin_Registry :: struct { commands: map[string]Builtin_Command }` |

### 2. Protocols → Struct with Procedure Pointer

Swift's `BuiltInCommand` protocol:
```swift
protocol BuiltInCommand {
    var name: String { get }
    func run(args: [String], state: inout SessionState)
}
```

Odin equivalent — a struct with a function pointer:
```odin
Builtin_Command :: struct {
    name: string,
    run:  proc(args: []string, state: ^Session_State),
}
```

Each builtin (cd, exit, alias) becomes a procedure that returns a `Builtin_Command` value, or we simply register procedure pointers directly into the registry map.

### 3. Enums with Associated Values → Tagged Unions

Swift:
```swift
enum ASTNode {
    case empty
    case command(Command)
    case pipeline([ASTNode])
}
```

Odin:
```odin
AST_Node :: union {
    AST_Empty,
    Command,
    Pipeline,
}

AST_Empty :: struct {}
Pipeline :: struct {
    nodes: [dynamic]AST_Node,
}
```

Pattern matching via `#partial switch v in node { ... }`.

### 4. Typed Enums → Odin Enums

Swift:
```swift
enum InputAction {
    case continueReading
    case readHistory
    case submitInput
}
```

Odin (direct mapping):
```odin
Input_Action :: enum {
    Continue_Reading,
    Read_History,
    Submit_Input,
}
```

### 5. String Operations

Swift's rich `String` API (`split`, `contains`, `replacingOccurrences`, `starts(with:)`, `filter`) maps to Odin's `core:strings` package:

| Swift | Odin |
|---|---|
| `input.split(separator: " ")` | `strings.split(input, " ")` |
| `s.contains("/")` | `strings.contains(s, "/")` |
| `s.replacingOccurrences(of: a, with: b)` | `strings.replace_all(s, a, b)` |
| `s.starts(with: prefix)` | `strings.has_prefix(s, prefix)` |
| `"hello" + " world"` | `strings.concatenate({"hello", " world"})` or `fmt.tprintf(...)` |

**Important**: Many `core:strings` procedures allocate. We must use `context.temp_allocator` for transient strings and `free_all(context.temp_allocator)` at appropriate points (e.g., each REPL loop iteration).

### 6. Foundation Framework → `core:os` + `core:sys/posix`

| Swift (Foundation) | Odin |
|---|---|
| `FileManager.default.changeCurrentDirectoryPath(p)` | `os.chdir(p)` |
| `FileManager.default.currentDirectoryPath` | `os.get_current_directory(allocator)` |
| `FileManager.default.homeDirectoryForCurrentUser` | `os.getenv("HOME", allocator)` |
| `FileManager.default.contentsOfDirectory(atPath:)` | `os.read_directory_iterator(dir_handle)` |
| `FileManager.default.fileExists(atPath:)` | `os.exists(path)` |
| `ProcessInfo.processInfo.environment["PATH"]` | `os.getenv("PATH", allocator)` |
| `String(contentsOfFile:)` | `os.read_entire_file(path, allocator)` |
| `s.write(toFile:)` | `os.write_entire_file(path, data)` |

### 7. Terminal I/O — `core:sys/posix`

The raw terminal input code translates almost 1:1 via `core:sys/posix`:

```odin
import psx "core:sys/posix"

read_raw_input :: proc() -> (string, bool) {
    old_term: psx.termios
    psx.tcgetattr(psx.STDIN_FILENO, &old_term)

    raw := old_term
    raw.c_lflag -= {.ECHO, .ICANON}
    psx.tcsetattr(psx.STDIN_FILENO, .TCSANOW, &raw)
    defer psx.tcsetattr(psx.STDIN_FILENO, .TCSANOW, &old_term)

    buf: [1]u8
    bytes_read := psx.read(psx.STDIN_FILENO, &buf, 1)
    if bytes_read > 0 {
        return string(buf[:bytes_read]), true
    }
    return "", false
}
```

### 8. Process Spawning

The Swift code uses `posix_spawn` directly. In Odin we have two options:

**Option A — `core:os` process API** (preferred, cross-platform):
```odin
import "core:os"

spawn_process :: proc(command: string, args: []string, state: ^Session_State) {
    result, stdout, stderr, err := os.process_exec(
        os.Process_Desc{
            command = args,  // first element is the program
        },
        context.allocator,
    )
    // handle result...
}
```

**Option B — Direct POSIX** (if we need env passthrough or finer control):
Use `core:sys/posix` for `posix_spawnp`, `waitpid`, etc. — nearly identical to the Swift C-interop code.

**Recommendation**: Start with Option A for simplicity. Fall back to Option B only if we need env variable passthrough (which we do for `state.environment`). We should investigate whether `os.process_exec` supports custom environment injection. If not, POSIX route it is.

### 9. Optional Types

Swift optionals → Odin multi-return or `Maybe(T)`:

```odin
// Swift: func getAlias(cmd: Command, state: SessionState) -> Optional<Command>
// Odin:
get_alias :: proc(cmd: Command, state: ^Session_State) -> (Command, bool) {
    alias, found := state.aliases[cmd.arguments[0]]
    if !found do return {}, false
    // ...
    return alias, true
}
```

### 10. `borrowing` / Ownership

Swift's `borrowing` keyword has no Odin equivalent — Odin uses manual pointer semantics. Pass `^Session_State` (pointer) when mutation is needed, and `Session_State` by value (or pointer for efficiency) when read-only. In practice, we'll pass `^Session_State` everywhere since it's a large struct.

### 11. flush_stdout

```odin
import "core:c/libc"

flush_stdout :: proc() {
    libc.fflush(libc.stdout)
}
```

Or simply use `fmt.printf` which flushes more predictably. We can also use `os.stdout` with `os.flush`.

---

## Feature Preservation Summary

| Feature | Preservable? | Notes |
|---|---|---|
| REPL loop | ✅ Yes | Direct translation |
| Raw terminal input | ✅ Yes | `core:sys/posix` termios |
| Arrow key history | ✅ Yes | Same escape sequence parsing |
| Tab completion | ✅ Yes | Same logic with `core:strings` |
| Command parsing | ✅ Yes | Direct translation |
| Built-in commands (cd, exit, alias) | ✅ Yes | Direct translation |
| Process spawning | ✅ Yes | `core:os` or `core:sys/posix` |
| Environment variables | ✅ Yes | `core:os` getenv/setenv |
| Config file loading | ✅ Yes | `core:os` file reading |
| ANSI prompt coloring | ✅ Yes | Raw escape sequences work the same |
| Handler registry pattern | ✅ Yes | `map[string]proc(...)` |
| Command history | ✅ Yes | `[dynamic]Command` |
| Alias expansion | ✅ Yes | Direct translation |
| Platform-conditional compilation | ✅ Yes | `when ODIN_OS == .Darwin` / `.Linux` |

**Nothing is lost.** Every feature in the Swift version has a clean Odin equivalent.

---

## Implementation Todos

1. **types package** — Define `Session_State`, `Command`, `AST_Node`, `Prompt_State`, `Input_Action`, `Builtin_Command`
2. **parser package** — Translate `parse()` using `core:strings`
3. **shell_io package** — Terminal raw input, handler registry, all key handlers, prompt handler, process spawner
4. **builtins package** — cd, exit, alias commands + registry
5. **core package** — Evaluator, `get_prompt`, `get_alias`
6. **config package** — Config file discovery, loading, session initialization
7. **main.odin** — Entry point REPL loop
8. **build_odin.sh** — Build script (`odin build odin_src/ -out:swell`)

---

## Open Questions for Discussion

1. **Process spawning strategy**: Use `core:os` process API or go straight to POSIX `posix_spawnp` for environment variable passthrough? The Swift version passes `state.environment` as `envp` — we need this to work.
Use Core:OS, in general favour idiomatic Odin where possible. This solution was chosen because it was the only way it was possible to write a shell in Swift.

2. **Memory management strategy**: Use `context.temp_allocator` with `free_all` each REPL iteration for transient strings? Or use arena allocators? The temp allocator approach is simplest and fits a REPL loop well.
use the temp allocator approach, we know what information persists between loops anyways, its all very obvious where the division is.

3. **Package granularity**: The proposed structure has 6 packages + main. An alternative is fewer, larger packages (e.g., merge `builtins` into `core`). More packages = cleaner separation but more import boilerplate. What's your preference?
merge builtins and core.

4. **Source directory**: Proposed `odin_src/` to coexist with the Swift `Sources/`. Or should the Odin version replace the Swift code entirely?
just use src, vs Sources, we will be removing Sources quite soon anyways and I prefer the name src

5. **Config file format**: Keep `config.swell` as-is (parsed line-by-line through the shell's own parser/evaluator)? This is a neat self-hosting feature worth preserving.
keep as is.
