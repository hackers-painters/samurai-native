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

#import "Samurai_CoreConfig.h"

// Modules
#import "Samurai_Assert.h"
#import "Samurai_Debug.h"
#import "Samurai_Encoding.h"
#import "Samurai_Handler.h"
#import "Samurai_Log.h"
#import "Samurai_Performance.h"
#import "Samurai_Property.h"
#import "Samurai_Runtime.h"
#import "Samurai_Sandbox.h"
#import "Samurai_Singleton.h"
#import "Samurai_System.h"
#import "Samurai_Thread.h"
#import "Samurai_Trigger.h"
#import "Samurai_UnitTest.h"
#import "Samurai_Validator.h"

// Extensions
#import "NSArray+Extension.h"
#import "NSBundle+Extension.h"
#import "NSData+Extension.h"
#import "NSDate+Extension.h"
#import "NSDictionary+Extension.h"
#import "NSMutableArray+Extension.h"
#import "NSMutableDictionary+Extension.h"
#import "NSMutableSet+Extension.h"
#import "NSObject+Extension.h"
#import "NSString+Extension.h"

// Namesapce

@namespace( core )								// S.core
@namespace( core, debugger,	SamuraiDebugger )	// S.core.debugger
@namespace( core, logger,	SamuraiLogger )		// S.core.logger
@namespace( core, system,	SamuraiSystem )		// S.core.system
