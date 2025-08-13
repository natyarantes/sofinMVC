//
//  ReportsViewController.swift
//  sofinMVC
//
//  Created by Natália Arantes on 11/08/25.
//

import UIKit
import CoreData

final class ReportsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let monthLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 22, weight: .semibold)
        lb.textAlignment = .center
        return lb
    }()

    private let totalsLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()

    private let prevButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("◀︎", for: .normal)
        return bt
    }()

    private let nextButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("▶︎", for: .normal)
        return bt
    }()

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Estado e lógica na ViewController
    private var currentMonth: Date = Date()
    private var transactions: [FinancialTransaction] = []
    private var categoryTotals: [(category: String, total: Double)] = []
    private var incomeTotal: Double = 0
    private var expenseTotal: Double = 0
    private var balance: Double { incomeTotal - expenseTotal }

    // MARK: - Core Data acoplado diretamente na ViewController
    private var context: NSManagedObjectContext {
        CoreDataManager.shared.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Relatórios"
        view.backgroundColor = .systemBackground
        setupLayout()
        wireActions()
        reloadReport()
    }

    private func setupLayout() {
        let navStack = UIStackView(arrangedSubviews: [prevButton, monthLabel, nextButton])
        navStack.axis = .horizontal
        navStack.spacing = 12
        navStack.alignment = .center
        navStack.distribution = .equalCentering

        let headerStack = UIStackView(arrangedSubviews: [navStack, totalsLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 8

        view.addSubview(headerStack)
        view.addSubview(tableView)

        headerStack.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func wireActions() {
        prevButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }

    @objc private func didTapPrev() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        reloadReport()
    }

    @objc private func didTapNext() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        reloadReport()
    }

    private func reloadReport() {
        monthLabel.text = formatMonth(currentMonth)
        fetchTransactionsForMonth()
        computeTotals()
        computeCategoryTotals()
        updateTotalsLabel()
        tableView.reloadData()
    }

    private func monthDateBounds(for date: Date) -> (start: Date, end: Date) {
        let cal = Calendar.current
        let start = cal.date(from: cal.dateComponents([.year, .month], from: date))!
        let end = cal.date(byAdding: DateComponents(month: 1), to: start)!
        return (start, end)
    }

    private func fetchTransactionsForMonth() {
        let bounds = monthDateBounds(for: currentMonth)
        let req: NSFetchRequest<FinancialTransaction> = FinancialTransaction.fetchRequest()
        req.predicate = NSPredicate(format: "date >= %@ AND date < %@", bounds.start as NSDate, bounds.end as NSDate)
        req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            transactions = try context.fetch(req)
        } catch {
            transactions = []
            print("⚠️ Erro ao buscar transações do mês: \(error)")
        }
    }

    private func isIncome(_ tx: FinancialTransaction) -> Bool {
        if let type = tx.transactionType?.lowercased() {
            return type == "income"
        }
        return tx.amount >= 0
    }

    private func computeTotals() {
        var inc: Double = 0
        var exp: Double = 0
        for tx in transactions {
            if isIncome(tx) {
                inc += abs(tx.amount)
            } else {
                exp += abs(tx.amount)
            }
        }
        incomeTotal = inc
        expenseTotal = exp
    }

    private func computeCategoryTotals() {
        var dict: [String: Double] = [:]
        for tx in transactions {
            guard !isIncome(tx) else { continue }
            let rawCategory = (tx.transactionCategory ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let category = rawCategory.isEmpty ? "Sem categoria" : rawCategory
            dict[category, default: 0] += abs(tx.amount)
        }
        categoryTotals = dict.map { ($0.key, $0.value) }
            .sorted { $0.total > $1.total }
    }

    private func updateTotalsLabel() {
        let inc = formatCurrency(incomeTotal)
        let exp = formatCurrency(expenseTotal)
        let bal = formatCurrency(balance)
        totalsLabel.text = "Receitas: \(inc)   •   Despesas: \(exp)\nSaldo do mês: \(bal)"
        totalsLabel.textColor = balance >= 0 ? .label : .systemRed
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryTotals.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Despesas por categoria"
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cat"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
            ?? UITableViewCell(style: .value1, reuseIdentifier: cellId)
        let item = categoryTotals[indexPath.row]
        cell.textLabel?.text = item.category
        cell.detailTextLabel?.text = formatCurrency(item.total)
        return cell
    }

    // MARK: - Helpers 
    private func formatMonth(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "pt_BR")
        fmt.dateFormat = "MMMM 'de' yyyy"
        return fmt.string(from: date).capitalized
    }

    private func formatCurrency(_ value: Double) -> String {
        let fmt = NumberFormatter()
        fmt.locale = Locale(identifier: "pt_BR")
        fmt.numberStyle = .currency
        return fmt.string(from: NSNumber(value: value)) ?? "R$ \(value)"
    }
}
