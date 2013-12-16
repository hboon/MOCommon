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


//Courtesy of https://github.com/InderKumarRathore/UIDevice-Hardware/blob/master/UIDevice%2BHardware.m
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

	if ([hardware isEqualToString:@"iPod1,1"]) return @"iPod Touch (1 Gen)";
	if ([hardware isEqualToString:@"iPod2,1"]) return @"iPod Touch (2 Gen)";
	if ([hardware isEqualToString:@"iPod3,1"]) return @"iPod Touch (3 Gen)";
	if ([hardware isEqualToString:@"iPod4,1"]) return @"iPod Touch (4 Gen)";
	if ([hardware isEqualToString:@"iPod5,1"]) return @"iPod Touch (5 Gen)";

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

	if ([hardware isEqualToString:@"i386"]) return @"Simulator";
	if ([hardware isEqualToString:@"x86_64"]) return @"Simulator";

	return @"Unknown";
}


//Courtesy of https://github.com/InderKumarRathore/UIDevice-Hardware/blob/master/UIDevice%2BHardware.m
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
