//
//  MapperProtocol.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation

protocol MapperProtocol {
    associatedtype LocalData: Codable
    associatedtype RemoteData: Codable
    associatedtype Entity: Codable
    func toLocalDomain(from dto: LocalData) -> Entity?
    func toRemoteDomain(from dto: RemoteData) -> Entity?
    func localToData(from entity: Entity) -> LocalData?
    func remoteToData(from entity: Entity) -> RemoteData?
}
