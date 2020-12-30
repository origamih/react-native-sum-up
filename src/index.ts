import { NativeModules, Platform } from 'react-native';
const isAndroid = Platform.select({
  ios: false,
  android: true
});

const RNSumUpWrapper = NativeModules.SumUpBridge;

const SumUp = {
  apiKey: '',

  // paymentOptionAny: (Platform.OS === 'ios') ? RNSumUpWrapper.SMPPaymentOptionAny : null,
  // paymentOptionCardReader: (Platform.OS === 'ios') ? RNSumUpWrapper.SMPPaymentOptionCardReader : null,
  // paymentOptionMobilePayment: (Platform.OS === 'ios') ? RNSumUpWrapper.SMPPaymentOptionMobilePayment : null,

  // SMPCurrencyCodeBGN: RNSumUpWrapper.SMPCurrencyCodeBGN,
  // SMPCurrencyCodeBRL: RNSumUpWrapper.SMPCurrencyCodeBRL,
  // SMPCurrencyCodeCHF: RNSumUpWrapper.SMPCurrencyCodeCHF,
  // SMPCurrencyCodeCLP: (Platform.OS === 'android') ? RNSumUpWrapper.SMPCurrencyCodeCLP : null, // iOS SDK version currently doesn't supports this currency
  // SMPCurrencyCodeCZK: RNSumUpWrapper.SMPCurrencyCodeCZK,
  // SMPCurrencyCodeDKK: RNSumUpWrapper.SMPCurrencyCodeDKK,
  // SMPCurrencyCodeEUR: RNSumUpWrapper.SMPCurrencyCodeEUR,
  // SMPCurrencyCodeGBP: RNSumUpWrapper.SMPCurrencyCodeGBP,
  // SMPCurrencyCodeHUF: RNSumUpWrapper.SMPCurrencyCodeHUF,
  // SMPCurrencyCodeNOK: RNSumUpWrapper.SMPCurrencyCodeNOK,
  // SMPCurrencyCodePLN: RNSumUpWrapper.SMPCurrencyCodePLN,
  // SMPCurrencyCodeRON: RNSumUpWrapper.SMPCurrencyCodeRON,
  // SMPCurrencyCodeSEK: RNSumUpWrapper.SMPCurrencyCodeSEK,
  // SMPCurrencyCodeUSD: RNSumUpWrapper.SMPCurrencyCodeUSD,

  setup(key: string) {
    this.apiKey = key;
    if (!isAndroid) {
      return RNSumUpWrapper.setupAPIKey(key);
    } else return Promise.resolve();
  },

  authenticate() {
    return !isAndroid ? RNSumUpWrapper.presentLoginFromViewController() : RNSumUpWrapper.presentLoginFromViewController(this.apiKey);
  },

  authenticateWithToken(token: string) {
    return !isAndroid ? RNSumUpWrapper.loginToSumUpWithToken(token) : RNSumUpWrapper.loginToSumUpWithToken(this.apiKey, token);
  },

  logout() {
    return RNSumUpWrapper.logout();
  },

  // prepareForCheckout() {
  //   return RNSumUpWrapper.prepareForCheckout();
  // },

  checkout(totalAmount: number, title: string, currencyCode: string, foreignTransactionId = null) {
    const request = {
      totalAmount,
      title,
      currencyCode: currencyCode || 'GBP',
      foreignID: foreignTransactionId,
      skipScreenOptions: 'false'
    };
    // const request = {
    //     'title' : title,
    //     'totalAmount' : sum,
    //     'currencyCode' : currencyCode,
    //     'skipScreenOptions' : skip,
    //     'foreignID : foreignTrID
    // }
    return RNSumUpWrapper.paymentCheckout(request);
  },

  // preferences() {
  //   return RNSumUpWrapper.preferences();
  // },

  isLoggedIn() {
    return RNSumUpWrapper.isLoggedIn();
  }
};

export default SumUp;
