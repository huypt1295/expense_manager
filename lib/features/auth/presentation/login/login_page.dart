import 'package:expense_manager/features/auth/presentation/login/widget/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart'
    show BaseStatefulWidget, BaseStatelessWidget, BlocListener, ReadContext;
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
    return const _LoginPageContent();
  }
}

class _LoginPageContent extends BaseStatelessWidget {
  const _LoginPageContent();

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        listener: (context, state) {
          if (state.isLoading) {
            showLoading();
          } else {
            hideLoading();
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
                    'POC',
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
                  SocialLoginButton(SocialType.google, () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventSignInWithGoogle());
                  }),
                  const SizedBox(height: 16),
                  SocialLoginButton(SocialType.facebook, () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventSignInWithFacebook());
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
