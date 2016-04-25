//
//  Model.swift
//  TwitterSearches
//
//  Created by Admin on 4/25/16.
//  Copyright © 2016 Morra. All rights reserved.
//

import Foundation

// delegate protocol that enables Model to notify controller when the data changes

protocol ModelDelegate {
    
    func modelDataChanged()
    
}

// manages the saved searches
class Model {
    
    // keys used for storing app's data in app's NSUserDefaults
    private let pairsKey = "TwitterSearchesKVPairs" // for tag-query pairs
    private let tagsKey = "TwitterSearchesKeyOrder" // for tags
    
    private var searches: [String: String] = [:] // stores tag-query pairs
    private var tags: [String] = [] // stores tags in user-specified order
    
    private let delegate: ModelDelegate // delegate is MasterViewController
    
    
    // initializes the Model
    init(delegate: ModelDelegate) {
        self.delegate = delegate
        
        // get the NSUserDefaults object for the app
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        // get Dictionary of the app's tag-query pairs
        if let pairs = userDefaults.dictionaryForKey(pairsKey) {
            
            self.searches = pairs as! [String: String]
            
        }
        
        
        // get Array with the app's tag order
        if let tags = userDefaults.arrayForKey(tagsKey) {
            
            self.tags = tags as! [String]
            
        }
        
        // register to iCloud change notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateSearches"), name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: NSUbiquitousKeyValueStore.defaultStore())
        
    }
    

    // called by view controller to synchronize model after it's created
    
    func synchronize() {
        NSUbiquitousKeyValueStore.defaultStore().synchronize()
    }
    
    
    // returns the tag at the specified index
    func tagAtIndex(index: Int) -> String {
        return tags[index]
        
    }
    
    // returns the query String for a given tag
    func queryForTag(tag: String) -> String {
        return searches[tag]!
    }
    
    // returns the query String for the tag at a given index
    func queryForTagAtIndex(index: Int) -> String {
        return searches[tags[index]]!
    }
    
    // returns the number of tags
    var count: Int {
        return tags.count
    }
    
    
}
