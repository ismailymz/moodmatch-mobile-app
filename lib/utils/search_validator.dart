String? validateSearchQuery(String? value) {
  final query = value?.trim() ?? '';

  if (query.isEmpty) {
    return 'Search cannot be empty';
  }

  if (query.length < 2) {
    return 'Search must be at least 2 characters';
  }

  return null;
}
