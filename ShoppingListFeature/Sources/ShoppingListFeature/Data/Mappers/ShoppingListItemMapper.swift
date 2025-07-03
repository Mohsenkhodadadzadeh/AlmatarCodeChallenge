//
//  ShoppingLIstItemMapper.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//
import Foundation

public struct ShoppingListItemMapper: MapperProtocol {

    func toRemoteDomain(from dto: ApiModel.ShoppingListItemRemote) -> ShoppingListItemEntity? {
        
        guard let uuid = UUID(uuidString: dto.id) else {
            return nil
        }
        
        return ShoppingListItemEntity(id: uuid , name: dto.name, quantity: dto.quantity, didPurchase: dto.didPurchase, createdAt: dto.createdAt, updatedAt: dto.updatedAt)
        
    }
    func toLocalDomain(from dto: DBModel.ShoppingListItem) -> ShoppingListItemEntity? {
       
        return ShoppingListItemEntity(id: dto.id, name: dto.name, quantity: dto.quantity, didPurchase: dto.didPurchase, createdAt: dto.createdAt, updatedAt: dto.updatedAt)
        
    }
    func remoteToData(from entity: ShoppingListItemEntity) -> ApiModel.ShoppingListItemRemote? {
        return ApiModel.ShoppingListItemRemote(id: entity.id.uuidString, name: entity.name, quantity: entity.quantity, didPurchase: entity.didPurchase, createdAt: entity.createdAt, updatedAt: entity.updatedAt)
    }
    func localToData(from entity: ShoppingListItemEntity) -> DBModel.ShoppingListItem? {
        return DBModel.ShoppingListItem(id: entity.id, name: entity.name, quantity: entity.quantity, didPurchase: entity.didPurchase, createdAt: entity.createdAt, updatedAt: entity.updatedAt)
    }
    
}
