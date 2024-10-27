//
//  UserCoreData.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/27/24.
//

import Foundation
import CoreData

public protocol UserCoreDataProtocol {
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError>    // 전체 즐겨찾기 리스트 가져오기
    func saveFavoriteUsers(user : UserListItem) -> Result<Bool, CoreDataError>  // 즐겨찾기 저장
    func deleteFavoriteUsers(userID : Int) -> Result<Bool, CoreDataError>       // 즐겨찾기 삭제
}


public struct UserCoreData : UserCoreDataProtocol {
    private let viewContext : NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        let fetchRequest : NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        do {
            let result = try viewContext.fetch(fetchRequest)
            let userList : [UserListItem] = result.compactMap { (favoriteUser : FavoriteUser) in
                if let login = favoriteUser.login, let imageURL = favoriteUser.imageURL {
                    return UserListItem(id: Int(favoriteUser.id), login: login, imageURL: imageURL)
                } else {
                    return nil
                }
            }
            return .success(userList)
            
        } catch {
            return .failure(.readError(error.localizedDescription))
        }
    }
    
    public func saveFavoriteUsers(user: UserListItem) -> Result<Bool, CoreDataError> {
        guard let entity = NSEntityDescription.entity(forEntityName: "CleanArchitectureProject", in: viewContext) else {
            return .failure(.entityNotFound("CleanArchitectureProject"))
        }
        let userObject = NSManagedObject(entity: entity, insertInto: viewContext)
        userObject.setValue(user.id, forKey: "id")
        userObject.setValue(user.login, forKey: "login")
        userObject.setValue(user.imageURL, forKey: "imageURL")
        
        do {
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.saveError(error.localizedDescription))
        }
    }
    
    public func deleteFavoriteUsers(userID: Int) -> Result<Bool, CoreDataError> {
        let fetchRequest : NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", userID)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            result.forEach { favoriteUser in
                viewContext.delete(favoriteUser)
            }
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.deleteError(error.localizedDescription))
        }
    }
}
