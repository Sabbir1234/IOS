//
//  ImageViewController.swift
//  apiDocumentCoreData
//
//  Created by Twinbit LTD on 2/12/20.
//

import UIKit
protocol ImageControllerDelegate {
    func fun()
}
class ImageViewController: UIViewController {
    var delegate : ImageControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate.fun()
        // Do any additional setup after loading the view.
    }
    



}
