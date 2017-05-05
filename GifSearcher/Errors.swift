import Foundation

enum GettingGifsError: Error {
    case notConnectedToInternet
    case noResultsFound
    case incorrectData
}
