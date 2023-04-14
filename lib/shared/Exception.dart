class GeneralException implements Exception {
  final String title;
  final String message;

  GeneralException({required this.title, required this.message});
}
