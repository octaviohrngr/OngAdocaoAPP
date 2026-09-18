import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

/// Tela 2: login.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = const AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isLoading = false;

  late final TapGestureRecognizer _signupRecognizer;

  @override
  void initState() {
    super.initState();
    _signupRecognizer = TapGestureRecognizer()..onTap = _goToSignup;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    _signupRecognizer.dispose();
    super.dispose();
  }

  void _goToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  Future<void> _submit() async {
    // Fecha o teclado antes de validar.
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await _auth.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      // Substitui toda a pilha: não faz sentido voltar ao login pelo botão físico.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.accentGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.pets, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Bem-vindo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Acesse sua conta para continuar ajudando nossos amigos pets.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.4),
                ),
                const SizedBox(height: 28),
                const FieldLabel('E-mail', bold: false),
                AppTextField(
                  controller: _emailController,
                  hint: 'Seu e-mail',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  enabled: !_isLoading,
                  onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                const SizedBox(height: 18),
                const FieldLabel('Senha', bold: false),
                AppTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  hint: 'Sua senha',
                  icon: Icons.lock_outline,
                  obscure: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: Validators.password,
                  enabled: !_isLoading,
                  onFieldSubmitted: (_) => _submit(),
                  suffix: PasswordToggle(
                    obscured: _obscurePassword,
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading ? null : () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Esqueci minha senha',
                      style: TextStyle(color: AppColors.accentGreen, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Entrar',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.divider)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'ou continue com',
                        style: TextStyle(fontSize: 12, color: AppColors.textGray),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),
                const SizedBox(height: 18),
                SocialButton(
                  label: 'Entrar com Google',
                  icon: Icons.person_outline,
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                SocialButton(
                  label: 'Entrar com Facebook',
                  icon: Icons.public,
                  onPressed: () {},
                ),
                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Não tem uma conta? ',
                      style: const TextStyle(color: AppColors.textDark, fontSize: 13),
                      children: [
                        TextSpan(
                          text: 'Cadastre-se',
                          style: const TextStyle(
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: _signupRecognizer,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
