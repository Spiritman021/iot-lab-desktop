import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants.dart';
import '../../core/database/app_database.dart';
import '../../core/mqtt/mqtt_service.dart';
import '../layout/app_scaffold.dart';

/// Homepage — matches web app's Homepage.tsx with device cards grid
class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final AppDatabase _db = AppDatabase.instance;
  List<Device> _devices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    try {
      final devices = await _db.getAllDevices();
      if (mounted) {
        setState(() {
          _devices = devices;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqttService = AppScaffold.of(context).mqttService;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Dashboard',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Device cards grid
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _devices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.radio,
                                size: 48,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                            const SizedBox(height: 12),
                            Text(
                              'No devices added yet',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () =>
                                  context.go('/settings/devices'),
                              child: const Text('Add a device'),
                            ),
                          ],
                        ),
                      )
                    : ListenableBuilder(
                        listenable: mqttService,
                        builder: (context, _) {
                          final now =
                              DateTime.now().millisecondsSinceEpoch;
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              childAspectRatio: 1.4,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: _devices.length,
                            itemBuilder: (context, index) {
                              final device = _devices[index];
                              return _DeviceCard(
                                device: device,
                                mqttService: mqttService,
                                currentTimeMs: now,
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final Device device;
  final MqttService mqttService;
  final int currentTimeMs;

  const _DeviceCard({
    required this.device,
    required this.mqttService,
    required this.currentTimeMs,
  });

  @override
  Widget build(BuildContext context) {
    final deviceId = device.deviceId;
    final isOnline = getDeviceActiveStatus(
      mqttService.deviceStatus[deviceId],
      currentTimeMs,
    );

    final phVal = mqttService.deviceValues['/$deviceId/PH_VAL'] ?? '--';
    final tempVal = mqttService.deviceValues['/$deviceId/TEMP_VAL'] ?? '--';
    final battery = mqttService.deviceValues['/$deviceId/BATTERY'] ?? '--';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/dashboard/${device.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device ID + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      deviceId,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isOnline
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle,
                            size: 8,
                            color: isOnline ? Colors.green : Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          isOnline ? 'Online' : 'Offline',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color:
                                        isOnline ? Colors.green : Colors.red,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                device.type.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              // Values
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ValueChip(
                    icon: LucideIcons.gauge,
                    label: device.type == 'ph' ? 'pH' : 'EC',
                    value: phVal,
                  ),
                  _ValueChip(
                    icon: LucideIcons.thermometer,
                    label: '°C',
                    value: tempVal,
                  ),
                  _ValueChip(
                    icon: LucideIcons.battery,
                    label: '%',
                    value: battery,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ValueChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
