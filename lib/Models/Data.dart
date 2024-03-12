class Data {
  final int id;
  final String title;
  final String? body;

  Data({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,

  };

  static List<Data> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((dataJson) {
      if (dataJson is Map<String, dynamic>) {
        return Data.fromJson(dataJson);
      } else {
        // Handle the case where the data is not in the expected format
        return Data(
          id: -1, // Provide a default value or handle accordingly
          title: "Unknown",
          body: null,
        );
      }
    }).toList();
  }
}