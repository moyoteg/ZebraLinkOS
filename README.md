# Zebra Link‑OS Swift Package

> **Bring Zebra’s Link‑OS™ iOS SDK into your app with nothing but Swift Package Manager — no manual framework dragging, no bridging headers, just `import ZebraLinkOS` and print.**

---

## ✨ Why this repo exists

Zebra ship their iOS SDK as an **XCFramework**. By wrapping it in a Swift Package we get:

| Benefit | Details |
|---------|---------|
| **One‑line install** | Xcode resolves the package, handles updates, and caches builds. |
| **CI‑friendly** | Works with GitHub Actions, Bitrise, Xcode Cloud, etc. |
| **Source control clarity** | Version tags (`1.0.0`, `1.1.0` …) track SDK upgrades. |
| **Autocomplete out of the box** | Public headers are embedded; Swift’s Clang importer exposes the APIs automatically. |

---

## 🚀 Quick start

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

Boom — Link‑OS is in your build and ready to drive a printer.

*(Need a full SwiftUI demo screen? Scroll to **Appendix A**).*  

---

## 🛠 Requirements

| | Minimum |
|-|---------|
| **Xcode** | 15.0 |
| **iOS** | 13.0 |
| **Swift tools** | 5.9 |
| **Architectures bundled** | `ios-arm64`, `ios-arm64_x86_64-simulator` |

---

## 📁 Package layout

```
ZebraLinkOS/
├─ Package.swift             – declares a `.binaryTarget` pointing to the XCFramework
├─ ZSDK_API.xcframework/     – Zebra’s pre‑built SDK slices & headers
└─ README.md                 – this file
```

No bridging headers, no extra resource bundles, no checksum hassles (because the framework is stored **inside** the repo).

---

## 🔑 Entitlements & Info.plist

| Connection type | Add to Info.plist |
|-----------------|--------------------|
| **Wi‑Fi / Ethernet** | `NSLocalNetworkUsageDescription` with a user‑facing explanation. |
| **MFi Bluetooth** | `NSBluetoothAlwaysUsageDescription` **and** an MFi Accessory entitlement in your provisioning profile. |

These are Apple requirements; the package itself doesn’t modify entitlements.

---

## 🧑‍💻 API primer

| Common class | Purpose |
|--------------|---------|
| `TcpPrinterConnection` | Raw TCP/IP socket printing over LAN or Wi‑Fi. |
| `MfiBtPrinterConnection` | Bluetooth (MFi) printing. |
| `ZebraPrinterFactory` | Detects the printer model & returns a `ZebraPrinter` instance. |
| `ZebraPrinter` | High‑level helpers (status, files, graphics, etc.). |
| `PrinterConnection` | Protocol implemented by all connection types. |

All Objective‑C headers are available to Swift with full autocomplete support.

---

## 🔄 Upgrading the Zebra SDK

1. Download the latest `zebra-linkos-mpsdk-ios-*.zip` from Zebra’s developer portal.  
2. Replace `ZSDK_API.xcframework` in this repo with the new version.  
3. Commit, bump the tag (`git tag 1.1.0 && git push --tags`).  
4. Consumers can update via **File ▸ Packages ▸ Update To Latest Package Versions**.

---

## 🧪 Continuous integration example (GitHub Actions)

```yaml
name: Build
on: [push, pull_request]
jobs:
  build:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4
      - name: Build package
        run: swift build -c release
```

Add this to ensure the package compiles on every commit.

---

## 🐞 Troubleshooting

| Symptom | Remedy |
|---------|--------|
| *“Module `ZebraLinkOS` not found”* | Make sure the target name in `Package.swift` (`.binaryTarget(name: "ZebraLinkOS", …)`) matches the umbrella header inside the XCFramework. |
| *App works in Simulator but crashes on device* | Check entitlements (Bluetooth, Local Network). |
| *Cannot open socket* | Verify IP/port (default 9100) and that the printer is on the same subnet. |

---

## 📄 License

The package bundles Zebra’s Link‑OS SDK under the Zebra Technologies **End‑User License Agreement**.  
Redistribution beyond your organisation may require permission from Zebra.  
See [`LICENSE`](LICENSE) for full terms.

---

## 🙏 Acknowledgements

* Zebra Technologies for the Link‑OS SDK.  
* The SwiftPM team for dependency nirvana.

---

## Appendix A – Full SwiftUI test view

<details>
<summary>Click to expand SwiftUI sample</summary>

```swift
import SwiftUI
import ZebraLinkOS

struct LinkOSTestView: View {
    @StateObject private var vm = ViewModel()

    var body: some View {
        Form {
            Section("Connection") {
                TextField("IP or BT MAC", text: $vm.address)
                Button(vm.isConnected ? "Disconnect" : "Connect") {
                    vm.toggleConnection()
                }
            }
            Section("Print") {
                TextField("Label text", text: $vm.labelText)
                Button("Send Test Label") { vm.printLabel() }
                    .disabled(!vm.canPrint)
            }
            if let status = vm.status {
                Text(status).font(.footnote)
            }
        }
        .navigationTitle("Zebra Test")
        .overlay {
            if vm.isBusy { ProgressView() }
        }
    }
}

@MainActor
final class ViewModel: ObservableObject {
    @Published var address    = "192.168.1.100"
    @Published var labelText  = "Hello, Zebra!"
    @Published var status: String?
    @Published var isConnected = false
    @Published var isBusy = false

    private var conn: PrinterConnection?

    var canPrint: Bool { isConnected && !labelText.isEmpty && !isBusy }

    func toggleConnection() { isConnected ? disconnect() : connect() }

    private func connect() {
        guard !address.isEmpty else { status = "Enter address"; return }
        isBusy = true
        Task.detached {
            let c = TcpPrinterConnection(ipAddress: self.address, andWithPort: 9100)!
            if c.open() {
                await MainActor.run {
                    self.conn = c; self.isConnected = true; self.status = "Connected"; self.isBusy = false
                }
            } else {
                await MainActor.run { self.status = "Socket error"; self.isBusy = false }
            }
        }
    }

    private func disconnect() {
        conn?.close(); conn = nil; isConnected = false; status = "Disconnected"
    }

    func printLabel() {
        guard let c = conn, c.isConnected() else { status = "Not connected"; return }
        isBusy = true
        Task.detached {
            let zpl = "^XA^FO50,50^ADN,36,20^FD\(self.labelText)^FS^XZ"
            c.write(zpl.data(using: .utf8), error: nil)
            await MainActor.run { self.status = "Label sent"; self.isBusy = false }
        }
    }
}
```
</details>
