import 'package:flutter/material.dart';

const String BASE_URL = 'https://imaji.ngrok.dev';
const String BASE_URL_GENERATE = 'https://imaji.ngrok.dev';

class ApiEndpoints {
  static const login = '$BASE_URL/oauth/client/token';
  static const verifyIdentity = '$BASE_URL/auth/me';
  static const fetchGenVid = '$BASE_URL/videos/generated';
  static const fetchPreviewVid = '$BASE_URL/videos/preview';
  static const static = '$BASE_URL/static/';
  static const playbackGenerated = '$BASE_URL/videos/playback?id=';
  static const playbackTemplate = '$BASE_URL/videos/playback_template?avatar_id=';
  static const playbackAudio = '$BASE_URL/audio/playback';
  static const products = '$BASE_URL/products';
  static const avatars = '$BASE_URL/avatars';
  static const newMedia = '$BASE_URL/media_unit/new';
  static const fetchProfile = '$BASE_URL/user';
  static const generateAudio = '$BASE_URL_GENERATE/scripts/audio/generate';
  static const generateVideo = '$BASE_URL_GENERATE/scripts/video/generate';
  static const checkVRTProgress = '$BASE_URL_GENERATE/scripts/check_progress';
}