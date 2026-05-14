# Graph Report - nyawit  (2026-05-14)

## Corpus Check
- 61 files · ~21,099 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 292 nodes · 314 edges · 40 communities (27 shown, 13 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 14 edges (avg confidence: 0.84)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `75473cb7`
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
- [[_COMMUNITY_App Entry Point|App Entry Point]]
- [[_COMMUNITY_AI Feature Pages|AI Feature Pages]]
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

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 11 edges
2. `Nyawit Flutter App` - 7 edges
3. `AppDelegate` - 6 edges
4. `../models/detection.dart` - 6 edges
5. `Create()` - 6 edges
6. `Destroy()` - 6 edges
7. `MessageHandler()` - 5 edges
8. `RunnerTests` - 4 edges
9. `../../services/auth_service.dart` - 4 edges
10. `signToken()` - 4 edges

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

## Communities (40 total, 13 thin omitted)

### Community 0 - "Auth & Login UI"
Cohesion: 0.06
Nodes (30): auth/login_page.dart, build, _login, LoginPage, _LoginPageState, Scaffold, SizedBox, SnackBar (+22 more)

### Community 1 - "Image Detection UI"
Cohesion: 0.12
Nodes (16): build, dispose, Divider, Exception, initState, LiveDetectionPage, _LiveDetectionPageState, Padding (+8 more)

### Community 2 - "Backend API Services"
Cohesion: 0.13
Nodes (17): getMe(), login(), register(), createDetection(), deleteDetection(), getDetectionById(), getDetections(), signToken() (+9 more)

### Community 3 - "Windows Native Runner"
Cohesion: 0.14
Nodes (18): RegisterPlugins(), OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable(), GetClientArea(), GetThisFromHandle(), GetWindowClass() (+10 more)

### Community 4 - "API Client & Auth Services"
Cohesion: 0.12
Nodes (15): api_client.dart, ApiClient, AuthService, jsonDecode, _saveToken, DetectionService, jsonDecode, DetectionBoxPainter (+7 more)

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
Cohesion: 0.15
Nodes (12): build, Card, HistoryPage, _HistoryPageState, initState, Padding, _showDeleteDialog, SizedBox (+4 more)

### Community 9 - "Navigation & Main Pages"
Cohesion: 0.18
Nodes (10): ai/ai_page.dart, AiPage, build, HistoryPage, HomePage, MainPage, _MainPageState, Scaffold (+2 more)

### Community 10 - "App Entry Point"
Cohesion: 0.2
Nodes (9): build, LoginPage, main, MainPage, MaterialApp, MyApp, Scaffold, package:nyawit/pages/main_page.dart (+1 more)

### Community 11 - "AI Feature Pages"
Cohesion: 0.22
Nodes (8): AiPage, build, _buildModeCard, Card, ListView, SizedBox, image_detection_page.dart, live_detection_page.dart

### Community 13 - "macOS Plugin Registration"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), NSWindow, MainFlutterWindow

### Community 14 - "App Branding Assets"
Cohesion: 0.33
Nodes (6): Android App Icon, iOS App Icon, iOS Launch Image, macOS App Icon, Web Favicon, Web PWA Icons

### Community 15 - "Windows Win32 Utilities"
Cohesion: 0.47
Nodes (4): wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16()

### Community 37 - "Community 37"
Cohesion: 0.12
Nodes (15): build, _buildDetailedResults, Column, dispose, Divider, ImageDetectionPage, _ImageDetectionPageState, initState (+7 more)

## Knowledge Gaps
- **142 isolated node(s):** `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry`, `MyApp`, `main` (+137 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `Auth & Login UI` to `Image Detection UI`, `API Client & Auth Services`, `Community 37`, `Detection History UI`, `Navigation & Main Pages`, `App Entry Point`, `AI Feature Pages`?**
  _High betweenness centrality (0.160) - this node is a cross-community bridge._
- **Why does `../models/detection.dart` connect `API Client & Auth Services` to `Detection History UI`, `Image Detection UI`, `Palm Detector ML Engine`, `Community 37`?**
  _High betweenness centrality (0.073) - this node is a cross-community bridge._
- **What connects `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry` to the rest of the system?**
  _142 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Auth & Login UI` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._
- **Should `Image Detection UI` be split into smaller, more focused modules?**
  _Cohesion score 0.12 - nodes in this community are weakly interconnected._
- **Should `Backend API Services` be split into smaller, more focused modules?**
  _Cohesion score 0.13 - nodes in this community are weakly interconnected._
- **Should `Windows Native Runner` be split into smaller, more focused modules?**
  _Cohesion score 0.14 - nodes in this community are weakly interconnected._