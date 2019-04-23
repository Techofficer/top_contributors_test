import Foundation

public enum GithibApiError: Error {
    case apiError(message : String?)
    case serverError(errorCode : Int)
}

extension GithibApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .apiError(let message): return message ?? "Something went wrong"
            case .serverError(let errorCode): return "Server error: \(errorCode)"
        }
    }
}
