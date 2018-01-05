/*
 * This is the source code of BTCchat for iOS v. 1.1
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Peter Iakovlev, 2013.
 */

#import "MTQueue.h"

@interface MTQueue ()
{
    bool _isMainQueue;
    dispatch_queue_t _queue;
    
    const char *_name;
}

@end

@implementation MTQueue

- (instancetype)init {
    self = [super init];
    if (self != nil)
    {
        _queue = dispatch_queue_create(nil, 0);
    }
    return self;
}

- (instancetype)initWithName:(const char *)name
{
    self = [super init];
    if (self != nil)
    {
        _name = name;
        
        _queue = dispatch_queue_create(_name, 0);
        dispatch_queue_set_specific(_queue, _name, (void *)_name, NULL);
    }
    return self;
}

- (void)dealloc
{
#if !OS_OBJECT_HAVE_OBJC_SUPPORT
    dispatch_release(_queue);
#endif
    _queue = nil;
}

+ (MTQueue *)mainQueue
{
    static MTQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        queue = [[MTQueue alloc] init];
        queue->_queue = dispatch_get_main_queue();
        queue->_isMainQueue = true;
    });
    return queue;
}

+ (MTQueue *)concurrentDefaultQueue {
    static MTQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        queue = [[MTQueue alloc] init];
        queue->_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    });
    return queue;
}

+ (MTQueue *)concurrentLowQueue {
    static MTQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        queue = [[MTQueue alloc] init];
        queue->_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    });
    return queue;
}

- (dispatch_queue_t)nativeQueue
{
    return _queue;
}

- (bool)isCurrentQueue
{
    if (_queue == nil || _name == nil)
        return false;
    
    if (_isMainQueue)
        return [NSThread isMainThread];
    else
        return dispatch_get_specific(_name) == _name;
}

- (void)dispatch:(dispatch_block_t)block {
    [self dispatchOnQueue:block synchronous:false];
}

- (void)dispatchOnQueue:(dispatch_block_t)block
{
    [self dispatchOnQueue:block synchronous:false];
}

- (void)dispatchOnQueue:(dispatch_block_t)block synchronous:(bool)synchronous
{
    if (block == nil)
        return;
    
    if (_queue != nil)
    {
        if (_isMainQueue)
        {
            if ([NSThread isMainThread])
                block();
            else if (synchronous)
                dispatch_sync(_queue, block);
            else
                dispatch_async(_queue, block);
        }
        else
        {
            if (_name != NULL && dispatch_get_specific(_name) == _name)
                block();
            else if (synchronous)
                dispatch_sync(_queue, block);
            else
                dispatch_async(_queue, block);
        }
    }
}

@end
