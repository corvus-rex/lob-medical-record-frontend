import 'package:flutter/material.dart';

const String BASE_URL = 'http://localhost:8000';

class ApiEndpoints {
  static const login = '$BASE_URL/oauth/client/token';
  static const me = '$BASE_URL/auth/me';
}