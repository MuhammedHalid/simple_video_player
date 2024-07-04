class Video {
  final String name;
  final String url;
  final String thumbnail;

  Video({
    required this.name,
    required this.url,
    required this.thumbnail,
  });
}

final videos = [
  
  Video(
    name: "Big Buck Bunny",
    url:
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    thumbnail:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Big_Buck_Bunny_thumbnail_vlc.png/1200px-Big_Buck_Bunny_thumbnail_vlc.png",
  ),
  Video(
    name: "The first Blender ",
    url:
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    thumbnail: "https://i.ytimg.com/vi_webp/gWw23EYM9VM/maxresdefault.webp",
  ),
];
