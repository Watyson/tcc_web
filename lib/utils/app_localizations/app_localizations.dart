import 'package:flutter/widgets.dart';
import 'package:mobile/utils/app_localizations/app_localizations_extension.dart';
import 'package:mobile/utils/app_localizations/en_us.dart';
import 'package:mobile/utils/app_localizations/pt_br.dart';

class AppLocalizations {
  Locale locale;
  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': localizationsEnUs(),
    'pt': localizationsPtBr(),
  };

  // === User Interface Strings:
  // Titles
  String get menu => 'menu'.localized(this);
  String get profile => 'profile'.localized(this);
  String get register => 'register'.localized(this);
  String get recoverPassword => 'recoverPassword'.localized(this);
  String get historic => 'historic'.localized(this);
  String get registerProduct => 'registerProduct'.localized(this);

  // Buttons
  String get update => 'update'.localized(this);
  String get connect => 'connect'.localized(this);
  String get back => 'back'.localized(this);
  String get recover => 'recover'.localized(this);
  String get confirm => 'confirm'.localized(this);
  String get cart => 'cart'.localized(this);
  String get portuguese => 'portuguese'.localized(this);
  String get english => 'english'.localized(this);
  String get logout => 'logout'.localized(this);
  String get managementMenu => 'managementMenu'.localized(this);
  String get managementPerfil => 'managementPerfil'.localized(this);
  String get yes => 'yes'.localized(this);
  String get no => 'no'.localized(this);
  String get youSure => 'youSure'.localized(this);
  String get areYouSure => 'AreYouSure'.localized(this);
  String get create => 'create'.localized(this);
  String get managementEmployees => 'managementEmployees'.localized(this);
  String get managementSales => 'managementSales'.localized(this);

  // Form
  String get username => 'username'.localized(this);
  String get password => 'password'.localized(this);
  String get repeatPassword => 'repeatPassword'.localized(this);
  String get name => 'name'.localized(this);
  String get email => 'email'.localized(this);
  String get phone => 'phone'.localized(this);
  String get address => 'address'.localized(this);
  String get newEmail => 'newEmail'.localized(this);
  String get newAddress => 'newAddress'.localized(this);
  String get newPhone => 'newPhone'.localized(this);
  String get newPassword => 'newPassword'.localized(this);
  String get newRepeatPassword => 'newRepeatPassword'.localized(this);
  String get observations => 'observations'.localized(this);
  String get giveMoneyBack => 'giveMoneyBack'.localized(this);
  String get order => 'order'.localized(this);
  String get status => 'status'.localized(this);
  String get date => 'date'.localized(this);
  String get hour => 'hour'.localized(this);
  String get user => 'user'.localized(this);
  String get employees => 'employees'.localized(this);
  String get administrator => 'administrator'.localized(this);
  String get selectAccessLevel => 'selectAccessLevel'.localized(this);
  String get selectDeliveredLevel => 'selectDeliveredLevel'.localized(this);

  // Struct
  String get description => 'description'.localized(this);
  String get finalPrice => 'finalPrice'.localized(this);
  String get amount => 'amount'.localized(this);
  String get totalMoney => 'totalMoney'.localized(this);
  String get qtd => 'qtd'.localized(this);
  String get totalPrice => 'totalPrice'.localized(this);
  String get quantity => 'quantity'.localized(this);
  String get und => 'und'.localized(this);
  String get price => 'price'.localized(this);
  String get avaliableInMenu => 'avaliableInMenu'.localized(this);
  String get image => 'image'.localized(this);

  // Utils
  String get moneySymbol => 'moneySymbol'.localized(this);
  String get acess0 => 'acess0'.localized(this);
  String get acess1 => 'acess1'.localized(this);
  String get acess2 => 'acess2'.localized(this);

  // System Message Strings
  // Success
  String get registerSucess => 'registerSucess'.localized(this);
  String get productRegisterSucess => 'productRegisterSucess'.localized(this);
  String get updateSucess => 'updateSucess'.localized(this);
  String get addCartSucess => 'addCartSucess'.localized(this);
  String get sucessPurchase => 'sucessPurchase'.localized(this);
  String get deleteSucess => 'deleteSucess'.localized(this);

  // Error
  String get errorInvalidData => 'errorInvalidData'.localized(this);
  String get errorEmptyLogin => 'errorEmptyLogin'.localized(this);
  String get errorCreateAccount => 'errorCreateAccount'.localized(this);
  String get errorCreateAccount1 => 'errorCreateAccount1'.localized(this);
  String get errorServerDown => 'errorServerDown'.localized(this);
  String get errorLoadingProducts => 'errorLoadingProducts'.localized(this);
  String get errorLoadingUsers => 'errorLoadingUsers'.localized(this);
  String get errorUpdate => 'errorUpdate'.localized(this);
  String get errorUpdate2 => 'errorUpdate2'.localized(this);
  String get errorUpdate3 => 'errorUpdate3'.localized(this);
  String get errorConfirmPurchase => 'errorConfirmPurchase'.localized(this);
  String get errorPurshaceEmpty => 'errorPurshaceEmpty'.localized(this);
  String get errorConnectServer => 'errorConnectServer'.localized(this);
  String get errorInvalidAcess => 'errorInvalidAcess'.localized(this);

  // Validate
  String get validateUsername => 'validateUsername'.localized(this);
  String get validatePassword1 => 'validatePassword1'.localized(this);
  String get validatePassword2 => 'validatePassword2'.localized(this);
  String get validateName => 'validateName'.localized(this);
  String get validateEmail => 'validateEmail'.localized(this);
  String get validateAddress => 'validateAddress'.localized(this);
  String get validatePhone => 'validatePhone'.localized(this);

  // Struct
  String get underReview => _localizedValues[locale.languageCode]!['underReview']!;
  String get inPreparation => _localizedValues[locale.languageCode]!['inPreparation']!;
  String get onTheWay => _localizedValues[locale.languageCode]!['onTheWay']!;
  String get delivered => _localizedValues[locale.languageCode]!['delivered']!;
  String get canceled => _localizedValues[locale.languageCode]!['canceled']!;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, String>? getLocalizedValues(String languageCode) {
    return _localizedValues[languageCode];
  }

  String getLanguage() {
    if (locale.languageCode == 'pt') {
      return english;
    }
    return portuguese;
  }

  void changeLanguage() {
    if (locale.languageCode == 'en') {
      locale = const Locale('pt', 'BR');
    } else {
      locale = const Locale('en', 'US');
    }
  }
}
