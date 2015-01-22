// The MIT License (MIT)
//
// Copyright (c) 2015 Alexander Grebenyuk (github.com/kean).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DFImageManaging.h"
#import <Foundation/Foundation.h>


/*! Composite image manager is a dynamic dispatcher in a chain of responsibility. Each image manager added to the composite manager defines the types of resources if can handle. The rest of the resources are passed to the next image manager in the chain.
 @note Automatically adapts DFImageManager to <DFImageManaging> protocol.
 */
@interface DFCompositeImageManager : NSObject <DFImageManaging>

- (instancetype)initWithImageManagers:(NSArray /* id<DFImageManagingCore> */ *)imageManagers NS_DESIGNATED_INITIALIZER;

- (void)addImageManager:(id<DFImageManagingCore>)imageManager;
- (void)addImageManagers:(NSArray /* <DFImageManagingCore> */ *)imageManagers;
- (void)removeImageManager:(id<DFImageManagingCore>)imageManager;
- (void)removeImageManagers:(NSArray /* <DFImageManagingCore> */ *)imageManagers;

@end
