//
//  AppDelegate.m
//  StudioLinkStandalone
//
//  Created by Sebastian Reimers on 03.01.16.
//  Copyright © 2016 IT-Service Sebastian Reimers. All rights reserved.
//

#import "AppDelegate.h"
#import "re/re.h"
#import "baresip.h"
#include <pthread.h>

pthread_t tid;

@interface AppDelegate ()

@property (unsafe_unretained) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    (void)sys_coredump_set(true);
    libre_init();
    conf_configure();
    ua_init("baresip v" BARESIP_VERSION " (" ARCH "/" OS ")", true, true, true, false);
    conf_modules();
    
    pthread_create(&tid, NULL, (void*(*)(void*))&re_main, NULL);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    ua_stop_all(false);
    (void)pthread_join(tid, NULL);
    ua_close();
    mod_close();
    libre_close();
}

@end
