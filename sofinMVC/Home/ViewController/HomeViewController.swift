//
//  HomeViewController.swift
//  sofinMVC
//
//  Created by Natália Arantes on 13/05/25.
//

import UIKit

class HomeViewController: UIViewController {

    private let homeView = HomeView()

    override func loadView() {
        // Define a HomeView como a view principal da tela
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }

    private func configureNavigation() {
        // Esconde o título grande e usa um visual mais clean como no mock
//        navigationItem.title = "Sofin"
        navigationController?.navigationBar.prefersLargeTitles = false

        // Se quiser estilizar a navbar (cor, texto, etc.)
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(named: "mainColor") ?? .black,
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold)
        ]
    }
}

