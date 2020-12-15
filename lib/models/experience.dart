class Experience {
  final String jobTitle;
  final String company;
  final String date;
  final bool active;
  final String description;

  Experience({
    this.jobTitle,
    this.company,
    this.date,
    this.active,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'jobTitle': jobTitle,
      'company': company,
      'date': date,
      'active': active,
      'description': description,
    };
  }
}
