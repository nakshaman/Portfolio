import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/nav_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/certifications_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey = GlobalKey();

  late final Map<String, GlobalKey> _sectionKeys = {
    "About": _aboutKey,
    "Skills": _skillsKey,
    "Experience": _experienceKey,
    "Projects": _projectsKey,
    "Contact": _contactKey,
  };

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          FloatingNavBar(sectionKeys: _sectionKeys, onNavTap: _scrollTo),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  HeroSection(
                    onProjectsTap: () => _scrollTo(_projectsKey),
                    onContactTap: () => _scrollTo(_contactKey),
                  ),
                  Container(key: _aboutKey, child: const AboutSection()),
                  Container(key: _skillsKey, child: const SkillsSection()),
                  Container(key: _experienceKey, child: const ExperienceSection()),
                  Container(key: _projectsKey, child: const ProjectsSection()),
                  const CertificationsSection(),
                  Container(key: _contactKey, child: const ContactSection()),
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
