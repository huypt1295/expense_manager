class ExpenseConstants {
  // Image processing settings
  static const int imageQuality = 80;
  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;

  // Processing delays
  static const Duration aiProcessingDelay = Duration(seconds: 2);
  static const Duration snackBarDuration = Duration(seconds: 3);

  // Colors
  static const int primaryColor = 0xFF667eea;
  static const int secondaryColor = 0xFF764ba2;

  // Messages
  static const String processingMessage = 'Processing image with AI...';
  static const String successMessage =
      '✅ AI extracted expense details successfully!';
  static const String cameraErrorMessage = 'Failed to access camera';
  static const String galleryErrorMessage = 'Failed to access gallery';
}
