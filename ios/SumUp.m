#import "SumUp.h"
#import "ScreenSaverManager.h"

@implementation RCTConvert (SMPPaymentOptions)

RCT_ENUM_CONVERTER(SMPPaymentOptions, (
                                       @{@"SMPPaymentOptionAny"           : @(SMPPaymentOptionAny),
                                         @"SMPPaymentOptionCardReader"    : @(SMPPaymentOptionCardReader),
                                         @"SMPPaymentOptionMobilePayment" : @(SMPPaymentOptionMobilePayment)
                                         }), SMPPaymentOptionAny, integerValue);

@end

@implementation RCTConvert (SMPSkipScreenOptions)
RCT_ENUM_CONVERTER(SMPSkipScreenOptions, (@{@"1" : @(SMPSkipScreenOptionSuccess)}), SMPSkipScreenOptionSuccess, integerValue);
@end

@implementation NSDictionary (WKDictionary)

- (id)objectForKeyNotNull:(id)key {
    
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}

@end


@implementation SumUp

- (NSDictionary *)constantsToExport
{
    return @{ @"SMPPaymentOptionAny": @(SMPPaymentOptionAny),
              @"SMPPaymentOptionCardReader": @(SMPPaymentOptionCardReader),
              @"SMPPaymentOptionMobilePayment": @(SMPPaymentOptionMobilePayment),
              @"SMPCurrencyCodeBGN" : (SMPCurrencyCodeBGN),
              @"SMPCurrencyCodeBRL" : (SMPCurrencyCodeBRL),
              @"SMPCurrencyCodeCHF" : (SMPCurrencyCodeCHF),
              @"SMPCurrencyCodeCLP" : (SMPCurrencyCodeCLP),
              @"SMPCurrencyCodeCZK" : (SMPCurrencyCodeCZK),
              @"SMPCurrencyCodeDKK" : (SMPCurrencyCodeDKK),
              @"SMPCurrencyCodeEUR" : (SMPCurrencyCodeEUR),
              @"SMPCurrencyCodeGBP" : (SMPCurrencyCodeGBP),
              @"SMPCurrencyCodeHUF" : (SMPCurrencyCodeHUF),
              @"SMPCurrencyCodeNOK" : (SMPCurrencyCodeNOK),
              @"SMPCurrencyCodePLN" : (SMPCurrencyCodePLN),
              @"SMPCurrencyCodeRON" : (SMPCurrencyCodeRON),
              @"SMPCurrencyCodeSEK" : (SMPCurrencyCodeSEK),
              @"SMPCurrencyCodeUSD" : (SMPCurrencyCodeUSD)};
}


RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setup:(NSString *)key resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    BOOL setupResponse = [SMPSumUpSDK setupWithAPIKey:key];
    if (setupResponse) {
        resolve(@"setup successful");
    } else {
        reject(@"000", @"It was not possible to complete setup with SumUp SDK. Please, check your implementation.", nil);
    }
}

RCT_EXPORT_METHOD(authenticate:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ScreenSaverManager *sharedManager = [ScreenSaverManager sharedManager];
        UIViewController *rootViewController = sharedManager.mainView;
        [SMPSumUpSDK presentLoginFromViewController:rootViewController animated:YES
                                    completionBlock:^(BOOL success, NSError *error) {
            if (error) {
                [rootViewController dismissViewControllerAnimated:YES completion:nil];
                reject(@"000", @"It was not possible to auth with SumUp. Please, check the username and password provided.", error);
            } else {
                SMPMerchant *merchantInfo = [SMPSumUpSDK currentMerchant];
                NSString *merchantCode = [merchantInfo merchantCode];
                NSString *currencyCode = [merchantInfo currencyCode];
                if ((merchantCode != nil) && (currencyCode != nil)) {
                    resolve(@{@"success": @(success),
                              @"userAdditionalInfo":
                                  @{ @"merchantCode": merchantCode,
                                     @"currencyCode": currencyCode
                                  }}
                            );
                }
            }
        }];
    });
}


RCT_EXPORT_METHOD(authenticateWithToken:(NSString *)token resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    BOOL isLoggedIn = [SMPSumUpSDK isLoggedIn];
    if (isLoggedIn) {
        resolve(nil);
    } else {
        NSString *aToken = token;
        [SMPSumUpSDK loginWithToken:aToken completion:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                reject(@"004", @"It was not possible to login with SumUp using a token. Please, try again.", nil);
            } else {
                resolve(nil);
            }
        }];
    }
}

RCT_EXPORT_METHOD(logout:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [SMPSumUpSDK logoutWithCompletionBlock:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            reject(@"004", @"It was not possible to log out with SumUp. Please, try again.", nil);
        } else {
            resolve(nil);
        }
    }];
}

RCT_EXPORT_METHOD(prepareForCheckout:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    BOOL isLoggedIn = [SMPSumUpSDK isLoggedIn];
    if (isLoggedIn) {
        [SMPSumUpSDK prepareForCheckout];
        resolve(nil);
    } else {
        reject(@"003", @"It was not possible to prepare for checkout. Please, log in first.", nil);
    }
}

RCT_EXPORT_METHOD(checkout:(NSDictionary *)request resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:[RCTConvert NSString:request[@"totalAmount"]]];
    NSString *title = [RCTConvert NSString:request[@"title"]];
    NSString *currencyCode = [RCTConvert NSString:request[@"currencyCode"]];
    NSUInteger paymentOption = [RCTConvert SMPPaymentOptions:request[@"paymentOption"]];
    NSUInteger skipScreen = [RCTConvert SMPSkipScreenOptions:@"1"];
    NSString *foreignTransactionID = [RCTConvert NSString:[request objectForKeyNotNull:@"foreignTransactionId"]];

    SMPCheckoutRequest *checkoutRequest = [SMPCheckoutRequest requestWithTotal:total
                                                                         title:title
                                                                  currencyCode:[[SMPSumUpSDK currentMerchant] currencyCode]
                                                                paymentOptions:paymentOption];
    if (foreignTransactionID != [NSNull null]) {
        [checkoutRequest setForeignTransactionID:foreignTransactionID];
    }
    checkoutRequest.skipScreenOptions = skipScreen;
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = UIApplication.sharedApplication.delegate.window.rootViewController;
        [SMPSumUpSDK checkoutWithRequest:checkoutRequest
                      fromViewController:rootViewController
                              completion:^(SMPCheckoutResult *result, NSError *error) {
                                  if (error) {
                                      reject(@"001", @"It was not possible to perform checkout with SumUp. Please, try again.", error);
                                  } else {
                                    NSDictionary *additionalInformation = [result additionalInfo];
                                      if (additionalInformation == nil) {
                                          reject(@"001", @"It was not possible to perform checkout with SumUp. Please, try again.", error);
                                      } else {
                                          NSString *cardType = [additionalInformation valueForKeyPath:@"card.type"];
                                          NSString *cardLast4Digits = [additionalInformation valueForKeyPath:@"card.last_4_digits"];
                                          NSString *installments = [additionalInformation valueForKeyPath:@"installments"];

                                          resolve(@{@"success": @([result success]), @"transactionCode": [result transactionCode], @"additionalInfo": @{ @"cardType": cardType, @"cardLast4Digits": cardLast4Digits, @"installments": installments }});
                                      }
                                  }
                              }];
    });
}

RCT_EXPORT_METHOD(preferences:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = UIApplication.sharedApplication.delegate.window.rootViewController;
        [SMPSumUpSDK presentCheckoutPreferencesFromViewController:rootViewController
                                                         animated:YES
                                                       completion:^(BOOL success, NSError * _Nullable error) {
                                                           if (success) {
                                                               resolve(nil);
                                                           } else {
                                                               reject(@"002", @"It was not possible to open Preferences window. Please, try again.", nil);
                                                           }
                                                       }];
    });
}

RCT_EXPORT_METHOD(isLoggedIn:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    BOOL isLoggedIn = [SMPSumUpSDK isLoggedIn];
    resolve(@{@"isLoggedIn": @(isLoggedIn)});
}


@end
