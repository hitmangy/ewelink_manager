import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:ewelink/models/user_model.dart';
import 'package:ewelink/models/device_model.dart';

class ApiService {
  static const String appId = 'R8Oq3y0eSZSYdKccHlrQzT1ACCOUT9Gv';
  static const String appSecret = '1ve5Qk9GXfUhKAn1svnKwpAlxXkMarru';

  // Create a signature for authentication
  Map<String, dynamic> _createSignature(String email, String password) {
    final String nonce = _generateRandomString(8);
    final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final String imei = const Uuid().v4();

    final Map<String, dynamic> payload = {
      'email': email,
      'password': password,
      'version': '6',
      'ts': timestamp,
      'nonce': nonce,
      'appid': appId,
      'imei': imei,
      'os': 'iOS',
      'model': 'iPhone11,8',
      'romVersion': '13.2',
      'appVersion': '3.11.0'
    };

    final String jsonPayload = jsonEncode(payload);
    final List<int> key = utf8.encode(appSecret);
    final List<int> bytes = utf8.encode(jsonPayload);
    final Hmac hmac = Hmac(sha256, key);
    final Digest digest = hmac.convert(bytes);
    final String signature = base64.encode(digest.bytes);

    return {
      'signature': signature,
      'payload': payload,
      'imei': imei,
    };
  }

  // Generate random string for nonce
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(List.generate(
        length, (index) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  // Login to eWelink API
  Future<Map<String, dynamic>> login(String email, String password,
      [String? initialRegion]) async {
    String apiRegion = initialRegion ?? 'us';
    final signatureData = _createSignature(email, password);
    final signature = signatureData['signature'];
    final payload = signatureData['payload'];
    final imei = signatureData['imei'];

    final headers = {
      'Authorization': 'Sign $signature',
      'Content-Type': 'application/json;charset=UTF-8',
    };

    try {
      final response = await http.post(
        Uri.parse('https://$apiRegion-api.coolkit.cc:8080/api/user/login'),
        headers: headers,
        body: jsonEncode(payload),
      );

      final responseData = jsonDecode(response.body);

      // Handle region redirect
      if (responseData['error'] == 301 && responseData['region'] != null) {
        print('Redirecting to region: ${responseData['region']}');
        return login(email, password, responseData['region']);
      }

      if (response.statusCode != 200 ||
          (responseData['error'] != null && responseData['error'] != 0)) {
        return {
          'success': false,
          'message':
              'Login failed: ${responseData['error'] ?? 'Unknown error'}',
        };
      }

      return {
        'success': true,
        'data': responseData,
        'region': apiRegion,
        'imei': imei,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // List devices
  Future<List<DeviceModel>> listDevices(UserModel user) async {
    final String nonce = _generateRandomString(8);
    final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final headers = {
      'Authorization': 'Bearer ${user.at}',
      'Content-Type': 'application/json;charset=UTF-8',
    };

    final url =
        Uri.parse('https://${user.region}-api.coolkit.cc:8080/api/user/device'
            '?lang=en'
            '&apiKey=${user.apiKey}'
            '&getTags=1'
            '&version=8'
            '&ts=$timestamp'
            '&nonce=$nonce'
            '&appid=$appId'
            '&imei=${user.imei}'
            '&os=iOS'
            '&model=iPhone10,6'
            '&romVersion=11.1.2'
            '&appVersion=3.5.3');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode != 200) {
        print('API Error Response: ${response.body}');
        throw Exception('Failed to load devices: ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      print('API Response: $responseData');

      if (responseData['error'] != null && responseData['error'] != 0) {
        throw Exception('API error: ${responseData['error']}');
      }

      final List<dynamic> deviceList = responseData['devicelist'] ?? [];
      return deviceList.map((device) => DeviceModel.fromJson(device)).toList();
    } catch (e) {
      print('Error fetching devices: $e');
      throw Exception('Failed to load devices: $e');
    }
  }

  // Toggle device state
  Future<bool> toggleDevice(
      UserModel user, String deviceId, bool newState) async {
    final headers = {
      'Authorization': 'Bearer ${user.at}',
      'Content-Type': 'application/json;charset=UTF-8',
    };

    final payload = {
      'deviceid': deviceId,
      'params': {
        'switch': newState ? 'on' : 'off',
      },
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://${user.region}-api.coolkit.cc:8080/api/user/device/status'),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        return false;
      }

      final responseData = jsonDecode(response.body);
      return responseData['error'] == 0;
    } catch (e) {
      return false;
    }
  }
}
