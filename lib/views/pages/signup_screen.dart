import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../viewmodels/signup_view_model.dart';
import 'package:ong_adocao_app/views/theme/app_colors.dart';
import '../../utils/phone_input_formatter.dart';
import '../../utils/validators.dart';
import '../../views/widgets/app_text_field.dart';
import '../../views/widgets/primary_button.dart';




class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final SignupViewModel _viewModel = SignupViewModel();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();



  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;
  late final TapGestureRecognizer _loginRecognizer;

  @override
  void initState() {
    super.initState();

    _viewModel.addListener(_atualizarTela);

    _termsRecognizer = TapGestureRecognizer()..onTap = () {};
    _privacyRecognizer = TapGestureRecognizer()..onTap = () {};
    _loginRecognizer = TapGestureRecognizer()
      ..onTap = () => Navigator.of(context).pop();
  }

  void _atualizarTela() {
    if (mounted) {
      setState(() {});
    }
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


    _viewModel.removeListener(_atualizarTela);
    _viewModel.dispose();
    super.dispose();
  }


  Future<void> _cadastrar() async {
    FocusScope.of(context).unfocus();

    final sucesso = await _viewModel.cadastrarUsuario(
      formularioValido:
      _formKey.currentState?.validate() ?? false,
      nome: _nameController.text,
      email: _emailController.text,
      telefone: _phoneController.text,
      senha: _passwordController.text,
    );

    if (!mounted) return;

    if (sucesso) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Conta criada! Faça login para continuar.',
          ),
        ),
      );
    } else if (_viewModel.mensagemErro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.mensagemErro!),
        ),
      );
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
                        enabled: !_viewModel.isLoading,
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
                        enabled: !_viewModel.isLoading,
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
                        enabled: !_viewModel.isLoading,
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel('Senha'),
                      AppTextField(
                        controller: _passwordController,
                        hint: '',
                        icon: Icons.lock_outline,
                        obscure: _viewModel.obscurePassword,
                        textInputAction: TextInputAction.next,
                        validator: Validators.password,
                        enabled: !_viewModel.isLoading,
                        suffix: PasswordToggle(
                          obscured: _viewModel.obscurePassword,
                          onPressed: _viewModel.alternarSenha,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel('Confirmar Senha'),
                      AppTextField(
                        controller: _confirmPasswordController,
                        hint: '',
                        icon: Icons.lock_outline,
                        obscure: _viewModel.obscurePassword,
                        textInputAction: TextInputAction.done,
                        validator: (value) => Validators.confirmPassword(
                          value,
                          _passwordController.text,
                        ),
                          enabled: !_viewModel.isLoading,
                        onFieldSubmitted: (_) => _cadastrar(),
                        suffix: PasswordToggle(
                          obscured: _viewModel.obscureConfirmPassword,
                          onPressed: _viewModel.alternarConfirmacao,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildTermsRow(context),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'CRIAR CONTA',
                        labelStyle: PrimaryButton.uppercaseLabelStyle,
                        isLoading: _viewModel.isLoading,
                        onPressed: _cadastrar,
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
              child:
              Checkbox(
                value: _viewModel.acceptedTerms,
                activeColor: AppColors.primaryGreen,
                isError: _viewModel.termsError,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: _viewModel.isLoading
                    ? null
                    : _viewModel.alterarTermos,
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
        if (_viewModel.termsError)
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
