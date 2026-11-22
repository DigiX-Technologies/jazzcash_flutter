class JazzCashPaymentDataModelV1 {
  String ppAmount;
  String ppBankID;
  String ppBillReference;
  String ppDescription;
  String ppLanguage;
  String ppMerchantID;
  String ppPassword;
  String ppProductID;
  String ppReturnURL;
  String ppTxnCurrency;
  String ppTxnDateTime;
  String ppTxnExpiryDateTime;
  String ppTxnRefNo;
  String ppTxnType;
  String ppVersion;
  String ppmpf1;
  String ppmpf2;
  String ppmpf3;
  String ppmpf4;
  String ppmpf5;

  JazzCashPaymentDataModelV1({
    required this.ppAmount,
    this.ppBankID = "",
    required this.ppBillReference,
    required this.ppDescription,
    this.ppLanguage = "EN",
    required this.ppMerchantID,
    required this.ppPassword,
    this.ppProductID = "",
    required this.ppReturnURL,
    this.ppTxnCurrency = "PKR",
    this.ppTxnDateTime = "",
    this.ppTxnExpiryDateTime = "",
    this.ppTxnRefNo = "",
    this.ppTxnType = "",
    this.ppVersion = "1.1",
    this.ppmpf1 = "",
    this.ppmpf2 = "",
    this.ppmpf3 = "",
    this.ppmpf4 = "",
    this.ppmpf5 = "",
  });

  factory JazzCashPaymentDataModelV1.fromJson(Map<String, dynamic> json) {
    return JazzCashPaymentDataModelV1(
      ppAmount: json['pp_Amount']?.toString() ?? '',
      ppBankID: json['pp_BankID']?.toString() ?? '',
      ppBillReference: json['pp_BillReference']?.toString() ?? '',
      ppDescription: json['pp_Description']?.toString() ?? '',
      ppLanguage: json['pp_Language']?.toString() ?? 'EN',
      ppMerchantID: json['pp_MerchantID']?.toString() ?? '',
      ppPassword: json['pp_Password']?.toString() ?? '',
      ppProductID: json['pp_ProductID']?.toString() ?? '',
      ppReturnURL: json['pp_ReturnURL']?.toString() ?? '',
      ppTxnCurrency: json['pp_TxnCurrency']?.toString() ?? 'PKR',
      ppTxnDateTime: json['pp_TxnDateTime']?.toString() ?? '',
      ppTxnExpiryDateTime: json['pp_TxnExpiryDateTime']?.toString() ?? '',
      ppTxnRefNo: json['pp_TxnRefNo']?.toString() ?? '',
      ppTxnType: json['pp_TxnType']?.toString() ?? '',
      ppVersion: json['pp_Version']?.toString() ?? '1.1',
      ppmpf1: json['ppmpf_1']?.toString() ?? '',
      ppmpf2: json['ppmpf_2']?.toString() ?? '',
      ppmpf3: json['ppmpf_3']?.toString() ?? '',
      ppmpf4: json['ppmpf_4']?.toString() ?? '',
      ppmpf5: json['ppmpf_5']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pp_Amount': ppAmount,
      'pp_BankID': ppBankID,
      'pp_BillReference': ppBillReference,
      'pp_Description': ppDescription,
      'pp_Language': ppLanguage,
      'pp_MerchantID': ppMerchantID,
      'pp_Password': ppPassword,
      'pp_ProductID': ppProductID,
      'pp_ReturnURL': ppReturnURL,
      'pp_TxnCurrency': ppTxnCurrency,
      'pp_TxnDateTime': ppTxnDateTime,
      'pp_TxnExpiryDateTime': ppTxnExpiryDateTime,
      'pp_TxnRefNo': ppTxnRefNo,
      'pp_TxnType': ppTxnType,
      'pp_Version': ppVersion,
      'ppmpf_1': ppmpf1,
      'ppmpf_2': ppmpf2,
      'ppmpf_3': ppmpf3,
      'ppmpf_4': ppmpf4,
      'ppmpf_5': ppmpf5,
    };
  }
}
