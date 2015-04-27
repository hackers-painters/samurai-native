//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "ServiceMonitorNetworkModel.h"

#pragma mark -

#define MAX_HISTORY	(128)

#pragma mark -

@implementation ServiceMonitorNetworkModel
{
	NSUInteger	_uploadStartBytes;
	NSUInteger	_downloadStartBytes;
}

@def_prop_assign( NSUInteger,		uploadBytes );
@def_prop_strong( NSMutableArray *,	uploadHistory );

@def_prop_assign( NSUInteger,		downloadBytes );
@def_prop_strong( NSMutableArray *,	downloadHistory );

@def_singleton( ServiceMonitorNetworkModel )

- (id)init
{
	self = [super init];
	if ( self )
	{
		_uploadStartBytes = 0;
		_downloadStartBytes = 0;

		self.uploadBytes = 0;
		self.downloadBytes = 0;
		
		self.uploadHistory = [[NSMutableArray alloc] init];
		self.downloadHistory = [[NSMutableArray alloc] init];
		
		for ( NSUInteger i = 0; i < MAX_HISTORY; ++i )
		{
			[self.uploadHistory addObject:@(0)];
			[self.downloadHistory addObject:@(0)];
		}
	}
	return self;
}

- (void)dealloc
{
	[self.uploadHistory removeAllObjects];
	self.uploadHistory = nil;

	[self.downloadHistory removeAllObjects];
	self.downloadHistory = nil;
}

- (void)update
{
	struct ifaddrs * ifa_list = 0;
	struct ifaddrs * ifa = 0;
	
	if ( getifaddrs(&ifa_list) == -1 )
	{
		return;
	}
	
	uint32_t iBytes = 0;
	uint32_t oBytes = 0;
	
	uint32_t wifiIBytes = 0;
	uint32_t wifiOBytes = 0;
	
	uint32_t wwanIBytes = 0;
	uint32_t wwanOBytes = 0;

	struct IF_DATA_TIMEVAL time = { 0 };
	
	for ( ifa = ifa_list; ifa; ifa = ifa->ifa_next )
	{
		if (AF_LINK != ifa->ifa_addr->sa_family)
			continue;
		
		if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
			continue;
		
		if (ifa->ifa_data == 0)
			continue;
		
	// Not a loopback device.
	// network flow
		
		if ( strncmp(ifa->ifa_name, "lo", 2) )
		{
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
			
			iBytes += if_data->ifi_ibytes;
			oBytes += if_data->ifi_obytes;

			time = if_data->ifi_lastchange;
		}

	//wifi flow
		
		if ( 0 == strcmp(ifa->ifa_name, "en0") )
		{
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
			
			wifiIBytes += if_data->ifi_ibytes;
			wifiOBytes += if_data->ifi_obytes;
		}

	//3G and gprs flow
		
		if ( 0 == strcmp(ifa->ifa_name, "pdp_ip0") )
		{
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
			
			wwanIBytes += if_data->ifi_ibytes;
			wwanOBytes += if_data->ifi_obytes;
		}
	}

	freeifaddrs( ifa_list );
	
	if ( 0 == _uploadStartBytes )
	{
		_uploadStartBytes = oBytes;
	}

	if ( 0 == _downloadStartBytes )
	{
		_downloadStartBytes = iBytes;
	}
	
	NSUInteger uploadSegment = (oBytes - _uploadStartBytes) - self.uploadBytes;
	NSUInteger downloadSegment = (iBytes - _downloadStartBytes) - self.downloadBytes;
	
	self.uploadBytes = oBytes - _uploadStartBytes;
	self.downloadBytes = iBytes - _downloadStartBytes;

	[self.uploadHistory addObject:[NSNumber numberWithFloat:uploadSegment]];
	[self.uploadHistory keepTail:MAX_HISTORY];

	[self.downloadHistory addObject:[NSNumber numberWithFloat:downloadSegment]];
	[self.downloadHistory keepTail:MAX_HISTORY];
	
//	PERF( @"Network, upload %d, download %d", self.uploadBytes, self.downloadBytes );
}

@end
