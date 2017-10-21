//
//  MOUIDeviceAdditions.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on May/04/2009.
//
/*
 Copyright 2009 Yar Hwee Boon. All rights reserved.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of MotionObj nor the names of its
 contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#include <sys/sysctl.h>  
#include <mach/mach.h>

#import "MOUIDeviceAdditions.h"

@implementation UIDevice (MOUIDeviceAdditions)

- (double)moAvailableMemory {
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) {
		return NSNotFound;
	}
	
	return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}


// Courtesy http://iphonedevelopertips.com/device/determine-if-iphone-is-3g-or-3gs-determine-if-ipod-is-first-or-second-generation.html
- (NSString*)moHardwareType {
	size_t size;

	// Set 'oldp' parameter to NULL to get the size of the data returned so we can allocate appropriate amount of space
	sysctlbyname("hw.machine", NULL, &size, NULL, 0); 

	// Allocate the space to store name
	char *name = malloc(size);

	// Get the platform name
	sysctlbyname("hw.machine", name, &size, NULL, 0);

	// Place name into a string
	NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];

	// Done with this
	free(name);

	return machine;
}


//Courtesy of https://github.com/InderKumarRathore/DeviceUtil/blob/master/DeviceUtil.m
- (NSString*)moHardwareDescription {
	NSString *hardware = [self moHardwareString];
	if ([hardware isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
	if ([hardware isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
	if ([hardware isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
	if ([hardware isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
	if ([hardware isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
	if ([hardware isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (CDMA)";
	if ([hardware isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
	if ([hardware isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
	if ([hardware isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";
	if ([hardware isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
	if ([hardware isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
	if ([hardware isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
	if ([hardware isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
	if ([hardware isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
	if ([hardware isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
	if ([hardware isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
	if ([hardware isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
	if ([hardware isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
	if ([hardware isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
	if ([hardware isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
	if ([hardware isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
	if ([hardware isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
	if ([hardware isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
	if ([hardware isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
	if ([hardware isEqualToString:@"iPhone10,3"]) return @"iPhone X";
	if ([hardware isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
	if ([hardware isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
	if ([hardware isEqualToString:@"iPhone10,6"]) return @"iPhone X";
	
	if ([hardware isEqualToString:@"iPod1,1"]) return @"iPod Touch (1 Gen)";
	if ([hardware isEqualToString:@"iPod2,1"]) return @"iPod Touch (2 Gen)";
	if ([hardware isEqualToString:@"iPod3,1"]) return @"iPod Touch (3 Gen)";
	if ([hardware isEqualToString:@"iPod4,1"]) return @"iPod Touch (4 Gen)";
	if ([hardware isEqualToString:@"iPod5,1"]) return @"iPod Touch (5 Gen)";
	//7,1 for 6th generation is not a typo
	if ([hardware isEqualToString:@"iPod7,1"]) return @"iPod Touch (6 Gen)";

	if ([hardware isEqualToString:@"iPad1,1"]) return @"iPad";
	if ([hardware isEqualToString:@"iPad1,2"]) return @"iPad 3G";
	if ([hardware isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
	if ([hardware isEqualToString:@"iPad2,2"]) return @"iPad 2";
	if ([hardware isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
	if ([hardware isEqualToString:@"iPad2,4"]) return @"iPad 2";
	if ([hardware isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
	if ([hardware isEqualToString:@"iPad2,6"]) return @"iPad Mini";
	if ([hardware isEqualToString:@"iPad2,7"]) return @"iPad Mini (GSM+CDMA)";
	if ([hardware isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
	if ([hardware isEqualToString:@"iPad3,2"]) return @"iPad 3 (GSM+CDMA)";
	if ([hardware isEqualToString:@"iPad3,3"]) return @"iPad 3";
	if ([hardware isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
	if ([hardware isEqualToString:@"iPad3,5"]) return @"iPad 4";
	if ([hardware isEqualToString:@"iPad3,6"]) return @"iPad 4 (GSM+CDMA)";
	if ([hardware isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
	if ([hardware isEqualToString:@"iPad4,2"]) return @"iPad Air";
	if ([hardware isEqualToString:@"iPad4,4"]) return @"iPad Mini Retina (WiFi)";
	if ([hardware isEqualToString:@"iPad4,5"]) return @"iPad Mini Retina";
	if ([hardware isEqualToString:@"iPad4,6"]) return @"iPad Mini Retina (CN)";
	if ([hardware isEqualToString:@"iPad4,7"]) return @"iPad Mini 3 (WiFi)";
	if ([hardware isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
	if ([hardware isEqualToString:@"iPad5,1"]) return @"iPad Mini 4 (WiFi)";
	if ([hardware isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
	if ([hardware isEqualToString:@"iPad5,3"]) return @"iPad Air 2 (WiFi)";
	if ([hardware isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
	if ([hardware isEqualToString:@"iPad6,3"]) return @"iPad Pro (9.7 inch)";
	if ([hardware isEqualToString:@"iPad6,4"]) return @"iPad Pro (9.7 inch)";
	if ([hardware isEqualToString:@"iPad6,7"]) return @"iPad Pro (12.9 inch)";
	if ([hardware isEqualToString:@"iPad6,8"]) return @"iPad Pro (12.9 inch)";
	if ([hardware isEqualToString:@"iPad6,11"]) return @"iPad 5 (WiFi)";
	if ([hardware isEqualToString:@"iPad6,12"]) return @"iPad 5 (GSM+DMA)";
	if ([hardware isEqualToString:@"iPad7,1"]) return @"iPad Pro 2 (WiFi)";
	if ([hardware isEqualToString:@"iPad7,2"]) return @"iPad Pro 2 (GSM+CDMA)";
	if ([hardware isEqualToString:@"iPad7,3"]) return @"iPad Pro (10.5 inch, WiFi)";
	if ([hardware isEqualToString:@"iPad7,4"]) return @"iPad Pro (10.5 inch, GSM+CDMA)";

	if ([hardware isEqualToString:@"i386"]) return @"Simulator";
	if ([hardware isEqualToString:@"x86_64"]) return @"Simulator";

	if ([hardware isEqualToString:@"AppleTV1,1"]) return @"Apple TV";
	if ([hardware isEqualToString:@"AppleTV2,1"]) return @"Apple TV 2G";
	if ([hardware isEqualToString:@"AppleTV3,1"]) return @"Apple TV 3";
	if ([hardware isEqualToString:@"AppleTV3,2"]) return @"Apple TV 3";
	if ([hardware isEqualToString:@"AppleTV5,3"]) return @"Apple TV 4";

	if ([hardware hasPrefix:@"iPhone"]) return [NSString stringWithFormat:@"Unknown iPhone: %@", hardware];
	if ([hardware hasPrefix:@"iPad"]) return [NSString stringWithFormat:@"Unknown iPad: %@", hardware];
	if ([hardware hasPrefix:@"iPod"]) return [NSString stringWithFormat:@"Unknown iPod: %@", hardware];
	if ([hardware hasPrefix:@"AppleTV"]) return [NSString stringWithFormat:@"Unknown Apple TV: %@", hardware];

	return [NSString stringWithFormat:@"Unknown device: %@", hardware];
}


//Courtesy of https://github.com/InderKumarRathore/UIDevice-Hardware/blob/master/UIDevice%2BHardware.m
//https://www.theiphonewiki.com/wiki/Models
- (NSString*)moHardwareString {
	size_t size = 100;
	char *hw_machine = malloc(size);
	int name[] = {CTL_HW,HW_MACHINE};
	sysctl(name, 2, hw_machine, &size, NULL, 0);
	NSString *hardware = [NSString stringWithUTF8String:hw_machine];
	free(hw_machine);
	return hardware;
}

@end
