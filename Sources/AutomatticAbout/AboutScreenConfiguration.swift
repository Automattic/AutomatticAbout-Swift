import Foundation
import UIKit

public typealias AboutScreenSection = [AboutItem]

/// Users of AutomatticAboutScreen must provide a configuration conforming to this protocol.
public protocol AboutScreenConfiguration {
    /// A list of AboutItems, grouped into sections, which will be displayed in the about screen's table view.
    var sections: [AboutScreenSection] { get }

    /// A method that dismisses the about screen
    func dismissScreen(_ actionContext: AboutItemActionContext)

    /// Called when the screen will be shown for customization purposes and event tracking.
    ///
    func willShow(viewController: UIViewController)

    /// Called when the screen has been hidden for customization purposes and event tracking.
    ///
    func didHide(viewController: UIViewController)
}

public typealias AboutItemAction = ((AboutItemActionContext) -> Void)


public struct AboutItemActionContext {
    /// The About Screen view controller itself.
    public let viewController: UIViewController

    /// If the action was triggered by the user interacting with a specific view, it'll be available here.
    public let sourceView: UIView?

    init(viewController: UIViewController, sourceView: UIView? = nil) {
        self.viewController = viewController
        self.sourceView = sourceView
    }

    public func showSubmenu(title: String = "", configuration: AboutScreenConfiguration) {
        let submenu = AutomatticAboutScreen(configuration: configuration, isSubmenu: true)
        submenu.title = title

        viewController.navigationController?.pushViewController(submenu, animated: true)
    }
}

/// Defines a single row in the unified about screen.
///
public struct AboutItem {
    /// Title displayed in the main textLabel of the item's table row
    public let title: String

    /// Subtitle displayed in the detailTextLabel of the item's table row
    public let subtitle: String?

    /// Which cell style should be used to render the item's cell. See `AboutItemCellStyle` for options.
    public let cellStyle: AboutItemCellStyle

    /// The accessory type that should be used for the item's table row
    public let accessoryType: UITableViewCell.AccessoryType

    /// If `true`, the item's table row will hide its bottom separator
    public let hidesSeparator: Bool

    /// An optional action that can be performed when the item's table row is tapped.
    /// The action will be passed an `AboutItemActionContext` containing references to the view controller
    /// and the source view that triggered the action.
    public let action: AboutItemAction?
    
    /// System image name used for creating image view for accessory view
    public let accessoryViewSystemImage: (name: String, tintColor: UIColor?)?

    public init(title: String, subtitle: String? = nil, cellStyle: AboutItemCellStyle = .default, accessoryType: UITableViewCell.AccessoryType = .none, hidesSeparator: Bool = false, action: AboutItemAction? = nil, accessoryViewSystemImage: (name: String, tintColor: UIColor?)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.cellStyle = cellStyle
        self.accessoryType = accessoryType
        self.hidesSeparator = hidesSeparator
        self.action = action
        self.accessoryViewSystemImage = accessoryViewSystemImage
    }

    public enum AboutItemCellStyle: String {
        // Displays only a title
        case `default`
        // Displays a title on the leading side and a secondary value on the trailing side
        case value1
        // Displays a title with a smaller subtitle below
        case subtitle
        // Displays the custom app logos cell
        case appLogos
    }
}
