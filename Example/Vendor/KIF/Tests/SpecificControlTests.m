//
//  SpecificControlTests.m
//  Test Suite
//
//  Created by Brian Nickel on 6/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>

@interface SpecificControlTests : KIFTestCase
@end

@implementation SpecificControlTests

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testTogglingASwitch
{
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone];
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"Happy"];
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"0" traits:UIAccessibilityTraitNone];
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"Happy"];
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone];
}

- (void)testMovingASlider
{
    [tester waitForTimeInterval:1];
    [tester setValue:3 forSliderWithAccessibilityLabel:@"Slider"];
    [tester waitForViewWithAccessibilityLabel:@"Slider" value:@"3" traits:UIAccessibilityTraitNone];
    [tester setValue:0 forSliderWithAccessibilityLabel:@"Slider"];
    [tester waitForViewWithAccessibilityLabel:@"Slider" value:@"0" traits:UIAccessibilityTraitNone];
    [tester setValue:5 forSliderWithAccessibilityLabel:@"Slider"];
    [tester waitForViewWithAccessibilityLabel:@"Slider" value:@"5" traits:UIAccessibilityTraitNone];
}

- (void)testPickingAPhoto
{
    NSOperatingSystemVersion iOS11 = {11, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]
        && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS11]) {
        NSLog(@"This test can't be run on iOS 11, as the activity sheet is hosted in an `AXRemoteElement`");
        return;
    }
    
    // 'acknowledgeSystemAlert' can't be used on iOS7
    // The console shows a message "AX Lookup problem! 22 com.apple.iphone.axserver:-1"
    if ([UIDevice.currentDevice.systemVersion compare:@"8.0" options:NSNumericSearch] < 0) {
        return;
    }

    [tester tapViewWithAccessibilityLabel:@"Photos"];
    [tester acknowledgeSystemAlert];
    [tester waitForTimeInterval:0.5f]; // Wait for view to stabilize

    [tester choosePhotoInAlbum:@"Camera Roll" atRow:1 column:2];
    [tester waitForViewWithAccessibilityLabel:@"UIImage"];
}

@end
