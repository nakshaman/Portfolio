/// All portfolio content lives here — edit this file to update the site
/// without touching any UI code.
class PortfolioData {
  static const String name = "Aman Kumar";
  static const String title = "Flutter Developer";
  static const String location = "Noida, UP";
  static const String email = "aman58320@gmail.com";
  static const String phone = "+91 8210597336";

  static const String githubUrl = "https://github.com/nakshaman";
  // TODO: replace with your real LinkedIn URL
  static const String linkedinUrl = "https://linkedin.com/in/YOUR_USERNAME";
  static const String instagramCloneRepo = "https://github.com/nakshaman/instagram";
  static const String hiveChatRepo = "https://github.com/nakshaman/HiveChat";
  static const String favoritePlacesRepo = "https://github.com/nakshaman/Favorite-Places";
  static const String weatherAppRepo = "https://github.com/nakshaman/WeatherApp";

  static const List<String> roles = [
    "Flutter Developer",
    "Cross-Platform App Builder",
    "GetX / Bloc / Riverpod",
    "Firebase & REST API Integrator",
  ];

  static const String summary =
      "Flutter Developer with hands-on experience building scalable cross-platform "
      "mobile apps using Flutter, Firebase, GetX, Bloc/Cubit, Riverpod, and REST APIs. "
      "Comfortable across the full app cycle: authentication, real-time data with "
      "Firestore, MVVM/modular architecture, and responsive UI. Focused on writing "
      "clean, maintainable, production-ready code.";

  static const Map<String, List<String>> skills = {
    "Languages": ["Dart", "C", "C++", "JavaScript"],
    "Frameworks & Tools": ["Flutter", "Firebase", "Git", "GitHub", "VS Code", "Android Studio"],
    "State Management": ["GetX", "Bloc", "Cubit", "Riverpod", "Provider"],
    "Architecture": ["MVVM", "Modular Architecture", "Repository Pattern"],
    "Backend & APIs": ["REST APIs", "Dio", "HTTP", "JSON Parsing", "Firebase Auth", "Firestore", "Storage"],
  };

  static const List<ExperienceItem> experience = [
    ExperienceItem(
      role: "Flutter Developer",
      company: "App Knit, Chandigarh",
      period: "Feb 2026 – Present",
      points: [
        "Developed scalable Flutter applications using GetX architecture with a modular, maintainable code structure.",
        "Designed reusable UI components and implemented structured REST API integrations using Dio.",
        "Optimized GetX state management to cut unnecessary widget rebuilds, improving rendering performance and app responsiveness.",
      ],
    ),
  ];

  static const List<ProjectItem> projects = [
    ProjectItem(
      title: "Instagram Clone",
      date: "Jul 2026",
      tech: ["Flutter", "Firebase Auth", "Firestore", "Storage", "Provider"],
      points: [
        "Built a full-featured Instagram clone with email/password authentication and secure session handling.",
        "Implemented image post creation with captions, like/unlike, and real-time commenting using Cloud Firestore.",
        "Added user search, follow/unfollow, and dynamic profile pages showing post count, followers, and following.",
        "Designed a fully responsive UI across mobile and web using Flutter's adaptive layout widgets.",
        "Structured Firestore data models and Firebase Storage integration for efficient querying.",
      ],
      repoUrl: instagramCloneRepo,
      icon: "camera",
    ),
    ProjectItem(
      title: "Hive Chat",
      date: "Jun 2025",
      tech: ["Flutter", "Firebase Auth", "Firestore", "Provider"],
      points: [
        "Built a live chat application enabling real-time global user communication.",
        "Implemented authentication, real-time messaging, image sharing, and user profile management.",
        "Designed a fully responsive UI with profile editing and secure logout functionality.",
        "Built live user search and efficient chat-room creation using Firestore queries with proper security rules.",
      ],
      repoUrl: hiveChatRepo,
      icon: "chat",
    ),
  ];

  // Smaller, secondary projects — lighter cards under the main two.
  static const List<ProjectItem> miniProjects = [
    ProjectItem(
      title: "Favorite Places",
      date: "Flutter",
      tech: ["Flutter", "Maps", "Image Picker", "Geolocation"],
      points: [
        "A place-bookmarking app where users capture a photo, tag a location on the map, and save it as a favorite spot.",
        "Practiced device camera/gallery access, geolocation, and persisting structured location data.",
      ],
      repoUrl: favoritePlacesRepo,
      icon: "place",
    ),
    ProjectItem(
      title: "Weather App",
      date: "Flutter",
      tech: ["Flutter", "REST API", "JSON Parsing"],
      points: [
        "A weather lookup app that fetches and parses live weather data from a REST API and displays it in a clean UI.",
        "Focused on API integration, async data handling, and error states.",
      ],
      repoUrl: weatherAppRepo,
      icon: "cloud",
    ),
  ];

  static const List<String> certifications = [
    "The Complete Flutter Development Bootcamp — Angela Yu, Udemy",
    "Flutter & Dart: The Complete Guide — Maximilian Schwarzmüller, Udemy",
  ];

  static const String education =
      "Bachelor of Computer Applications (BCA)\nGalgotias University · Sep 2023 – Jun 2026";

  static const List<String> additional = [
    "Participated in Smart India Hackathon (SIH 2024)",
    "Solved 400+ coding problems on LeetCode, CodeChef, and Coding Ninjas",
  ];
}

class ExperienceItem {
  final String role;
  final String company;
  final String period;
  final List<String> points;
  const ExperienceItem({
    required this.role,
    required this.company,
    required this.period,
    required this.points,
  });
}

class ProjectItem {
  final String title;
  final String date;
  final List<String> tech;
  final List<String> points;
  final String repoUrl;
  final String icon;
  const ProjectItem({
    required this.title,
    required this.date,
    required this.tech,
    required this.points,
    required this.repoUrl,
    required this.icon,
  });
}
