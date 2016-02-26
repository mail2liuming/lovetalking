//
//  AppDelegate.m
//  AiDuiJiang
//
//  Created by liu on 15/11/22.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"
#import "LoginViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UserAccoutManager.h"
#import "HomeViewController.h"
#import "SlideNavigationController.h"
#import "MenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [TencentOAuth HandleOpenURL:url];
}

- (void)configAPIKey {
    [AMapNaviServices sharedServices].apiKey = @"4363c3b646260c230109ff20b2a0ccac";
    [MAMapServices sharedServices].apiKey = @"4363c3b646260c230109ff20b2a0ccac";
    
    
    NSLog(@"###map version %@", [MAMapServices sharedServices].SDKVersion);
    NSLog(@"###nav version %@", [AMapNaviServices sharedServices].SDKVersion);

    
}

- (void)configIFlySpeech
{
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",@"565529bf",@"20000"]];
    
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:NO];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self configAPIKey];
    [self configIFlySpeech];
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    [navigationBar setBarTintColor:[UIColor colorWithRed:45.0f / 255.f green:45.0f / 255.f blue:45.0f / 255.f alpha:1.0f]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor  whiteColor]}];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    if ([[UINavigationBar class] instancesRespondToSelector:@selector(setBackIndicatorImage:)]) {
        navigationBar.backIndicatorImage = [UIImage imageNamed:@"icon_back@2x.png"];
        navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"icon_back@2x.png"];
        navigationBar.tintColor = [UIColor whiteColor];
    }
    
    SlideNavigationController *navController;
    if ([[UserAccoutManager sharedManager] isLogin] == YES) {
        HomeViewController *viewController = [[HomeViewController alloc] init];
        navController = [[SlideNavigationController alloc] initWithRootViewController:viewController];
        self.window.rootViewController = navController;
    } else {
        LoginViewController *viewController = [[LoginViewController alloc] init];
        navController = [[SlideNavigationController alloc] initWithRootViewController:viewController];
        self.window.rootViewController = navController;
    }
    
    MenuViewController *menuController = [[MenuViewController alloc] init];    
    [SlideNavigationController sharedInstance].leftMenu = menuController;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    
    [self.window makeKeyAndVisible];
    
    return YES;
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
    // The directory the application uses to store the Core Data store file. This code uses a directory named "liu.AiDuiJiang" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AiDuiJiang" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AiDuiJiang.sqlite"];
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
