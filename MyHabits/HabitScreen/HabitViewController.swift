//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 03.11.2023.
//

import UIKit

protocol HabitViewControllerDelegate: AnyObject {
    func habitViewControllerDidCancel(_ habitViewController: HabitViewController)
    func habitViewControllerDidSave(_ habitViewController: HabitViewController, with habit: Habit)
}


class HabitViewController: UIViewController {
    
    weak var delegate: HabitViewControllerDelegate?
    
//    var store = HabitsStore.shared
    var selectedTime: Date = Date()
    var selectedColor: UIColor = .purpleDark
    var habit: Habit?

    //MARK: - UI Elements
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    /// Habit name
    let habitTitle: UILabel = {
        let label = UILabel()
        label.text = .uppercased("название")()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .SFProTextSemibold_Medium
        
        return label
    }()
    
    let habitTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    /// Habit color
    let colorTitle: UILabel = {
        let label = UILabel()
        label.text = .uppercased("цвет")()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .SFProTextSemibold_Medium
        
        return label
    }()
    
    let colorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(showColorPicker), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var colorPicker: UIColorPickerViewController = {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = .purpleDark
        colorPicker.delegate = self
        
        return colorPicker
    }()
    
    /// Habit time
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = .uppercased("время")()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .SFProTextSemibold_Medium
        
        return label
    }()
    
    private let habitTimeText: UILabel = {
        let label = UILabel()
        label.text = "Каждый день в"
        label.font = .SFProTextRegular_Big
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var habitTime: UILabel = {
        let label = UILabel()
        label.textColor = .purpleDark
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "HH:mm a"
        label.text = formatDate.string(from: Date())
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    let timePicker: UIDatePicker = {
        let time = UIDatePicker()
        time.datePickerMode = .time
        time.preferredDatePickerStyle = .wheels
        time.locale = Locale(identifier: "en_US")
        time.timeZone = TimeZone.current
        time.translatesAutoresizingMaskIntoConstraints = false
        
        return time
    }()
    

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        setupConstraints()
    }
    
    //MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(habitTime)
        scrollView.addSubview(habitTimeText)
        scrollView.addSubview(timePicker)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(colorButton)
        scrollView.addSubview(colorTitle)
        scrollView.addSubview(habitTitleTextField)
        scrollView.addSubview(habitTitle)
        
        habitTitleTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupNavigation() {
        
        if let navigationController = navigationController {
            navigationController
                .setNavigationBarAppearance(
                NavigationControllerManager.shared.navigationBarAppearance
            )
        }
        navigationController?.navigationBar.tintColor = .systemBackground
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("SaveButtonTitle", comment: ""),
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = .purpleDark

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("CancelButtonTitle", comment: ""),
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .purpleDark
        
        navigationController?.navigationBar.isTranslucent = false
        
        title = "Создать"
    }
    
    
    private func setupConstraints() {
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            habitTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            habitTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            habitTitleTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            habitTitleTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            habitTitleTextField.topAnchor.constraint(equalTo: habitTitle.bottomAnchor, constant: 8),
        ])
        
        NSLayoutConstraint.activate([
            colorTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorTitle.topAnchor.constraint(equalTo: habitTitleTextField.bottomAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            colorButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorButton.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: 16),
            colorButton.widthAnchor.constraint(equalToConstant: 30),
            colorButton.heightAnchor.constraint(equalTo: colorButton.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            timeLabel.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            habitTimeText.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
            habitTimeText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            habitTime.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
            habitTime.leadingAnchor.constraint(equalTo: habitTimeText.trailingAnchor, constant: 8),
        ])
        
        
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40),
            timePicker.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
        
        
    }

    //MARK: - Actions
    
    @objc func setHabitTime() {
        let formatDate = DateFormatter()
        formatDate.dateFormat = "HH:mm a"
        habitTime.text = formatDate.string(from: timePicker.date)
        
    }
    
    @objc func showColorPicker() {
        present(colorPicker, animated: true, completion: nil)
    }
    
    ///CANCEL
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///SAVE
    @objc func saveButtonTapped() {
        setHabitTime()
        ///Create a Habit object with the selected values
        let newHabit = Habit(
            name: habitTitleTextField.text ?? "",
            date: timePicker.date,
            trackDates: [],
            color: selectedColor
        )
        
        ///Inform the delegate about the new habit
        delegate?.habitViewControllerDidSave(self, with: newHabit)
        
        self.dismiss(animated: true, completion: nil)
    }



       //MARK: - Keyboard Handling

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        ///Adjust the content inset of the scroll view to avoid the keyboard
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        ///Reset the content inset when the keyboard is hidden
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

    //MARK: - Extensions

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        colorButton.backgroundColor = color
        habitTitleTextField.textColor = color
        selectedColor = color
    }
}


extension HabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ///Hide the keyboard when the return key is pressed
        textField.resignFirstResponder()
        textField.font = .SFProTextSemibold_Big
        return true
    }
    
}
