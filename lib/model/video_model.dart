class VideoModel {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String videoUrl;

  VideoModel(
      {required this.id,
      required this.name,
      required this.thumbnailUrl,
      required this.videoUrl});


}
 List<VideoModel> videoList = [
   VideoModel(
   id: "3",
   name: "Big Buck Bunny",
   videoUrl:
   "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
   thumbnailUrl:
   "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg",
 ),
  VideoModel(
    id: "2",
    name: "Elephant Dream",
    videoUrl:
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    thumbnailUrl:
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg",
  ),

  VideoModel(
      id: "4",
      name: "For Bigger Blazes",
      videoUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      thumbnailUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg"),
  VideoModel(
      id: "5",
      name: "For Bigger Escape",
      videoUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      thumbnailUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg"),
  VideoModel(
      id: "6",
      name: "For Bigger Fun",
      videoUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      thumbnailUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerFun.jpg"),
  VideoModel(
      id: "7",
      name: "For Bigger Joyrides",
      videoUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
      thumbnailUrl:
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg"),
];