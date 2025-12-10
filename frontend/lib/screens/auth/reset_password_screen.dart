import 'package:flutter/material.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_input.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

enum ResetStep { email, code, newPassword }

class ResetPasswordScreen extends StatefulWidget {
  final VoidCallback? onLoginTap;

  const ResetPasswordScreen({
    super.key,
    this.onLoginTap,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _authService = AuthService();
  ResetStep _currentStep = ResetStep.email;

  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  String? _email;
  String? _code;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailSubmit() async {
    if (_emailController.text.isEmpty) {
      setState(() => _error = 'Email est requis');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _authService.requestPasswordReset(_emailController.text.trim());
      setState(() {
        _email = _emailController.text.trim();
        _currentStep = ResetStep.code;
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCodeSubmit() async {
    if (_codeController.text.isEmpty) {
      setState(() => _error = 'Code est requis');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _authService.verifyCode(_email!, _codeController.text.trim());
      setState(() {
        _code = _codeController.text.trim();
        _currentStep = ResetStep.newPassword;
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePasswordReset() async {
    if (_newPasswordController.text.isEmpty) {
      setState(() => _error = 'Nouveau mot de passe est requis');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _error = 'Les mots de passe ne correspondent pas');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _authService.resetPassword(
        email: _email!,
        code: _code!,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mot de passe réinitialisé avec succès!'),
            backgroundColor: AppTheme.success,
          ),
        );

        if (widget.onLoginTap != null) {
          widget.onLoginTap!();
        } else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
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
                        '🔑',
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Title
                  const Text(
                    'Réinitialiser le mot de passe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),

                  // Step indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStepIndicator(1, ResetStep.email),
                      Container(
                        width: 40,
                        height: 2,
                        color: _currentStep.index > 0
                            ? AppTheme.primary
                            : AppTheme.textSecondary.withOpacity(0.3),
                      ),
                      _buildStepIndicator(2, ResetStep.code),
                      Container(
                        width: 40,
                        height: 2,
                        color: _currentStep.index > 1
                            ? AppTheme.primary
                            : AppTheme.textSecondary.withOpacity(0.3),
                      ),
                      _buildStepIndicator(3, ResetStep.newPassword),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Error message
                  if (_error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.error.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: AppTheme.error,
                          fontSize: 13,
                        ),
                      ),
                    ),

                  // Step content
                  if (_currentStep == ResetStep.email) _buildEmailStep(),
                  if (_currentStep == ResetStep.code) _buildCodeStep(),
                  if (_currentStep == ResetStep.newPassword) _buildNewPasswordStep(),

                  const SizedBox(height: 28),

                  // Back to login
                  TextButton(
                    onPressed: widget.onLoginTap ??
                        () => Navigator.of(context).pushReplacementNamed('/login'),
                    child: const Text('Retour à la connexion'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, ResetStep stepType) {
    final isActive = _currentStep.index >= step - 1;
    final isCompleted = _currentStep.index > step - 1;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppTheme.primary : AppTheme.textSecondary.withOpacity(0.3),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : Text(
                '$step',
                style: TextStyle(
                  color: isActive ? Colors.white : AppTheme.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildEmailStep() {
    return Column(
      children: [
        const Text(
          'Entrez votre adresse email pour recevoir un code de réinitialisation',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'ADRESSE EMAIL',
          hint: 'vous@exemple.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        AppButton(
          text: 'Envoyer le code',
          onPressed: _handleEmailSubmit,
          isLoading: _isLoading,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildCodeStep() {
    return Column(
      children: [
        Text(
          'Code envoyé à $_email',
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'CODE DE VÉRIFICATION',
          hint: 'Entrez le code',
          controller: _codeController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        AppButton(
          text: 'Vérifier le code',
          onPressed: _handleCodeSubmit,
          isLoading: _isLoading,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildNewPasswordStep() {
    return Column(
      children: [
        const Text(
          'Entrez votre nouveau mot de passe',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AppInput(
          label: 'NOUVEAU MOT DE PASSE',
          hint: '••••••••',
          controller: _newPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 18),
        AppInput(
          label: 'CONFIRMER LE MOT DE PASSE',
          hint: '••••••••',
          controller: _confirmPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 24),
        AppButton(
          text: 'Réinitialiser',
          onPressed: _handlePasswordReset,
          isLoading: _isLoading,
          width: double.infinity,
        ),
      ],
    );
  }
}



