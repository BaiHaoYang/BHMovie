//
//  AppDelegate.h
//  BHMovie
//
//  Created by mac on 2016/10/25.
//  Copyright © 2016年 XHDAXHK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PlayViewController.h"
//#import "DMPagerViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//@property (strong, nonatomic) DMPagerViewController *pageVC;
@property (strong, nonatomic) PlayViewController *livingVC;
@property (assign, nonatomic) BOOL allowRotation;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
