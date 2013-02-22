/*
 * This file is part of the SDNetworkActivityIndicator package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDNetworkActivityIndicator.h"

/* if you define this precompiler variable the SDNetworkActivityIndicator will just
 * be a proxy to the AFNetworkActivityIndicatorManager. It can be defined in the 
 * .pch file of the project. 
 */
#ifdef SDNetworkActivityIndicatorAFNetworkSupport
#import "AFNetworkActivityIndicatorManager.h"
#endif


static SDNetworkActivityIndicator *instance;

@implementation SDNetworkActivityIndicator

+ (id)sharedActivityIndicator
{
    if (instance == nil)
    {
        instance = [[SDNetworkActivityIndicator alloc] init];
    }

    return instance;
}

- (id)init
{
    if ((self = [super init]))
    {
        counter = 0;
    }

    return self;
}

- (void)startActivity
{
    @synchronized(self)
    {
#ifndef SDNetworkActivityIndicatorAFNetworkSupport
        if (counter == 0)
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
#else
            [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
#endif
        counter++;
    }
}

- (void)stopActivity
{
    @synchronized(self)
    {
#ifdef SDNetworkActivityIndicatorAFNetworkSupport
        if ( counter>0) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            --counter;
        }
#else
        if (counter > 0 && --counter == 0)
        {
           [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];            
        }
#endif
    }
}

- (void)stopAllActivity
{
    @synchronized(self)
    {
#ifndef SDNetworkActivityIndicatorAFNetworkSupport
        counter = 0;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#else
        for(;counter>0; counter--)
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
#endif
    }
}

@end
