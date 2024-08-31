import ArgumentParser
import AsyncBridgeKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@main
struct AsyncBridgeKitClient: ParsableCommand {

    @Argument(help: "String value of the URL to download")
    var urlString: String

    mutating func run() throws {
        guard let url = URL(string: urlString) else {
            fatalError("URL invalid.")
        }

        let semaphore = DispatchSemaphore(value: 0)
        Task {
            defer { semaphore.signal() }
            let (data, _) = try await URLSession.shared.data(from: url)
            if let content = String(data: data, encoding: .utf8) {
                print(content)
            } else {
                print("Error decoding the response string.")
            }
        }
        semaphore.wait()
    }
}
