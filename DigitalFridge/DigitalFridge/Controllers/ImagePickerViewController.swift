//
//  ImagePickerViewController.swift
//  Snapchat Camera Lab
//
//  Created by Paige Plander on 3/11/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import UIKit
import AVFoundation

// TODO: you'll need to edit this line to make your class conform to a protocol
class ImagePickerViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // Part 1 involves connecting these outlets
    @IBOutlet weak var imageViewOverlay: UIImageView!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // The image to send as a Snap
    var selectedImage = UIImage()
    
    // middleman between AVCaptureInput and AVCaptureOutputs
    var captureSession: AVCaptureSession?
    
    // the device we are capturing media from (i.e. front camera of an iPhone 7)
    var captureDevice : AVCaptureDevice?
    
    // view that will let us preview what is being captured from our input
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // used to capture a single photo from our capture device
    var photoOutput = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = imageViewOverlay, let _ = takePhotoButton, let _ = sendButton, let _ = cancelButton, let _ = flipCameraButton else {
            print("Looks like you haven't connected all of your outlets!")
            return
        }
        
        // TODO: instantiate `captureSession` here (no need to pass in any
        // parameters into their initializers
        captureSession = AVCaptureSession()
        
        // TODO: uncomment me when the README tells you to!
        createAndLayoutPreviewLayer(fromSession: captureSession)
        configureCaptureSession(forDevicePosition: .unspecified)
        
        captureSession?.startRunning()
        
        toggleUI(isInPreviewMode: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the navigation bar while we are in this view
        navigationController?.navigationBar.isHidden = true
    }
    
    
    /// Should configure `captureSession` with an input and output (you'll need to implement this!)
    ///
    /// - Parameter devicePostion: AVCaptureDevice.Position type
    func configureCaptureSession(forDevicePosition devicePostion: AVCaptureDevice.Position) {
        guard let captureSession = captureSession else {
            print("captureSession has not been initialized")
            return
        }
        
        // specifies that we want high quality video captured from the device
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // This line will need to be edited for part 5.
        // It has a bad name (and is poorly written syntactically) because we want
        // you to think about what it's type should be.
        let someConstantWithABadName = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: devicePostion).devices[1]
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: someConstantWithABadName)
            
            captureSession.addInput(cameraInput)
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    /// This method should initialize a preview layer
    /// and add it to our view. It's not complete yet.
    ///
    /// - Parameter session: the current captureSession
    func createAndLayoutPreviewLayer(fromSession session: AVCaptureSession?) {
        // TODO: initialize previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        
        guard let previewLayer = previewLayer else {
            print("previewLayer hasn't been initialized yet!")
            return
        }
        
        // these two lines add the previewlayer to our viewcontroller's view programattically
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.layer.frame
        previewLayer.zPosition = -1
    }
    
    @IBAction func takePhotoButtonWasPressed(_ sender: UIButton) {
        // Instead of sending a squirrel pic every time, here we will want
        // to start the process of creating a photo from our photoOutput
        
        // TODO: delete this line
        // selectedImage = UIImage(named: "squirrel") ?? UIImage()
        
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        
        // TODO: capture the photo using photoOutput
        photoOutput.capturePhoto(with: photoSettings, delegate: self as AVCapturePhotoCaptureDelegate)
        
        toggleUI(isInPreviewMode: true)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        
        if let data = photo.fileDataRepresentation() {
            selectedImage = UIImage(data: data)!
        }
        toggleUI(isInPreviewMode: true)
    }
    
    /// Switch between front and back camera
    ///
    /// - Parameter sender: The flip camera button in the top left of the view
    @IBAction func flipCameraButtonWasPressed(_ sender: UIButton) {
        // TODO: allow user to switch between front and back camera.
        // you will need to remove all of your inputs from
        // your capture session before switching cameras
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: UIButton) {
        selectedImage = UIImage()
        toggleUI(isInPreviewMode: false)
    }
    
    @IBAction func sendButtonWasPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindToImagePicker", sender: nil)
    }
    
    // MARK: Do not edit below this line
    
    /// Toggles the UI depending on whether or not the user is
    /// viewing a photo they took, or is currently taking a photo.
    ///
    /// - Parameter isInPreviewMode: true if they just took a photo (and are viewing it)
    func toggleUI(isInPreviewMode: Bool) {
        if isInPreviewMode {
            imageViewOverlay.image = selectedImage
            print("got it")
            takePhotoButton.isHidden = true
            sendButton.isHidden = false
            cancelButton.isHidden = false
            flipCameraButton.isHidden = true
            
        }
        else {
            takePhotoButton.isHidden = false
            sendButton.isHidden = true
            cancelButton.isHidden = true
            imageViewOverlay.image = nil
            flipCameraButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationController?.navigationBar.isHidden = false
        let destination = segue.destination as! NewItemViewController
        destination.chosenImage = selectedImage
        destination.chosenImageView.image = selectedImage
        toggleUI(isInPreviewMode: false)
    }
}


