import 'package:expense_manager/features/auth/presentation/login/bloc/auth_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart'
    show BaseStatefulWidget, BlocBuilder, BlocListener, BlocProvider, EasyLoading, EffectBlocListener, ReadContext, tpGetIt;
import 'package:flutter_resource/flutter_resource.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class LoginPage extends BaseStatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => tpGetIt.get<AuthBloc>(),
      child: const _LoginPageContent(),
    );
  }
}

class _LoginPageContent extends StatelessWidget {
  const _LoginPageContent();

  @override
  Widget build(BuildContext context) {
    return EffectBlocListener<AuthState, AuthEffect, AuthBloc>(
      listener: (eff, ui) {
        if (eff case AuthShowErrorEffect(:final message)) {
          ui.showDialogSafe(
            builder: (_) => AlertDialog(
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'))
              ],
            ),
          );
        } else if (eff case NavigateToHomePage()) {
          ui.navigate((ctx) => Navigator.of(ctx).pushReplacementNamed('/home'));
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (p, c) => p.runtimeType != c.runtimeType,
        builder: (ctx, state) {
          final isLoading = state is LoginLoading;
          // ... build form giống trên và overlay loading theo state
          return const Placeholder(); // rút gọn cho ngắn
        },
      ),
    );
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            EasyLoading.show();
          } else if (state is AuthAuthenticated) {
            EasyLoading.dismiss();
            // Routing sẽ tự động chuyển đến home page
          } else if (state is AuthUnauthenticated) {
            EasyLoading.dismiss();
          } else if (state is AuthError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.message);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Title
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Expense Manager',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage your expenses with ease',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 60),

                  // Login Buttons
                  _buildSocialLoginButton(
                    context,
                    'Continue with Google',
                    TPAssets.logoGoogle,
                    Colors.white,
                    () =>
                        context.read<AuthBloc>().add(const SignInWithGoogle()),
                  ),
                  const SizedBox(height: 16),
                  _buildSocialLoginButton(
                    context,
                    'Continue with Facebook',
                    TPAssets.logoFB,
                    AppColors.blue600,
                    () => context.read<AuthBloc>().add(
                          const SignInWithFacebook(),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(
    BuildContext context,
    String text,
    String iconPath,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Image.asset(iconPath, width: 24, height: 24),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
