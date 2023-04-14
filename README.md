# elixir-ex
Random Elixir examples and code snippets when learning Elixir.

Install [Hex](https://hex.pm/):
```bash
mix hex.local
```

Fetch dependencies:
```bash
mix deps.get
```

Create new Mix project:
```bash
mix new ex001_json
```

## How to select which tests to run?

Select tests to run:
```elixir
@tag runonly: true
test "foo" do
done
```

```bash
mix test --only runonly:true
```

Disable tests:
```elixir
@tag disabled: true
test "foo" do
done
```

`test_helpers.exs`:
```elixir
ExUnit.configure exclude: [disabled: true]
```