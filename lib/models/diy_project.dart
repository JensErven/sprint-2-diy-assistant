class DiyProject {
  String title;
  String description;
  List<String> materials;
  List<String> instructions;
  String imageUrl;
  String craftingTimeInMinute;
  String ageGroup;

  DiyProject(
      {required this.title,
      required this.description,
      required this.materials,
      required this.instructions,
      required this.imageUrl,
      required this.craftingTimeInMinute,
      required this.ageGroup});
}
