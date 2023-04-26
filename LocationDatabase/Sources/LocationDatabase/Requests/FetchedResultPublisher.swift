//
//  FetchedResultPublisher.swift
//  Yarn
//
//  Created by Pierre Gabory on 26/04/2023.
//

import Combine
import CoreData
import Foundation

public struct FetchedResultPublisher<Convertor: DTOConvertor>: Publisher {
    public typealias Output = [Convertor.DTO]
    public typealias Failure = Error
    
    private let convertor: Convertor
    private let managedObjectPublisher: ManagedObjectFetchedResultPublisher<Convertor.DBO>

    public func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
        managedObjectPublisher
            .tryMap { objects in try objects.map(convertor.convert) }
            .share()
            .receive(subscriber: subscriber)
    }
    
    init<SortPropertyType>(
        convertor: Convertor,
        managedObjectContext: NSManagedObjectContext,
        sortingBy sortPropertyKeypath: KeyPath<Convertor.DBO, SortPropertyType>,
        cacheName: String? = nil
    ) {
        self.convertor = convertor
        self.managedObjectPublisher = ManagedObjectFetchedResultPublisher(
            managedObjectContext: managedObjectContext,
            sortingBy: sortPropertyKeypath,
            cacheName: cacheName
        )
    }
}

private struct ManagedObjectFetchedResultPublisher<ManagedObject: NSManagedObject>: Publisher {
    typealias Output = [ManagedObject]
    typealias Failure = Error

    private let controller: NSFetchedResultsController<ManagedObject>
    
    func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
        let subscription = ManagedObjectFetchedResultSubscription(
            resultController: controller,
            resultPublisher: self,
            target: subscriber
        )
        subscriber.receive(subscription: subscription)
    }
    
    init(
        fetchRequest: NSFetchRequest<ManagedObject>,
        managedObjectContext: NSManagedObjectContext,
        cacheName: String? = nil
    ) {
        controller = NSFetchedResultsController<ManagedObject>(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: cacheName
        )
    }

    init<SortPropertyType>(
        managedObjectContext: NSManagedObjectContext,
        sortingBy sortPropertyKeypath: KeyPath<ManagedObject, SortPropertyType>,
        cacheName: String? = nil
    ) {
        let fetchRequest = NSFetchRequest<ManagedObject>()
        fetchRequest.entity = ManagedObject.entity()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: sortPropertyKeypath, ascending: true)
        ]
        self.init(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            cacheName: cacheName
        )
    }
}

private final class ManagedObjectFetchedResultSubscription<Target: Subscriber, ManagedObject: NSManagedObject>: NSObject,
    NSFetchedResultsControllerDelegate,
    Subscription
    where Target.Input == [ManagedObject], Target.Failure == Error
{
    let resultPublisher: ManagedObjectFetchedResultPublisher<ManagedObject>
    var target: Target?
    
    init(resultController: NSFetchedResultsController<ManagedObject>, resultPublisher: ManagedObjectFetchedResultPublisher<ManagedObject>, target: Target) {
        self.resultPublisher = resultPublisher
        self.target = target
        super.init()
        
        resultController.delegate = self
        do {
            try resultController.performFetch()
        } catch {
            target.receive(completion: .failure(error))
        }
    }
    
    func request(_ demand: Subscribers.Demand) {
        // Nothing to do.
    }
    
    func cancel() {
        target = nil
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let controller = controller as! NSFetchedResultsController<ManagedObject>
        if let results = controller.fetchedObjects {
            _ = target?.receive(results)
        }
    }
}
