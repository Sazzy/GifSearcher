import Foundation

enum GettingGifs: Error {
    case notConnectedToInternet
    case invalidRequest
    case noResultsFound
}
