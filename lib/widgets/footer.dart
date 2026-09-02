import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context), vertical: 28),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.center,
        children: [
          Text("© 2026 ${PortfolioData.name}. Built with Flutter.", style: AppTheme.body(size: 13)),
          if (isMobile) const SizedBox(height: 14),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FooterIcon(icon: Icons.code_rounded, url: PortfolioData.githubUrl),
              const SizedBox(width: 14),
              _FooterIcon(icon: Icons.business_center_rounded, url: PortfolioData.linkedinUrl),
              const SizedBox(width: 14),
              _FooterIcon(icon: Icons.mail_rounded, url: "mailto:${PortfolioData.email}"),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  const _FooterIcon({required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(icon, size: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
