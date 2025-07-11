#if os(iOS)
@_exported import ZSDK_API
#else
// Stub definitions for non-iOS platforms
public protocol PrinterConnection {}
public protocol ZebraPrinter {}

public class TcpPrinterConnection: PrinterConnection {
    public init(ipAddress: String, andWithPort port: UInt16) {}
    public func open() -> Bool { false }
    public func write(_ data: Data?, error: NSErrorPointer?) {}
    public func close() {}
    public func isConnected() -> Bool { false }
}

public class ZebraPrinterFactory {
    public static func getInstance(_ conn: Any, error: NSErrorPointer?) -> Any? { nil }
}
#endif
