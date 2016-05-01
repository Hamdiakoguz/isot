# isot

A simple WSDL parser in crystal. Ported from [wasabi](https://github.com/savonrb/wasabi) ruby gem.

[![Build Status](https://travis-ci.org/Hamdiakoguz/isot.svg?branch=master)](https://travis-ci.org/Hamdiakoguz/isot)

## Usage

```crystal
require "./src/isot"
document = Isot.document("./spec/fixtures/authentication.wsdl")
```

Get the SOAP endpoint:
```crystal
puts document.endpoint
# => http://example.com/validation/1.0/AuthenticationService
```

Get the target namespace:
```crystal
puts document.namespace
# => http://v1_0.ws.auth.order.example.com/
```

Check whether elementFormDefault is set to `"qualified"` or `"unqualified"`:
```crystal
puts document.element_form_default
# => unqualified
```

Get a list of available SOAP actions (snakecase for convenience):
```crystal
puts document.soap_actions
# => ["authenticate"]
```

Get a map of SOAP actions from String to Isot::Operation:
```crystal
puts document.operations
# => {"authenticate" => Isot::Operation(@name="authenticate", @action="authenticate", @inputs=[Isot::Message(@name="authenticate", @type=nil, @element="authenticate")], @outputs=[Isot::Message(@name="authenticateResponse", @type=nil, @element="authenticateResponse")], @namespace_identifier="tns", @parameters=[])}
```

## Contributing

1. Fork it ( https://github.com/Hamdiakoguz/isot/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Hamdiakoguz](https://github.com/Hamdiakoguz) Hamdi Akoğuz - creator, maintainer
- [enderahmetyurt](https://github.com/enderahmetyurt) Ender Ahmet Yurt - creator, maintainer
