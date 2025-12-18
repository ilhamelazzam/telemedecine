import 'package:flutter/material.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_input.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onRegisterTap;
  final VoidCallback? onResetPasswordTap;
  final Function(User)? onLoginSuccess;

  const LoginScreen({
    super.key,
    this.onRegisterTap,
    this.onResetPasswordTap,
    this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'Email est requis');
      return;
    }

    if (!_emailController.text.contains('@')) {
      setState(() => _emailError = 'Email invalide');
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Mot de passe est requis');
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() => _passwordError = 'Le mot de passe doit contenir au moins 6 caractères');
      return;
    }
  }

  Future<void> _handleLogin() async {
    _validateForm();

    if (_emailError != null || _passwordError != null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (widget.onLoginSuccess != null) {
          widget.onLoginSuccess!(user);
        } else {
          Navigator.of(context).pushReplacementNamed('/patient');
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
                        'TeleMedecine',
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
                      'Connexion à votre compte',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Email input
                    AppInput(
                      label: 'ADRESSE EMAIL',
                      hint: 'vous@exemple.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                      onChanged: (value) {
                        if (_emailError != null) {
                          setState(() => _emailError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 18),

                    // Password input
                    AppInput(
                      label: 'MOT DE PASSE',
                      hint: '********',
                      controller: _passwordController,
                      obscureText: true,
                      errorText: _passwordError,
                      onChanged: (value) {
                        if (_passwordError != null) {
                          setState(() => _passwordError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    AppButton(
                      text: _isLoading ? 'Connexion...' : 'Se connecter',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 28),

                    // Footer links
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TextButton(
                          onPressed: widget.onResetPasswordTap ??
                              () => Navigator.of(context).pushNamed('/reset-password'),
                          child: const Text('Mot de passe oublié ?'),
                        ),
                        const Text(' • ', style: TextStyle(color: AppTheme.textSecondary)),
                        TextButton(
                          onPressed: widget.onRegisterTap ??
                              () => Navigator.of(context).pushNamed('/register'),
                          child: const Text('Créer un compte'),
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

