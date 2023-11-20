//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 03.11.2023.
//

import UIKit

final class HabitViewController: UIViewController {
    
    ///Delegates
    weak var habitsDelegate: HabitsDelegate?
    weak var habitDetailsDelegate: HabitDetailsDelegate?
    
    private var index: Int?
    private var titleHabit: String?
    private var colorHabit: UIColor
    private var date: Date?
    private var defaultColor: UIColor = .orange
    private var currentHabit: Habit?
    

    //MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    /// Habit name
    private lazy var habitTitle: UILabel = {
        let label = UILabel()
        label.text = "название".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .SFProTextSemibold_Medium
        
        return label
    }()
    
    private lazy var habitTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .systemGray2
        
        return textField
    }()
    
    /// Habit color
    private lazy var colorTitle: UILabel = {
        let label = UILabel()
        label.text = "цвет".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .SFProTextSemibold_Medium
        
        return label
    }()
    
    private lazy var colorButton: UIButton = {
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
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "время".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .SFProTextSemibold_Medium
        
        return label
    }()
    
    private lazy var habitTimeText: UILabel = {
        let label = UILabel()
        label.text = "Каждый день в"
        label.font = .SFProTextRegular_Big
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var habitTime: UILabel = {
        let label = UILabel()
        label.textColor = .purpleDark
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "HH:mm a"
        label.text = formatDate.string(from: Date())
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    private lazy var timePicker: UIDatePicker = {
        let time = UIDatePicker()
        time.datePickerMode = .time
        time.preferredDatePickerStyle = .wheels
        time.locale = Locale(identifier: "en_US")
        time.timeZone = TimeZone.current
        time.translatesAutoresizingMaskIntoConstraints = false
        
        return time
    }()
    
    ///DELETE Habit button
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .SFProTextRegular_Big
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(deleteHabitAlert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
//MARK: - Alerts
    
    private lazy var messageDeleteAlertController = UIAlertController(
        title: "Удалить привычку",
        message: "Вы хотите удалить привычку_title_habbit_?",
        preferredStyle: .alert
    )
    
    private func messageDeleteAlertButtons() {
        let cancelButton = UIAlertAction(title: "Отмена", style: .default)
        let deleteButton = UIAlertAction(title: "Удалить", style: .destructive) {_ in
            self.deleteHabit(self.index!)
        }
        messageDeleteAlertController.addAction(cancelButton)
        messageDeleteAlertController.addAction(deleteButton)
    }
    
    private lazy var messageSaveAlertController = UIAlertController(
        title: "Ошибка",
        message: "Заполните название привычки",
        preferredStyle: .alert
    )
    
    private func messageSaveAlertButton() {
        let okButton = UIAlertAction(title: "OK", style: .default)
        messageSaveAlertController.addAction(okButton)
    }
    
    // ALERT Delete action

    @objc private func deleteHabitAlert() {
          if let textHabit = habitTextField.text {
              messageDeleteAlertController.message = messageDeleteAlertController.message?.replacingOccurrences(of: "_title_habbit_", with: (textHabit != "") ? "\n\"\(textHabit)\"": "")
          }
          self.present(messageDeleteAlertController, animated: true)
      }
    
    @objc private func deleteHabit(_ index: Int) {
        self.dismiss(animated: true)
        HabitsStore.shared.habits.remove(at: index)
        habitDetailsDelegate?.habitDetailDelete(at: index)
    }
    

    //MARK: - Init
    
    init(habit: Habit?, index: Int?) {
        
        self.index = index
        self.titleHabit = habit?.name
        self.colorHabit = habit?.color ?? defaultColor
        self.date = habit?.date
        
        if index != nil {
            self.currentHabit = habit!
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageDeleteAlertButtons()
        messageSaveAlertButton()
        
        setupUI()
        setupNavigation()
        setupConstraints()
        setupFields()
        setHabitTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Private
    
    private func setupFields() {
        deleteButton.isHidden = index == nil ? true: false
        habitTextField.text = titleHabit
        habitTextField.textColor = colorHabit
        habitTextField.font = .SFProTextRegular_Big
        colorButton.backgroundColor = colorHabit
       }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(habitTime)
        scrollView.addSubview(habitTimeText)
        scrollView.addSubview(timePicker)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(colorButton)
        scrollView.addSubview(colorTitle)
        scrollView.addSubview(habitTextField)
        scrollView.addSubview(habitTitle)
        scrollView.addSubview(deleteButton)
        
        habitTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    ///Naviigation
    private func setupNavigation() {
        
        title = "Создать"
        
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
    }
    
    
    ///Constraints
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
            habitTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            habitTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            habitTextField.topAnchor.constraint(equalTo: habitTitle.bottomAnchor, constant: 8),
        ])
        NSLayoutConstraint.activate([
            colorTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorTitle.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 16),
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
        NSLayoutConstraint.activate([
            deleteButton.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            deleteButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
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
    @objc private func saveButtonTapped() {
            guard habitTextField.text != "" else {
                self.present(messageSaveAlertController, animated: true)
                return
            }
            
            let storeHabits = HabitsStore.shared
            
            self.dismiss(animated: true, completion: nil)
            
            if self.index == nil {
                let newHabit = Habit(
                    name: habitTextField.text!,
                    date: timePicker.date,
                    color: colorButton.backgroundColor!
                )
                storeHabits.habits.append(newHabit)
                
                habitsDelegate?.habitCreate()
                
            } else {
                currentHabit?.name = habitTextField.text!
                currentHabit?.date = timePicker.date
                currentHabit?.color = colorButton.backgroundColor!
                
                storeHabits.habits[index!] = currentHabit!
                
                habitDetailsDelegate?.habitDetailUpdate(habit: currentHabit!, at: index!)
            }
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
        habitTextField.textColor = color
    }
}


extension HabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ///Hide the keyboard when the return key is pressed
        textField.resignFirstResponder()
        textField.font = .SFProTextSemibold_Big
        textField.textColor = colorHabit
        
        return true
    }
    
}
