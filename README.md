# Zebra Link-OS Swift Package

> **Bring Zebra’s Link‑OS™ iOS SDK into your app with nothing but Swift Package Manager — no manual framework dragging, no bridging headers, just `import ZebraLinkOS` and print.**

---

## ✨ Why this repo exists

Zebra ship their iOS SDK as an **XCFramework**. Wrapping it in a Swift Package gives you:

| Benefit | Details |
|---------|---------|
| **One‑line install** | Xcode resolves and caches the dependency. |
| **CI‑friendly** | Works on GitHub Actions, Bitrise, Xcode Cloud, etc. |
| **Clear versioning** | Git tags (`1.0.0`, `1.1.0`, …) track SDK upgrades. |
| **Autocomplete**    | Public headers embedded; Swift’s Clang importer exposes APIs. |

---

## 🚀 Quick start

1. **Add the package**  
   ```text
   File ▸ Packages ▸ Add Package Dependency…
   URL: https://github.com/moyoteg/ZebraLinkOS
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
