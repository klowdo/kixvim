-- Go snippets for LuaSnip
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

go_snippets = {
  -- Main function
  s("main", fmt([[
    package main

    func main() {{
    	{}
    }}
  ]], {i(0)})),

  -- Package declaration
  s("pkg", fmt("package {}", {i(1, "main")})),

  -- Function declaration
  s("fn", fmt([[
    func {}({}) {} {{
    	{}
    }}
  ]], {
    i(1, "functionName"),
    i(2, ""),
    i(3, ""),
    i(0)
  })),

  -- Method declaration
  s("meth", fmt([[
    func ({} {}) {}({}) {} {{
    	{}
    }}
  ]], {
    i(1, "receiver"),
    i(2, "Type"),
    i(3, "methodName"),
    i(4, ""),
    i(5, ""),
    i(0)
  })),

  -- If error handling
  s("iferr", fmt([[
    if err != nil {{
    	{}
    }}
  ]], {
    c(1, {
      t("return err"),
      fmt("return {}, err", {i(1)}),
      fmt("return nil, err", {}),
      fmt("log.Fatal(err)", {}),
      fmt('log.Printf("error: %v", err)', {}),
      i(nil, "")
    })
  })),

  -- Error return
  s("errn", fmt("if err != nil {{\n\treturn {}\n}}", {
    c(1, {
      t("err"),
      fmt("{}, err", {i(1)}),
      fmt("nil, err", {}),
      fmt("nil, fmt.Errorf(\"{}: %w\", err)", {i(1, "error message")})
    })
  })),

  -- Error wrap with context
  s("errw", fmt('return fmt.Errorf("{}: %w", err)', {i(1, "context")})),

  -- Struct declaration
  s("st", fmt([[
    type {} struct {{
    	{}
    }}
  ]], {
    i(1, "StructName"),
    i(0)
  })),

  -- Interface declaration
  s("int", fmt([[
    type {} interface {{
    	{}
    }}
  ]], {
    i(1, "InterfaceName"),
    i(0)
  })),

  -- For loop
  s("for", fmt("for {} {{\n\t{}\n}}", {i(1, "i := 0; i < n; i++"), i(0)})),

  -- For range loop
  s("forr", fmt("for {}, {} := range {} {{\n\t{}\n}}", {
    i(1, "i"),
    i(2, "v"),
    i(3, "slice"),
    i(0)
  })),

  -- For range with index only
  s("fori", fmt("for {} := range {} {{\n\t{}\n}}", {
    i(1, "i"),
    i(2, "slice"),
    i(0)
  })),

  -- For range with value only
  s("forv", fmt("for _, {} := range {} {{\n\t{}\n}}", {
    i(1, "v"),
    i(2, "slice"),
    i(0)
  })),

  -- Switch statement
  s("sw", fmt([[
    switch {} {{
    case {}:
    	{}
    default:
    	{}
    }}
  ]], {
    i(1, "variable"),
    i(2, "value"),
    i(3),
    i(0)
  })),

  -- Select statement
  s("sel", fmt([[
    select {{
    case {}:
    	{}
    default:
    	{}
    }}
  ]], {
    i(1, "<-ch"),
    i(2),
    i(0)
  })),

  -- Go routine
  s("go", fmt("go func() {{\n\t{}\n}}()", {i(0)})),

  -- Go routine with channel
  s("goch", fmt([[
    go func(ch chan {}) {{
    	{}
    }}({})
  ]], {
    i(1, "type"),
    i(2),
    i(3, "ch")
  })),

  -- Defer statement
  s("df", fmt("defer {}", {i(0)})),

  -- Test function
  s("test", fmt([[
    func Test{}(t *testing.T) {{
    	{}
    }}
  ]], {
    i(1, "Function"),
    i(0)
  })),

  -- Table driven test
  s("tdt", fmt([[
    func Test{}(t *testing.T) {{
    	tests := []struct {{
    		name string
    		{}
    		want {}
    	}}{{
    		{{"{}"}},
    	}}
    	for _, tt := range tests {{
    		t.Run(tt.name, func(t *testing.T) {{
    			{}
    		}})
    	}}
    }}
  ]], {
    i(1, "Function"),
    i(2, "args"),
    i(3, "result"),
    i(4, "test case"),
    i(0)
  })),

  -- Benchmark function
  s("bench", fmt([[
    func Benchmark{}(b *testing.B) {{
    	for i := 0; i < b.N; i++ {{
    		{}
    	}}
    }}
  ]], {
    i(1, "Function"),
    i(0)
  })),

  -- HTTP handler
  s("handler", fmt([[
    func {}(w http.ResponseWriter, r *http.Request) {{
    	{}
    }}
  ]], {
    i(1, "handlerName"),
    i(0)
  })),

  -- HTTP handler method
  s("hm", fmt([[
    func ({} *{}) ServeHTTP(w http.ResponseWriter, r *http.Request) {{
    	{}
    }}
  ]], {
    i(1, "h"),
    i(2, "Handler"),
    i(0)
  })),

  -- JSON marshal
  s("json", fmt([[
    data, err := json.Marshal({})
    if err != nil {{
    	{}
    }}
  ]], {
    i(1, "value"),
    i(2, "return err")
  })),

  -- JSON unmarshal
  s("jsonu", fmt([[
    var {} {}
    err := json.Unmarshal({}, &{})
    if err != nil {{
    	{}
    }}
  ]], {
    i(1, "result"),
    i(2, "Type"),
    i(3, "data"),
    rep(1),
    i(0, "return err")
  })),

  -- Make slice
  s("make", fmt("make({}, {})", {
    i(1, "[]Type"),
    i(2, "0")
  })),

  -- Make map
  s("mapm", fmt("make(map[{}]{}, {})", {
    i(1, "KeyType"),
    i(2, "ValueType"),
    i(3, "0")
  })),

  -- Make channel
  s("makec", fmt("make(chan {}, {})", {
    i(1, "Type"),
    i(2, "0")
  })),

  -- Printf
  s("pf", fmt('fmt.Printf("{}: %v\\n", {})', {
    i(1, "debug"),
    i(2, "value")
  })),

  -- Println
  s("pl", fmt("fmt.Println({})", {i(1)})),

  -- Sprintf
  s("sp", fmt('fmt.Sprintf("{}", {})', {
    i(1, "%v"),
    i(2)
  })),

  -- Errorf
  s("errf", fmt('fmt.Errorf("{}: %w", {})', {
    i(1, "error message"),
    i(2, "err")
  })),

  -- Context with cancel
  s("ctx", fmt("ctx, cancel := context.WithCancel({})\ndefer cancel()", {
    i(1, "context.Background()")
  })),

  -- Context with timeout
  s("ctxt", fmt("ctx, cancel := context.WithTimeout({}, {})\ndefer cancel()", {
    i(1, "context.Background()"),
    i(2, "time.Second")
  })),

  -- Context with deadline
  s("ctxd", fmt("ctx, cancel := context.WithDeadline({}, {})\ndefer cancel()", {
    i(1, "context.Background()"),
    i(2, "time.Now().Add(time.Second)")
  })),

  -- Goroutine with WaitGroup
  s("wg", fmt([[
    var wg sync.WaitGroup
    wg.Add({})
    go func() {{
    	defer wg.Done()
    	{}
    }}()
    wg.Wait()
  ]], {
    i(1, "1"),
    i(0)
  })),

  -- Mutex lock/unlock
  s("mu", fmt([[
    {}.Lock()
    defer {}.Unlock()
    {}
  ]], {
    i(1, "mu"),
    rep(1),
    i(0)
  })),

  -- Read lock/unlock
  s("rmu", fmt([[
    {}.RLock()
    defer {}.RUnlock()
    {}
  ]], {
    i(1, "mu"),
    rep(1),
    i(0)
  })),

  -- Type assertion
  s("ta", fmt("{}, ok := {}.({}){}if !ok {{\n\t{}\n}}", {
    i(1, "value"),
    i(2, "interface"),
    i(3, "Type"),
    t("\n"),
    i(0, "// handle error")
  })),

  -- Type switch
  s("ts", fmt([[
    switch {} := {}.(type) {{
    case {}:
    	{}
    default:
    	{}
    }}
  ]], {
    i(1, "v"),
    i(2, "interface"),
    i(3, "Type"),
    i(4),
    i(0)
  })),

  -- Append to slice
  s("ap", fmt("{} = append({}, {})", {
    i(1, "slice"),
    rep(1),
    i(2, "value")
  })),

  -- Import statement
  s("im", fmt('import "{}"', {i(1, "package")})),

  -- Import block
  s("imp", fmt([[
    import (
    	{}
    )
  ]], {i(0)})),

  -- Constant declaration
  s("const", fmt("const {} = {}", {
    i(1, "NAME"),
    i(2, "value")
  })),

  -- Constant block
  s("consts", fmt([[
    const (
    	{}
    )
  ]], {i(0)})),

  -- Variable declaration
  s("var", fmt("var {} {}", {
    i(1, "name"),
    i(2, "Type")
  })),

  -- Variable block
  s("vars", fmt([[
    var (
    	{}
    )
  ]], {i(0)})),

  -- Init function
  s("init", fmt([[
    func init() {{
    	{}
    }}
  ]], {i(0)})),

  -- Struct with JSON tags
  s("stj", fmt([[
    type {} struct {{
    	{} {} `json:"{}"`
    }}
  ]], {
    i(1, "StructName"),
    i(2, "Field"),
    i(3, "Type"),
    f(function(args)
      local field = args[1][1]
      return field:sub(1, 1):lower() .. field:sub(2)
    end, {2})
  })),

  -- HTTP middleware
  s("mid", fmt([[
    func {}(next http.Handler) http.Handler {{
    	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {{
    		{}
    		next.ServeHTTP(w, r)
    	}})
    }}
  ]], {
    i(1, "middleware"),
    i(0, "// middleware logic")
  })),

  -- Database query
  s("dbq", fmt([[
    rows, err := db.Query("{}", {})
    if err != nil {{
    	{}
    }}
    defer rows.Close()

    for rows.Next() {{
    	{}
    }}
    if err := rows.Err(); err != nil {{
    	{}
    }}
  ]], {
    i(1, "SELECT * FROM table WHERE id = ?"),
    i(2, "id"),
    i(3, "return err"),
    i(4, "// scan rows"),
    i(0, "return err")
  })),

  -- Single row query
  s("dbqr", fmt([[
    var {} {}
    err := db.QueryRow("{}", {}).Scan({})
    if err != nil {{
    	{}
    }}
  ]], {
    i(1, "result"),
    i(2, "Type"),
    i(3, "SELECT * FROM table WHERE id = ?"),
    i(4, "id"),
    i(5, "&result"),
    i(0, "return err")
  })),

  -- Execute statement
  s("dbex", fmt([[
    result, err := db.Exec("{}", {})
    if err != nil {{
    	{}
    }}
  ]], {
    i(1, "INSERT INTO table (column) VALUES (?)"),
    i(2, "value"),
    i(0, "return err")
  })),

  -- Custom error type
  s("errt", fmt([[
    type {}Error struct {{
    	{}
    }}

    func (e *{}Error) Error() string {{
    	return {}
    }}
  ]], {
    i(1, "Custom"),
    i(2, "Message string"),
    rep(1),
    i(0, "e.Message")
  })),
}
