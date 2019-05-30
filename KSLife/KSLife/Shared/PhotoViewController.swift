//
//  PhotoViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/29.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    lazy var imagePickerController: UIImagePickerController = {[unowned self] in
        let pc = UIImagePickerController()
        pc.allowsEditing = true
        pc.delegate = self
        return pc
        }()
    
    @objc func tapAvatar() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "拍照", style: .default, handler: {_ in
            self.checkCameraPermission()
        })
        let album = UIAlertAction(title: "从手机相册选择", style: .default, handler: {_ in
            self.checkAlbumPermission()
        })
        let cancel = UIAlertAction(title: "取消", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    self.takePhoto()
                }
            })
        case .denied, .restricted:
            self.alertCamear()
        default:
            self.takePhoto()
        }
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        } else {
            print("不能用模拟器拍照")
        }
    }
    
    func alertCamear() {
        let alert = UIAlertController(title: "请在设置中打开相机", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkAlbumPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.selectAlbum()
                    }
                }
            })
        case .denied, .restricted:
            self.alertCamear()
        default:
            self.selectAlbum()
        }
    }
    
    func selectAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
    }
    
    func alertAlbum() {
        let alert = UIAlertController(title: "请在设置中打开相册", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
    }

}
