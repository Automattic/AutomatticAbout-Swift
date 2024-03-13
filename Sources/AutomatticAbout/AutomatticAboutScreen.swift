import UIKit

// Required to prevent rotation in the About screen
private class AutomatticAboutScreenNavigationController: UINavigationController, OrientationLimited {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

public class AutomatticAboutScreen: UIViewController {
    private let appInfo: AboutScreenAppInfo?
    private let fonts: AboutScreenFonts?

    private let configuration: AboutScreenConfiguration
    private let isSubmenu: Bool

    private var sections: [AboutScreenSection] {
        configuration.sections
    }

    private var appLogosIndexPath: IndexPath? {
        for (sectionIndex, row) in sections.enumerated() {
            if let rowIndex = row.firstIndex(where: { $0.cellStyle == .appLogos }) {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }

        return nil
    }

    // MARK: - Views

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Occasionally our hidden separator insets can cause the horizontal
        // scrollbar to appear on rotation
        tableView.showsHorizontalScrollIndicator = false

        if isSubmenu == false {
            tableView.tableHeaderView = headerView
            tableView.tableFooterView = footerView
        }

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    lazy var headerView: UIView? = {
        guard let appInfo = appInfo else {
            return nil
        }

        let headerFonts = fonts ?? AboutScreenFonts.defaultFonts

        let headerView = AboutHeaderView(appInfo: appInfo, fonts: headerFonts, dismissAction: { [weak self] in
            self?.dismissAboutScreen()
        })

        // Setting the frame once is needed so that the table view header will show.
        headerView.frame.size.height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        return headerView
    }()

    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .systemGroupedBackground

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(containerView)

        let logo = UIImageView(image: UIImage(named: Images.automatticLogo))
        logo.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(logo)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: Metrics.footerVerticalOffset),
            containerView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Metrics.footerHeight),
            logo.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        footerView.frame.size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        return footerView
    }()

    private var shouldShowNavigationBar: Bool {
        isSubmenu
    }

    // MARK: - View lifecycle

    /// This is the preferred way to create an About screen to present, as a navigation controller is required.
    public static func controller(appInfo: AboutScreenAppInfo? = nil, configuration: AboutScreenConfiguration, fonts: AboutScreenFonts? = nil, isSubmenu: Bool = false) -> UIViewController {
        let viewController = AutomatticAboutScreen(appInfo: appInfo,
                                                   configuration: configuration,
                                                   fonts: fonts,
                                                   isSubmenu: isSubmenu)
        let navigationController = AutomatticAboutScreenNavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .formSheet
        return navigationController
    }

    init(appInfo: AboutScreenAppInfo? = nil, configuration: AboutScreenConfiguration, fonts: AboutScreenFonts? = nil, isSubmenu: Bool = false) {
        self.appInfo = appInfo
        self.fonts = fonts
        self.configuration = configuration
        self.isSubmenu = isSubmenu
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        if isSubmenu {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissAboutScreen))
        }

        view.backgroundColor = .systemGroupedBackground

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        if let headerView = headerView {
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }

        updateHeaderSize()

        tableView.reloadData()
    }

    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if let indexPath = appLogosIndexPath {
            // When rotating (only on iPad), scroll so that the app logos cell is always visible
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.appLogosScrollDelay) {
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        for cell in tableView.visibleCells {
            attemptToSetHapticState(.paused, for: cell)
        }

        if isMovingFromParent || isBeingDismissedDirectlyOrByAncestor() {
            configuration.didHide(viewController: self)
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for cell in tableView.visibleCells {
            attemptToSetHapticState(.active, for: cell)
        }

        navigationController?.setNavigationBarHidden(!shouldShowNavigationBar, animated: true)

        if isMovingToParent {
            configuration.willShow(viewController: self)
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateHeaderSize()
    }

    private func updateHeaderSize() {
        guard let headerView = headerView else {
            return
        }

        headerView.layoutIfNeeded()

        headerView.frame.size.height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableView.tableHeaderView = headerView
    }

    /// If the provided cell is an AutomatticAppLogosCell, set the haptic state to the requested one.
    ///
    private func attemptToSetHapticState(_ state: HapticsState, for cell: UITableViewCell) {
        guard let cell = cell as? AutomatticAppLogosCell else {
            return
        }

        cell.hapticsState = state
    }

    // MARK: - Actions

    @objc private func dismissAboutScreen() {
        let context = AboutItemActionContext(viewController: self)
        configuration.dismissScreen(context)
    }

    // MARK: - Constants

    enum Metrics {
        static let footerHeight: CGFloat = 58.0
        static let footerVerticalOffset: CGFloat = 20.0
    }

    enum Constants {
        static let appLogosScrollDelay: TimeInterval = 0.25
    }

    enum Images {
        static let automatticLogo = "automattic-logo"
    }
}

// MARK: - Table view data source

extension AutomatticAboutScreen: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let item = section[indexPath.row]

        let cell = item.makeCell()

        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.accessoryType = item.accessoryType
        cell.selectionStyle = item.cellSelectionStyle
        cell.accessoryView = item.accessoryView

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let item = section[indexPath.row]

        return item.cellHeight
    }
}

// MARK: - Table view delegate

extension AutomatticAboutScreen: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section[indexPath.row]

        let context = AboutItemActionContext(viewController: self, sourceView: tableView.cellForRow(at: indexPath))

        item.action?(context)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section[indexPath.row]

        cell.separatorInset = item.hidesSeparator ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) : tableView.separatorInset

        attemptToSetHapticState(.active, for: cell)
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        attemptToSetHapticState(.paused, for: cell)
    }
}

// MARK: AboutItem Extensions

private extension AboutItem {
    func makeCell() -> UITableViewCell {
        switch cellStyle {
        case .default:
            return UITableViewCell(style: .default, reuseIdentifier: cellStyle.rawValue)
        case .value1:
            return UITableViewCell(style: .value1, reuseIdentifier: cellStyle.rawValue)
        case .subtitle:
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellStyle.rawValue)
        case .appLogos:
            return AutomatticAppLogosCell()
        }
    }

    var cellHeight: CGFloat {
        switch cellStyle {
        case .appLogos:
            return AutomatticAppLogosCell.Metrics.cellHeight
        default:
            return UITableView.automaticDimension
        }
    }

    var cellSelectionStyle: UITableViewCell.SelectionStyle {
        switch cellStyle {
        case .appLogos:
            return .none
        default:
            return .default
        }
    }

    var accessoryView: UIView? {
        guard let accessoryViewSystemImage else {
            return nil
        }
        let imageView = UIImageView(image: UIImage(systemName: accessoryViewSystemImage.name)?.withRenderingMode(.alwaysTemplate))
        if let tintColor = accessoryViewSystemImage.tintColor {
            imageView.tintColor = tintColor
        }
        return imageView
    }
}


// From WordPress-iOS

private extension UIViewController {
    /// iOS's `isBeingDismissed` can return `false` if the VC is being dismissed indirectly, by one of its ancestors
    /// being dismissed.  This method returns `true` if the VC is being dismissed directly, or if one of its ancestors is being
    /// dismissed.
    ///
    func isBeingDismissedDirectlyOrByAncestor() -> Bool {
        guard !isBeingDismissed else {
            return true
        }

        var current: UIViewController = self

        while let ancestor = current.parent {
            guard !ancestor.isBeingDismissed else {
                return true
            }

            current = ancestor
        }

        return false
    }
}

