# Zebra Link-OS Swift Package

> **Bring Zebra’s Link‑OS™ iOS SDK into your app with nothing but Swift Package Manager — no manual framework dragging, no bridging headers, just `import ZebraLinkOS` and print.**

---

## ✨ Why this repo exists

Zebra ship their iOS SDK as an **XCFramework**. Wrapping it in a Swift Package gives you:

| Benefit | Details |
|---------|---------|
| **One‑line install** | Xcode resolves and caches the dependency. |
| **CI‑friendly** | Works out‑of‑the‑box with GitHub Actions, Bitrise, Xcode Cloud, etc. |
| **Clear versioning** | Git tags (`1.0.0`, `1.1.0` …) track SDK upgrades. |
| **Autocomplete out of the box** | Public headers are embedded; Swift’s Clang importer exposes the APIs automatically. |

---

## 🚀 Quick start (Xcode projects)

1. **Add the package**

   ```text
   Xcode ▸ File ▸ Add Packages…
   URL: https://github.com/moyoteg/ZebraLinkOS
   Version rule: Up to Next Major 1.0.0
   ```

2. **Import & print**

   ```swift
   import ZebraLinkOS

   let connection = TcpPrinterConnection(ipAddress: "192.168.1.100", andWithPort: 9100)!
   if connection.open() {
       let zpl = "^XA^FO50,50^ADN,36,20^FDHello, Zebra!^FS^XZ"
       connection.write(zpl.data(using: .utf8), error: nil)
       connection.close()
   }
   ```

---

## 📦 Using this package *from another Swift Package*

Drop the snippet below into your **own** `Package.swift` to bring in Zebra Link‑OS:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MyAwesomeLib",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MyAwesomeLib",
            targets: ["MyAwesomeLib"]
        )
    ],
    dependencies: [
        // ➡️ Copy‑paste this line
        .package(url: "https://github.com/moyoteg/ZebraLinkOS", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "MyAwesomeLib",
            dependencies: [
                // Reference the product here
                .product(name: "ZebraLinkOS", package: "ZebraLinkOS")
            ]
        )
    ]
)
```

Run `swift build` and you’re done — your library can now `import ZebraLinkOS`.

---

## 🛠 Requirements

| | Minimum |
|---|---|
| **Xcode** | 15.0 |
| **iOS** | 13.0 |
| **Swift tools** | 5.9 |

---

## 🔑 Entitlements & Info.plist

| Connection | Add to Info.plist |
|-----------|-------------------|
| **Wi‑Fi / Ethernet** | `NSLocalNetworkUsageDescription` |
| **MFi Bluetooth** | `NSBluetoothAlwaysUsageDescription` **and** an MFi Accessory entitlement |

---

## 📄 License

This package bundles Zebra’s Link‑OS SDK under the Zebra Technologies **End‑User License Agreement**.  See [`LICENSE`](LICENSE) for full terms.