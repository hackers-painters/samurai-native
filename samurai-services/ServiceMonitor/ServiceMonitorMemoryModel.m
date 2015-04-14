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

#import "ServiceMonitorMemoryModel.h"

#pragma mark -

#define MAX_HISTORY	(128)

#pragma mark -

@implementation ServiceMonitorMemoryModel

@def_prop_assign( int64_t,			usedBytes );
@def_prop_assign( int64_t,			totalBytes );
@def_prop_strong( NSMutableArray *,	history );

@def_singleton( ServiceMonitorMemoryModel )

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.usedBytes = 0;
		self.totalBytes = 0;
		self.history = [[NSMutableArray alloc] init];

		for ( NSUInteger i = 0; i < MAX_HISTORY; ++i )
		{
			[self.history addObject:@(0)];
		}
	}
	return self;
}

- (void)dealloc
{
	[self.history removeAllObjects];
	self.history = nil;
}

- (void)update
{
	struct mstats stat = mstats();

	if ( 0 == stat.bytes_used )
	{
		self.usedBytes = 0;
		self.totalBytes = 0;

		mach_port_t host_port;
		mach_msg_type_number_t host_size;
		vm_size_t pagesize;

		host_port = mach_host_self();
		host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
		host_page_size( host_port, &pagesize );

		vm_statistics_data_t vm_stat;
		kern_return_t ret = host_statistics( host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size );
		
		if ( KERN_SUCCESS == ret )
		{
			natural_t mem_used = (natural_t)((vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize);
			natural_t mem_free = (natural_t)(vm_stat.free_count * pagesize);
			natural_t mem_total = mem_used + mem_free;

			self.usedBytes = mem_used;
			self.totalBytes = mem_total;
		}
	}
	else
	{
		self.usedBytes = stat.bytes_used;
		self.totalBytes = [[NSProcessInfo processInfo] physicalMemory];
	}
	
	[self.history addObject:[NSNumber numberWithFloat:self.usedBytes]];
	[self.history keepTail:MAX_HISTORY];
	
//	PERF( @"Memory, used %d, total %d", self.used, self.total );
}

@end
