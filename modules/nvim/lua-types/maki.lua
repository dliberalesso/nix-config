---@meta

-- Hand-translated from plugins/maki.d.luau in github.com/tontinton/maki.
-- Upstream generates that file with maki-docgen in Luau `declare` syntax,
-- which lua-language-server cannot parse. shortcut: update this mirror by
-- hand when the maki Lua API changes; when an EmmyLua maki types repo
-- appears, replace this file with a flake input like plugins-wezterm-types.

---@class maki.agent
---@field resolve_model fun(ctx: any, opts: any): any, string?
---@field system_prompt fun(ctx: any, opts: any): string?, string?
---@field tools fun(ctx: any, opts: any): any, string?
---@field callable_tools fun(ctx: any): any, string?
---@field call_tool fun(ctx: any, name: string, input: any, opts: any): string?, string?, string?
---@field session fun(ctx: any, opts: any): any, string?
---@field list fun(opts: any): any, string?

---@class maki.api
---@field register_tool fun(spec: any)
---@field register_permission_rule fun(spec: any)
---@field register_command fun(spec: any)
---@field register_prompt_hint fun(spec: any)
---@field register_options fun(spec: any): any
---@field set_prompt fun(spec: any)
---@field get_tools fun(opts: any): any
---@field get_tool fun(name: string): any
---@field run_command fun(cmdline: string): boolean?, string?
---@field create_autocmd fun(event: any, opts: any): number
---@field del_autocmd fun(id: number)
---@field exec_autocmds fun(event: any, opts: any)
---@field register_action fun(name: string, callback: any, opts: any): string
---@field declare_slot fun(name: string, default: any, opts: any): any
---@field set_slot fun(name: string, wrapper: any)
---@field get_slots fun(): any

---@class maki.async
---@field run fun(fn: any, on_finish: any)
---@field spawn fun(fn: any): any
---@field sleep fun(ms: number)
---@field await fun(argc: number, fn: any, ...): any
---@field wrap fun(argc: number, fn: any): any
---@field join fun(max_jobs: number, fns: any)
---@field gather fun(fns: any): any
---@field semaphore fun(n: number): any
---@field on_cancel fun(fn: any)

---@class maki.base64
---@field encode fun(data: string): string
---@field decode fun(str: string): string?, string?

---@class maki.env
---@field state_dir fun(): string?
---@field config_dir fun(): string?
---@field logs_dir fun(): string?
---@field legacy_dir fun(): string?

---@class maki.fn
---@field jobstart fun(cmd: any, opts: any): number?, string?
---@field jobstop fun(job_id: number)
---@field jobforget fun(job_id: number)
---@field jobwait fun(job_id: number, timeout_ms: number?): any, string?
---@field jobinfo fun(job_id: number): any, string?
---@field joblist fun(session: string?): any
---@field jobattach fun(job_id: number, opts: any): boolean?, string?
---@field jobfind fun(name: string): number?, string?
---@field executable fun(name: string): number
---@field winsaveview fun(): any, string?
---@field winrestview fun(view: any): boolean?, string?
---@field mode fun(): string

---@class maki.fs
---@field read fun(path: string, opts: any): string?, string?
---@field read_bytes fun(path: string, opts: any): string?, string?
---@field read_lines fun(path: string, opts: any): any, string?
---@field metadata fun(path: string): any, string?
---@field dirname fun(path: string): string?
---@field basename fun(path: string): string?
---@field joinpath fun(...): string
---@field normalize fun(path: string): string
---@field abspath fun(path: string): string
---@field parents fun(path: string): any
---@field root fun(source: string, marker: any): string?, string?
---@field relpath fun(base: string, target: string): string
---@field ext fun(path: string): string?
---@field dir fun(path: string, opts: any): any, string?
---@field write fun(path: string, content: string): true?, string?
---@field append fun(path: string, content: string): true?, string?
---@field atomic_write fun(path: string, content: string): true?, string?
---@field rename fun(from: string, to: string): true?, string?
---@field rm fun(path: string, opts: any): true?, string?
---@field mkdir fun(path: string, opts: any): true?, string?
---@field glob fun(pattern: any, opts: any): any, string?
---@field grep fun(pattern: string, opts: any): any, string?
---@field fuzzy_files fun(opts: any): any, string?

---@class maki.image
---@field probe fun(data: string): any, string?
---@field decode fun(data: string): any, string?

---@class maki.interpreter
---@field run fun(code: string, opts: any): any, string?

---@class maki.json
---@field encode fun(value: any): string?, string?
---@field decode fun(str: string, opts: any): any, string?
---@field schema_validator fun(schema: any): any, string?

---@class maki.keymap
---@field set fun(mode: any, lhs: string, rhs: any, opts: any)
---@field del fun(mode: any, lhs: string, opts: any)
---@field normalize fun(lhs: string): string?, string?

---@class maki.log
---@field debug fun(msg: string)
---@field info fun(msg: string)
---@field warn fun(msg: string)
---@field error fun(msg: string)

---@class maki.model
---@field get fun(): any, string?
---@field available fun(): any, string?
---@field set fun(opts: any): any, string?
---@field tier fun(name: string, provider: string?): any, string?
---@field info fun(spec: string): any, string?

---@class maki.net
---@field request fun(url: string, opts: any): any, string?
---@field connect fun(host: string, port: number, opts: any): any, string?
---@field connect_unix fun(path: string, opts: any): any, string?
---@field listen_unix fun(path: string): any, string?

---@class maki.pack
---@field add fun(specs: any, opts: any)
---@field get fun(names: any, opts: any): any, string?

---@class maki.plan
---@field read fun(opts: any): any, string?

---@class maki.provider.auth
---@field get fun(slug: string): any, string?
---@field set fun(slug: string, credentials: any): boolean?, string?
---@field clear fun(slug: string): boolean?, string?

---@class maki.provider
---@field register fun(spec: any)
---@field is_selected fun(slug: string): boolean
---@field http_error fun(res: any): any
---@field auth maki.provider.auth

---@class maki.session
---@field list fun(): any, string?
---@field live fun(): any, string?
---@field current fun(): string?, string?
---@field read fun(opts: any): any, string?
---@field export fun(opts: any): any, string?
---@field messages fun(opts: any): any, string?
---@field windows fun(opts: any): any, string?
---@field subagents fun(opts: any): any, string?
---@field focus fun(id: string): boolean?, string?
---@field delete fun(id: string): boolean?, string?
---@field new fun(opts: any): string?, string?
---@field prompt fun(text: string, opts: any): string?, string?
---@field notify fun(text: string, opts: any): boolean?, string?
---@field set_mode fun(mode: string, opts: any): boolean?, string?
---@field request_compact fun(opts: any): boolean?, string?
---@field set_title fun(opts: any): boolean?, string?
---@field data_dir fun(opts: any): string?, string?

---@class maki.task
---@field list fun(): any, string?
---@field focus fun(id: string): boolean?, string?
---@field remove fun(id: string): boolean?, string?
---@field stop fun(id: any, opts: any): any, string?
---@field send fun(ctx: any, id: string, text: string, opts: any): any, string?
---@field messages fun(ctx: any, id: string, opts: any): any, string?

---@class maki.text
---@field html_to_markdown fun(html: string): string?, string?
---@field to_utf8 fun(s: string): string
---@field fuzzy fun(needle: string, haystack: string, opts: any): number?, any
---@field fuzzy_list fun(needle: string, haystacks: any, opts: any): any

---@class maki.treesitter.language
---@field add fun(lang: string, opts: any): boolean?, string?
---@field register fun(lang: string, filetype: any)
---@field get_lang fun(filetype: string): string?
---@field get_filetypes fun(lang: string): any
---@field inspect fun(lang: string): any

---@class maki.treesitter.query
---@field parse fun(lang: string, query: string): any
---@field get fun(lang: string, name: string): any

---@class maki.treesitter
---@field get_parser fun(source: string, lang: string): any, string?
---@field get_string_parser fun(source: string, lang: string): any, string?
---@field get_node_text fun(node: any, source: string): string
---@field get_node_range fun(node: any): number, number, number, number
---@field get_range fun(node: any): any
---@field is_ancestor fun(dest: any, source: any): boolean
---@field is_in_node_range fun(node: any, line: number, col: number): boolean
---@field node_contains fun(node: any, range: any): boolean
---@field get_node fun(opts: any): any
---@field language maki.treesitter.language
---@field query maki.treesitter.query

---@class maki.ui
---@field buf fun(opts: any): any
---@field theme_color fun(name: string): string?
---@field theme_style fun(name: string): any
---@field highlight fun(code: string, lang: string, opts: any): any
---@field markdown fun(text: string, width: number): any
---@field humantime fun(secs: number): string
---@field terminal_size fun(): any
---@field display_width fun(text: string): number
---@field truncate_text fun(text: string, max_width: number): any
---@field set_mode fun(mode: string)
---@field set_cursor_shape fun(shape: string, opts: any)
---@field flash fun(msg: string)
---@field action fun(name: string): boolean?, string?
---@field open_editor fun(path: string): number
---@field open_win fun(buf: any, opts: any): any
---@field set_status_hint fun(spans: any, opts: any)
---@field set_window_title fun(title: string)
---@field input fun(): any, string?
---@field input_rules fun(opts: any)
---@field input_decorate fun(opts: any): any, string?
---@field input_edit fun(opts: any): any, string?
---@field input_submit fun(opts: any): boolean?, string?

---@class maki.uv
---@field cwd fun(): string?
---@field os_homedir fun(): string?
---@field os_getenv fun(name: string): string?

---@class maki.version
---@field parse fun(version: string, opts: any): any, string?
---@field cmp fun(v1: any, v2: any): number?, string?
---@field eq fun(v1: any, v2: any): boolean?, string?
---@field lt fun(v1: any, v2: any): boolean?, string?
---@field le fun(v1: any, v2: any): boolean?, string?
---@field gt fun(v1: any, v2: any): boolean?, string?
---@field ge fun(v1: any, v2: any): boolean?, string?
---@field last fun(versions: any): any, string?

---@class maki.yaml
---@field encode fun(value: any): string?, string?
---@field decode fun(str: string): any, string?

---@class maki
---@field setup fun(config: any)
---@field split fun(s: string, sep: string, opts: any): any
---@field packadd fun(name: string)
---@field defer_fn fun(callback: any, ms: number): any
---@field notify fun(msg: string, level: string?, opts: any)
---@field set_notify_handler fun(handler: any)
---@field deepcopy fun(orig: any, noref: boolean?): any
---@field NIL any
---@field agent maki.agent
---@field api maki.api
---@field async maki.async
---@field base64 maki.base64
---@field env maki.env
---@field fn maki.fn
---@field fs maki.fs
---@field image maki.image
---@field interpreter maki.interpreter
---@field json maki.json
---@field keymap maki.keymap
---@field log maki.log
---@field model maki.model
---@field net maki.net
---@field pack maki.pack
---@field plan maki.plan
---@field provider maki.provider
---@field session maki.session
---@field task maki.task
---@field text maki.text
---@field treesitter maki.treesitter
---@field ui maki.ui
---@field uv maki.uv
---@field version maki.version
---@field yaml maki.yaml
maki = {}
