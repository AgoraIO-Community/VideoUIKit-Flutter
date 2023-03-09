import 'package:agora_uikit/agora_uikit.dart';

class CloudStorageData {
  /// The Customer Key provided by Agora RESTful API
  final String customerKey;

  /// The Customer Secret provided by Agora RESTful API
  final String customerSecret;

  /// The which cloud storage provider is being used
  final CloudStorageProvider cloudStorageProvider;

  /// The bucket name for the cloud storage provider
  final String bucketName;

  /// The access key for the cloud storage provider
  final String accessKey;

  /// The secret key for the cloud storage provider
  final String secretKey;

  CloudStorageData({
    required this.customerKey,
    required this.customerSecret,
    required this.cloudStorageProvider,
    required this.bucketName,
    required this.accessKey,
    required this.secretKey,
  });
}
