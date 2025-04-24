class DeviceModel {
  final String deviceId;
  final String name;
  final String? brandName;
  final String? productModel;
  final Map<String, dynamic> params;
  final String? deviceKey;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int? uiid;

  DeviceModel({
    required this.deviceId,
    required this.name,
    this.brandName,
    this.productModel,
    required this.params,
    this.deviceKey,
    this.createdAt,
    this.updatedAt,
    this.uiid,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceId: json['deviceid'] ?? '',
      name: json['name'] ?? 'Unknown Device',
      brandName: json['brandName'],
      productModel: json['productModel'],
      params: json['params'] ?? {},
      deviceKey: json['apikey'],
      createdAt: json['createdAt'],
      updatedAt: json['updateAt'],
      uiid: json['extra']?['extra']?['uiid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceid': deviceId,
      'name': name,
      'brandName': brandName,
      'productModel': productModel,
      'params': params,
      'apikey': deviceKey,
      'createdAt': createdAt,
      'updateAt': updatedAt,
    };
  }

  bool get isOn {
    if (uiid == 138) {
      // Multi-switch device (like Bedroom light)
      final switches = params['switches'] as List?;
      if (switches != null && switches.isNotEmpty) {
        return switches.any((s) => s['switch'] == 'on');
      }
      return false;
    } else {
      // Single switch device
      return params['switch'] == 'on';
    }
  }

  String get switchState => isOn ? 'ON' : 'OFF';

  String? get ipAddress => params['ip'];

  String? get macAddress => params['staMac'];

  String? get ssid => params['ssid'];

  String? get firmwareVersion => params['fwVersion'];

  bool get hasSwitch {
    if (uiid == 138) {
      return params['switches'] != null;
    } else {
      return params.containsKey('switch');
    }
  }
}
