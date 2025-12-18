import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import 'patient_screen.dart';

class PatientNavigation extends StatelessWidget {
  final PatientScreen currentScreen;
  final Function(PatientScreen) onScreenChange;
  final Widget child;
  final String? userName;

  const PatientNavigation({
    super.key,
    required this.currentScreen,
    required this.onScreenChange,
    required this.child,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryDark,
                  AppTheme.primary,
                  Color(0xFFA855F7),
                ],
              ),
            ),
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 12,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'TéléMédecine',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (MediaQuery.of(context).size.width > 600) ...[
                  Text(
                    'Bienvenue, ${userName ?? "Utilisateur"}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white, size: 24),
                  onPressed: () => _handleLogout(context),
                  tooltip: 'Déconnexion',
                ),
              ],
            ),
          ),
          // Main content with sidebar
          Expanded(
            child: Row(
              children: [
                // Sidebar (only on larger screens)
                if (MediaQuery.of(context).size.width > 768)
                  _buildSidebar(context),
                // Main content
                Expanded(
                  child: Container(
                    color: AppTheme.background,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: _buildMobileDrawer(context),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: AppTheme.cardBg,
      child: Column(
        children: [
          const SizedBox(height: 24),
          ..._buildNavItems(context),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppTheme.cardBg,
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.primary],
                ),
              ),
              child: Center(
                child: Text(
                  'TéléMédecine',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ..._buildNavItems(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    final screens = [
      {
        'screen': PatientScreen.dashboard,
        'label': 'Accueil',
        'icon': Icons.home,
      },
      {
        'screen': PatientScreen.analysis,
        'label': 'Nouvelle analyse',
        'icon': Icons.search,
      },
      {
        'screen': PatientScreen.history,
        'label': 'Historique',
        'icon': Icons.history,
      },
      {
        'screen': PatientScreen.notifications,
        'label': 'Notifications',
        'icon': Icons.notifications,
      },
      {
        'screen': PatientScreen.profile,
        'label': 'Profil',
        'icon': Icons.person,
      },
    ];

    return screens.map((item) {
      final isActive = currentScreen == item['screen'];
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border(
                  left: BorderSide(
                    color: AppTheme.primary,
                    width: 4,
                  ),
                )
              : null,
        ),
        child: ListTile(
          leading: Icon(
            item['icon'] as IconData,
            color: isActive ? AppTheme.primaryDark : AppTheme.textSecondary,
          ),
          title: Text(
            item['label'] as String,
            style: TextStyle(
              color: isActive ? AppTheme.primaryDark : AppTheme.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          onTap: () {
            onScreenChange(item['screen'] as PatientScreen);
            if (Scaffold.of(context).hasDrawer) {
              Navigator.of(context).pop();
            }
          },
        ),
      );
    }).toList();
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final authService = AuthService();
      await authService.logout();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }
}

