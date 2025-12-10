import 'package:flutter/material.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_input.dart';
import '../../widgets/common/app_card.dart';
import '../../models/profile.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const ProfileScreen({
    super.key,
    this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editMode = false;
  late UserProfile _profileData;
  late UserProfile _formData;

  @override
  void initState() {
    super.initState();
    // Mock profile data - in real app, fetch from service
    _profileData = UserProfile(
      userId: '1',
      firstName: 'Jean',
      lastName: 'Dupont',
      email: 'jean.dupont@example.com',
      phone: '+33 6 12 34 56 78',
      chronicDiseases: 'Asthme léger',
      allergies: 'Pénicilline',
      language: 'fr',
    );
    _formData = _profileData;
  }

  void _handleSave() {
    setState(() {
      _profileData = _formData;
      _editMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil mis à jour avec succès'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _handleCancel() {
    setState(() {
      _formData = _profileData;
      _editMode = false;
    });
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (widget.onLogout != null) {
                widget.onLogout!();
              }
            },
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Votre profil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 32),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppTheme.primary, AppTheme.accent],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _profileData.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _profileData.fullName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _profileData.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Personal Info
                  const Text(
                    'Informations personnelles',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppInput(
                          label: 'PRÉNOM',
                          controller: TextEditingController(text: _formData.firstName),
                          onChanged: (value) {
                            setState(() {
                              _formData = _formData.copyWith(firstName: value);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppInput(
                          label: 'NOM',
                          controller: TextEditingController(text: _formData.lastName),
                          onChanged: (value) {
                            setState(() {
                              _formData = _formData.copyWith(lastName: value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  AppInput(
                    label: 'EMAIL',
                    controller: TextEditingController(text: _formData.email),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        _formData = _formData.copyWith(email: value);
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  AppInput(
                    label: 'TÉLÉPHONE',
                    controller: TextEditingController(text: _formData.phone ?? ''),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      setState(() {
                        _formData = _formData.copyWith(phone: value);
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Medical Info
                  const Text(
                    'Informations médicales (optionnel)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppInput(
                    label: 'MALADIES CHRONIQUES',
                    hint: 'Ex: Asthme, Diabète...',
                    controller: TextEditingController(
                      text: _formData.chronicDiseases ?? '',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _formData = _formData.copyWith(chronicDiseases: value);
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  AppInput(
                    label: 'ALLERGIES',
                    hint: 'Ex: Pénicilline, Arachides...',
                    controller: TextEditingController(text: _formData.allergies ?? ''),
                    onChanged: (value) {
                      setState(() {
                        _formData = _formData.copyWith(allergies: value);
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    value: _formData.language,
                    decoration: const InputDecoration(
                      labelText: 'LANGUE PRÉFÉRÉE',
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'fr', child: Text('Français')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'es', child: Text('Español')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _formData = _formData.copyWith(language: value);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Actions
                  if (!_editMode)
                    Column(
                      children: [
                        AppButton(
                          text: '✎ Modifier mon profil',
                          onPressed: () => setState(() => _editMode = true),
                          width: double.infinity,
                        ),
                        const SizedBox(height: 12),
                        AppButton(
                          text: '🚪 Déconnexion',
                          onPressed: _handleLogout,
                          isPrimary: false,
                          width: double.infinity,
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: '✓ Enregistrer',
                            onPressed: _handleSave,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            text: '✕ Annuler',
                            onPressed: _handleCancel,
                            isPrimary: false,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



