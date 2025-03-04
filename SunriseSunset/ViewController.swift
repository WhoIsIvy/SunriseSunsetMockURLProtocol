//
//  ViewController.swift
//  SunriseSunset
//
//  Created by Lisa Fellows on 3/2/25.
//

import UIKit

class ViewController: UIViewController {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let sunriseStackView = UIStackView(axis: .horizontal, distribution: .fillEqually)
    private let sunriseTitleLabel = UILabel(textAlignment: .right, adjustsFontSizeToFitWidth: true)

    private let sunsetStackView = UIStackView(axis: .horizontal, distribution: .fillEqually)
    private let sunsetTitleLabel = UILabel(adjustsFontSizeToFitWidth: true)

    private let textField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.layer.cornerRadius = 5
        field.textAlignment = .center
        return field
    }()

    private let additionalInfoLabel = UILabel(
        textAlignment: .center,
        numberOfLines: 0,
        adjustsFontSizeToFitWidth: true
    )

    private let timeStackView = UIStackView(
        axis: .vertical,
        spacing: 8,
        alignment: .fill,
        distribution: .fillEqually
    )

    private let sunriseTimeLabel = UILabel(textAlignment: .center, adjustsFontSizeToFitWidth: true)
    private let sunsetTimeLabel = UILabel(textAlignment: .center, adjustsFontSizeToFitWidth: true)

    private let spacerView = UIView()
    private let disclaimerLabel = UILabel(
        textAlignment: .center,
        numberOfLines: 0,
        adjustsFontSizeToFitWidth:  true
    )

    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupView()
        setupConstraints()

        viewModel.displayError = { [weak self] attributedError in
            self?.additionalInfoLabel.attributedText = attributedError
        }
    }

    private func setupSubviews() {
        backgroundImageView.image = UIImage(named: Constant.backgroundAsset)
        sunriseTitleLabel.attributedText = viewModel.sunriseTitleAttributed
        sunsetTitleLabel.attributedText = viewModel.sunsetTitleAttributed
        disclaimerLabel.attributedText = viewModel.disclaimerAttributed

        textField.attributedPlaceholder = viewModel.zipPlaceholderAttributed
        textField.textColor = Attributed.textfield.textColor
        textField.font = Attributed.textfield.font
        textField.delegate = self
    }

    private func setupView() {
        sunriseStackView.addArrangedSubview(sunriseTitleLabel)
        sunriseStackView.addArrangedSubview(UIView())

        sunsetStackView.addArrangedSubview(UIView())
        sunsetStackView.addArrangedSubview(sunsetTitleLabel)

        timeStackView.addArrangedSubview(sunriseTimeLabel)
        timeStackView.addArrangedSubview(sunsetTimeLabel)

        [backgroundImageView,
        sunriseStackView,
        sunsetStackView,
        textField,
        additionalInfoLabel,
        timeStackView,
        spacerView,
         disclaimerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            sunriseStackView.heightAnchor.constraint(equalToConstant: 35),
            sunriseStackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 16),
            sunriseStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            sunriseStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            sunsetStackView.heightAnchor.constraint(equalToConstant: 35),
            sunsetStackView.topAnchor.constraint(equalTo: sunriseStackView.bottomAnchor, constant: 16),
            sunsetStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            sunsetStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            textField.heightAnchor.constraint(equalToConstant: 35),
            textField.topAnchor.constraint(equalTo: sunsetStackView.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            additionalInfoLabel.heightAnchor.constraint(equalToConstant: 35),
            additionalInfoLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            additionalInfoLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            additionalInfoLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            timeStackView.topAnchor.constraint(equalTo: additionalInfoLabel.bottomAnchor, constant: 16),
            timeStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            timeStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),

            spacerView.topAnchor.constraint(equalTo: timeStackView.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            spacerView.bottomAnchor.constraint(equalTo: disclaimerLabel.topAnchor),

            disclaimerLabel.heightAnchor.constraint(equalToConstant: 50),
            disclaimerLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            disclaimerLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            disclaimerLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        additionalInfoLabel.text = ""
        sunriseTimeLabel.text = ""
        sunsetTimeLabel.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let zipString = textField.text ?? ""
        viewModel.retrieveSunTimes(for: zipString) { [weak self] sunModel in
            self?.additionalInfoLabel.attributedText = sunModel.cityAndCountryAttributed
            self?.sunriseTimeLabel.attributedText = sunModel.sunriseTimeAttributed
            self?.sunsetTimeLabel.attributedText = sunModel.sunsetTimeAttributed
        }
    }
}
