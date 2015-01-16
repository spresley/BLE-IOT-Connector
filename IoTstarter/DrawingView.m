/*******************************************************************************
 * Copyright (c) 2014 IBM Corp.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * and Eclipse Distribution License v1.0 which accompany this distribution.
 *
 * The Eclipse Public License is available at
 *   http://www.eclipse.org/legal/epl-v10.html
 * and the Eclipse Distribution License is available at
 *   http://www.eclipse.org/org/documents/edl-v10.php.
 *
 * Contributors:
 *    Mike Robertson - initial contribution
 *******************************************************************************/

//
//  DrawingView.m
//  IoTstarter
//

#import "DrawingView.h"
#import "Messenger.h"

@interface DrawingView ()

@property (nonatomic) float previousX;
@property (nonatomic) float previousY;

@end

@implementation DrawingView
{
    UIBezierPath *path;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Initialization code
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
    }
    return self;
}

/** Respond to the initial event for a user touching the screen.
 *  This does not send a message, but initializes the previous X and Y values
 *  to be used in touchesMoved.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    UITouch *touch = [touches anyObject];
    self.previousX = [touch locationInView:self].x;
    self.previousY = [touch locationInView:self].y;
    [path moveToPoint:[touch locationInView:self]];
    //NSLog(@"start x: %f, start y: %f", self.previousX, self.previousY);
}

/** Respond to incoming events as a user is touching the screen.
 *  Publish a message for each event.
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self publishTouchMove:touches ended:NO];
}

/** Respond to the final event for a user touching the screen.
 *  Publish a message with the ended flag set to true indicating
 *  the final message of the touch.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    [self publishTouchMove:touches ended:YES];
    [path removeAllPoints];
}

/** Publish the touchmove message. The message contains the current x,y coordinates,
 *  as well as the delta values between the current and previous coordinates.
 *  @param touches The set of touch events so far.
 *  @param ended Indicates whether this is the final message of the touch.
 */
- (void)publishTouchMove:(NSSet *)touches ended:(BOOL)ended
{
    Messenger *messenger = [Messenger sharedMessenger];
    if (messenger.client.isConnected == NO)
    {
        NSLog(@"Mqtt Client not connected. Swipes will be ignored");
        return;
    }
    
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float endX = [touch locationInView:self].x;
    float endY = [touch locationInView:self].y;
    float deltaX = endX - self.previousX;
    float deltaY = endY - self.previousY;
    //NSLog(@"start X: %f, start Y: %f, delta X: %f, delta Y: %f", self.previousX, self.previousY, deltaX, deltaY);
    float relativeX = self.previousX / screenBounds.size.width;
    float relativeY = self.previousY / screenBounds.size.height;
    float relativeDeltaX = deltaX / screenBounds.size.width;
    float relativeDeltaY = deltaY / screenBounds.size.height;
    //NSLog(@"relative start X: %f, relative start Y: %f, relative delta X: %f, relative delta Y: %f", relativeX, relativeY, relativeDeltaX, relativeDeltaY);
    
    self.previousX = endX;
    self.previousY = endY;
    
    NSString *endedString = @"";
    if (ended)
    {
        endedString = @", \"ended\": 1";
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *messageData = [MessageFactory createTouchmoveMessage:relativeX
                                                          screen_y:relativeY
                                                           delta_x:relativeDeltaX
                                                           delta_y:relativeDeltaY
                                                             ended:ended?1:0];
    
    [appDelegate publishData:messageData event:IOTTouchMoveEvent];
}

/** Respond to the event of a touch being cancelled.
 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
}

@end
