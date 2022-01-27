class Constants {
  // errors
  static Map<String, String> errorMessages = {
    'default': "An error has occurred. Please try again later",
  };

  //order statuses
  static Map<int, String> orderStatus = {
    1: 'PENDING',
    2: 'COMPLETE',
    3: 'EXPIRED',
  };

  //order expiration period
  static double expirationPeriod = 60.0;
}
