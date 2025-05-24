//
//  CoreDataTests.swift
//  sofinMVC
//
//  Created by Natália Arantes on 24/05/25.
//

import XCTest
import CoreData
@testable import sofinMVC

final class CoreDataManagerTests: XCTestCase {

    func testSaveContextActuallyPersistsData() {
        let manager = CoreDataManager.shared
        let context = manager.persistentContainer.viewContext

        let transaction = FinancialTransaction(context: context)
        transaction.id = UUID()
        transaction.amount = 999.99
        transaction.transactionCategory = "Test"
        transaction.date = Date()
        transaction.transactionType = "income"

        XCTAssertTrue(context.hasChanges)

        manager.saveContext()

        XCTAssertFalse(context.hasChanges)

        let fetchRequest: NSFetchRequest<FinancialTransaction> = FinancialTransaction.fetchRequest()
        let results = try? context.fetch(fetchRequest)

        XCTAssertTrue(results?.contains(where: { $0.id == transaction.id }) ?? false)
    }
}
