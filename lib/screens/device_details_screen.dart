import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glossy/glossy.dart';
import 'package:intl/intl.dart';
import 'package:ewelink/models/device_model.dart';
import 'package:ewelink/providers/auth_provider.dart';
import 'package:ewelink/providers/device_provider.dart';
import 'package:ewelink/theme/app_theme.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final DeviceModel device;

  const DeviceDetailsScreen({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';

    // Handle both string and integer timestamps
    int timestampValue;
    if (timestamp is String) {
      timestampValue = int.tryParse(timestamp) ?? 0;
    } else if (timestamp is int) {
      timestampValue = timestamp;
    } else {
      return 'N/A';
    }

    if (timestampValue == 0) return 'N/A';

    final date = DateTime.fromMillisecondsSinceEpoch(timestampValue * 1000);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: [
          if (widget.device.params.containsKey('switch'))
            Switch(
              value: widget.device.isOn,
              activeColor: AppTheme.successColor,
              inactiveThumbColor: AppTheme.errorColor,
              onChanged: (value) {
                if (user != null) {
                  deviceProvider.toggleDevice(
                    user,
                    widget.device.deviceId,
                    value,
                  );
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Status Card
            GlossyContainer(
              width: double.infinity,
              height: 150,
              opacity: 0.2,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.device.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.device.brandName ?? 'Unknown'} ${widget.device.productModel ?? ''}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        if (widget.device.params.containsKey('switch'))
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: widget.device.isOn
                                  ? AppTheme.successColor.withOpacity(0.2)
                                  : AppTheme.errorColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  widget.device.isOn
                                      ? Icons.power_settings_new
                                      : Icons.power_off,
                                  color: widget.device.isOn
                                      ? AppTheme.successColor
                                      : AppTheme.errorColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.device.switchState,
                                  style: TextStyle(
                                    color: widget.device.isOn
                                        ? AppTheme.successColor
                                        : AppTheme.errorColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            context,
                            Icons.memory,
                            'Device ID',
                            widget.device.deviceId,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            context,
                            Icons.wifi,
                            'IP Address',
                            widget.device.ipAddress ?? 'N/A',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tabs
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Details'),
                Tab(text: 'JSON Data'),
              ],
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Details Tab
                  ListView(
                    padding: const EdgeInsets.only(top: 16),
                    children: [
                      _buildDetailItem('Name', widget.device.name),
                      _buildDetailItem(
                          'Brand', widget.device.brandName ?? 'Unknown'),
                      _buildDetailItem(
                          'Model', widget.device.productModel ?? 'Unknown'),
                      _buildDetailItem('Device ID', widget.device.deviceId),
                      _buildDetailItem(
                          'API Key', widget.device.deviceKey ?? 'N/A'),
                      _buildDetailItem(
                          'MAC Address', widget.device.macAddress ?? 'N/A'),
                      _buildDetailItem(
                          'Switch State', widget.device.switchState),
                      _buildDetailItem(
                          'IP Address', widget.device.ipAddress ?? 'N/A'),
                      _buildDetailItem('SSID', widget.device.ssid ?? 'N/A'),
                      _buildDetailItem('Firmware Version',
                          widget.device.firmwareVersion ?? 'N/A'),
                      _buildDetailItem('Created At',
                          _formatTimestamp(widget.device.createdAt)),
                      _buildDetailItem('Updated At',
                          _formatTimestamp(widget.device.updatedAt)),
                    ],
                  ),

                  // JSON Data Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _prettyJson(widget.device.toJson()),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accentColor),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: label == 'Switch State'
                    ? (value == 'ON'
                        ? AppTheme.successColor
                        : AppTheme.errorColor)
                    : AppTheme.textColor,
                fontWeight: label == 'Switch State'
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _prettyJson(Map<String, dynamic> json) {
    String result = '';
    int indent = 0;

    void addIndent() {
      for (int i = 0; i < indent; i++) {
        result += '  ';
      }
    }

    void processValue(dynamic value) {
      if (value is Map) {
        result += '{\n';
        indent++;

        int count = 0;
        value.forEach((k, v) {
          addIndent();
          result += '"$k": ';
          processValue(v);

          if (count < value.length - 1) {
            result += ',';
          }
          result += '\n';
          count++;
        });

        indent--;
        addIndent();
        result += '}';
      } else if (value is List) {
        result += '[\n';
        indent++;

        for (int i = 0; i < value.length; i++) {
          addIndent();
          processValue(value[i]);

          if (i < value.length - 1) {
            result += ',';
          }
          result += '\n';
        }

        indent--;
        addIndent();
        result += ']';
      } else if (value is String) {
        result += '"$value"';
      } else {
        result += value.toString();
      }
    }

    processValue(json);
    return result;
  }
}
