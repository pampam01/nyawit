# Graph Report - nyawit  (2026-05-27)

## Corpus Check
- 70 files · ~159,108 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 380 nodes · 425 edges · 41 communities (29 shown, 12 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 14 edges (avg confidence: 0.84)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `fe77c074`
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

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 13 edges
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

## Communities (41 total, 12 thin omitted)

### Community 0 - "Auth & Login UI"
Cohesion: 0.06
Nodes (30): build, LoginPage, main, MainPage, MaterialApp, MyApp, Scaffold, build (+22 more)

### Community 1 - "Image Detection UI"
Cohesion: 0.06
Nodes (31): build, _buildDetailedResults, Column, dispose, Divider, ImageDetectionPage, _ImageDetectionPageState, initState (+23 more)

### Community 2 - "Backend API Services"
Cohesion: 0.14
Nodes (19): getMe(), login(), register(), updateProfile(), createDetection(), deleteDetection(), getDetectionById(), getDetections() (+11 more)

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
Cohesion: 0.19
Nodes (9): CacheEntry, getSeedForDate(), getTodayPrices(), priceCache, fetchHargaSawit(), getHargaSawitLive(), router, router (+1 more)

### Community 9 - "Navigation & Main Pages"
Cohesion: 0.15
Nodes (12): ai/ai_page.dart, AiPage, build, HistoryPage, HomePage, MainPage, _MainPageState, ProfilePage (+4 more)

### Community 10 - "Community 10"
Cohesion: 0.12
Nodes (15): build, Card, HistoryPage, _HistoryPageState, initState, Padding, Scaffold, _showDeleteDialog (+7 more)

### Community 11 - "Community 11"
Cohesion: 0.2
Nodes (9): calculator_page.dart, AiPage, build, _buildModeCard, Card, ListView, SizedBox, image_detection_page.dart (+1 more)

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
Cohesion: 0.06
Nodes (34): auth/login_page.dart, build, _calculate, CalculatorPage, _CalculatorPageState, dispose, DropdownMenuItem, Icon (+26 more)

### Community 37 - "Community 37"
Cohesion: 0.08
Nodes (23): build, _buildAvatarWidget, _buildDefaultAvatar, _buildPresetAvatarOption, _buildProfileTile, _buildSourceButton, ClipOval, Container (+15 more)

### Community 40 - "Community 40"
Cohesion: 0.1
Nodes (17): api_client.dart, ApiClient, AuthService, jsonDecode, _saveToken, DetectionService, jsonDecode, PalmPriceData (+9 more)

## Knowledge Gaps
- **207 isolated node(s):** `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry`, `MyApp`, `main` (+202 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `Auth & Login UI` to `Image Detection UI`, `Community 37`, `Community 40`, `Navigation & Main Pages`, `Community 10`, `Community 11`, `Windows Flutter Window`?**
  _High betweenness centrality (0.176) - this node is a cross-community bridge._
- **Why does `dart:convert` connect `Community 40` to `Windows Flutter Window`, `Community 37`, `Image Detection UI`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **Why does `../models/detection.dart` connect `Community 40` to `Image Detection UI`, `Community 10`, `Palm Detector ML Engine`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **What connects `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry` to the rest of the system?**
  _207 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Auth & Login UI` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._
- **Should `Image Detection UI` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._
- **Should `Backend API Services` be split into smaller, more focused modules?**
  _Cohesion score 0.14 - nodes in this community are weakly interconnected._