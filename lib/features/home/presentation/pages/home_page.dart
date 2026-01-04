import 'package:flutter/material.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            // 0: Home (Dashboard)
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatusSection(context),
                  const SizedBox(height: 32),
                  _buildLivingAreasSection(context),
                  const SizedBox(height: 32),
                  _buildEntranceSection(context),
                ],
              ),
            ),
            // 1: Events (Placeholder)
            const Center(child: Text("Events")),
            // 2: Smart (Placeholder)
            const Center(child: Text("Smart")),
            // 3: Storage (Placeholder)
            const Center(child: Text("Storage")),
            // 4: Profile
            const ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context).translate('nav_home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: AppLocalizations.of(context).translate('nav_events'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.smart_toy),
            label: AppLocalizations.of(context).translate('nav_smart'),
          ), // Using smart_toy for generic smart icon
          BottomNavigationBarItem(
            icon: const Icon(Icons.cloud),
            label: AppLocalizations.of(context).translate('nav_storage'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context).translate('nav_profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.videocam, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate('my_home'),
                  style: AppTheme.headingMedium.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).translate('safety_first'),
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: const CircleBorder(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            context,
            icon: Icons.shield,
            iconColor: Colors.green,
            title: AppLocalizations.of(context).translate('status'),
            value: "Armed Away",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatusCard(
            context,
            icon: Icons.wifi,
            iconColor: Colors.blue,
            title: AppLocalizations.of(context).translate('online'),
            value: "3 Active",
          ),
        ),
      ],
    );
  }

  Widget _buildLivingAreasSection(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader(
          AppLocalizations.of(context).translate('living_areas'),
          "2",
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildCameraCard(
                context,
                name: "Living Room",
                status: "Online",
                battery: "92%",
                isLive: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCameraCard(
                context,
                name: "Kitchen",
                status: "Connecting...",
                isLoading: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEntranceSection(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader(
          AppLocalizations.of(context).translate('entrance_outdoor'),
          "2",
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildCameraCard(
                context,
                name: "Front Door",
                status: "2m ago",
                battery: "40%",
                isMotion: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCameraCard(
                context,
                name: "Backyard",
                status: "Check Network",
                isOffline: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String count) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Text(count, style: TextStyle(color: Colors.grey)),
        const Spacer(),
        const Icon(Icons.more_horiz, color: Colors.grey),
      ],
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
        // No shadow for deep grey theme
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraCard(
    BuildContext context, {
    required String name,
    required String status,
    String? battery,
    bool isLive = false,
    bool isLoading = false,
    bool isOffline = false,
    bool isMotion = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
        // No shadow for deep grey theme
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image/Preview Area
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              //  image: DecorationImage(image: NetworkImage("...")) // Placeholder
            ),
            child: Stack(
              children: [
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (isOffline)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, color: Colors.grey[400], size: 32),
                        const SizedBox(height: 4),
                        Text(
                          "OFFLINE",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  )
                else ...[
                  // Mock Image Content is mostly color for now
                ],

                if (isLive)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 8),
                          SizedBox(width: 4),
                          Text(
                            "LIVE",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (isMotion)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.motion_photos_on,
                            color: Colors.white,
                            size: 10,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "MOTION",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Details Area
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (battery != null) ...[
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color:
                              (int.tryParse(battery.replaceAll('%', '')) ?? 0) >
                                  20
                              ? Colors.green.withOpacity(0.15)
                              : Colors.orange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              (int.tryParse(battery.replaceAll('%', '')) ?? 0) >
                                      20
                                  ? Icons.battery_full
                                  : Icons.battery_alert,
                              size: 12,
                              color:
                                  (int.tryParse(battery.replaceAll('%', '')) ??
                                          0) >
                                      20
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              battery,
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    (int.tryParse(
                                              battery.replaceAll('%', ''),
                                            ) ??
                                            0) >
                                        20
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: isOffline ? Colors.red : Colors.grey,
                      ),
                    ),
                    if (!isLoading && !isOffline)
                      const Row(
                        children: [
                          Icon(Icons.mic, size: 16, color: Colors.grey),
                          SizedBox(width: 8),
                          Icon(Icons.history, size: 16, color: Colors.grey),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
