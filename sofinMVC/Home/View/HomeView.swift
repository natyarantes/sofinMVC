//
//  HomeView.swift
//  sofinMVC
//
//  Created by Natália Arantes on 13/05/25.
//

import UIKit

class HomeView: UIView {

    // MARK: - Componentes
    
    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.text = "Sofin"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "AccentColor") ?? .accent
        label.translatesAutoresizingMaskIntoConstraints = false
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
        view.translatesAutoresizingMaskIntoConstraints = false
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

    private let transacoesLabel: UILabel = {
        let label = UILabel()
        label.text = "Transações"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .accent
        return label
    }()

    private let transacoesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        addSubview(tituloLabel)
        let saldoStack = UIStackView(arrangedSubviews: [saldoLabel, saldoValorLabel])
        saldoStack.axis = .vertical
        saldoStack.spacing = 4

        saldoCardView.addSubview(saldoStack)
        saldoStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tituloLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            tituloLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            saldoStack.topAnchor.constraint(equalTo: saldoCardView.topAnchor, constant: 12),
            saldoStack.leadingAnchor.constraint(equalTo: saldoCardView.leadingAnchor, constant: 16),
            saldoStack.trailingAnchor.constraint(equalTo: saldoCardView.trailingAnchor, constant: -16),
            saldoStack.bottomAnchor.constraint(equalTo: saldoCardView.bottomAnchor, constant: -12)
        ])

        let visaoGeralStack = UIStackView(arrangedSubviews: [receitasLabel, despesasLabel])
        visaoGeralStack.axis = .vertical
        visaoGeralStack.spacing = 32

        let mainStack = UIStackView(arrangedSubviews: [
            saldoCardView,
            visaoGeralLabel,
            visaoGeralStack,
            transacoesLabel,
            transacoesStack
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 24
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])

        // Transações mockadas
        adicionarTransacao(titulo: "Alimentação", valor: "R$ 250,00")
        adicionarTransacao(titulo: "Transporte", valor: "R$ 50,00")
        adicionarTransacao(titulo: "Lazer", valor: "R$ 150,00")
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

    private func adicionarTransacao(titulo: String, valor: String) {
        let label = HomeView.itemLabel(title: titulo, value: valor, color: UIColor(named: "mainColor"))
        transacoesStack.addArrangedSubview(label)
    }
}
