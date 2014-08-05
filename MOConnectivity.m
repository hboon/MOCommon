//
//  MOConnectivity.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Aug/02/2011.
//
/*
 Copyright 2011 Yar Hwee Boon. All rights reserved.
 
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

#import <SystemConfiguration/SystemConfiguration.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

#if ! defined(IFT_ETHER)
#define IFT_ETHER 0x6/* Ethernet CSMACD */
#endif

#import "MOConnectivity.h"

BOOL moIsReachable(const char* hostName);
BOOL moIsReachable(const char* hostName) {
	SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, hostName);
	SCNetworkReachabilityFlags flags;
	Boolean flagsValid = SCNetworkReachabilityGetFlags(reachabilityRef, &flags);
	CFRelease(reachabilityRef);
	
	if (!flagsValid) {
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
	BOOL isReachableButNeedConnection = flags & kSCNetworkReachabilityFlagsConnectionRequired;
	
	return !(!isReachable || isReachableButNeedConnection);
}


//http://mattbsoftware.blogspot.sg/2009/04/how-to-get-ip-address-of-iphone-os-v221.html
NSString* getWiFiIPAddress(void);
NSString* getWiFiIPAddress(void) {
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;

	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) { // this second test keeps from picking up the loopback address
				NSString* name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"]) { // found the WiFi adapter
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
				}
			}

			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
}


BOOL moIsOnWifi(void) {
	const char* hostName = "google.com";
	SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, hostName);
	SCNetworkReachabilityFlags flags;
	Boolean flagsValid = SCNetworkReachabilityGetFlags(reachabilityRef, &flags);
	CFRelease(reachabilityRef);
	
	if (!flagsValid) {
		return NO;
	}

	BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
	BOOL isReachableButNeedConnection = flags & kSCNetworkReachabilityFlagsConnectionRequired;

	if (isReachable && !isReachableButNeedConnection) {
		// determine what type of connection is available
		BOOL isCellularConnection = ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0);
		NSString *wifiIPAddress = getWiFiIPAddress();

		if (isCellularConnection)  {
			return NO; // cellular connection available
		}

		if (wifiIPAddress) {
			return YES; // wifi connection available
		}
	}
	return 0;
}


BOOL moDoNotHaveInternetConnection(void) {
	return !moIsReachable("google.com");
}
