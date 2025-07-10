# Swell

A shell written in swift for personal learnings.

Swell is a passion project and a necessity, I am a full time DevOps engineer, scripts are my bread and butter, so having a robust programming suite that I can feel comfortable solving the mirriad of issues I have, is my objective with this project.

I am also looking to delight, to provide a feature rich, beautiful out of the box experience. This Shell does not aim to be posix compliant.

## Development Roadmap

Here is a concise plan for the next features to be implemented.

### 1. Improve Tab Completion

The current implementation only completes command names. The next step is to add file and directory path completion.

- **Detect context:** In `tabComplete.swift`, determine if the user is typing a command or a path. If the input contains spaces, completion should apply to the last word, treating it as a path.
- **List directory contents:** Use `FileManager.default.contentsOfDirectory(atPath:)` to get a list of files and folders in the current directory.
- **Filter and complete:** Filter the list based on the word being completed. If there's a unique match, append the remaining part of the name. If the completed item is a directory, append a `/`.

### 2. Dynamic Environment Variables

Processes spawned by Swell should inherit the environment of the parent shell.

- **Fetch environment:** In `spawnProcess.swift`, replace the hardcoded `env` dictionary with a call to `ProcessInfo.processInfo.environment`. This will provide a `[String: String]` dictionary of the current environment variables.
- **Pass to `posix_spawnp`:** Ensure the dynamically retrieved environment variables are correctly formatted and passed to the `envp` argument of `posix_spawnp`.

### 3. Robust Error Handling

Improve feedback for failed commands.

- **`changeDirectory`:** Before attempting to change directory, verify the target path exists and is a directory using `FileManager.default.fileExists(atPath:isdirectory:)`. If not, print an informative error message to the user (e.g., "cd: no such file or directory: <path>").
- **`spawnProcess`:** Check the return values of `posix_spawnp` and `waitpid`. If an error occurs (e.g., command not found), print a descriptive error message like "swell: command not found: <command>".

## Testing

To ensure Swell is robust and reliable, we will use **Swift Testing**, a modern, expressive, and cross-platform testing framework. It works seamlessly on Linux with the Swift Package Manager.

### Writing Tests

1.  Create the test directory structure if it doesn't exist:
    ```bash
    mkdir -p Tests/SwellTests
    ```
2.  Create your first test file:
    ```bash
    touch Tests/SwellTests/SwellTests.swift
    ```
3.  Add test code to `Tests/SwellTests/SwellTests.swift`. With Swift Testing, you can write clear and concise tests using the `@Test` macro and `#expect` expressions.

    ```swift
    import Testing
    @testable import Swell

    @Test func example() {
      #expect(2 + 2 == 4)
    }
    ```

    You can organize tests into suites and add descriptive tags for better structure and filtering.

    ```swift
    @Suite("Core Functionality Tests")
    struct CoreTests {
        @Test("Input Sanitization", .tags(.core))
        func testSanitizeInput() {
            let input = "  ls -la  "
            let sanitized = sanitiseInput(input: input)
            #expect(sanitized == ["ls", "-la"])
        }
    }
    ```

### Running Tests

To run your entire test suite from the command line, simply execute the following command in the root of the project:

```bash
swift test
```

This command will compile your project and the test files, then execute the tests and report the results. You can also filter tests based on names or tags for more targeted feedback.
