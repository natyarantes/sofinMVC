//
//  HomeViewController.swift
//  sofinMVC
//
//  Created by Natália Arantes on 24/05/25.
//

import XCTest
import CoreData
@testable import sofinMVC

final class HomeViewController: XCTestCase {

    func testSalvarTransacaoIncomeComSucesso() {
        // Arrange
        let context = CoreDataTestStack.mockContext()
        let transaction = FinancialTransaction(context: context)

        transaction.id = UUID()
        transaction.amount = 1200.0
        transaction.transactionCategory = "Salário"
        transaction.date = Date()
        transaction.transactionDescription = "Salário de maio"
        transaction.transactionType = "income"

        // Act
        do {
            try context.save()
        } catch {
            XCTFail("Erro ao salvar transação: \(error.localizedDescription)")
        }

        // Assert
        let request: NSFetchRequest<FinancialTransaction> = FinancialTransaction.fetchRequest()
        let result = try? context.fetch(request)

        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?.first?.transactionType, "income")
        XCTAssertEqual(result?.first?.transactionCategory, "Salário")
        XCTAssertEqual(result?.first?.amount, 1200.0)
    }
    
    func testConversaoDeValorComVirgula_ePonto() {
        let valorDigitado = "1.234,56"
        let normalizado = valorDigitado
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")

        let convertido = Double(normalizado)

        XCTAssertEqual(convertido, 1234.56)
    }
    
    func testCalculoSaldoComReceitaEDespesa() {
        let context = CoreDataTestStack.mockContext()

        let receita = FinancialTransaction(context: context)
        receita.id = UUID()
        receita.amount = 2000
        receita.transactionCategory = "Salário"
        receita.date = Date()
        receita.transactionType = "income"

        let despesa = FinancialTransaction(context: context)
        despesa.id = UUID()
        despesa.amount = 500
        despesa.transactionCategory = "Aluguel"
        despesa.date = Date()
        despesa.transactionType = "expense"

        try? context.save()

        let request: NSFetchRequest<FinancialTransaction> = FinancialTransaction.fetchRequest()
        let transacoes = try? context.fetch(request)

        let receitas = transacoes?.filter { $0.transactionType == "income" } ?? []
        let despesas = transacoes?.filter { $0.transactionType == "expense" } ?? []

        let totalReceitas = receitas.reduce(0) { $0 + $1.amount }
        let totalDespesas = despesas.reduce(0) { $0 + $1.amount }
        let saldo = totalReceitas - totalDespesas

        XCTAssertEqual(totalReceitas, 2000)
        XCTAssertEqual(totalDespesas, 500)
        XCTAssertEqual(saldo, 1500)
    }
}
