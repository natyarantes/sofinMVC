//
//  HomeViewController.swift
//  sofinMVC
//
//  Created by Natália Arantes on 13/05/25.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    private let homeView = HomeView()
    private var transactions: [FinancialTransaction] = []
    private var incomeTransactions: [FinancialTransaction] = []
    private var expenseTransactions: [FinancialTransaction] = []


    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.incomeTable.dataSource = self
        homeView.expenseTable.dataSource = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTransactionSaved),
            name: NSNotification.Name("TransactionSaved"),
            object: nil
        )

        configureNavigation()
        fetchTransactions()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    private func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "accentColor") ?? .black,
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold)
        ]
    }
    
    private func fetchTransactions() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FinancialTransaction> = FinancialTransaction.fetchRequest()
        let totalReceitas = incomeTransactions.reduce(0) { $0 + $1.amount }
        let totalDespesas = expenseTransactions.reduce(0) { $0 + $1.amount }
        let saldo = totalReceitas - totalDespesas
        
        do {
            transactions = try context.fetch(fetchRequest)
            incomeTransactions = transactions.filter { $0.transactionType == "income" }
            expenseTransactions = transactions.filter { $0.transactionType == "expense" }
            homeView.incomeTable.reloadData()
            homeView.expenseTable.reloadData()
            homeView.atualizarAlturaDasTabelas()
        } catch {
            print("❌ Erro ao buscar transações: \(error.localizedDescription)")
        }
        
        homeView.saldoValorLabelPublico.text = formatarParaBRL(saldo)

        homeView.receitasLabelPublico.attributedText = HomeView.itemLabel(
            title: "Receitas",
            value: formatarParaBRL(totalReceitas),
            color: .highLightIncome
        ).attributedText

        homeView.despesasLabelPublico.attributedText = HomeView.itemLabel(
            title: "Despesas",
            value: formatarParaBRL(totalDespesas),
            color: .highLightExpense
        ).attributedText
    }
    
    @objc private func handleTransactionSaved() {
        fetchTransactions()
    }

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == homeView.incomeTable {
            return incomeTransactions.count
        } else {
            return expenseTransactions.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction: FinancialTransaction

        if tableView == homeView.incomeTable {
            transaction = incomeTransactions[indexPath.row]
        } else {
            transaction = expenseTransactions[indexPath.row]
        }

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TransactionCell")
        cell.textLabel?.text = transaction.transactionCategory
        cell.detailTextLabel?.text = String(format: "R$ %.2f - %@", transaction.amount, formatDate(transaction.date))
        return cell
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatarParaBRL(_ valor: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: valor)) ?? "R$ 0,00"
    }

}
