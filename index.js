import { NativeModules, Platform } from 'react-native';
const isAndroid = Platform.select({
  ios: false,
  android: true
});

const RNSumUpWrapper = !isAndroid ? NativeModules.SumUp : {};

const SumUp = {
  apiKey: '',

  paymentOptionAny: (Platform.OS === 'ios') ? RNSumUpWrapper.SMPPaymentOptionAny : null,
  paymentOptionCardReader: (Platform.OS === 'ios') ? RNSumUpWrapper.SMPPaymentOptionCardReader : null,
  paymentOptionMobilePayment: (Platform.OS === 'ios') ? RNSumUpWrapper.SMPPaymentOptionMobilePayment : null,

  SMPCurrencyCodeBGN: RNSumUpWrapper.SMPCurrencyCodeBGN,
  SMPCurrencyCodeBRL: RNSumUpWrapper.SMPCurrencyCodeBRL,
  SMPCurrencyCodeCHF: RNSumUpWrapper.SMPCurrencyCodeCHF,
  SMPCurrencyCodeCLP: (Platform.OS === 'android') ? RNSumUpWrapper.SMPCurrencyCodeCLP : null, // iOS SDK version currently doesn't supports this currency
  SMPCurrencyCodeCZK: RNSumUpWrapper.SMPCurrencyCodeCZK,
  SMPCurrencyCodeDKK: RNSumUpWrapper.SMPCurrencyCodeDKK,
  SMPCurrencyCodeEUR: RNSumUpWrapper.SMPCurrencyCodeEUR,
  SMPCurrencyCodeGBP: RNSumUpWrapper.SMPCurrencyCodeGBP,
  SMPCurrencyCodeHUF: RNSumUpWrapper.SMPCurrencyCodeHUF,
  SMPCurrencyCodeNOK: RNSumUpWrapper.SMPCurrencyCodeNOK,
  SMPCurrencyCodePLN: RNSumUpWrapper.SMPCurrencyCodePLN,
  SMPCurrencyCodeRON: RNSumUpWrapper.SMPCurrencyCodeRON,
  SMPCurrencyCodeSEK: RNSumUpWrapper.SMPCurrencyCodeSEK,
  SMPCurrencyCodeUSD: RNSumUpWrapper.SMPCurrencyCodeUSD,

  setup(key) {
    this.apiKey = key;
    if (Platform.OS === 'ios') {
      return RNSumUpWrapper.setup(key);
    } else return Promise.resolve();
  },

  authenticate() {
    return (Platform.OS === 'ios') ? RNSumUpWrapper.authenticate() : RNSumUpWrapper.authenticate(this.apiKey);
  },

  authenticateWithToken(token) {
    return (Platform.OS === 'ios') ? RNSumUpWrapper.authenticateWithToken(token) : RNSumUpWrapper.authenticateWithToken(this.apiKey, token);
  },

  logout() {
    return RNSumUpWrapper.logout();
  },

  prepareForCheckout() {
    return RNSumUpWrapper.prepareForCheckout();
  },

  checkout(totalAmount, title, currencyCode, foreignTransactionId = null) {
    const request = {
      totalAmount,
      title,
      currencyCode: currencyCode || 'GBP',
      paymentOption: RNSumUpWrapper.SMPPaymentOptionCardReader,
      foreignTransactionId
    };
    return RNSumUpWrapper.checkout(request);
  },

  preferences() {
    return RNSumUpWrapper.preferences();
  },

  isLoggedIn() {
    return RNSumUpWrapper.isLoggedIn();
  }
};

export default SumUp;
