

extension NumExtension on num {
  String toPriceFormat() {
   // return "${isCurrencyPositionLeft ? appConfigurationStore.currencySymbol : ''}${this.toStringAsFixed(appConfigurationStore.priceDecimalPoint).formatNumberWithComma()}${isCurrencyPositionRight ? appConfigurationStore.currencySymbol : ''}";
    return "";
  }
}
