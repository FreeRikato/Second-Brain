![[Pasted image 20250302032324.png]]

> **Objective**: Building tiny, fast binaries for all major desktop and mobile platforms.

```bash
npm create tauri-app@latest
yarn create tauri-app
pnpm create tauri-app
```

## Why Tauri?
- Secure foundation for building apps
	- Built on Rust, takes advantage of memory, thread, and type-safety offered by rust
- Smaller bundle size by using the system's native webview
	- Code + Specific Assets ✅ Browser Engine ❌
- Flexibility for developers
	- Virtually any frontend framework is compatible
	- Bindings between JavaScript and Rust are available to developers using the `invloke` function in JavaScript, Swift and Kotlin bindings available for [[tauri plugins]]
		- TAO library => Responsible for creating and managing windows in Tauri applications.
		- WRY library => Handles rendering of web views in Tauri applications.
		- Tauri plugins => Extend the core functionalities of Tauri.

[Refer Tauri pre-requisites to install necessary dependencies](https://v2.tauri.app/start/prerequisites/)

## Tauri Frontend Configuration
- **Supports most frontend frameworks;** some may need extra setup
- Use SSG, SPA, or MPA (SSR is not supported) [[webpage-rendering-techniques]]
- For mobile, a dev server is needed on an internal IP.
- Follow a proper client-server model (avoid hybrid SSR)
- Vite is recommended for React, Svelte, Vue, and JS/TS
- **Meta-frameworks** need extra config for SSR workaraounds

## Tauri architecture

- *Problem*: Traditional desktop apps require large runtimes (e.g. Electron) and increase application size
- *Solution*: Use Rust for the backend and Webview for rendering, avoiding shipping a full browser engine.
![[Pasted image 20250302035538.png]]
- **What Tauri is NOT**: 
> ❌ Kernel wrapper (does not wrap OS) nor VM (interacts directly with OS-level APIs)
> Uses `WRY` and `TAQ` to do the heavy lifting in making calls to the OS

![Tauri Architecture](https://v2.tauri.app/d2/docs/concept/architecture-0.svg)

### **Core Ecosystem**

| Component             | Description                                                                                                                                                                                                            |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **tauri**             | The major crate that holds everything together. It integrates runtimes, macros, utilities, and APIs. Reads `tauri.conf.json` at compile time for configuration and handles script injection, API hosting, and updates. |
| **tauri-runtime**     | The glue layer between Tauri and lower-level webview libraries.                                                                                                                                                        |
| **tauri-macros**      | Creates macros for context, handlers, and commands using `tauri-codegen`.                                                                                                                                              |
| **tauri-utils**       | Provides reusable utilities like parsing config files, detecting platform triples, injecting CSP, and managing assets.                                                                                                 |
| **tauri-build**       | Applies macros at build-time to enable special features required by Cargo.                                                                                                                                             |
| **tauri-codegen**     | Embeds, hashes, and compresses assets (icons, system tray), parses `tauri.conf.json`, and generates the `Config` struct.                                                                                               |
| **tauri-runtime-wry** | Enables system-level interactions for WRY, such as printing, monitor detection, and windowing-related tasks.                                                                                                           |

---

### **Tauri Tooling**

| Component                         | Description                                                                                                                                       |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **API (JavaScript / TypeScript)** | TypeScript library that provides JavaScript endpoints for frontend frameworks to communicate with backend activity. Uses webview message passing. |
| **Bundler (Rust / Shell)**        | Library that builds Tauri apps for detected platforms (Windows, macOS, Linux). Planned support for mobile. Can be used outside of Tauri projects. |
| **cli.rs (Rust)**                 | Rust-based executable that provides the CLI interface for managing Tauri applications. Supports macOS, Windows, and Linux.                        |
| **cli.js (JavaScript)**           | JavaScript wrapper around `cli.rs`, using `napi-rs` to produce npm packages for different platforms.                                              |
| **create-tauri-app (JavaScript)** | Toolkit for quickly scaffolding new Tauri projects with a frontend framework of choice.                                                           |

---

### **Upstream Crates**

|Component|Description|
|---|---|
|**TAO**|Cross-platform Rust library for application window creation. Supports Windows, macOS, Linux, iOS, and Android. Fork of `winit`, extended with features like the menu bar and system tray.|
|**WRY**|Cross-platform Rust library for WebView rendering. Supports Windows, macOS, and Linux. Tauri uses WRY to abstract webview handling and interactions.|

---

### **Additional Tooling**

|Component|Description|
|---|---|
|**tauri-action**|GitHub workflow that builds Tauri binaries for all platforms. Allows basic Tauri app creation even without setup.|
|**tauri-vscode**|Enhances Visual Studio Code with additional Tauri-related features.|
|**vue-cli-plugin-tauri**|Enables quick installation of Tauri in a `vue-cli` project.|