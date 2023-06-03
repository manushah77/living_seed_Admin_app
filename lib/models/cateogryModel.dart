class CategoryModel {
  String? addedBy;
  String? categoryName;
  bool? isSelected;
  String? id;

  CategoryModel({required this.addedBy, required this.categoryName, this.isSelected, required this.id});

  CategoryModel.fromMap(Map<String, dynamic> map) {
    addedBy = map['Added By'];
    categoryName = map['Category'];
    id = map['id'];
  }
}
