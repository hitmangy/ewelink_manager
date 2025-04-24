import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:ewelink/models/device_model.dart';
import 'package:ewelink/models/user_model.dart';
import 'package:ewelink/services/api_service.dart';

class DeviceProvider with ChangeNotifier {
  List<DeviceModel> _devices = [];
  List<DeviceModel> _filteredDevices = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<DeviceModel> get devices => _devices;
  List<DeviceModel> get filteredDevices => _filteredDevices;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  final ApiService _apiService = ApiService();

  Future<void> fetchDevices(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final devices = await _apiService.listDevices(user);
      _devices = devices;
      _applyFilter();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load devices: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleDevice(
      UserModel user, String deviceId, bool newState) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _apiService.toggleDevice(user, deviceId, newState);

      if (success) {
        // Update device in the list
        final index =
            _devices.indexWhere((device) => device.deviceId == deviceId);
        if (index != -1) {
          final device = _devices[index];
          final updatedParams = Map<String, dynamic>.from(device.params);
          updatedParams['switch'] = newState ? 'on' : 'off';

          _devices[index] = DeviceModel(
            deviceId: device.deviceId,
            name: device.name,
            brandName: device.brandName,
            productModel: device.productModel,
            params: updatedParams,
            deviceKey: device.deviceKey,
            createdAt: device.createdAt,
            updatedAt: device.updatedAt,
          );

          _applyFilter();
        }
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = 'Failed to toggle device: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredDevices = List.from(_devices);
    } else {
      _filteredDevices = _devices.where((device) {
        final searchLower = _searchQuery.toLowerCase();
        return device.name.toLowerCase().contains(searchLower) ||
            (device.brandName?.toLowerCase().contains(searchLower) ?? false) ||
            (device.productModel?.toLowerCase().contains(searchLower) ??
                false) ||
            device.deviceId.toLowerCase().contains(searchLower);
      }).toList();
    }
  }

  Future<String?> exportToJson() async {
    if (_devices.isEmpty) {
      return null;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'ewelink_devices_$timestamp.json';
      final file = File('${directory.path}/$fileName');

      final devicesJson = _devices.map((device) => device.toJson()).toList();
      await file.writeAsString(jsonEncode(devicesJson));

      return file.path;
    } catch (e) {
      _error = 'Failed to export devices: $e';
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
