//
//  AddTransactionViewController.swift
//  sofinMVC
//
//  Created by Natália Arantes on 13/05/25.
//

import UIKit

class AddTransactionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private let transactionType: String
    private let categories = ["Alimentação", "Transporte", "Entretenimento", "Salário", "Outro"]

    private let pickerView = UIPickerView()

    init(type: String) {
        self.transactionType = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .tintColor
        label.textAlignment = .left
        return label
    }()

    private let amountField: UITextField = {
        let field = UITextField()
        field.placeholder = "Valor"
        field.borderStyle = .roundedRect
        field.keyboardType = .decimalPad
        return field
    }()

    private let categoryField: UITextField = {
        let field = UITextField()
        field.placeholder = "Selecione a categoria"
        field.borderStyle = .roundedRect
        return field
    }()

    private let dateField: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    private let descriptionField: UITextField = {
        let field = UITextField()
        field.placeholder = "Descrição (opcional)"
        field.borderStyle = .roundedRect
        return field
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar", for: .normal)
        button.backgroundColor = .tintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        titleLabel.text = transactionType == "income" ? "Nova entrada" : "Nova despesa"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )

        setupPicker()
        setupLayout()
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryField.inputView = pickerView
    }

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            amountField,
            categoryField,
            dateField,
            descriptionField,
            saveButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    // MARK: - PickerView

    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = categories[row]
        categoryField.resignFirstResponder()
    }
    
    // MARK: - Save data
    @objc private func saveTapped() {
        guard
            let amountText = amountField.text,
            let amount = Double(amountText),
            let category = categoryField.text,
            !category.isEmpty
        else {
            showAlert(message: "Por favor preencha todos os campos obrigatórios!")
            return
        }

        let description = descriptionField.text?.isEmpty == false ? descriptionField.text : nil
        let date = dateField.date

        let transaction = Transaction(
            amount: amount,
            category: category,
            date: date,
            description: description,
            type: transactionType
        )

        print("✅ Saved transaction: \(transaction)")
        dismiss(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

