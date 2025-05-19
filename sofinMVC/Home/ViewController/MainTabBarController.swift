//
//  MainTabBarController.swift
//  sofinMVC
//
//  Created by Natália Arantes on 13/05/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let fabButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .accent
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        return button
    }()

    private let incomeButton = MainTabBarController.createActionButton(icon: "arrow.down.circle", color: .highLightIncome)
    private let expenseButton = MainTabBarController.createActionButton(icon: "arrow.up.circle", color: .highLightExpense)

    private var buttonsVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupFAB()
    }

    private func setupTabs() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Início", image: UIImage(systemName: "house.fill"), tag: 0)

        let placeholderVC = UIViewController() // Aba central vazia
        placeholderVC.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 1)

        let relatorioVC = UIViewController()
        relatorioVC.view.backgroundColor = .white
        relatorioVC.tabBarItem = UITabBarItem(title: "Relatório", image: UIImage(systemName: "chart.bar.fill"), tag: 2)

        viewControllers = [homeVC, placeholderVC, relatorioVC]
        tabBar.tintColor = UIColor(named: "mainColor") ?? .tintColor
        tabBar.unselectedItemTintColor = .systemGray3
    }

    private func setupFAB() {
        fabButton.translatesAutoresizingMaskIntoConstraints = false
        incomeButton.translatesAutoresizingMaskIntoConstraints = false
        expenseButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(fabButton)
        view.addSubview(incomeButton)
        view.addSubview(expenseButton)

        NSLayoutConstraint.activate([
            fabButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            fabButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor),
            fabButton.widthAnchor.constraint(equalToConstant: 70),
            fabButton.heightAnchor.constraint(equalToConstant: 70),

            incomeButton.centerXAnchor.constraint(equalTo: fabButton.centerXAnchor),
            incomeButton.bottomAnchor.constraint(equalTo: fabButton.topAnchor, constant: -20),
            incomeButton.widthAnchor.constraint(equalToConstant: 55),
            incomeButton.heightAnchor.constraint(equalToConstant: 55),

            expenseButton.centerXAnchor.constraint(equalTo: fabButton.centerXAnchor),
            expenseButton.bottomAnchor.constraint(equalTo: incomeButton.topAnchor, constant: -15),
            expenseButton.widthAnchor.constraint(equalToConstant: 55),
            expenseButton.heightAnchor.constraint(equalToConstant: 55)
        ])

        incomeButton.alpha = 0
        expenseButton.alpha = 0

        fabButton.addTarget(self, action: #selector(toggleFAB), for: .touchUpInside)
        incomeButton.addTarget(self, action: #selector(openIncomeForm), for: .touchUpInside)
        expenseButton.addTarget(self, action: #selector(openExpenseForm), for: .touchUpInside)

    }

    @objc private func toggleFAB() {
        buttonsVisible.toggle()

        UIView.animate(withDuration: 0.3) {
            self.incomeButton.alpha = self.buttonsVisible ? 1 : 0
            self.expenseButton.alpha = self.buttonsVisible ? 1 : 0
        }
    }

    private static func createActionButton(icon: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: icon), for: .normal)
        button.tintColor = .white
        button.backgroundColor = color
        button.layer.cornerRadius = 27.5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 4
        return button
    }
    
    @objc private func openIncomeForm() {
        presentAddTransaction(type: "income")
    }

    @objc private func openExpenseForm() {
        presentAddTransaction(type: "expense")
    }

    private func presentAddTransaction(type: String) {
        let vc = AddTransactionViewController(type: type)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
}

