import UIKit
import AutomatticAbout

class ViewController: UIViewController {

    @IBAction func showTapped() {
        let configuration = AppAboutScreenConfiguration()
        let controller = AutomatticAboutScreen.controller(appInfo: AppAboutScreenConfiguration.appInfo,
                                                          configuration: configuration)
        present(controller, animated: true, completion: nil)
    }
}
