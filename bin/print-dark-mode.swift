import AppKit

if let style = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") {
    print(style, terminator:"")
}
