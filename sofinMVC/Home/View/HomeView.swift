//
//  HomeView.swift
//  sofinMVC
//
//  Created by Natália Arantes on 13/05/25.
//
import UIKit

class HomeView: UIView {

    // MARK: - Subviews

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.text = "Sofin"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .accent
        return label
    }()

    private let saldoLabel: UILabel = {
        let label = UILabel()
        label.text = "Saldo Atual"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let saldoValorLabel: UILabel = {
        let label = UILabel()
        label.text = "R$ 5.200,00"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .accent
        return label
    }()

    private let saldoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()

    private let visaoGeralLabel: UILabel = {
        let label = UILabel()
        label.text = "Visão Geral"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .accent
        return label
    }()

    private let receitasLabel = HomeView.itemLabel(title: "Receitas", value: "R$ 500,00", color: .highLightIncome)
    private let despesasLabel = HomeView.itemLabel(title: "Despesas", value: "R$ 300,00", color: .highLightExpense)

    private let entradasLabel: UILabel = {
        let label = UILabel()
        label.text = "Entradas"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .accent
        return label
    }()

    private let saidasLabel: UILabel = {
        let label = UILabel()
        label.text = "Saídas"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .accent
        return label
    }()

    let incomeTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let expenseTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var incomeTableHeightConstraint: NSLayoutConstraint!
    private var expenseTableHeightConstraint: NSLayoutConstraint!

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupLayout() {
        backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(contentStack)

        contentStack.addArrangedSubview(tituloLabel)

        let saldoStack = UIStackView(arrangedSubviews: [saldoLabel, saldoValorLabel])
        saldoStack.axis = .vertical
        saldoStack.spacing = 4
        saldoStack.translatesAutoresizingMaskIntoConstraints = false

        saldoCardView.addSubview(saldoStack)
        contentStack.addArrangedSubview(saldoCardView)

        NSLayoutConstraint.activate([
            saldoStack.topAnchor.constraint(equalTo: saldoCardView.topAnchor, constant: 12),
            saldoStack.leadingAnchor.constraint(equalTo: saldoCardView.leadingAnchor, constant: 16),
            saldoStack.trailingAnchor.constraint(equalTo: saldoCardView.trailingAnchor, constant: -16),
            saldoStack.bottomAnchor.constraint(equalTo: saldoCardView.bottomAnchor, constant: -12)
        ])

        contentStack.addArrangedSubview(visaoGeralLabel)
        let visaoGeralStack = UIStackView(arrangedSubviews: [receitasLabel, despesasLabel])
        visaoGeralStack.axis = .vertical
        visaoGeralStack.spacing = 32
        contentStack.addArrangedSubview(visaoGeralStack)

        contentStack.addArrangedSubview(entradasLabel)
        contentStack.addArrangedSubview(incomeTableView)
        contentStack.addArrangedSubview(saidasLabel)
        contentStack.addArrangedSubview(expenseTableView)
        
        incomeTableHeightConstraint = incomeTableView.heightAnchor.constraint(equalToConstant: 100)
        expenseTableHeightConstraint = expenseTableView.heightAnchor.constraint(equalToConstant: 100)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            incomeTableHeightConstraint,
            expenseTableHeightConstraint
        ])
    }

    // MARK: - Helpers

    static func itemLabel(title: String, value: String, color: UIColor? = .black) -> UILabel {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(
            string: "\(title)  ",
            attributes: [.foregroundColor: UIColor.darkGray]
        )
        attributedText.append(NSAttributedString(
            string: value,
            attributes: [.foregroundColor: color ?? .black, .font: UIFont.boldSystemFont(ofSize: 16)]
        ))
        label.attributedText = attributedText
        return label
    }
    
    func atualizarAlturaDasTabelas() {
        incomeTableView.layoutIfNeeded()
        expenseTableView.layoutIfNeeded()

        incomeTableHeightConstraint.constant = incomeTableView.contentSize.height
        expenseTableHeightConstraint.constant = expenseTableView.contentSize.height
    }

    // MARK: - Acesso aos valores

    var incomeTable: UITableView { incomeTableView }
    var expenseTable: UITableView { expenseTableView }
    
    var saldoValorLabelPublico: UILabel {
        return saldoValorLabel
    }

    var receitasLabelPublico: UILabel {
        return receitasLabel
    }

    var despesasLabelPublico: UILabel {
        return despesasLabel
    }
}
