import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

enum SocialType { google, facebook }

extension on SocialType {
  Color get color {
    if (this == SocialType.google) {
      return Colors.white;
    } else {
      return AppColors.blue600;
    }
  }

  String get label {
    if (this == SocialType.google) {
      return "Continue with Google";
    } else {
      return "Continue with Facebook";
    }
  }

  String get path {
    if (this == SocialType.google) {
      return TPAssets.logoGoogle;
    } else {
      return TPAssets.logoFB;
    }
  }
}

class SocialLoginButton extends BaseStatelessWidget {
  final SocialType socialType;
  final VoidCallback onPressed;

  const SocialLoginButton(this.socialType, this.onPressed, {super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: socialType.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
                Image.asset(socialType.path, width: 24, height: 24),
                const SizedBox(width: 16),
                Text(
                  socialType.label,
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
