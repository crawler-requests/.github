#!/usr/bin/env bash
# Generate the crawler-requests ORG PROFILE README (lives in the `.github` repo).
# Fetches live public repo names so all links are correct; embeds a stable
# display-name map. Re-run any time the org changes.
# Usage: bash gen-org-readme.sh [output_path]
set -uo pipefail
ORG=crawler-requests
OUT="${1:-/tmp/org-profile-README.md}"
BASE="https://github.com/$ORG"

# ---- slug -> display name (stable; language names don't change) ----
declare -A D
D[abap]=ABAP; D[actionscript]=ActionScript; D[ada]=Ada; D[agda]=Agda; D[apl]=APL; D[apex]=Apex
D[assembly]=Assembly; D[autohotkey]=AutoHotkey; D[awk]=Awk; D[bqn]=BQN
D[cap-n-proto]="Cap'n Proto"; D[carbon]=Carbon; D[clojure]=Clojure; D[cmake]=CMake
D[cobol]=COBOL; D[common-lisp]="Common Lisp"; D[c]=C; D[cpp]="C++"
D[crystal]=Crystal; D[csharp]="C#"; D[cue]=CUE; D[curry]=Curry; D[d]=D; D[dart]=Dart
D[dockerfile]=Dockerfile; D[eiffel]=Eiffel; D[elixir]=Elixir; D[elm]=Elm
D[emacs-lisp]="Emacs Lisp"; D[erlang]=Erlang; D[factor]=Factor; D[fantom]=Fantom
D[forth]=Forth; D[fortran]=Fortran; D[fsharp]="F#"; D[gdscript]=GDScript
D[glsl]=GLSL; D[gnuplot]=Gnuplot; D[go]=Go; D[groovy]=Groovy; D[haskell]=Haskell
D[haxe]=Haxe; D[hlsl]=HLSL; D[idris]=Idris; D[java]=Java; D[javascript]=JavaScript
D[jsonnet]=Jsonnet; D[julia]=Julia; D[kotlin]=Kotlin; D[lean]=Lean; D[lua]=Lua
D[matlab]=MATLAB; D[mercury]=Mercury; D[meson]=Meson; D[mojo]=Mojo; D[move]=Move
D[nim]=Nim; D[objective-c]="Objective-C"; D[objectscript]=ObjectScript; D[ocaml]=OCaml
D[opencl]=OpenCL; D[oz]=Oz; D[pascal]=Pascal; D[perl]=Perl; D[php]=PHP
D[plsql]="PL/SQL"; D[powershell]=PowerShell; D[prolog]=Prolog; D[purescript]=PureScript
D[python]=Python; D[r]=R; D[racket]=Racket; D[rescript]=ReScript; D[ruby]=Ruby
D[rust]=Rust; D[sas]=SAS; D[scala]=Scala; D[scheme]=Scheme; D[shell]=Shell
D[smalltalk]=Smalltalk; D[solidity]=Solidity; D[standard-ml]="Standard ML"
D[starlark]=Starlark; D[stata]=Stata; D[swift]=Swift; D[systemverilog]=SystemVerilog
D[tcl]=Tcl; D[thrift]=Thrift; D[tsql]="Transact-SQL"; D[typescript]=TypeScript
D[v]=V; D[vala]=Vala; D[vba]=VBA; D[verilog]=Verilog; D[vhdl]=VHDL
D[vim-script]="Vim Script"; D[visual-basic-net]="Visual Basic .NET"
D[webassembly]=WebAssembly; D[wolfram-language]="Wolfram Language"; D[zig]=Zig

# classification sets (slugs)
CORE="go python java"                                   # featured in Core section
MAINSTREAM="javascript typescript c cpp csharp rust php ruby swift kotlin scala r perl shell dart lua objective-c haskell elixir erlang clojure julia nim zig crystal v fsharp groovy ocaml solidity matlab visual-basic-net powershell mojo"
in_set(){ case " $2 " in *" $1 "*) return 0;; esac; return 1; }

# fetch live PUBLIC requests-* repo names
mapfile -t REPOS < <(gh repo list "$ORG" --limit 1000 --json name,visibility \
  --jq '.[] | select(.visibility=="PUBLIC" and (.name|startswith("requests-"))) | .name')
SLUGS=(); for r in "${REPOS[@]}"; do SLUGS+=("${r#requests-}"); done

disp(){ printf '%s' "${D[$1]:-$1}"; }
link(){ printf '[`%s`](%s/%s)' "$2" "$BASE" "requests-$1"; }   # slug display -> repo link
status(){ # slug -> status badge
  case "$1" in
    go|python) printf '✅ 可用';; java) printf '🔧 开发中';;
    *) printf '🚧 规划中';;
  esac
}

emit_table(){ # slugs... -> markdown table | 语言 | 仓库 | 状态 |
  printf '| 语言 | 仓库 | 状态 |\n|---|---|---|\n'
  for s in "$@"; do
    printf '| %s | %s | %s |\n' "$(disp "$s")" "$(link "$s" "$(disp "$s")")" "$(status "$s")"
  done
}

# ---- which slugs go where ----
core_slugs=(); main_slugs=(); other_slugs=()
for s in "${SLUGS[@]}"; do
  if in_set "$s" "$CORE"; then core_slugs+=("$s");
  elif in_set "$s" "$MAINSTREAM"; then main_slugs+=("$s");
  else other_slugs+=("$s"); fi
done
n_total=${#SLUGS[@]}; n_main=${#main_slugs[@]}; n_other=${#other_slugs[@]}

# ---- write README ----
{
cat <<EOF
<div align="center">

# 🕷️ crawler-requests

**为每一种主流编程语言提供 \`requests\` 风格的 HTTP 客户端**
**内置 TLS / HTTP2 / JA3 / JA4 指纹自定义 · 面向爬虫与反检测场景**

*A \`requests\`-style HTTP client for every major programming language —*
*with TLS / HTTP2 / JA3 / JA4 fingerprint customization, built for crawlers & anti-bot.*

[[$n_total] 个语言客户端](#-语言客户端) · [核心引擎](#-核心与工具) · [指纹评测](#-核心与工具)

</div>

---

## 这是什么

[\`crawler-requests\`]($BASE) 是一组**跨语言的 HTTP 客户端**家族:每个主流编程语言都有一个 \`requests-<lang>\` 仓库,API 风格统一参考 Python 的 [\`requests\`](https://github.com/psf/requests),并内置 **TLS / HTTP2 / JA3 / JA4 指纹定制**能力,专门应对**基于指纹的反爬检测**(Cloudflare、Akamai、Datadome 等)。

核心思路:**不是随机伪造指纹,而是冒充真实浏览器/客户端**——底层引擎基于 uTLS 重放真实抓包的 ClientHello,让请求的 JA3/JA4 恰好等于 Chrome / Firefox / iOS 等真实客户端,混进正常流量。

## ✨ 特性

- 🔐 **TLS / JA3 / JA4 指纹自定义** — 冒充真实浏览器,绕过指纹反爬
- ⚡ **HTTP/2 支持**,含 Akamai HTTP2 指纹
- 🧩 **跨语言统一的 \`requests\` 风格 API** — 换语言不换写法
- 🛡️ 面向爬虫 / 数据采集 / 反检测场景

## 🏗️ 架构

\`\`\`
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
\`\`\`

- **requests-go** = 整个家族的**底层引擎**,基于 uTLS。
- **requests-python** = 通过 FFI 加载编译好的 Go 动态库(\`.so\`/\`.dll\`/\`.dylib\`),在 Python 里直接用。
- **requests-\<lang\>** = 各语言客户端(部分早期 scaffold 阶段)。

## 🧠 核心与工具

| 仓库 | 作用 | License |
|---|---|---|
| [\`requests-go\`]($BASE/requests-go) | 🧠 **核心引擎**(Go)。基于 uTLS 重放真实浏览器 TLS 指纹,支持 HTTP/2、JA3/JA4 自定义。整个家族的底层实现。 | GPL-3.0 |
| [\`requests-python\`]($BASE/requests-python) | **Python 版**。FFI 加载编译好的 Go 引擎动态库,Python 里直接用 \`requests\` 风格 API。 | MIT |
| [\`requests-java\`]($BASE/requests-java) | **Java 版**(开发中)。 | Apache-2.0 |
| [\`tls-fingerprint-benchmark\`]($BASE/tls-fingerprint-benchmark) | 🔬 **TLS 指纹评测套件**。采集 / 校验 / 对比各客户端的 JA3 / JA4 / HTTP2(Akamai)指纹,量化"有多像真实浏览器"。 | — |

## 🌐 语言客户端

共 **$n_total 个** \`requests-<lang>\` 仓库。状态图例: ✅ 可用 · 🔧 开发中 · 🚧 规划中(scaffold)。

### 主流语言($n_main)

EOF
IFS=$'\n' main_sorted=($(for s in "${main_slugs[@]}"; do printf '%s\t%s\n' "$(disp "$s")" "$s"; done | sort -f | cut -f2)); unset IFS
emit_table "${main_sorted[@]}"

cat <<EOF

### 其他语言($n_other)

<details>
<summary>点击展开完整列表(按字母) —— 成熟/领域/历史/DSL 语言</summary>

EOF
# sort others by display name
IFS=$'\n' sorted=($(for s in "${other_slugs[@]}"; do printf '%s\t%s\n' "$(disp "$s")" "$s"; done | sort -f | cut -f2)); unset IFS
emit_table "${sorted[@]}"

cat <<EOF

</details>

> 想要的语言不在列表里?在任意仓库提 Issue,或参考 [\`docs/programming-languages.md\`]($BASE/.github) 的完整语言清单(Top-100 之外的冷门语言按需创建,不批量铺开以防封号)。

## 📜 License 说明

各仓库 License 不一(历史遗留):引擎 \`requests-go\` 因 fork 为 **GPL-3.0**;\`requests-python\` 为 **MIT**;其余 scaffold 仓库统一 **Apache-2.0**。具体以各仓库 LICENSE 为准。

## 🤝 参与贡献

欢迎在各仓库的 Issues 讨论 API 设计、提交实现或反馈指纹兼容性问题。指纹相关的采集/校验工具位于 [\`tls-fingerprint-benchmark\`]($BASE/tls-fingerprint-benchmark)。

<div align="center">

<sub>本导航由仓库内的 \`gen-org-readme.sh\` 根据组织实时仓库列表生成。</sub>

</div>
EOF
} > "$OUT"

echo "wrote $OUT  ($n_total clients: $n_main mainstream + $n_other other + ${#core_slugs[@]} core)"
echo "lines: $(wc -l < "$OUT")"