//
//  UserDataFactory.swift
//  TheSpaces
//
//  Created by Денис Швыров on 16.12.2020.
//  Copyright © 2020 Денис Швыров. All rights reserved.
//

import Foundation
import MagicalRecord

class UserDataFactory {
    static func loadUserData() -> UserDataModel? {
        guard let userDataDB = UserDataDBModel.mr_findFirst() else { return nil }
         
        let roles = (userDataDB.roles?.allObjects as? Array<UserDataRoleDBModel>) ?? []
        
        return UserDataModel(email: userDataDB.email ?? "",
                                     lastName: userDataDB.lastName ?? "",
                                     firstName: userDataDB.firstName ?? "",
                                     phoneConfirmed: userDataDB.phoneConfirmed,
                                     roles: roles.map({$0.value ?? ""}))
    }
    
    static func saveUserData(_ userData: UserDataModel) {
        removeUserData()
        
        MagicalRecord.save ({ (context) in
            let userDBModel = UserDataDBModel.mr_createEntity(in: context)
            userDBModel?.email = userData.email
            userDBModel?.lastName = userData.lastName
            userDBModel?.firstName = userData.firstName
            userDBModel?.phoneConfirmed = userData.phoneConfirmed
            
            for role in userData.roles {
                guard let roleDB = UserDataRoleDBModel.mr_createEntity(in: context) else { continue }
                roleDB.value = role
                userDBModel?.addToRoles(roleDB)
            }
            
        })
    }
    
    static func removeUserData() {
        MagicalRecord.save(blockAndWait: { context in
            UserDataDBModel.mr_truncateAll(in: context)
        })
    }
    
}
