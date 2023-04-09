import CoreData

protocol LocationDataProcessorCommand {
    func execute(dbContext: NSManagedObjectContext) async throws
}

public struct LocationDataProcessor {
    private let context: NSManagedObjectContext
    private let commands: [LocationDataProcessorCommand]
    
    public init(context: NSManagedObjectContext) {
        self.init(context: context, commands: [NullLocationFilter(), HighSpeedFilter()])
    }
    
    init(context: NSManagedObjectContext, commands: [LocationDataProcessorCommand]) {
        self.context = context
        self.commands = commands
    }
    
    public func execute() async throws {
        var caughtError: Error?
        for command in commands {
            do {
                try await command.execute(dbContext: context)
            } catch {
                print("Location Data Processor Error: \(error)")
                caughtError = error
            }
        }
        if let caughtError {
            throw caughtError
        }
    }
}
