//
//  SetupViewController.swift
//  Dresser
//
//  Created by 山口瑞歩 on 2019/07/20.
//  Copyright © 2019 山口瑞歩. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    // 上下の画像のパス
    static var upImagePath: String?
    static var bottomImagePath: String?

    @IBOutlet weak var upImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var anotherImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        anotherImage.image = UIImage(named: "skirt")
//        upImage.image = UIImage(named: "tops")
//        bottomImage.image = UIImage(named: "bottom")
        print("up")
        print(SetupViewController.upImagePath)
        print("bottom")
        print(SetupViewController.bottomImagePath)

        upImage.image = loadImageFromPath(path: SetupViewController.upImagePath ?? "")
        bottomImage.image = loadImageFromPath(path: SetupViewController.bottomImagePath ?? "")
    }

    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: \(path)")
        }
        return image
    }
}
