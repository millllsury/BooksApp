//
//  BookStorage.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 14/01/2026.
//

import RealmSwift

protocol StorageEngine {
    func write(_ block: () -> Void)
    func save<T: Object>(_ object: T)
    func fetch<T: Object>(_ type: T.Type) -> [T]
    func fetchById<T: Object>(_ type: T.Type, id: String) -> T?
    func delete<T: Object>(_ object: T)
    func update<T: Object>(_ type: T.Type, id: String, block: (T) -> Void)
}


final class RealmStorageEngine: StorageEngine {
    
    private let realm: Realm /*= try! Realm()*/
    
    init() {
          let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true) // удаляет базу если изменения - это толкьо для разработки
          realm = try! Realm(configuration: config)
      }
    
    func write(_ block: () -> Void) {
        try? realm.write {
            block()
        }
    }
    
    func save<T: Object>(_ object: T) {
        write {
            realm.add(object, update: .modified)
        }
    }
    
    func fetch<T: Object>(_ type: T.Type) -> [T] {
        Array(realm.objects(type))
    }
    
    func fetchById<T: Object>(_ type: T.Type, id: String) -> T? {
        realm.object(ofType: type, forPrimaryKey: id)
    }
    
    func delete<T: Object>(_ object: T) {
        write {
            realm.delete(object)
        }
    }
    
    func update<T: Object>(_ type: T.Type, id: String, block: (T) -> Void) {
        guard let object = fetchById(type, id: id) else { return }
        write {
            block(object)
        }
    }
}


