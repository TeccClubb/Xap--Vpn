// ignore_for_file: file_names, use_build_context_synchronously, unnecessary_brace_in_string_interps
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:async' show Timer, TimeoutException;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:dart_ping/dart_ping.dart';

import 'package:wireguard_flutter/wireguard_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xap_vpn/DataModel/plansModel.dart';
import 'package:xap_vpn/DataModel/userModel.dart';
import 'package:xap_vpn/DataModel/serverDataModel.dart';
import 'package:xap_vpn/DataModel/subscriptionModel.dart';
import 'package:xap_vpn/Defaults/utils.dart';
import 'package:xap_vpn/Wireguard/Engine/wireguard_engine.dart';
import 'package:xap_vpn/ReusableWidgets/customSnackBar.dart';
import 'package:xap_vpn/Screens/Auth/login.dart';

// Only WireGuard protocol is supported

enum VpnStatusConnectionStatus {
  connected,
  disconnected,
  connecting,
  disconnecting,
  reconnecting,
}

class VpnProvide with ChangeNotifier {
  var vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;

  final WireguardEngine _wireguardEngine = WireguardEngine();
  var isloading = false;
  var selectedServerIndex = 0;
  var selectedSubServerIndex = 0;
  var servers = <Server>[];
  var filterServers = <Server>[];
  var isPremium = false;
  var plans = <PlanModel>[];
  //make the user varaible type user
  var user = <UserModel>{};
  var downloadSpeed = "0.0";
  var uploadSpeed = "0.0";
  var pingSpeed = "0.0";
  String? connectionError; // Add error message variable

  // Subscription details
  SubscriptionModel? activeSubscription;
  String? subscriptionStatus;

  static const String favoriteServersPrefsKey = 'favorite_server_ids';
  var favoriteServerIds = <int>{};
  var favoritesFilterActive = false;

  var messageController = TextEditingController();
  var subjectController = TextEditingController();
  var emailController = TextEditingController();

  var autoConnectOn = false;
  var killSwitchOn = false;

  String queryText = '';
  bool queryActive = false;

  Timer? speedUpdateTimer;
  Timer? _stageTimer;
  Timer? _connectionTimer;
  int connectionDuration = 0; // Duration in seconds since connection started
  bool isManuallySelected = false; // Track if user manually selected a server
  bool isPingingServers = false; // Track if currently pinging servers

  bool autoSelectProtocol = false;
  bool _cancelRequested = false;

  void requestCancellation() {
    if (_cancelRequested) {
      return;
    }
    _cancelRequested = true;
    if (vpnConnectionStatus != VpnStatusConnectionStatus.disconnected) {
      vpnConnectionStatus = VpnStatusConnectionStatus.disconnecting;
      notifyListeners();
    }
  }

  // Sync VPN state on app restart to handle stuck states
  Future<void> syncVpnStateOnRestart() async {
    try {
      final currentStage = await _wireguardEngine.getVpnStatus();
      log("Syncing VPN state on restart - Current stage: $currentStage");

      // Update internal state to match actual VPN state
      if (currentStage == VpnStage.connected) {
        vpnConnectionStatus = VpnStatusConnectionStatus.connected;
        speedMonitor();
        if (connectionDuration == 0) {
          startConnectionTimer();
        }
        log("VPN is connected - resuming monitoring");
      } else if (currentStage == VpnStage.disconnected) {
        vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
        stopMonitor();
        stopConnectionTimer();
        log("VPN is disconnected");
      } else if (currentStage == VpnStage.connecting ||
          currentStage == VpnStage.disconnecting) {
        // If stuck in connecting/disconnecting, force disconnect
        log(
          "VPN stuck in transitional state: $currentStage - forcing disconnect",
        );
        await _wireguardEngine.stopVpn().timeout(const Duration(seconds: 3));
        vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
        stopMonitor();
        stopConnectionTimer();
      }
      notifyListeners();
    } catch (e) {
      log("Error syncing VPN state on restart: $e");
      vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
      notifyListeners();
    }
  }

  autoC(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    autoConnectOn = prefs.getBool('autoConnect') ?? false;
    log("Auto-connect check: $autoConnectOn");

    // Check actual VPN stage to prevent auto-connect on app restart
    try {
      // final currentStage = await _wireguardEngine.getVpnStatus();
      // log("Current VPN stage for auto-connect: $currentStage");

      // Only auto-connect if:
      // 1. Auto-connect is enabled
      // 2. VPN is truly disconnected (not connecting, not connected, not disconnecting)
      // 3. This is a fresh app start (servers were just loaded
      if (autoConnectOn && vpnConnectionStatus == VpnStatusConnectionStatus.disconnected) {
        log("Triggering auto-connect");
        await toggleVpn();
        notifyListeners();
      } else {
        // log(
        //   "Auto-connect skipped: autoConnect=$autoConnectOn, Stage=$currentStage",
        // );
      }
    } catch (e) {
      log("Error checking VPN stage for auto-connect: $e");
    }
  }

  toggleAutoConnectState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    autoConnectOn = !autoConnectOn;
    log(autoConnectOn.toString());
    prefs.setBool('autoConnect', autoConnectOn);
    notifyListeners();
  }

  // Load auto-connect state from storage
  Future<void> loadAutoConnectState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    autoConnectOn = prefs.getBool('autoConnect') ?? false;
    notifyListeners();
  }

  toggleKillSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    killSwitchOn = !killSwitchOn;
    log(killSwitchOn.toString());
    prefs.setBool('killSwitchOn', killSwitchOn);
    log("KillSwitch toggled: $killSwitchOn");
    notifyListeners();
  }

  myKillSwitch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    killSwitchOn = prefs.getBool('killSwitchOn') ?? false;
    notifyListeners();
  }

  Future<void> selectFastestServerByHealth({
    bool considerAllServers = false,
  }) async {
    if (servers.isEmpty) {
      log("No servers available to analyze.");
      return;
    }

    isloading = true;
    notifyListeners();

    int fastestIndex = 0;
    double highestScore = -1.0;
    bool foundServer = false;

    for (int i = 0; i < servers.length; i++) {
      try {
        // For free users, only consider free servers
        // For premium users or when considerAllServers is true, consider all servers
        if (!isPremium && !considerAllServers) {
          if (servers[i].type.toLowerCase() != 'free') {
            log(
              "Skipping premium server for free user: ${servers[i].name} (Type: ${servers[i].type})",
            );
            continue;
          }
        }

        foundServer = true;

        // Each server can have multiple subServers, so find the best among them
        final subServers = servers[i].subServers ?? [];
        for (var sub in subServers) {
          final vpsGroup = sub.vpsGroup;
          if (vpsGroup != null &&
              vpsGroup.servers != null &&
              vpsGroup.servers!.isNotEmpty) {
            // BUSINESS RULE: ONLY primary VPS are eligible for selection
            final primaryVps = vpsGroup.servers!.firstWhere(
              (vps) => vps.role.toLowerCase() == 'primary',
              orElse: () => vpsGroup.servers!.first,
            );

            // Skip if no primary VPS found and first server is not primary
            if (primaryVps.role.toLowerCase() != 'primary') {
              log("Skipping ${servers[i].name} - No primary VPS available");
              continue;
            }

            final score =
                double.tryParse(primaryVps.healthScore.toString()) ?? 0.0;
            log(
              "Server ${servers[i].name} - Primary VPS Health Score: $score, Type ${servers[i].type}",
            );
            if (score > highestScore) {
              highestScore = score;
              fastestIndex = i;
            }
          }
        }
      } catch (e) {
        log("Error checking health_score for server ${servers[i].name}: $e");
      }
    }

    if (!foundServer) {
      if (!isPremium && !considerAllServers) {
        log("No free servers available for free user.");
      } else {
        log("No servers available.");
      }
      isloading = false;
      notifyListeners();
      return;
    }

    selectedServerIndex = fastestIndex;
    isManuallySelected = false; // Auto-selected, not manual
    await _saveSelectedServerIndex();

    isloading = false;
    notifyListeners();

    if (isPremium || considerAllServers) {
      log(
        "Fastest server selected: ${servers[fastestIndex].name} (Health Score: $highestScore, Type: ${servers[fastestIndex].type})",
      );
    } else {
      log(
        "Fastest free server selected: ${servers[fastestIndex].name} (Health Score: $highestScore, Type: ${servers[fastestIndex].type})",
      );
    }
  }

  // Select next fastest server (excluding current one)
  Future<void> selectNextFastestServer() async {
    if (servers.isEmpty) {
      log("No servers available to analyze.");
      return;
    }

    isloading = true;
    notifyListeners();

    int currentIndex = selectedServerIndex;
    int fastestIndex = 0;
    double highestScore = -1.0;
    bool foundServer = false;

    for (int i = 0; i < servers.length; i++) {
      try {
        // Skip the currently selected server
        if (i == currentIndex) {
          log("Skipping current server: ${servers[i].name}");
          continue;
        }

        // For free users, only consider free servers
        // For premium users, consider all servers
        if (!isPremium) {
          if (servers[i].type.toLowerCase() != 'free') {
            log(
              "Skipping premium server for free user: ${servers[i].name} (Type: ${servers[i].type})",
            );
            continue;
          }
        }

        foundServer = true;

        // Each server can have multiple subServers, so find the best among them
        final subServers = servers[i].subServers ?? [];
        for (var sub in subServers) {
          final vpsGroup = sub.vpsGroup;
          if (vpsGroup != null &&
              vpsGroup.servers != null &&
              vpsGroup.servers!.isNotEmpty) {
            // BUSINESS RULE: ONLY primary VPS are eligible for selection
            final primaryVps = vpsGroup.servers!.firstWhere(
              (vps) => vps.role.toLowerCase() == 'primary',
              orElse: () => vpsGroup.servers!.first,
            );

            // Skip if no primary VPS found and first server is not primary
            if (primaryVps.role.toLowerCase() != 'primary') {
              log("Skipping ${servers[i].name} - No primary VPS available");
              continue;
            }

            final score =
                double.tryParse(primaryVps.healthScore.toString()) ?? 0.0;
            log(
              "Server ${servers[i].name} - Primary VPS Health Score: $score, Type ${servers[i].type}",
            );
            if (score > highestScore) {
              highestScore = score;
              fastestIndex = i;
            }
          }
        }
      } catch (e) {
        log("Error checking health_score for server ${servers[i].name}: $e");
      }
    }

    if (!foundServer) {
      if (!isPremium) {
        log("No other free servers available. Keeping current server.");
      } else {
        log("No other servers available. Keeping current server.");
      }
      isloading = false;
      notifyListeners();
      return;
    }

    selectedServerIndex = fastestIndex;
    isManuallySelected = false; // Auto-selected, not manual
    await _saveSelectedServerIndex();

    isloading = false;
    notifyListeners();

    if (isPremium) {
      log(
        "Next fastest server selected: ${servers[fastestIndex].name} (Health Score: $highestScore, Type: ${servers[fastestIndex].type})",
      );
    } else {
      log(
        "Next fastest free server selected: ${servers[fastestIndex].name} (Health Score: $highestScore, Type: ${servers[fastestIndex].type})",
      );
    }
  }

  Future<bool> setAutoSelectProtocol(bool value) async {
    if (value &&
        vpnConnectionStatus != VpnStatusConnectionStatus.disconnected) {
      log('Auto-select requires the VPN to be disconnected.');
      notifyListeners();
      return false;
    }

    if (autoSelectProtocol == value) {
      return true;
    }

    autoSelectProtocol = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoSelectProtocol', value);

    notifyListeners();
    return true;
  }

  Future<void> lProtocolFromStorage() async {
    log("Using WireGuard protocol (only supported protocol)");
    notifyListeners();
    startGettingStages();
  }

  // make me a function to load the selectedserverindex from sharedpreference
  Future<void> loadSelectedServerIndex() async {
    final prefs = await SharedPreferences.getInstance();
    selectedServerIndex = prefs.getInt('selected_server_index') ?? 0;
    notifyListeners();
  }

  void setSelectedServerIndex(int index, {bool manually = false}) {
    selectedServerIndex = index;
    isManuallySelected = manually; // Track if user manually selected
    _saveSelectedServerIndex();
    notifyListeners();
  }

  Future<void> _saveSelectedServerIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_server_index', selectedServerIndex);
  }

  // Validate and fix selected server for free users
  Future<void> validateAndFixSelectedServer() async {
    if (servers.isEmpty) {
      log("No servers available to validate.");
      return;
    }

    // Check if user is premium
    if (isPremium) {
      log("User is premium, no need to validate server selection.");
      return;
    }

    // Check if current selected server is valid and free
    if (selectedServerIndex >= 0 && selectedServerIndex < servers.length) {
      final currentServer = servers[selectedServerIndex];

      if (currentServer.type.toLowerCase() == 'free') {
        log("Current server is free: ${currentServer.name}");
        return;
      }

      log(
        "Current server is premium: ${currentServer.name}. User is free. Need to select a free server.",
      );
    } else {
      log(
        "Invalid server index: $selectedServerIndex. Need to select a free server.",
      );
    }

    // Find first free server or select fastest free server
    await selectFastestServerByHealth(considerAllServers: false);
  }

  // Set query text and filter list
  void setQueryText(String text) {
    queryText = text;
    filterSrvList();
  }

  // Filter by search query only
  void filterSrvList() {
    List<Server> results = List.from(servers);

    syncFavoriteServersWithAvailableServers();

    if (queryText.trim().isNotEmpty) {
      results = results
          .where((s) => s.name.toLowerCase().contains(queryText.toLowerCase()))
          .toList();
      queryActive = true;
    } else {
      queryActive = false;
    }

    if (favoritesFilterActive) {
      results = results
          .where((server) => favoriteServerIds.contains(server.id))
          .toList();
    }

    results.sort((a, b) {
      final aFav = favoriteServerIds.contains(a.id);
      final bFav = favoriteServerIds.contains(b.id);

      if (aFav != bFav) {
        return aFav ? -1 : 1;
      }

      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    filterServers = results;
    notifyListeners();
  }

  Future<void> loadFavoriteServers() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIds =
        prefs.getStringList(favoriteServersPrefsKey) ?? <String>[];

    favoriteServerIds = storedIds
        .map((value) => int.tryParse(value))
        .whereType<int>()
        .toSet();

    filterSrvList();
  }

  Future<void> toggleFavoriteServer(int serverId) async {
    if (favoriteServerIds.contains(serverId)) {
      favoriteServerIds.remove(serverId);
    } else {
      favoriteServerIds.add(serverId);
    }

    await _persistFavoriteServers();
    filterSrvList();
  }

  bool isFavoriteServer(int serverId) {
    return favoriteServerIds.contains(serverId);
  }

  void setFavoritesFilter(bool value) {
    if (favoritesFilterActive == value) {
      return;
    }

    favoritesFilterActive = value;
    filterSrvList();
  }

  void toggleFavoritesFilter() {
    favoritesFilterActive = !favoritesFilterActive;
    filterSrvList();
  }

  Future<void> _persistFavoriteServers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      favoriteServersPrefsKey,
      favoriteServerIds.map((id) => id.toString()).toList(),
    );
  }

  void syncFavoriteServersWithAvailableServers() {
    if (servers.isEmpty) {
      return;
    }

    favoriteServerIds.retainWhere(
      (serverId) => servers.any((server) => server.id == serverId),
    );
  }

  bool _shouldAbortConnection() {
    if (!_cancelRequested) {
      return false;
    }
    _cancelRequested = false;
    log("Connection cancelled by user");
    vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
    notifyListeners();
    return true;
  }

  Map<String, dynamic>? _parseJsonBody(http.Response response, String label) {
    try {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      log("$label returned unexpected JSON: ${decoded.runtimeType}");
    } catch (e) {
      final body = response.body;
      final preview = body.length > 120 ? body.substring(0, 120) : body;
      log(
        "$label returned non JSON (${response.statusCode}): ${preview.replaceAll('\n', ' ')}",
      );
    }
    return null;
  }

  Future<void> getServersPlease(bool net) async {
    isloading = true;
    notifyListeners();
    // Simulate a network call or data fetching
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var platform = Platform.isAndroid
          ? "android"
          : Platform.isIOS
          ? "ios"
          : Platform.isWindows
          ? "windows"
          : Platform.isMacOS
          ? "macos"
          : "linux";

      if (net) {
        var headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var response = await http.get(
          Uri.parse("${UUtils.getServers}?platform=$platform"),
          headers: headers,
        );

        var data = jsonDecode(response.body);
        log(data.toString());
        if (data['status'] == true) {
          servers = (data['servers'] as List)
              .map((e) => Server.fromJson(e))
              .toList();
          log('Servers: $servers');
          log(
            'Servers fetched successfully: ${servers.length} servers loaded.',
          );
          filterSrvList();
        } else {
          // Handle error
          log('Error: ${data['message']}');
          servers = [];
          filterSrvList();
        }
      }
    } catch (error) {
      log('Error: $error');

      isloading = false;
      servers = [];
      filterSrvList();
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  getRequiredServerDomain() {
    return servers[selectedServerIndex]
        .subServers![selectedSubServerIndex]
        .vpsGroup!
        .servers![0]
        .domain;
  }

  startGettingStages() {
    log("Starting stage monitoring for WireGuard");
    // Avoid spawning multiple timers
    _stageTimer ??= Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      await listenWireguard();
    });
  }

  Future<VpnStatusConnectionStatus> listenWireguard() async {
    try {
      VpnStatusConnectionStatus newStage = vpnConnectionStatus;
      final value = await _wireguardEngine.getVpnStatus();
      if (value == VpnStage.connected) {
        newStage = VpnStatusConnectionStatus.connected;
      } else if (value == VpnStage.connecting || isloading) {
        newStage = VpnStatusConnectionStatus.connecting;
      } else if (value == VpnStage.disconnected) {
        newStage = VpnStatusConnectionStatus.disconnected;
      } else if (value == VpnStage.disconnecting) {
        newStage = VpnStatusConnectionStatus.disconnecting;
      } else {
        newStage = VpnStatusConnectionStatus.disconnected;
      }

      vpnConnectionStatus = newStage;

      // Start timer when connected (if not already running)
      if (newStage == VpnStatusConnectionStatus.connected &&
          _connectionTimer == null) {
        startConnectionTimer();
        log("Started connection timer from listenWireguard");
      }

      // Stop timer when disconnecting or disconnected
      if (newStage == VpnStatusConnectionStatus.disconnected ||
          newStage == VpnStatusConnectionStatus.disconnecting) {
        if (_connectionTimer != null) {
          stopConnectionTimer();
          log("Stopped connection timer from listenWireguard");
        }
      }

      log("WireGuard Stage: $vpnConnectionStatus");

      return newStage;
    } catch (e) {
      log("Error getting WireGuard stage: $e");
      vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
      stopConnectionTimer();
      return VpnStatusConnectionStatus.disconnected;
    }
  }

  Future<bool> registerUserInVps(String serverUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? name = prefs.getString('name');
      final String? password = prefs.getString('password');

      if (_cancelRequested) {
        log("Registration aborted before start on $serverUrl");
        return false;
      }

      log("Name is $name");
      log("Password is $password");

      if (name == null || password == null) {
        log("Name or password is missing");
        return false;
      }

      final String platform = Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : Platform.isLinux
          ? 'linux'
          : 'desktop';

      const headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-Token': 'a3f7b9c2-d1e5-4f68-8a0b-95c6e7f4d8a1',
      };

      log("Name_platform is that ${name}_$platform");
      log("Password is that $password");

      final firstResponse = await http
          .post(
            Uri.parse("$serverUrl/api/clients/generate"),
            headers: headers,
            body: jsonEncode({"name": "${name}_$platform"}),
          )
          .timeout(const Duration(seconds: 8));

      if (_cancelRequested) {
        log("Registration aborted after initial request on $serverUrl");
        return false;
      }

      // OpenVPN registration removed - only WireGuard is supported

      log(
        "Initial registration response ${firstResponse.statusCode}: ${firstResponse.body}",
      );

      final Map<String, dynamic>? firstBody = _parseJsonBody(
        firstResponse,
        "WireGuard registration",
      );

      // Check if registration succeeded
      final bool initialSuccess =
          firstResponse.statusCode == 200 &&
          firstBody != null &&
          (firstBody["error"] == null) &&
          (firstBody["success"] == true || firstBody.containsKey("config"));

      if (initialSuccess) {
        log("Registered successfully on $serverUrl");
        return true;
      }

      // Only retry if client already exists
      final bool clientExists =
          firstBody != null &&
          firstBody["error"] != null &&
          firstBody["error"].toString().toLowerCase().contains(
            "already exists",
          );

      if (!clientExists) {
        log(
          "Registration failed on $serverUrl: ${firstBody?["error"] ?? "Unknown error"}",
        );
        return false;
      }

      // Client exists, delete and retry
      log("Client already exists, attempting to delete and re-register");

      if (_cancelRequested) {
        log("Registration aborted before delete on $serverUrl");
        return false;
      }

      final deleteResponse = await http
          .delete(
            Uri.parse("$serverUrl/api/clients/${name}_$platform"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 8));

      if (deleteResponse.statusCode != 200) {
        log(
          "Unable to delete existing client on $serverUrl: ${deleteResponse.statusCode}",
        );
        return false;
      }

      if (_cancelRequested) {
        log("Registration aborted before retry on $serverUrl");
        return false;
      }

      // Retry registration
      final newResponse = await http
          .post(
            Uri.parse("$serverUrl/api/clients/generate"),
            headers: headers,
            body: jsonEncode({
              "name": "${name}_$platform",
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 8));

      final Map<String, dynamic>? responseBody = _parseJsonBody(
        newResponse,
        "WireGuard re-registration",
      );

      final bool registrationSuccess =
          newResponse.statusCode == 200 &&
          responseBody != null &&
          (responseBody["success"] == true ||
              responseBody.containsKey("config"));

      if (registrationSuccess) {
        log("Registered successfully on $serverUrl (after retry)");
        return true;
      }

      log("Registration failed on $serverUrl after retry");
      return false;
    } on TimeoutException catch (e) {
      log("Registration timed out on $serverUrl: $e");
      return false;
    } catch (e) {
      log("Exception during registration on $serverUrl: $e");
      return false;
    }
  }

  toggleVpn() async {
    var domain = getRequiredServerDomain();
    log("Domain: $domain");

    log("Protocol: WireGuard (only supported)");
    log("State: ${vpnConnectionStatus}");

    // CRITICAL: Backend validation - Enforce access control before connecting
    if (vpnConnectionStatus == VpnStatusConnectionStatus.disconnected) {
      // Validate server access for Free users
      if (!isPremium) {
        // Get selected server
        final selectedServer =
            servers.isNotEmpty && selectedServerIndex < servers.length
            ? servers[selectedServerIndex]
            : null;

        // Check if selected server is Premium
        if (selectedServer != null &&
            selectedServer.type.toLowerCase() != 'free') {
          log(
            'SECURITY BLOCK: Free user attempted to connect to Premium server: ${selectedServer.name}',
          );
          connectionError =
              'Premium server access denied. Please upgrade to Premium.';
          notifyListeners();
          return; // BLOCK CONNECTION AT BACKEND
        }

        // Check if any Free servers are available
        final hasFreeServers = servers.any(
          (server) => server.type.toLowerCase() == 'free',
        );
        if (!hasFreeServers) {
          log('SECURITY BLOCK: No Free servers available for Free user');
          connectionError =
              'No Free servers available. Please upgrade to Premium for full access.';
          notifyListeners();
          return; // BLOCK CONNECTION AT BACKEND
        }
      }
    }

    // Only WireGuard is supported
    if (vpnConnectionStatus == VpnStatusConnectionStatus.connected ||
        vpnConnectionStatus == VpnStatusConnectionStatus.connecting) {
      if (vpnConnectionStatus == VpnStatusConnectionStatus.connecting) {
        requestCancellation();
      }
      await disconnectWireguard();
    } else if (vpnConnectionStatus == VpnStatusConnectionStatus.disconnected) {
      log("WireGuard Called!");
      await connectWireguard(domain);
    }
  }

  // Singbox removed - only WireGuard is supported

  disconnectWireguard() async {
    try {
      if (vpnConnectionStatus != VpnStatusConnectionStatus.disconnected) {
        vpnConnectionStatus = VpnStatusConnectionStatus.disconnecting;
        notifyListeners();
      }
      await _wireguardEngine.stopVpn().timeout(const Duration(seconds: 5));
      stopMonitor();
      vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
      notifyListeners();
      log('WireGuard disconnected successfully');
    } on TimeoutException catch (e) {
      log('WireGuard disconnect timed out: $e');
      vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
      notifyListeners();
    } catch (e) {
      log('Error disconnecting WireGuard: $e');
    }
  }

  Future<String?> selectedWirVPNConfig(String serverUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? name = prefs.getString('name');

      final String platform = Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : Platform.isWindows
          ? 'windows'
          : 'macos';

      if (_cancelRequested) {
        log("Config fetch aborted before request on $serverUrl");
        return null;
      }

      const headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-Token': 'a3f7b9c2-d1e5-4f68-8a0b-95c6e7f4d8a1',
      };

      final response = await http
          .get(
            Uri.parse("$serverUrl/api/clients/${name}_$platform"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 8));

      if (_cancelRequested) {
        log("Config fetch aborted after response on $serverUrl");
        return null;
      }

      log("Response status code: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final String wireguardConfig = responseData['config'];
        final String ipAddress = responseData['ip'];
        final String clientName = responseData['name'];
        final String qrCode = responseData['qr_code'];

        await prefs.setString('current_wireguard_config', wireguardConfig);
        await prefs.setString('current_wireguard_ip', ipAddress);
        await prefs.setString('current_wireguard_client', clientName);
        await prefs.setString('current_wireguard_qr', qrCode);
        await prefs.setString('current_wireguard_server_url', serverUrl);

        log("WireGuard config received: $wireguardConfig");
        log("WireGuard config saved successfully");

        return wireguardConfig;
      } else {
        log("Failed to get WireGuard config: ${response.statusCode}");
        return null;
      }
    } on TimeoutException catch (e) {
      log("WireGuard config request timed out on $serverUrl: $e");
      return null;
    } catch (e) {
      log("Error getting WireGuard config: $e");
      return null;
    }
  }

  Future<bool> connectWireguard(String domain) async {
    try {
      _cancelRequested = false;
      connectionError = null; // Clear previous errors
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('connectTime', DateTime.now().toString());

      // Check if selected server is healthy
      if (servers.isNotEmpty &&
          selectedServerIndex < servers.length &&
          servers[selectedServerIndex].subServers!.isNotEmpty &&
          selectedSubServerIndex <
              servers[selectedServerIndex].subServers!.length) {
        final selectedServer = servers[selectedServerIndex]
            .subServers![selectedSubServerIndex]
            .vpsGroup!
            .servers;

        if (selectedServer != null && selectedServer.isNotEmpty) {
          final primaryServer = selectedServer.firstWhere(
            (s) => s.role == 'primary',
            orElse: () => selectedServer[0],
          );

          if (!primaryServer.status || primaryServer.healthScore == 0) {
            log(
              "Selected server is offline or unhealthy: ${primaryServer.name}",
            );
            connectionError =
                "Server is currently offline. Please select another server.";
            vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
            isloading = false;
            notifyListeners();
            return false;
          }
        }
      }

      isloading = true;
      vpnConnectionStatus = VpnStatusConnectionStatus.connecting;
      // connectionError = "Connecting to server...";
      notifyListeners();

      if (_shouldAbortConnection()) {
        return false;
      }

      // connectionError = ".";
      notifyListeners();
      final registered = await registerUserInVps("http://$domain:5000");
      if (_shouldAbortConnection()) {
        return false;
      }
      if (!registered) {
        log("User registration failed");
        connectionError =
            "Unable to connect to server. Server may be offline or unreachable.";
        vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
        notifyListeners();
        return false;
      }

      // connectionError = "Fetching VPN configuration...";
      notifyListeners();
      final config = await selectedWirVPNConfig("http://$domain:5000");
      if (_shouldAbortConnection()) {
        return false;
      }
      if (config == null) {
        log("Failed to get WireGuard config");
        vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
        notifyListeners();
        return false;
      }

      // Start WireGuard VPN using the new engine
      // connectionError = "Starting VPN tunnel...";
      notifyListeners();
      await _wireguardEngine.startVpn(config, domain);

      if (_shouldAbortConnection()) {
        await _wireguardEngine.stopVpn();
        return false;
      }

      speedMonitor();

      vpnConnectionStatus = VpnStatusConnectionStatus.connected;
      connectionError = null; // Clear error on success
      notifyListeners();
      log('WireGuard connected successfully');
      return true;
    } catch (e) {
      log('Error connecting WireGuard: $e');
      vpnConnectionStatus = VpnStatusConnectionStatus.disconnected;
      notifyListeners();
      return false;
    } finally {
      _cancelRequested = false;
      isloading = false;
      notifyListeners();
    }
  }

  // Singbox removed - only WireGuard is supported

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    servers = [];
    selectedServerIndex = 0;
    selectedSubServerIndex = 0;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    notifyListeners();
  }

  Future<void> getUser() async {
    log("user function called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(Uri.parse(UUtils.user), headers: headers);

    var data = jsonDecode(response.body);
    if (data['status'] == true || response.statusCode == 200) {
      log('User data: ${data['user']}');

      user = {UserModel.fromJson(data['user'])};
      await prefs.setString('user', jsonEncode(data['user']));
    } else {
      log('Error: ${data['message']}');
    }
  }

  Future<void> getPremium() async {
    log("premium function called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.get(
      Uri.parse(UUtils.subscription),
      headers: headers,
    );

    log("Response body: ${response.body}");
    var data = jsonDecode(response.body);

    log("Response status code: ${response.statusCode}");
    if (data['status'] == true || response.statusCode == 200) {
      log('Premium plans: ${data['plans']}');

      // Parse subscription details if available
      if (data['subscription'] != null) {
        try {
          activeSubscription = SubscriptionModel.fromJson(data['subscription']);
          subscriptionStatus = activeSubscription?.status;
          log('Subscription parsed: ${activeSubscription?.planName}');
        } catch (e) {
          log('Error parsing subscription: $e');
        }
      }

      // Set premium status
      isPremium = true;
      notifyListeners();
    } else {
      log('Error: ${data['message']}');
      isPremium = false;
      activeSubscription = null;
      subscriptionStatus = null;
      notifyListeners();
    }
  }

  Future<void> getPlans() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final response = await http.get(
        Uri.parse(UUtils.plans),
        headers: headers,
      );
      log("Response status code: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Parse each plan into a PlanModel
        plans = (data['plans'] as List)
            .map((plan) => PlanModel.fromJson(plan))
            .toList();

        notifyListeners();
      } else {
        log('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception in getPlans: $e');
    }
  }

  Future<void> addFeedback(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Send email, message, and subject
      var body = {
        'email': emailController.text,
        'message': messageController.text,
        'subject': subjectController.text,
      };

      log('Submitting feedback with email: ${emailController.text}');
      log('Subject: ${subjectController.text}');
      log('Message: ${messageController.text}');

      var response = await http.post(
        Uri.parse(UUtils.feedback),
        headers: headers,
        body: jsonEncode(body),
      );

      log('Feedback response status: ${response.statusCode}');
      log('Feedback response body: ${response.body}');

      var data = jsonDecode(response.body);
      if (data['status'] == true || response.statusCode == 200) {
        log('Feedback submitted: ${data['message']}');
        // Handle successful feedback submission
        showCustomSnackBar(
          context,
          Icons.check,
          'Success',
          'Feedback submitted successfully',
          Colors.green,
        );
      } else {
        log('Error submitting feedback: ${data['message']}');
        showCustomSnackBar(
          context,
          Icons.error,
          'Error',
          data['message'] ?? 'Failed to submit feedback',
          Colors.red,
        );
      }
    } catch (error) {
      log('Exception in addFeedback: $error');
      showCustomSnackBar(
        context,
        Icons.error,
        'Error',
        'Failed to submit feedback: $error',
        Colors.red,
      );
    }
  }

  // Check network speed
  Future<Map<String, String>> networkSpeed() async {
    var speed = {'download': "0", 'upload': "0"};
    final url = 'https://youtube.com';
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final elapsed = stopwatch.elapsedMilliseconds;
        // Calculate speed in Mbps (Megabits per second)
        final speedInMbps =
            ((response.bodyBytes.length / 1024 / 1024) / (elapsed / 1000)) *
            8 /
            3;
        String download = speedInMbps.toStringAsFixed(2);
        String upload = (speedInMbps + 1.36).toStringAsFixed(2);
        speed = {'download': download, 'upload': upload};
      }
      return speed;
    } catch (e) {
      log(e.toString());
      return speed;
    }
  }

  void speedMonitor() {
    log("Starting speed monitoring");
    stopMonitor(); // Stop any existing timer

    speedUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (vpnConnectionStatus == VpnStatusConnectionStatus.connected) {
        log("Monitoring speeds...");
        var speeds = await networkSpeed();
        log("Speeds (Mbps): $speeds");

        // Convert Mbps to Kbps
        double downloadMbps =
            double.tryParse(speeds['download'] ?? "0.0") ?? 0.0;
        double uploadMbps = double.tryParse(speeds['upload'] ?? "0.0") ?? 0.0;

        downloadSpeed = (downloadMbps * 1000).toStringAsFixed(2); // kbps
        uploadSpeed = (uploadMbps * 1000).toStringAsFixed(2); // kbps

        // Log the speeds in kbps
        log("Download Speed: $downloadSpeed Kbps");
        log("Upload Speed: $uploadSpeed Kbps");

        // Get ping measurement using dart_ping to the selected server
        await _pingSelectedServer();

        log("Ping Speed: $pingSpeed ms");
        notifyListeners();
        // Ensure UI updates to reflect new speeds
      } else {
        // Reset values when not connected
        downloadSpeed = "0.0";
        uploadSpeed = "0.0";
        pingSpeed = "0";
        // Notify UI of reset values
        notifyListeners();
      }
    });
  }

  // Method to stop monitoring when disconnected
  void stopMonitor() {
    speedUpdateTimer?.cancel();
    speedUpdateTimer = null;
  }

  // Ping the selected server using dart_ping
  Future<void> _pingSelectedServer() async {
    try {
      // Get the currently selected server
      if (servers.isEmpty || selectedServerIndex >= servers.length) {
        pingSpeed = "0";
        return;
      }

      final selectedServer = servers[selectedServerIndex];

      // Get the selected subserver
      if (selectedServer.subServers == null ||
          selectedServer.subServers!.isEmpty ||
          selectedSubServerIndex >= selectedServer.subServers!.length) {
        pingSpeed = "0";
        return;
      }

      final selectedSubServer =
          selectedServer.subServers![selectedSubServerIndex];

      // Get the VPS server to ping (prefer primary server)
      if (selectedSubServer.vpsGroup?.servers == null ||
          selectedSubServer.vpsGroup!.servers!.isEmpty) {
        pingSpeed = "0";
        return;
      }

      // Try to find the primary server first, otherwise use the first available
      VpsServer? serverToPing;
      for (var vpsServer in selectedSubServer.vpsGroup!.servers!) {
        if (vpsServer.role.toLowerCase() == 'primary' && vpsServer.status) {
          serverToPing = vpsServer;
          break;
        }
      }

      // If no primary found, use first active server
      if (serverToPing == null) {
        serverToPing = selectedSubServer.vpsGroup!.servers!.firstWhere(
          (s) => s.status,
          orElse: () => selectedSubServer.vpsGroup!.servers!.first,
        );
      }

      // Ping the server IP or domain
      final targetAddress = serverToPing.ipAddress.isNotEmpty
          ? serverToPing.ipAddress
          : serverToPing.domain;

      if (targetAddress.isEmpty) {
        pingSpeed = "0";
        return;
      }

      // Perform ping with timeout
      final ping = Ping(targetAddress, count: 1, timeout: 3);
      await for (final result in ping.stream) {
        if (result.response != null && result.response!.time != null) {
          pingSpeed = result.response!.time!.inMilliseconds.toString();
          log("Pinged ${serverToPing.name} (${targetAddress}): ${pingSpeed}ms");
          return;
        }
      }

      // If no successful ping
      pingSpeed = "0";
    } catch (e) {
      log("Ping error: $e");
      pingSpeed = "0";
    }
  }

  // Ping a specific VPS server and return the latency in milliseconds
  Future<int> pingVpsServer(VpsServer vpsServer) async {
    try {
      final targetAddress = vpsServer.ipAddress.isNotEmpty
          ? vpsServer.ipAddress
          : vpsServer.domain;

      if (targetAddress.isEmpty) {
        return 9999; // Return high value for unreachable servers
      }

      // Perform ping with timeout
      final ping = Ping(targetAddress, count: 1, timeout: 3);
      await for (final result in ping.stream) {
        if (result.response != null && result.response!.time != null) {
          final latency = result.response!.time!.inMilliseconds;
          log("Pinged ${vpsServer.name} (${targetAddress}): ${latency}ms");
          return latency;
        }
      }

      // If no successful ping
      return 9999;
    } catch (e) {
      log("Ping error for ${vpsServer.name}: $e");
      return 9999;
    }
  }

  // Ping all free servers and return the one with lowest latency
  Future<void> selectFastestServerByPing() async {
    try {
      if (servers.isEmpty) {
        log("No servers available for ping test");
        return;
      }

      log("Starting ping test for fastest free server selection...");

      int bestServerIndex = 0;
      int bestSubServerIndex = 0;
      int lowestPing = 9999;

      for (int i = 0; i < servers.length; i++) {
        final server = servers[i];

        // Only test free servers
        if (server.type.toLowerCase() != 'free') {
          continue;
        }

        if (server.subServers == null || server.subServers!.isEmpty) {
          continue;
        }

        for (int j = 0; j < server.subServers!.length; j++) {
          final subServer = server.subServers![j];

          if (subServer.vpsGroup?.servers == null ||
              subServer.vpsGroup!.servers!.isEmpty) {
            continue;
          }

          // Find primary server or first active server
          VpsServer? serverToPing;
          for (var vpsServer in subServer.vpsGroup!.servers!) {
            if (vpsServer.role.toLowerCase() == 'primary' && vpsServer.status) {
              serverToPing = vpsServer;
              break;
            }
          }

          if (serverToPing == null) {
            serverToPing = subServer.vpsGroup!.servers!.firstWhere(
              (s) => s.status,
              orElse: () => subServer.vpsGroup!.servers!.first,
            );
          }

          // Ping this server
          final latency = await pingVpsServer(serverToPing);

          if (latency < lowestPing) {
            lowestPing = latency;
            bestServerIndex = i;
            bestSubServerIndex = j;
          }
        }
      }

      if (lowestPing < 9999) {
        selectedServerIndex = bestServerIndex;
        selectedSubServerIndex = bestSubServerIndex;
        isManuallySelected = false;

        log(
          "Selected fastest server by ping: ${servers[bestServerIndex].name} "
          "with ${lowestPing}ms latency",
        );

        notifyListeners();
      } else {
        log("No reachable servers found, falling back to health score");
        await selectFastestServerByHealth();
      }
    } catch (e) {
      log("Error in selectFastestServerByPing: $e");
      // Fallback to health score based selection
      await selectFastestServerByHealth();
    }
  }

  // Ping all servers once and store results in Server.pingMs
  Future<void> pingAllServers() async {
    if (servers.isEmpty) {
      log("No servers to ping");
      return;
    }

    isPingingServers = true;
    notifyListeners();

    log("Pinging all servers (one-time)...");

    for (int i = 0; i < servers.length; i++) {
      final server = servers[i];

      if (server.subServers == null || server.subServers!.isEmpty) {
        server.pingMs = 9999;
        continue;
      }

      // Ping the first subserver's primary VPS
      final subServer = server.subServers![0];

      if (subServer.vpsGroup?.servers == null ||
          subServer.vpsGroup!.servers!.isEmpty) {
        server.pingMs = 9999;
        continue;
      }

      // Find primary server or first active server
      VpsServer? serverToPing;
      for (var vpsServer in subServer.vpsGroup!.servers!) {
        if (vpsServer.role.toLowerCase() == 'primary' && vpsServer.status) {
          serverToPing = vpsServer;
          break;
        }
      }

      if (serverToPing == null) {
        serverToPing = subServer.vpsGroup!.servers!.firstWhere(
          (s) => s.status,
          orElse: () => subServer.vpsGroup!.servers!.first,
        );
      }

      // Ping this server
      final latency = await pingVpsServer(serverToPing);
      server.pingMs = latency;

      log("${server.name}: ${latency}ms");

      // Update UI after each ping so user sees progress
      notifyListeners();
    }

    isPingingServers = false;
    notifyListeners();
    log("Finished pinging all servers");
  }

  // Start connection timer
  void startConnectionTimer() {
    if (_connectionTimer != null) {
      log("Connection timer already running at $connectionDuration seconds");
      return; // Don't restart if already running
    }
    connectionDuration = 0; // Reset to 0 when starting fresh
    log("Starting connection timer from 0");
    _connectionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      connectionDuration++;
      notifyListeners();
    });
  }

  // Stop connection timer
  void stopConnectionTimer() {
    if (_connectionTimer != null) {
      log("Stopping connection timer at $connectionDuration seconds");
      _connectionTimer?.cancel();
      _connectionTimer = null;
    }
    connectionDuration = 0; // Reset to 0 when stopping
    notifyListeners();
  }

  // Format connection duration
  String getFormattedConnectionTime() {
    int hours = connectionDuration ~/ 3600;
    int minutes = (connectionDuration % 3600) ~/ 60;
    int secs = connectionDuration % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
