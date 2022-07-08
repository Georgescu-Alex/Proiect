//
//  DataController.swift
//  Proiect
//
//  Created by m1 on 07/07/2022.
//

import CoreData
import Foundation

class DataController: ObservableObject
{
    let container = NSPersistentContainer(name: "BookData")

    init()
    {
        container.loadPersistentStores
        {
            description, error in
            if let error = error
            {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
