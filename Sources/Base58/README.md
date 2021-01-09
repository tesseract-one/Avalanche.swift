# Base58Swift

## Update (by Daniel Leping on Jan 9, 2021)
## Modified to depend on CryptoSwift instead of Mac built-in crypto lib for the purposes of Avalanche library. This way we can have it for Linux. Make a PR?

Base58Swift is a Swift library that implements Base58 / Base58Check encodings for cryptocurrencies. It is based off of [go-base-58](https://github.com/jbenet/go-base58) with some added functions.

## Usage

Base58Swift provides a static utility class, `Base58`, which provides encoding and decoding functions.

To encode / decode in Base58:
```swift
let bytes: [UInt8] = [255, 254, 253, 252]

let encodedString = Base58.encode(bytes)!
let decodedBytes = Base58.decode(encodedString)!

print(encodedString) // 7YXVWT
print(decodedBytes)  // [255, 254, 253, 252]
```

To encode / decode in Base58Check:
```swift
let bytes: [UInt8] = [255, 254, 253, 252]

let encodedString = Base58.base58CheckEncode(bytes)!
let decodedBytes = Base58.base58CheckDecode(encodedString)!

print(encodedString) // jpUz5f99p1R
print(decodedBytes)  // [255, 254, 253, 252]
```

## Contributing

Pull requests are welcome.

To get set up:
```shell
$ brew install xcodegen # if you don't already have it
$ xcodegen generate # Generate an XCode project from Project.yml
$ open Base58Swift.xcodeproj
```

## License

MIT
