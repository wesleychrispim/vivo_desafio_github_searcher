class SearchFilter {
  final String? location;
  final int? minFollowers;
  final int? minRepositories;
  final String? language; // Novo campo

  const SearchFilter({
    this.location,
    this.minFollowers,
    this.minRepositories,
    this.language,
  });
}
