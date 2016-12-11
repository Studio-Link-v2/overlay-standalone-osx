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

static void ua_exit_handler(void *arg)
{
	(void)arg;
	debug("ua exited -- stopping main runloop\n");

	/* The main run-loop can be stopped now */
	re_cancel();
}


@interface AppDelegate ()

@property (unsafe_unretained) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    (void)sys_coredump_set(true);
    libre_init();
    conf_configure();
    baresip_init(conf_config(), false);
    uag_set_exit_handler(ua_exit_handler, NULL);
    ua_init("baresip v" BARESIP_VERSION " (" ARCH "/" OS ")", true, true, true, false);
    conf_modules();
    uag_set_exit_handler(ua_exit_handler, NULL);    
    pthread_create(&tid, NULL, (void*(*)(void*))&re_main, NULL);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    ua_stop_all(false);
    sys_msleep(500);
    ua_close();
    conf_close();
    baresip_close();
    mod_close();
    libre_close();
    tmr_debug();
    mem_debug();
}

@end
