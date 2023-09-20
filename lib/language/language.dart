class Language {
  final int id;
  final String flag;
  final String name;
  final String language_code;

  Language(this.id, this.flag, this.name, this.language_code);

  static List<Language> language_list() {
    return <Language>[
      Language(1, "🇻🇳", "Vietnamese", "vi"),
      Language(2, "🇬🇧", "English", "en")
    ];
  }
}
