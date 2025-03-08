This library aims to provide a simple and elegant approach to writing network requests. It's designed to be lightweight, adding a thin layer on top of `URLSession` without excessive engineering overhead. 

#### Our primary objectives are:

- **Lightweight networking library:** Keep the library small and efficient.
- **Easy to maintain:** Prioritize clear code and modular design for maintainability.
- **Beginner friendly:** Make the library accessible to developers of all levels.
- **Well documented:** Provide comprehensive documentation to guide usage.
- **Customizable and testable:** Allow for flexibility and ensure code quality through testing.


Currently, this library supports basic HTTP data requests (`GET`, `POST`, `PUT`, `DELETE`) and includes a small file upload feature using `multipart/form-data`. These capabilities address the majority of network communication needs in most applications.<br><br>


For detailed information on feature status, please refer to the [Roadmap](https://github.com/AnbalaganD/EagleNet/wiki/Roadmap) file
<br><br>

### Swift Package manager (SPM) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FAnbalaganD%2FEagleNet%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/AnbalaganD/EagleNet)

EagleNet is available through [SPM](https://github.com/AnbalaganD/EagleNet). Use below URL to add as a dependency

```swift
dependencies: [
    .package(url: "https://github.com/AnbalaganD/EagleNet", .upToNextMajor(from: "1.0.4"))
]
```

## Usage
```swift
import EagleNet

struct User: Decodable {
    let name: String
    let profile: URL?
}

let response: User = try await EagleNet.networkService.execute(
    DataRequest(url: "https://example.com/user/1")
)

```

## Author

[Anbalagan D](mailto:anbu94p@gmail.com)

## License

EagleNet is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
