class Education {
  final String title;
  final String institute;
  final String date;
  final bool active;
  final String description;

  Education({
    this.title,
    this.institute,
    this.date,
    this.active,
    this.description,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'institute': institute,
      'date': date,
      'active': active,
      'description': description,
    };
  }
}
