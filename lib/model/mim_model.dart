class MimModel {
  MimModel({
    required this.success,
    required this.data,
  });

  bool success;
  Data data;

  factory MimModel.fromJson(Map<String, dynamic> json) => MimModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.memes,
  });

  List<Meme> memes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        memes: List<Meme>.from(json["memes"].map((x) => Meme.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "memes": List<dynamic>.from(memes.map((x) => x.toJson())),
      };
}

class Meme {
  Meme({
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
    required this.boxCount,
    required this.captions,
  });

  String id;
  String name;
  String url;
  int width;
  int height;
  int boxCount;
  int captions;

  factory Meme.fromJson(Map<String, dynamic> json) => Meme(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        width: json["width"],
        height: json["height"],
        boxCount: json["box_count"],
        captions: json["captions"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "width": width,
        "height": height,
        "box_count": boxCount,
        "captions": captions,
      };
}
