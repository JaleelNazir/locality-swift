//
//  PhotoUploadManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/10/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseStorage

enum PhotoType:Int {
    case profile = 0, location, post
}

class PhotoUploadManager: NSObject {
    
    

    class func uploadPhoto(image:UIImage, type:PhotoType, uid:String, completionHandler: @escaping (FIRStorageMetadata?, Error?) -> ()) -> () {
        
        let imageData:Data = UIImageJPEGRepresentation(image, K.NumberConstant.Upload.ImageQuality)!
        
        // set upload path
        let filePath = buildPhotoURL(type: type, uid: uid)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        
        FirebaseManager.getImageStorageRef().child(filePath).put(imageData, metadata: metaData){(metaData,error) in
            if let error = error {
                print("UploadPhoto Error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }else{
                
                print("UploadPhoto Success!")
                completionHandler(metaData, nil)
            }
        }
    }

    class func buildPhotoURL(type:PhotoType, uid:String) -> String {
        switch type {
        case .profile:
            return String(format: K.String.UploadURL.ProfileFormat, uid)
    
        case .location:
            return String(format: K.String.UploadURL.LocationFormat, uid, Util.generateUUID())
            
        case .post:
            return String(format: K.String.UploadURL.PostFormat, uid, Util.generateUUID())
        }
    }
    
    class func deletePhoto(url:String, completionHandler: @escaping (Error?) -> ()) -> () {
        
        //let filePath = buildPhotoURL(type: type, uid: uid)
        FirebaseManager.getImageStorageRef().child(url).delete { (error) in
            completionHandler(error)
        }
        
    }
}
