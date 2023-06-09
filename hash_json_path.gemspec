# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "hash-json-path"
  spec.version       = "1.0.2"
  spec.authors       = ['Terry Tan']
  spec.email         = ["tanyongsheng0805@gmail.com"]
  spec.description   = "HashJsonPath is a simple gem to access hash and set hash value using json path."
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/serpapi/hash-json-path"
  spec.license       = "MIT"
  spec.require_paths = ["lib"]
  spec.files         += Dir.glob("lib/**/*.rb")
end