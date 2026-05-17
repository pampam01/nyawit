# Graph Report - nyawit  (2026-05-17)

## Corpus Check
- 69 files · ~33,025 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 367 nodes · 411 edges · 43 communities (31 shown, 12 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 14 edges (avg confidence: 0.84)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `624dcc0d`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Auth & Login UI|Auth & Login UI]]
- [[_COMMUNITY_Image Detection UI|Image Detection UI]]
- [[_COMMUNITY_Backend API Services|Backend API Services]]
- [[_COMMUNITY_Windows Native Runner|Windows Native Runner]]
- [[_COMMUNITY_API Client & Auth Services|API Client & Auth Services]]
- [[_COMMUNITY_Palm Detector ML Engine|Palm Detector ML Engine]]
- [[_COMMUNITY_Database Schema & iOS Plugins|Database Schema & iOS Plugins]]
- [[_COMMUNITY_Linux Native Runner|Linux Native Runner]]
- [[_COMMUNITY_Detection History UI|Detection History UI]]
- [[_COMMUNITY_Navigation & Main Pages|Navigation & Main Pages]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_iOS App Delegate|iOS App Delegate]]
- [[_COMMUNITY_macOS Plugin Registration|macOS Plugin Registration]]
- [[_COMMUNITY_App Branding Assets|App Branding Assets]]
- [[_COMMUNITY_Windows Win32 Utilities|Windows Win32 Utilities]]
- [[_COMMUNITY_iOS Runner Tests|iOS Runner Tests]]
- [[_COMMUNITY_Windows Flutter Window|Windows Flutter Window]]
- [[_COMMUNITY_LLDB Debugger Helper|LLDB Debugger Helper]]
- [[_COMMUNITY_Android Plugin Registrant|Android Plugin Registrant]]
- [[_COMMUNITY_iOS Plugin Registrant (ObjC)|iOS Plugin Registrant (ObjC)]]
- [[_COMMUNITY_Detection Data Model|Detection Data Model]]
- [[_COMMUNITY_Express TypeScript Types|Express TypeScript Types]]
- [[_COMMUNITY_Android Main Activity|Android Main Activity]]
- [[_COMMUNITY_Linux Build Target|Linux Build Target]]
- [[_COMMUNITY_Windows Build Target|Windows Build Target]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 12 edges
2. `dart:convert` - 7 edges
3. `Nyawit Flutter App` - 7 edges
4. `AppDelegate` - 6 edges
5. `../models/detection.dart` - 6 edges
6. `Create()` - 6 edges
7. `Destroy()` - 6 edges
8. `🚀 Fitur Utama yang Telah Diimplementasikan` - 6 edges
9. `../../services/auth_service.dart` - 5 edges
10. `authMiddleware()` - 5 edges

## Surprising Connections (you probably didn't know these)
- `Detection Table (userId, total, dominantLabel, counts, detections, imagePath)` --conceptually_related_to--> `TFLite Flutter (AI Inference)`  [INFERRED]
  nyawit-api/prisma/migrations/20260513155422_init/migration.sql → pubspec.yaml
- `Android App Icon` --semantically_similar_to--> `iOS App Icon`  [INFERRED] [semantically similar]
  android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png → ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png
- `Android App Icon` --semantically_similar_to--> `Web PWA Icons`  [INFERRED] [semantically similar]
  android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png → web/icons/Icon-512.png
- `iOS App Icon` --semantically_similar_to--> `macOS App Icon`  [INFERRED] [semantically similar]
  ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png → macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png
- `iOS CameraPlugin Registration` --implements--> `Camera Package`  [EXTRACTED]
  ios/Runner/GeneratedPluginRegistrant.m → pubspec.yaml

## Hyperedges (group relationships)
- **Flutter Plugin Ecosystem (camera, image_picker, shared_prefs)** — pubspec_yaml_camera, pubspec_yaml_image_picker, pubspec_yaml_shared_preferences, ios_plugin_registrant_camera, ios_plugin_registrant_image_picker, ios_plugin_registrant_shared_prefs [EXTRACTED 1.00]
- **Database Schema (User + Detection)** — migration_sql_user_table, migration_sql_detection_table, migration_sql_user_detection_fk [EXTRACTED 1.00]
- **Nyawit App Branding Assets** — android_ic_launcher, ios_app_icon, ios_launch_image, macos_app_icon, web_favicon, web_icons [INFERRED 0.95]

## Communities (43 total, 12 thin omitted)

### Community 0 - "Auth & Login UI"
Cohesion: 0.11
Nodes (17): build, _login, LoginPage, _LoginPageState, Scaffold, SizedBox, SnackBar, build (+9 more)

### Community 1 - "Image Detection UI"
Cohesion: 0.12
Nodes (16): build, _buildDetailedResults, Column, dispose, Divider, ImageDetectionPage, _ImageDetectionPageState, initState (+8 more)

### Community 2 - "Backend API Services"
Cohesion: 0.1
Nodes (25): getMe(), login(), register(), updateProfile(), createDetection(), deleteDetection(), getDetectionById(), getDetections() (+17 more)

### Community 3 - "Windows Native Runner"
Cohesion: 0.11
Nodes (19): RegisterPlugins(), FlutterWindow(), OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable(), GetClientArea(), GetThisFromHandle() (+11 more)

### Community 4 - "API Client & Auth Services"
Cohesion: 0.15
Nodes (12): 1. Sistem Autentikasi & Keamanan (Auth & Security), 2. Personalisasi Akun Premium (Forest Green Aesthetic), 3. Sistem Deteksi AI Berbasis Gambar (Image AI Detection), 4. Deteksi Real-Time Kamera Live (Live Camera Detection) — *⭐ Fitur Performa Tinggi*, 5. Penyimpanan Gambar Hybrid (Hybrid Image Storage) — *⭐ Fitur Unggulan*, 🛠️ Arsitektur & Teknologi Stack, 🚀 Fitur Utama yang Telah Diimplementasikan, 📈 Perkembangan Struktur Kode (Graphify watch) (+4 more)

### Community 5 - "Palm Detector ML Engine"
Cohesion: 0.13
Nodes (14): _applyNMS, _calculateIoU, close, PalmDetector, _parseOutput, _parseOutputAlt, _rawYuvToTensor, _runInference (+6 more)

### Community 6 - "Database Schema & iOS Plugins"
Cohesion: 0.14
Nodes (14): iOS CameraPlugin Registration, iOS FLTImagePickerPlugin Registration, iOS SharedPreferencesPlugin Registration, Detection Table (userId, total, dominantLabel, counts, detections, imagePath), User-Detection Foreign Key (ON DELETE CASCADE), User Table (id, name, email, password), ML Model Assets, Camera Package (+6 more)

### Community 7 - "Linux Native Runner"
Cohesion: 0.15
Nodes (4): fl_register_plugins(), main(), my_application_activate(), my_application_new()

### Community 8 - "Detection History UI"
Cohesion: 0.6
Nodes (3): fetchHargaSawit(), getHargaSawitLive(), router

### Community 9 - "Navigation & Main Pages"
Cohesion: 0.15
Nodes (12): ai/ai_page.dart, AiPage, build, HistoryPage, HomePage, MainPage, _MainPageState, ProfilePage (+4 more)

### Community 10 - "Community 10"
Cohesion: 0.12
Nodes (15): build, Card, HistoryPage, _HistoryPageState, initState, Padding, Scaffold, _showDeleteDialog (+7 more)

### Community 11 - "Community 11"
Cohesion: 0.11
Nodes (16): AiPage, build, _buildModeCard, Card, ListView, SizedBox, DetectionBoxPainter, _getColorForClass (+8 more)

### Community 13 - "macOS Plugin Registration"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), NSWindow, MainFlutterWindow

### Community 14 - "App Branding Assets"
Cohesion: 0.33
Nodes (6): Android App Icon, iOS App Icon, iOS Launch Image, macOS App Icon, Web Favicon, Web PWA Icons

### Community 15 - "Windows Win32 Utilities"
Cohesion: 0.47
Nodes (4): wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16()

### Community 17 - "Windows Flutter Window"
Cohesion: 0.08
Nodes (23): auth/login_page.dart, build, _buildAvatarWidget, _buildDefaultAvatar, _buildFeatureCard, _buildInfoCard, _buildPriceRow, _buildTodayPriceCard (+15 more)

### Community 37 - "Community 37"
Cohesion: 0.06
Nodes (33): api_client.dart, build, _buildAvatarWidget, _buildDefaultAvatar, _buildPresetAvatarOption, _buildProfileTile, _buildSourceButton, ClipOval (+25 more)

### Community 40 - "Community 40"
Cohesion: 0.5
Nodes (3): DetectionService, jsonDecode, ../models/detection.dart

### Community 41 - "Community 41"
Cohesion: 0.12
Nodes (15): build, dispose, Divider, Exception, initState, LiveDetectionPage, _LiveDetectionPageState, Padding (+7 more)

### Community 42 - "Community 42"
Cohesion: 0.2
Nodes (9): build, LoginPage, main, MainPage, MaterialApp, MyApp, Scaffold, package:nyawit/pages/main_page.dart (+1 more)

## Knowledge Gaps
- **196 isolated node(s):** `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry`, `MyApp`, `main` (+191 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `Community 11` to `Auth & Login UI`, `Image Detection UI`, `Community 37`, `Navigation & Main Pages`, `Community 42`, `Community 10`, `Community 41`, `Windows Flutter Window`?**
  _High betweenness centrality (0.154) - this node is a cross-community bridge._
- **Why does `dart:convert` connect `Community 37` to `Community 40`, `Windows Flutter Window`, `Image Detection UI`?**
  _High betweenness centrality (0.044) - this node is a cross-community bridge._
- **Why does `../models/detection.dart` connect `Community 40` to `Image Detection UI`, `Palm Detector ML Engine`, `Community 41`, `Community 10`, `Community 11`?**
  _High betweenness centrality (0.036) - this node is a cross-community bridge._
- **What connects `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry` to the rest of the system?**
  _196 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Auth & Login UI` be split into smaller, more focused modules?**
  _Cohesion score 0.11 - nodes in this community are weakly interconnected._
- **Should `Image Detection UI` be split into smaller, more focused modules?**
  _Cohesion score 0.12 - nodes in this community are weakly interconnected._
- **Should `Backend API Services` be split into smaller, more focused modules?**
  _Cohesion score 0.1 - nodes in this community are weakly interconnected._