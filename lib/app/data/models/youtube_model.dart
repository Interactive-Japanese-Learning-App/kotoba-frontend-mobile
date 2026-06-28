class YoutubeChannel {
  final String channelName;
  final int subscribers;
  final int totalViews;
  final int totalVideos;

  YoutubeChannel({
    required this.channelName,
    required this.subscribers,
    required this.totalViews,
    required this.totalVideos,
  });

  factory YoutubeChannel.fromJson(Map<String, dynamic> json) {
    return YoutubeChannel(
      channelName: json["channel_name"] ?? "",
      subscribers: json["subscribers"] ?? 0,
      totalViews: json["total_views"] ?? 0,
      totalVideos: json["total_videos"] ?? 0,
    );
  }
}