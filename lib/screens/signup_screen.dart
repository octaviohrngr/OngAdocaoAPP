import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../utils/phone_input_formatter.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

/// Tela 3: criação de conta.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = const AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _termsError = false;
  bool _isLoading = false;

  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;
  late final TapGestureRecognizer _loginRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = () {};
    _privacyRecognizer = TapGestureRecognizer()..onTap = () {};
    _loginRecognizer = TapGestureRecognizer()..onTap = () => Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _loginRecognizer.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final formOk = _formKey.currentState?.validate() ?? false;
    setState(() => _termsError = !_acceptedTerms);

    if (!formOk || !_acceptedTerms) return;

    setState(() => _isLoading = true);

    try {
      await _auth.signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      // Volta ao login para o usuário entrar com a conta recém-criada.
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Conta criada! Faça login para continuar.')),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets, color: AppColors.primaryGreen, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'Atipattas',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, color: AppColors.divider),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Criar uma conta',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Junte-se à nossa comunidade e ajude a encontrar lares amorosos.',
                        style: TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      const FieldLabel('Nome Completo'),
                      AppTextField(
                        controller: _nameController,
                        hint: 'Seu nome completo',
                        icon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        validator: Validators.fullName,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel('E-mail'),
                      AppTextField(
                        controller: _emailController,
                        hint: 'seu.email@exemplo.com',
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.email,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel('Telefone'),
                      AppTextField(
                        controller: _phoneController,
                        hint: '(00) 00000-0000',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [PhoneInputFormatter()],
                        validator: Validators.phone,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel('Senha'),
                      AppTextField(
                        controller: _passwordController,
                        hint: '',
                        icon: Icons.lock_outline,
                        obscure: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        validator: Validators.password,
                        enabled: !_isLoading,
                        suffix: PasswordToggle(
                          obscured: _obscurePassword,
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel('Confirmar Senha'),
                      AppTextField(
                        controller: _confirmPasswordController,
                        hint: '',
                        icon: Icons.lock_outline,
                        obscure: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        validator: (value) => Validators.confirmPassword(
                          value,
                          _passwordController.text,
                        ),
                        enabled: !_isLoading,
                        onFieldSubmitted: (_) => _submit(),
                        suffix: PasswordToggle(
                          obscured: _obscureConfirmPassword,
                          onPressed: () => setState(
                            () => _obscureConfirmPassword = !_obscureConfirmPassword,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildTermsRow(context),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'CRIAR CONTA',
                        labelStyle: PrimaryButton.uppercaseLabelStyle,
                        isLoading: _isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Já tem uma conta? ',
                            style: const TextStyle(color: AppColors.textDark, fontSize: 13),
                            children: [
                              TextSpan(
                                text: 'Fazer login',
                                style: const TextStyle(
                                  color: AppColors.accentGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: _loginRecognizer,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsRow(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: _acceptedTerms,
                activeColor: AppColors.primaryGreen,
                isError: _termsError,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: _isLoading
                    ? null
                    : (value) => setState(() {
                          _acceptedTerms = value ?? false;
                          if (_acceptedTerms) _termsError = false;
                        }),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4),
                  children: [
                    const TextSpan(text: 'Aceito os '),
                    TextSpan(
                      text: 'Termos de Uso',
                      style: const TextStyle(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: _termsRecognizer,
                    ),
                    const TextSpan(text: ' e '),
                    TextSpan(
                      text: 'Política de Privacidade',
                      style: const TextStyle(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: _privacyRecognizer,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_termsError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 32),
            child: Text(
              'É necessário aceitar os termos para continuar',
              style: TextStyle(color: errorColor, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
