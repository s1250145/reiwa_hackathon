//
//  UpViewController.swift
//  Dresser
//
//  Created by 山口瑞歩 on 2019/07/20.
//  Copyright © 2019 山口瑞歩. All rights reserved.
//

import UIKit
import AVFoundation

class UpViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {

    // カメラ撮影部分
    @IBOutlet weak var camera: UIView!
    // シャッターボタン
    @IBOutlet weak var shutter: UIButton!

    // カメラの入出力を管理するオブジェクトを生成
    private let session = AVCaptureSession()
    private let imageOutput = AVCapturePhotoOutput()
    private var previewLayer = AVCaptureVideoPreviewLayer()

    var upImagePath: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        startCamera()
    }

    // シャッター押下時
    @IBAction func pushedShutter(_ sender: Any) {
        let setting = AVCapturePhotoSettings()
        setting.flashMode = .auto
        setting.isAutoStillImageStabilizationEnabled = true
        setting.isHighResolutionPhotoEnabled = false

        imageOutput.capturePhoto(with: setting, delegate: self)
    }

    // 撮影した画像の取得と保存
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            let photo = UIImage(data: imageData)!

            // 保存処理
            let url = "http://~/foo_bar.png"
            let myImageName = url.replacingOccurrences(of: "/", with: "=")
            upImagePath = self.fileINDocumentsDirectory(filename: myImageName)
            saveImage(image: photo, path: upImagePath)
        }

        // segue使わずに遷移
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "bottomView") as? BottomViewController else { return }
//        vc.upImagePath = self.upImagePath!
//        let next = BottomViewController()
//        vc.upImagePath = upImagePath
        SetupViewController.upImagePath = upImagePath;
        self.present(vc, animated: true, completion: nil)
    }

    // ディレクトリのURL取得
    func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        return documentsURL
    }

    // パスの作成
    func fileINDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL!.path
    }

    // ストレージへの保存処理
    func saveImage(image: UIImage, path: String) {
        let pngImageData = image.pngData()
        do {
            try pngImageData!.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print(error)
        }
    }

    // カメラ入出力の設定と撮影の開始
    func startCamera() {
        // 背面カメラの使用を設定
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)

        let devices = discoverySession.devices

        if let backCamera = devices.first {
            do {
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)

                // 入力
                if self .session.canAddInput(deviceInput) {
                    self.session.addInput(deviceInput)

                    // 出力
                    if(session.canAddOutput(imageOutput)) {

                        // カメラ起動
                        session.addOutput(imageOutput)
                        session.startRunning()

                        previewLayer = AVCaptureVideoPreviewLayer(session: session)
                        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait

                        // ビューに設定
                        previewLayer.frame = self.camera.bounds
                        previewLayer.videoGravity = .resizeAspectFill
                        camera.layer.addSublayer(previewLayer)
                    }
                }
            } catch {
                print("Error occured while creating video device input: \(error)")
            }
        }
    }
}
