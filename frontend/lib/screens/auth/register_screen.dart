import 'package:flutter/material.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_input.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onLoginTap;
  final Function()? onRegisterSuccess;

  const RegisterScreen({
    super.key,
    this.onLoginTap,
    this.onRegisterSuccess,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  Map<String, String> _errors = {};

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _errors = {};
    });

    if (_firstNameController.text.trim().isEmpty) {
      _errors['firstName'] = 'Prénom est requis';
    }

    if (_lastNameController.text.trim().isEmpty) {
      _errors['lastName'] = 'Nom est requis';
    }

    if (_emailController.text.isEmpty) {
      _errors['email'] = 'Email est requis';
    } else if (!_emailController.text.contains('@')) {
      _errors['email'] = 'Email invalide';
    }

    if (_passwordController.text.isEmpty) {
      _errors['password'] = 'Mot de passe est requis';
    } else if (_passwordController.text.length < 8) {
      _errors['password'] = 'Le mot de passe doit contenir au moins 8 caractères';
    } else if (!RegExp(r'[A-Z]').hasMatch(_passwordController.text) ||
        !RegExp(r'[0-9]').hasMatch(_passwordController.text)) {
      _errors['password'] = 'Au moins 1 majuscule et 1 chiffre requis';
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _errors['confirmPassword'] = 'Les mots de passe ne correspondent pas';
    }
  }

  Future<void> _handleRegister() async {
    _validateForm();

    if (_errors.isNotEmpty) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inscription réussie!'),
            backgroundColor: AppTheme.success,
          ),
        );

        if (widget.onRegisterSuccess != null) {
          widget.onRegisterSuccess!();
        } else if (widget.onLoginTap != null) {
          widget.onLoginTap!();
        } else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF9F5FF),
              Color(0xFFF3EDFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primary.withOpacity(0.22),
                            AppTheme.accent.withOpacity(0.26),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '🏥',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Title
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppTheme.primaryDark, AppTheme.accent],
                      ).createShader(bounds),
                      child: const Text(
                        'TéleMédecine',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Créer un nouveau compte',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Name fields
                    Row(
                      children: [
                        Expanded(
                          child: AppInput(
                            label: 'PRÉNOM',
                            hint: 'Jean',
                            controller: _firstNameController,
                            errorText: _errors['firstName'],
                            onChanged: (value) {
                              if (_errors['firstName'] != null) {
                                setState(() => _errors.remove('firstName'));
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppInput(
                            label: 'NOM',
                            hint: 'Dupont',
                            controller: _lastNameController,
                            errorText: _errors['lastName'],
                            onChanged: (value) {
                              if (_errors['lastName'] != null) {
                                setState(() => _errors.remove('lastName'));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Email input
                    AppInput(
                      label: 'ADRESSE EMAIL',
                      hint: 'vous@exemple.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _errors['email'],
                      onChanged: (value) {
                        if (_errors['email'] != null) {
                          setState(() => _errors.remove('email'));
                        }
                      },
                    ),
                    const SizedBox(height: 18),

                    // Password input
                    AppInput(
                      label: 'MOT DE PASSE',
                      hint: '••••••••',
                      controller: _passwordController,
                      obscureText: true,
                      errorText: _errors['password'],
                      onChanged: (value) {
                        if (_errors['password'] != null) {
                          setState(() => _errors.remove('password'));
                        }
                      },
                    ),
                    const SizedBox(height: 18),

                    // Confirm Password input
                    AppInput(
                      label: 'CONFIRMER MOT DE PASSE',
                      hint: '••••••••',
                      controller: _confirmPasswordController,
                      obscureText: true,
                      errorText: _errors['confirmPassword'],
                      onChanged: (value) {
                        if (_errors['confirmPassword'] != null) {
                          setState(() => _errors.remove('confirmPassword'));
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Register button
                    AppButton(
                      text: _isLoading ? 'Création...' : 'Créer un compte',
                      onPressed: _handleRegister,
                      isLoading: _isLoading,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 28),

                    // Footer link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Vous avez déjà un compte ? ',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                        TextButton(
                          onPressed: widget.onLoginTap ??
                              () => Navigator.of(context).pushReplacementNamed('/login'),
                          child: const Text('Se connecter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



