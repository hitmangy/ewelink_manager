import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ewelink/providers/auth_provider.dart';
import 'package:ewelink/providers/device_provider.dart';
import 'package:ewelink/screens/login_screen.dart';
import 'package:ewelink/screens/device_details_screen.dart';
import 'package:ewelink/screens/about_screen.dart';
import 'package:ewelink/widgets/device_card.dart';
import 'package:ewelink/widgets/animated_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch devices when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null) {
        Provider.of<DeviceProvider>(context, listen: false).fetchDevices(user);
      }
    });

    // Listen to search changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<DeviceProvider>(context, listen: false)
        .setSearchQuery(_searchController.text);
  }

  Future<void> _refreshDevices() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      await Provider.of<DeviceProvider>(context, listen: false)
          .fetchDevices(user);
    }
  }

  void _showExportDialog(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Successful'),
        content: Text('Devices exported to:\n$filePath'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportDevices() async {
    final filePath = await Provider.of<DeviceProvider>(context, listen: false)
        .exportToJson();
    if (filePath != null && mounted) {
      _showExportDialog(context, filePath);
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'eWelink Manager',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            if (user != null)
                              Text(
                                'Logged in as: ${user.email}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: _confirmLogout,
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Devices', icon: Icon(Icons.devices)),
                    Tab(text: 'About', icon: Icon(Icons.info_outline)),
                  ],
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Devices Tab
                      Column(
                        children: [
                          // Search and Actions Bar
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                      hintText: 'Search devices...',
                                      prefixIcon: Icon(Icons.search),
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: _refreshDevices,
                                  tooltip: 'Refresh',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.save_alt),
                                  onPressed: _exportDevices,
                                  tooltip: 'Export',
                                ),
                              ],
                            ),
                          ),

                          // Device List
                          Expanded(
                            child: deviceProvider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : deviceProvider.filteredDevices.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.devices_other,
                                              size: 64,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              deviceProvider.devices.isEmpty
                                                  ? 'No devices found'
                                                  : 'No devices match your search',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ],
                                        ),
                                      )
                                    : RefreshIndicator(
                                        onRefresh: _refreshDevices,
                                        child: ListView.builder(
                                          padding: const EdgeInsets.all(16),
                                          itemCount: deviceProvider
                                              .filteredDevices.length,
                                          itemBuilder: (context, index) {
                                            final device = deviceProvider
                                                .filteredDevices[index];
                                            return DeviceCard(
                                              device: device,
                                              onToggle: (newState) {
                                                if (user != null) {
                                                  deviceProvider.toggleDevice(
                                                    user,
                                                    device.deviceId,
                                                    newState,
                                                  );
                                                }
                                              },
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DeviceDetailsScreen(
                                                            device: device),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                          ),
                        ],
                      ),

                      // About Tab
                      const AboutScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
