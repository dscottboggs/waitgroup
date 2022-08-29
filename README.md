# waitgroup
Simple waitgroup implementation for Crystal.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     waitgroup:
       github: dscottboggs/waitgroup
   ```

2. Run `shards install`

## Usage

```crystal
require "waitgroup"

wg = WaitGroup.new
time_taken = Time.measure do
  10.times do
    wg.spawn do
      sleep 1
    end
  end
  wg.wait
end

time_taken.should be_close 1.second,
  delta: 0.1.seconds
```

See the spec file for more examples.

## Contributing

1. Fork it (<https://github.com/dscottboggs/waitgroup/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Verify your changes pass all tests, including formatting and linting with ameba
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request.

## Contributors

- [D. Scott Boggs](https://github.com/dscottboggs) - creator and maintainer
