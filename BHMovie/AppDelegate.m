//
//  AppDelegate.m
//  BHMovie
//
//  Created by mac on 2016/10/25.
//  Copyright © 2016年 XHDAXHK. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HotSearchViewController.h"
#import "BHMusicViewController.h"
#import "Bmob.h"
#import "BHLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QQDrawerViewController.h"
#import "QQMainTabBarController.h"
#import "QQLeftTableViewController.h"
#import <Bugly/Bugly.h>
#define BMOBApid @"64716e5c7d5e5c3e8cff996edbe8b3c4"
#define RestAoid @"85acdfc2ef815a4f60c0ec79113fb217"
#define SECRETKey @"57b6fcc9d5133bbf"
#define masterKey @"08486948d76c59e8d50106a867310661"
#define BuglyID @"e9143e8aa3"
@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Bmob registerWithAppKey:BMOBApid];
    [Bugly startWithAppId:BuglyID];
    [self setMainUI];
    [self SetbackMusicType];
    //开启远程事件(锁屏时使用)
    [application beginReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    return YES;
}
- (void)setMainUI{
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    HotSearchViewController *searchHot=[[HotSearchViewController alloc]init];
//    searchHot.title=@"热门搜索";
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:searchHot];
//    BHMusicViewController *music=[[BHMusicViewController alloc]init];
//    music.title=@"热门音乐";
//    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:music];
//    UITabBarController *tab=[[UITabBarController alloc]init];
//    [searchHot.tabBarItem setImage: [[UIImage imageNamed:@"hotSearchGray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [searchHot.tabBarItem setSelectedImage: [[UIImage imageNamed:@"hotSearch"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [music.tabBarItem setImage: [[UIImage imageNamed:@"musicGray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [music.tabBarItem setSelectedImage: [[UIImage imageNamed:@"music"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    tab.viewControllers=@[nav,nav1];
//    [[UITabBar appearance] setTintColor:[UIColor redColor]];
////    self.window.rootViewController=tab;
//    BHLoginViewController *login=[[BHLoginViewController alloc]init];
//    self.window.rootViewController=login;
//    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //  创建左视图
    QQLeftTableViewController *leftViewController = [[QQLeftTableViewController alloc]init];
    //  创建主视图
    QQMainTabBarController *mainViewController = [[QQMainTabBarController alloc]init];
    //  传入左视图和主视图以及抽屉的最大宽度 创建抽屉
    QQDrawerViewController *rootViewController = [QQDrawerViewController drawerWithLeftViewController:leftViewController andMainViewController:mainViewController andMaxWidth:300];
    self.window.rootViewController = rootViewController;
//    [self.window makeKeyAndVisible];
    
}
- (void)SetbackMusicType{
    //    /设置音乐后台播放的会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error=nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"%s %@", __func__, error);
    }
    [session setActive:YES error:nil];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xhk.BHMovie" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BHMovie" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BHMovie.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
