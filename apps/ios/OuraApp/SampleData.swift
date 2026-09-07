import Foundation

enum SampleData {
    static func summary() -> Summary? {
        guard let url = Bundle.main.url(forResource: "SampleSummary", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(Summary.self, from: data)
    }
}
