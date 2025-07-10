# ZebraLinkOS Swift Package

This package wraps Zebra Link-OS SDK v1.6.1158 as a Swift Package.

## Usage

Add the package in Xcode:
```
File ▸ Add Packages…
URL: <Your Repo URL>
```
Then in code:

```swift
import ZebraLinkOS

let conn = TcpPrinterConnection(ipAddress: "192.168.1.100", andWithPort: 9100)!
// ...
```
