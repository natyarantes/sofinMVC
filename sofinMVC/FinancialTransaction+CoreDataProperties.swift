//
//  FinancialTransaction+CoreDataProperties.swift
//  
//
//  Created by Natália Arantes on 19/05/25.
//
//

import Foundation
import CoreData


extension FinancialTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FinancialTransaction> {
        return NSFetchRequest<FinancialTransaction>(entityName: "FinancialTransaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isIncome: Bool
    @NSManaged public var title: String?
    @NSManaged public var transactionDescription: String?
    @NSManaged public var transactionCategory: String?
    @NSManaged public var transactionType: String?

}
