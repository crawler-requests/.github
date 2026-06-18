<div align="center">

# 🕷️ crawler-requests

**为每一种主流编程语言提供 `requests` 风格的 HTTP 客户端**
**内置 TLS / HTTP2 / JA3 / JA4 指纹自定义 · 面向爬虫与反检测场景**

*A `requests`-style HTTP client for every major programming language —*
*with TLS / HTTP2 / JA3 / JA4 fingerprint customization, built for crawlers & anti-bot.*

[[99] 个语言客户端](#-语言客户端) · [核心引擎](#-核心与工具) · [指纹评测](#-核心与工具)

</div>

---

## 这是什么

[`crawler-requests`](https://github.com/crawler-requests) 是一组**跨语言的 HTTP 客户端**家族:每个主流编程语言都有一个 `requests-<lang>` 仓库,API 风格统一参考 Python 的 [`requests`](https://github.com/psf/requests),并内置 **TLS / HTTP2 / JA3 / JA4 指纹定制**能力,专门应对**基于指纹的反爬检测**(Cloudflare、Akamai、Datadome 等)。

核心思路:**不是随机伪造指纹,而是冒充真实浏览器/客户端**——底层引擎基于 uTLS 重放真实抓包的 ClientHello,让请求的 JA3/JA4 恰好等于 Chrome / Firefox / iOS 等真实客户端,混进正常流量。

## ✨ 特性

- 🔐 **TLS / JA3 / JA4 指纹自定义** — 冒充真实浏览器,绕过指纹反爬
- ⚡ **HTTP/2 支持**,含 Akamai HTTP2 指纹
- 🧩 **跨语言统一的 `requests` 风格 API** — 换语言不换写法
- 🛡️ 面向爬虫 / 数据采集 / 反检测场景

## 🏗️ 架构

```
                       ┌──────────────────────────┐
  requests-python ───▶ │                          │
  requests-rust   ───▶ │   requests-go  (引擎)     │ ◀── uTLS / BoringSSL
  requests-<lang> ───▶ │   Go · GPL-3.0           │      真实浏览器指纹库
                       │   (fork of wangluozhe)   │
                       └────────────┬─────────────┘
                                    │ 采集 / 校验 / 对比指纹
                       ┌────────────▼─────────────┐
                       │ tls-fingerprint-benchmark │
                       │ (JA3/JA4/HTTP2 评测)      │
                       └──────────────────────────┘
```

- **requests-go** = 整个家族的**底层引擎**,基于 uTLS。
- **requests-python** = 通过 FFI 加载编译好的 Go 动态库(`.so`/`.dll`/`.dylib`),在 Python 里直接用。
- **requests-\<lang\>** = 各语言客户端(部分早期 scaffold 阶段)。

## 🧠 核心与工具

| 仓库 | 作用 | License |
|---|---|---|
| [`requests-go`](https://github.com/crawler-requests/requests-go) | 🧠 **核心引擎**(Go)。基于 uTLS 重放真实浏览器 TLS 指纹,支持 HTTP/2、JA3/JA4 自定义。整个家族的底层实现。 | GPL-3.0 |
| [`requests-python`](https://github.com/crawler-requests/requests-python) | **Python 版**。FFI 加载编译好的 Go 引擎动态库,Python 里直接用 `requests` 风格 API。 | MIT |
| [`requests-java`](https://github.com/crawler-requests/requests-java) | **Java 版**(开发中)。 | Apache-2.0 |
| [`tls-fingerprint-benchmark`](https://github.com/crawler-requests/tls-fingerprint-benchmark) | 🔬 **TLS 指纹评测套件**。采集 / 校验 / 对比各客户端的 JA3 / JA4 / HTTP2(Akamai)指纹,量化"有多像真实浏览器"。 | — |

## 🌐 语言客户端

共 **99 个** `requests-<lang>` 仓库。状态图例: ✅ 可用 · 🔧 开发中 · 🚧 规划中(scaffold)。

### 主流语言(33)

| 语言 | 仓库 | 状态 |
|---|---|---|
| C | [`C`](https://github.com/crawler-requests/requests-c) | 🚧 规划中 |
| C++ | [`C++`](https://github.com/crawler-requests/requests-cpp) | 🚧 规划中 |
| C# | [`C#`](https://github.com/crawler-requests/requests-csharp) | 🚧 规划中 |
| Clojure | [`Clojure`](https://github.com/crawler-requests/requests-clojure) | 🚧 规划中 |
| Crystal | [`Crystal`](https://github.com/crawler-requests/requests-crystal) | 🚧 规划中 |
| Dart | [`Dart`](https://github.com/crawler-requests/requests-dart) | 🚧 规划中 |
| Elixir | [`Elixir`](https://github.com/crawler-requests/requests-elixir) | 🚧 规划中 |
| Erlang | [`Erlang`](https://github.com/crawler-requests/requests-erlang) | 🚧 规划中 |
| F# | [`F#`](https://github.com/crawler-requests/requests-fsharp) | 🚧 规划中 |
| Groovy | [`Groovy`](https://github.com/crawler-requests/requests-groovy) | 🚧 规划中 |
| Haskell | [`Haskell`](https://github.com/crawler-requests/requests-haskell) | 🚧 规划中 |
| JavaScript | [`JavaScript`](https://github.com/crawler-requests/requests-javascript) | 🚧 规划中 |
| Julia | [`Julia`](https://github.com/crawler-requests/requests-julia) | 🚧 规划中 |
| Kotlin | [`Kotlin`](https://github.com/crawler-requests/requests-kotlin) | 🚧 规划中 |
| Lua | [`Lua`](https://github.com/crawler-requests/requests-lua) | 🚧 规划中 |
| MATLAB | [`MATLAB`](https://github.com/crawler-requests/requests-matlab) | 🚧 规划中 |
| Mojo | [`Mojo`](https://github.com/crawler-requests/requests-mojo) | 🚧 规划中 |
| Nim | [`Nim`](https://github.com/crawler-requests/requests-nim) | 🚧 规划中 |
| Objective-C | [`Objective-C`](https://github.com/crawler-requests/requests-objective-c) | 🚧 规划中 |
| OCaml | [`OCaml`](https://github.com/crawler-requests/requests-ocaml) | 🚧 规划中 |
| Perl | [`Perl`](https://github.com/crawler-requests/requests-perl) | 🚧 规划中 |
| PHP | [`PHP`](https://github.com/crawler-requests/requests-php) | 🚧 规划中 |
| PowerShell | [`PowerShell`](https://github.com/crawler-requests/requests-powershell) | 🚧 规划中 |
| R | [`R`](https://github.com/crawler-requests/requests-r) | 🚧 规划中 |
| Ruby | [`Ruby`](https://github.com/crawler-requests/requests-ruby) | 🚧 规划中 |
| Rust | [`Rust`](https://github.com/crawler-requests/requests-rust) | 🚧 规划中 |
| Scala | [`Scala`](https://github.com/crawler-requests/requests-scala) | 🚧 规划中 |
| Shell | [`Shell`](https://github.com/crawler-requests/requests-shell) | 🚧 规划中 |
| Solidity | [`Solidity`](https://github.com/crawler-requests/requests-solidity) | 🚧 规划中 |
| Swift | [`Swift`](https://github.com/crawler-requests/requests-swift) | 🚧 规划中 |
| Visual Basic .NET | [`Visual Basic .NET`](https://github.com/crawler-requests/requests-visual-basic-net) | 🚧 规划中 |
| V | [`V`](https://github.com/crawler-requests/requests-v) | 🚧 规划中 |
| Zig | [`Zig`](https://github.com/crawler-requests/requests-zig) | 🚧 规划中 |

### 其他语言(63)

<details>
<summary>点击展开完整列表(按字母) —— 成熟/领域/历史/DSL 语言</summary>

| 语言 | 仓库 | 状态 |
|---|---|---|
| ABAP | [`ABAP`](https://github.com/crawler-requests/requests-abap) | 🚧 规划中 |
| ActionScript | [`ActionScript`](https://github.com/crawler-requests/requests-actionscript) | 🚧 规划中 |
| Ada | [`Ada`](https://github.com/crawler-requests/requests-ada) | 🚧 规划中 |
| Agda | [`Agda`](https://github.com/crawler-requests/requests-agda) | 🚧 规划中 |
| Apex | [`Apex`](https://github.com/crawler-requests/requests-apex) | 🚧 规划中 |
| APL | [`APL`](https://github.com/crawler-requests/requests-apl) | 🚧 规划中 |
| Assembly | [`Assembly`](https://github.com/crawler-requests/requests-assembly) | 🚧 规划中 |
| AutoHotkey | [`AutoHotkey`](https://github.com/crawler-requests/requests-autohotkey) | 🚧 规划中 |
| Awk | [`Awk`](https://github.com/crawler-requests/requests-awk) | 🚧 规划中 |
| BQN | [`BQN`](https://github.com/crawler-requests/requests-bqn) | 🚧 规划中 |
| Cap'n Proto | [`Cap'n Proto`](https://github.com/crawler-requests/requests-cap-n-proto) | 🚧 规划中 |
| Carbon | [`Carbon`](https://github.com/crawler-requests/requests-carbon) | 🚧 规划中 |
| CMake | [`CMake`](https://github.com/crawler-requests/requests-cmake) | 🚧 规划中 |
| COBOL | [`COBOL`](https://github.com/crawler-requests/requests-cobol) | 🚧 规划中 |
| Common Lisp | [`Common Lisp`](https://github.com/crawler-requests/requests-common-lisp) | 🚧 规划中 |
| CUE | [`CUE`](https://github.com/crawler-requests/requests-cue) | 🚧 规划中 |
| Curry | [`Curry`](https://github.com/crawler-requests/requests-curry) | 🚧 规划中 |
| D | [`D`](https://github.com/crawler-requests/requests-d) | 🚧 规划中 |
| Dockerfile | [`Dockerfile`](https://github.com/crawler-requests/requests-dockerfile) | 🚧 规划中 |
| Eiffel | [`Eiffel`](https://github.com/crawler-requests/requests-eiffel) | 🚧 规划中 |
| Elm | [`Elm`](https://github.com/crawler-requests/requests-elm) | 🚧 规划中 |
| Emacs Lisp | [`Emacs Lisp`](https://github.com/crawler-requests/requests-emacs-lisp) | 🚧 规划中 |
| Factor | [`Factor`](https://github.com/crawler-requests/requests-factor) | 🚧 规划中 |
| Fantom | [`Fantom`](https://github.com/crawler-requests/requests-fantom) | 🚧 规划中 |
| Forth | [`Forth`](https://github.com/crawler-requests/requests-forth) | 🚧 规划中 |
| Fortran | [`Fortran`](https://github.com/crawler-requests/requests-fortran) | 🚧 规划中 |
| GDScript | [`GDScript`](https://github.com/crawler-requests/requests-gdscript) | 🚧 规划中 |
| GLSL | [`GLSL`](https://github.com/crawler-requests/requests-glsl) | 🚧 规划中 |
| Gnuplot | [`Gnuplot`](https://github.com/crawler-requests/requests-gnuplot) | 🚧 规划中 |
| Haxe | [`Haxe`](https://github.com/crawler-requests/requests-haxe) | 🚧 规划中 |
| HLSL | [`HLSL`](https://github.com/crawler-requests/requests-hlsl) | 🚧 规划中 |
| Idris | [`Idris`](https://github.com/crawler-requests/requests-idris) | 🚧 规划中 |
| Jsonnet | [`Jsonnet`](https://github.com/crawler-requests/requests-jsonnet) | 🚧 规划中 |
| Lean | [`Lean`](https://github.com/crawler-requests/requests-lean) | 🚧 规划中 |
| Mercury | [`Mercury`](https://github.com/crawler-requests/requests-mercury) | 🚧 规划中 |
| Meson | [`Meson`](https://github.com/crawler-requests/requests-meson) | 🚧 规划中 |
| Move | [`Move`](https://github.com/crawler-requests/requests-move) | 🚧 规划中 |
| ObjectScript | [`ObjectScript`](https://github.com/crawler-requests/requests-objectscript) | 🚧 规划中 |
| OpenCL | [`OpenCL`](https://github.com/crawler-requests/requests-opencl) | 🚧 规划中 |
| Oz | [`Oz`](https://github.com/crawler-requests/requests-oz) | 🚧 规划中 |
| Pascal | [`Pascal`](https://github.com/crawler-requests/requests-pascal) | 🚧 规划中 |
| PL/SQL | [`PL/SQL`](https://github.com/crawler-requests/requests-plsql) | 🚧 规划中 |
| Prolog | [`Prolog`](https://github.com/crawler-requests/requests-prolog) | 🚧 规划中 |
| PureScript | [`PureScript`](https://github.com/crawler-requests/requests-purescript) | 🚧 规划中 |
| Racket | [`Racket`](https://github.com/crawler-requests/requests-racket) | 🚧 规划中 |
| ReScript | [`ReScript`](https://github.com/crawler-requests/requests-rescript) | 🚧 规划中 |
| SAS | [`SAS`](https://github.com/crawler-requests/requests-sas) | 🚧 规划中 |
| Scheme | [`Scheme`](https://github.com/crawler-requests/requests-scheme) | 🚧 规划中 |
| Smalltalk | [`Smalltalk`](https://github.com/crawler-requests/requests-smalltalk) | 🚧 规划中 |
| Standard ML | [`Standard ML`](https://github.com/crawler-requests/requests-standard-ml) | 🚧 规划中 |
| Starlark | [`Starlark`](https://github.com/crawler-requests/requests-starlark) | 🚧 规划中 |
| Stata | [`Stata`](https://github.com/crawler-requests/requests-stata) | 🚧 规划中 |
| SystemVerilog | [`SystemVerilog`](https://github.com/crawler-requests/requests-systemverilog) | 🚧 规划中 |
| Tcl | [`Tcl`](https://github.com/crawler-requests/requests-tcl) | 🚧 规划中 |
| Thrift | [`Thrift`](https://github.com/crawler-requests/requests-thrift) | 🚧 规划中 |
| Transact-SQL | [`Transact-SQL`](https://github.com/crawler-requests/requests-tsql) | 🚧 规划中 |
| Vala | [`Vala`](https://github.com/crawler-requests/requests-vala) | 🚧 规划中 |
| VBA | [`VBA`](https://github.com/crawler-requests/requests-vba) | 🚧 规划中 |
| Verilog | [`Verilog`](https://github.com/crawler-requests/requests-verilog) | 🚧 规划中 |
| VHDL | [`VHDL`](https://github.com/crawler-requests/requests-vhdl) | 🚧 规划中 |
| Vim Script | [`Vim Script`](https://github.com/crawler-requests/requests-vim-script) | 🚧 规划中 |
| WebAssembly | [`WebAssembly`](https://github.com/crawler-requests/requests-webassembly) | 🚧 规划中 |
| Wolfram Language | [`Wolfram Language`](https://github.com/crawler-requests/requests-wolfram-language) | 🚧 规划中 |

</details>

> 想要的语言不在列表里?在任意仓库提 Issue,或参考 [`docs/programming-languages.md`](https://github.com/crawler-requests/.github) 的完整语言清单(Top-100 之外的冷门语言按需创建,不批量铺开以防封号)。

## 📜 License 说明

各仓库 License 不一(历史遗留):引擎 `requests-go` 因 fork 为 **GPL-3.0**;`requests-python` 为 **MIT**;其余 scaffold 仓库统一 **Apache-2.0**。具体以各仓库 LICENSE 为准。

## 🤝 参与贡献

欢迎在各仓库的 Issues 讨论 API 设计、提交实现或反馈指纹兼容性问题。指纹相关的采集/校验工具位于 [`tls-fingerprint-benchmark`](https://github.com/crawler-requests/tls-fingerprint-benchmark)。

<div align="center">

<sub>本导航由仓库内的 `gen-org-readme.sh` 根据组织实时仓库列表生成。</sub>

</div>
