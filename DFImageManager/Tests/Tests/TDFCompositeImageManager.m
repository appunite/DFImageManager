//
//  TDFCompositeImageManager.m
//  DFImageManager
//
//  Created by Alexander Grebenyuk on 3/1/15.
//  Copyright (c) 2015 Alexander Grebenyuk. All rights reserved.
//

#import "DFImageManagerKit.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>


@interface _TDFMockImageManagerForComposite : NSObject <DFImageManaging>

@property (nonatomic) NSString *supportedResource;
@property (nonatomic, readonly) NSArray *submitedRequests;

@end

@implementation _TDFMockImageManagerForComposite {
    NSMutableArray *_submitedRequests;
}

- (instancetype)init {
    if (self = [super init]) {
        _submitedRequests = [NSMutableArray new];
    }
    return self;
}

- (BOOL)canHandleRequest:(nonnull DFImageRequest *)request {
    return [self.supportedResource isEqualToString:request.resource];
}

- (DFImageTask *)imageTaskForResource:(id)resource completion:(void (^)(UIImage *, NSDictionary *))completion {
    return [self imageTaskForRequest:[DFImageRequest requestWithResource:resource] completion:completion];
}

- (DFImageTask *)imageTaskForRequest:(DFImageRequest *)request completion:(void (^)(UIImage *, NSDictionary *))completion {
    [_submitedRequests addObject:request];
    return nil;
}

- (DFImageTask *)requestImageForResource:(id)resource completion:(void (^)(UIImage *, NSDictionary *))completion {
    return [self requestImageForRequest:[DFImageRequest requestWithResource:resource] completion:completion];
}

- (DFImageTask *)requestImageForRequest:(DFImageRequest *)request completion:(void (^)(UIImage *, NSDictionary *))completion {
    [_submitedRequests addObject:request];
    return nil;
}

- (void)invalidateAndCancel {
    // Do nothing
}

- (void)startPreheatingImagesForRequests:(NSArray *)requests {
    for (DFImageRequest *request in requests) {
        [self requestImageForRequest:request completion:nil];
    }
}

- (void)stopPreheatingImagesForRequests:(NSArray *)requests {
    // Do nothing
}

- (void)stopPreheatingImagesForAllRequests {
    // Do nothing
}

@end


/*! Test suite for DFCompositeImageManager class.
 */
@interface TDFCompositeImageManager : XCTestCase

@end

@implementation TDFCompositeImageManager

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatRequestsAreForwarded {
    NSString *resource1 = @"01";
    NSString *resource2 = @"02";
    
    _TDFMockImageManagerForComposite *manager1 = [_TDFMockImageManagerForComposite new];
    manager1.supportedResource = resource1;
    
    _TDFMockImageManagerForComposite *manager2 = [_TDFMockImageManagerForComposite new];
    manager2.supportedResource = resource2;
    
    DFCompositeImageManager *composite = [[DFCompositeImageManager alloc] initWithImageManagers:@[ manager1, manager2 ]];
    
    DFImageRequest *request1 = [[DFImageRequest alloc] initWithResource:resource1];
    DFImageRequest *request2 = [[DFImageRequest alloc] initWithResource:resource2];
    
    XCTAssertTrue([composite canHandleRequest:request1]);
    XCTAssertTrue([composite canHandleRequest:request2]);
    
    [composite requestImageForRequest:request1 completion:nil];
    [composite requestImageForRequest:request2 completion:nil];
    
    XCTAssertTrue(manager1.submitedRequests.count == 1);
    XCTAssertTrue([manager1.submitedRequests containsObject:request1]);
    XCTAssertTrue(manager2.submitedRequests.count == 1);
    XCTAssertTrue([manager2.submitedRequests containsObject:request2]);
}

- (void)testThatCompositesCanFormATreeStructure {
    NSString *resource1 = @"01";
    NSString *resource2 = @"02";
    
    _TDFMockImageManagerForComposite *manager1 = [_TDFMockImageManagerForComposite new];
    manager1.supportedResource = resource1;
    
    _TDFMockImageManagerForComposite *manager2 = [_TDFMockImageManagerForComposite new];
    manager2.supportedResource = resource2;
    
    DFCompositeImageManager *composite = [[DFCompositeImageManager alloc] initWithImageManagers:@[ manager1, [[DFCompositeImageManager alloc] initWithImageManagers:@[ manager2 ]] ]];
    
    DFImageRequest *request1 = [[DFImageRequest alloc] initWithResource:resource1];
    DFImageRequest *request2 = [[DFImageRequest alloc] initWithResource:resource2];
    
    XCTAssertTrue([composite canHandleRequest:request1]);
    XCTAssertTrue([composite canHandleRequest:request2]);
    
    [composite requestImageForRequest:request1 completion:nil];
    [composite requestImageForRequest:request2 completion:nil];
    
    XCTAssertTrue(manager1.submitedRequests.count == 1);
    XCTAssertTrue([manager1.submitedRequests containsObject:request1]);
    XCTAssertTrue(manager2.submitedRequests.count == 1);
    XCTAssertTrue([manager2.submitedRequests containsObject:request2]);
}

- (void)testThatIfTheRequestCantBeHandledTheExceptionIsThrown {
    _TDFMockImageManagerForComposite *manager = [_TDFMockImageManagerForComposite new];
    manager.supportedResource = @"resourse_01";
    DFCompositeImageManager *compisite = [[DFCompositeImageManager alloc] initWithImageManagers:@[ manager ]];
    XCTAssertThrows([compisite requestImageForRequest:[DFImageRequest requestWithResource:@"resourse_02"] completion:nil]);
}

@end
