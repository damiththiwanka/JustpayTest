#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double sdkVersionNumber;
FOUNDATION_EXPORT const unsigned char sdkVersionString[];

@protocol LPTrustedSDKDelegate
- (void) onIdentitySuccess;
- (void) onIdentityFailed: (int) errorCode message: (NSString*) errorMessage;
- (void) onMessageSignSuccess:(NSString*) signedMessage status: (NSString*) status;
- (void) onMessageSignFailed: (int) errorCode message: (NSString*) errorMessage;
@end

@interface LPTrustedSDK : NSObject

@property (weak) id <LPTrustedSDKDelegate> delegate;


- (void) createIdentity: (NSString*) challenge;
- (void) createIdentity: (NSString*) justpayCode challenge: (NSString*) challenge;
- (void) signMessage: (NSString*) message;
- (void) signMessage: (NSString*) justpayCode message: (NSString*) message;
- (BOOL) isIdentityExist;
- (BOOL) isIdentityExist: (NSString*) justpayCode;
- (BOOL) clearIdentity;
- (BOOL) clearIdentity: (NSString*) justpayCode;
- (NSString *) getDeviceId;
- (NSString*) getVersion;

+(id)getInstance;


@end

