//
//  AddTransactionViewControllerTests.swift
//  sofinMVC
//
//  Created by Natália Arantes on 24/05/25.
//

import XCTest
import CoreData
@testable import sofinMVC

final class AddTransactionViewControllerTests: XCTestCase {
    
    var sut: AddTransactionViewController!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        context = CoreDataTestStack.mockContext()
        sut = AddTransactionViewController(type: "income")
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        context = nil
        sut = nil
        super.tearDown()
    }
    
    func testSalvarTransacaoViaMetodoPublico() {
        let data = Date()
        
        sut.saveTransaction(
            title: "Teste",
            amount: 99.90,
            date: data,
            isIncome: true,
            context: context
        )
        
        let request: NSFetchRequest<FinancialTransaction> = FinancialTransaction.fetchRequest()
        let resultados = try? context.fetch(request)

        XCTAssertEqual(resultados?.count, 1)
        XCTAssertEqual(resultados?.first?.transactionCategory, nil)
        XCTAssertEqual(resultados?.first?.amount, 99.90)
        XCTAssertEqual(resultados?.first?.transactionType, nil)
    }
    
    func testValidarCamposComValorValidoEVirgula() {
        let resultado = sut.validateFields(amountText: "1000,50", category: "Salário")
        XCTAssertEqual(resultado, 1000.50)
    }

    func testValidarCamposComTextoInvalido() {
        let resultado = sut.validateFields(amountText: "abc", category: "Salário")
        XCTAssertNil(resultado)
    }

    func testValidarCamposComCategoriaVazia() {
        let resultado = sut.validateFields(amountText: "200", category: "")
        XCTAssertNil(resultado)
    }

}
