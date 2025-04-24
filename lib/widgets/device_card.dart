import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';
import 'package:ewelink/models/device_model.dart';
import 'package:ewelink/theme/app_theme.dart';

class DeviceCard extends StatelessWidget {
  final DeviceModel device;
  final Function(bool) onToggle;
  final VoidCallback onTap;

  const DeviceCard({
    Key? key,
    required this.device,
    required this.onToggle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasSwitch = device.hasSwitch;
    final isOn = device.isOn;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: GlossyContainer(
          width: double.infinity,
          height: 120,
          opacity: 0.2,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Status indicator
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: hasSwitch
                            ? (isOn
                                ? AppTheme.successColor
                                : AppTheme.errorColor)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Device info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (device.brandName != null ||
                              device.productModel != null)
                            Text(
                              '${device.brandName ?? ''} ${device.productModel ?? ''}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.secondaryTextColor,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Toggle button
                    if (hasSwitch)
                      Switch(
                        value: isOn,
                        activeColor: AppTheme.successColor,
                        inactiveThumbColor: AppTheme.errorColor,
                        onChanged: onToggle,
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Additional info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(
                      context,
                      Icons.memory,
                      'ID',
                      device.deviceId.substring(0, 8) + '...',
                    ),
                    if (device.ipAddress != null)
                      _buildInfoItem(
                        context,
                        Icons.wifi,
                        'IP',
                        device.ipAddress!,
                      ),
                    if (hasSwitch)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOn
                              ? AppTheme.successColor.withOpacity(0.2)
                              : AppTheme.errorColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isOn ? 'ON' : 'OFF',
                          style: TextStyle(
                            color: isOn
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppTheme.secondaryTextColor,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
