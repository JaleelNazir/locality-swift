//
//  UserComment.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/14/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserComment: NSObject {
    
    
    var commentId:String!
    var postId:String!
    var userHandle:String!
    
    var commentText:String!
    var createdDate:Date!
    
    var user:BaseUser!
    
    init(comment:String, postId:String, user:BaseUser) {
        
        //This may change once we pull other users' posts
        
        self.createdDate = Date()
        self.commentId = Util.generateUUID()
        self.postId = postId
        self.userHandle = user.uid
        self.commentText = comment
        
        self.user = user
    }
    
    init(snapshot: FIRDataSnapshot) {
        super.init()
        let dic = snapshot.value as? [String:Any]
        
        let dateInt = dic?[K.DB.Var.CreatedDate] as! Int
        
        self.createdDate = Util.dateFromInt(dateInt: dateInt)
        self.postId = dic?[K.DB.Var.PostId] as! String
        self.commentText = dic?[K.DB.Var.CommentText] as! String
        self.commentId = dic?[K.DB.Var.CommentId] as! String
        self.userHandle = dic?[K.DB.Var.UserId] as! String
        self.user = BaseUser()
        
    }
    
    
    func toFirebaseObject() -> [String:Any] {
        return[K.DB.Var.CreatedDate:Util.intFromDate(date: createdDate),
               K.DB.Var.PostId:postId,
               K.DB.Var.UserId:userHandle,
               K.DB.Var.CommentId:commentId,
               K.DB.Var.CommentText:commentText]
    }
}
