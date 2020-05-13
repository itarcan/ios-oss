import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

final class DiscoveryProjectTagPillCell: UICollectionViewCell, ValueCell {
  // MARK: - Properties
  private lazy var rootStackView: UIStackView = { UIStackView(frame: .zero) }()
  private lazy var tagIconImageView: UIImageView = { UIImageView(frame: .zero) }()
  private(set) lazy var tagLabel: UILabel = { UILabel(frame: .zero) }()

  var stackViewWidthConstraint: NSLayoutConstraint?

  private let viewModel: DiscoveryProjectTagPillViewModelType = DiscoveryProjectTagPillViewModel()

  // MARK: - Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.configureSubviews()
    self.bindStyles()
    self.bindViewModel()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Styles

  override func bindStyles() {
    super.bindStyles()

    _ = self.contentView
      |> contentViewStyle

    _ = self.rootStackView
      |> rootStackViewStyle

    _ = self.tagLabel
      |> tagLabelStyle
  }

  // MARK: - View Model

  override func bindViewModel() {
    super.bindViewModel()

    self.tagLabel.rac.text = self.viewModel.outputs.tagLabelText
    self.tagLabel.rac.textColor = self.viewModel.outputs.tagLabelTextColor
    self.contentView.rac.backgroundColor = self.viewModel.outputs.backgroundColor
    self.tagIconImageView.rac.tintColor = self.viewModel.outputs.tagIconImageTintColor

    self.viewModel.outputs.tagIconImageName
    .observeForUI()
    .observeValues { [weak self] imageName in
      guard let self = self else { return }
      _ = self.tagIconImageView
        |> \.image .~ image(named: imageName)
    }

//    self.viewModel.outputs.tagIconImageTintColor
//    .observeForUI()
//    .observeValues { [weak self] tintColor in
//      guard let self = self else { return }
//      _ = self.tagIconImageView
//        |> \.tintColor .~ tintColor
//    }
  }

  // MARK: - Configuration

  func configureWith(value: DiscoveryProjectTagPillCellValue) {
    self.viewModel.inputs.configure(with: value)
  }

  // MARK: - Functions

  private func configureSubviews() {
    _ = (self.rootStackView, self.contentView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = ([self.tagIconImageView, self.tagLabel], self.rootStackView)
      |> ksr_addArrangedSubviewsToStackView()

    _ = [self.tagIconImageView]
      ||> \.translatesAutoresizingMaskIntoConstraints .~ false

//    self.stackViewWidthConstraint = self.rootStackView.widthAnchor.constraint(equalToConstant: 0.0)
//      |> \.isActive .~ true
    let tagIconImageViewHeightConstraint = self.tagIconImageView.heightAnchor.constraint(equalToConstant: 13.0)
      |> \.priority .~ .defaultHigh

    NSLayoutConstraint.activate([
      self.tagIconImageView.widthAnchor.constraint(equalToConstant: 13.0),
      tagIconImageViewHeightConstraint
    ])
  }
}

// MARK: - Styles

private let contentViewStyle: ViewStyle = { view in
  view
    |> roundedStyle(cornerRadius: Styles.grid(1))
}

private let tagLabelStyle: LabelStyle = { label in
  label
    |> \.font .~ UIFont.ksr_caption1().bolded
    |> \.numberOfLines .~ 1
    |> \.lineBreakMode .~ .byTruncatingTail
}

private let rootStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> \.axis .~ .horizontal
    |> \.spacing .~ Styles.grid(1)
    |> \.alignment .~ .center
    |> \.layoutMargins .~ .init(topBottom: Styles.gridHalf(2), leftRight: Styles.gridHalf(3))
    |> \.isLayoutMarginsRelativeArrangement .~ true
}
