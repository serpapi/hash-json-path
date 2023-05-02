# HashJsonPath

HashJsonPath is a simple gem to access hash and set hash value using json path.

## Usage

```ruby
hash = {
  a: {
    b: {
      c: 10
    },
    c: 20,
    d: [
      {e: 30},
      {f: 40}
    ]
  }
}

# Get
HashJsonPath.on(hash).get("a[d][1][f]") 
# => 40

# Set
HashJsonPath.on(hash).set("a[b][c]", { x: 100 })
# => { a: { b: { c: { x: 100 } } } ... }

# Merge - Add to the end of Hash
HashJsonPath.on(hash).merge("a[b]", { x: 100 })
# => { a: { b: { c: 10, x: 100 } } ... }

# Prepend - Insert from the start of Hash
HashJsonPath.on(hash).prepend("a[b]", { x: 100 })
# => { a: { b: { x: 100, c: 10 } } ... }
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).