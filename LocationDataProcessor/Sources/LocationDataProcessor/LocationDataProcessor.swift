import CoreData
import Combine

protocol DataProcessorCommand {
    associatedtype LogStream: Publisher<String, Never>
    var logStream: LogStream { get }
    func execute(dbContext: NSManagedObjectContext) async throws
}

extension DataProcessorCommand {
    var log: AnyPublisher<String, Never> {
        logStream.eraseToAnyPublisher()
    }
}

public struct LocationDataProcessor {
    private let context: NSManagedObjectContext
    private let commands: [any DataProcessorCommand]
    
    public let logger = Logger()
    
    public init(context: NSManagedObjectContext) {
        self.init(context: context, commands: [LabelNullCoordinates(), BuildLocationData()])
    }
    
    init(context: NSManagedObjectContext, commands: [any DataProcessorCommand]) {
        self.context = context
        self.commands = commands
    }
    
    public func execute() async throws {
        var caughtError: Error?
        for command in commands {
            logger.connect(command.log)
            do {
                try await command.execute(dbContext: context)
            } catch {
                logger.send(message: "Location Data Processor Error: \(error)")
                caughtError = error
            }
        }
        if let caughtError {
            throw caughtError
        }
    }
}
