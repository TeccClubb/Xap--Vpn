// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'wireguard_api_service.dart';

class WireguardService {
  /// Generate and store username in SharedPreferences
  static Future<String> generateAndStoreUsername() async {
    final username = 'user_${Uuid().v4().substring(0, 8)}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', username);
    return username;
  }

  /// Get username from SharedPreferences or generate if not exists
  static Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('name');
    if (username == null || username.isEmpty) {
      username = await generateAndStoreUsername();
    }
    return username;
  }

  /// Get username with platform suffix for identification
  static Future<String> getUsernameWithPlatform() async {
    String username = await getUsername();
    String platform = Platform.operatingSystem;
    return username + '_$platform';
  }

  /// Parse WireGuard config to extract necessary parameters
  /// Parses the [Interface] and [Peer] sections
  static ParsedWireguardConfig parseWireguardConfig(String config) {
    String privateKey = '';
    String address = '';
    String dns = '';
    String peerPublicKey = '';
    String peerAddress = '';
    int peerPort = 443;

    // Split config into lines
    List<String> lines = config.split('\n');

    for (String line in lines) {
      line = line.trim();

      // Parse Interface section
      if (line.startsWith('PrivateKey')) {
        privateKey = line.split('=')[1].trim();
      } else if (line.startsWith('Address')) {
        address = line.split('=')[1].trim();
        // // Remove /16 or /24 suffix if present, keep only IP
        // if (address.contains('/')) {
        //   address = address.split('/')[0].trim();
        // }
      } else if (line.startsWith('DNS')) {
        dns = line.split('=')[1].trim();
      }
      // Parse Peer section
      else if (line.startsWith('PublicKey')) {
        peerPublicKey = line.split('=')[1].trim();
      } else if (line.startsWith('Endpoint')) {
        String endpoint = line.split('=')[1].trim();
        // Endpoint format: "91.98.230.114:443"
        if (endpoint.contains(':')) {
          List<String> parts = endpoint.split(':');
          peerAddress = parts[0].trim();
          peerPort = int.tryParse(parts[1].trim()) ?? 51820;
        }
      }
    }

    return ParsedWireguardConfig(
      privateKey: privateKey + "=",
      address: address,
      peerPublicKey: peerPublicKey + "=",
      peerAddress: peerAddress,
      peerPort: peerPort,
      dns: dns,
    );
  }

  /// Fetch or create WireGuard client configuration from the server
  /// Returns the complete client configuration
  static Future<WireguardClientConfig> fetchOrCreateClientConfig({
    required String serverUrl,
  }) async {
    // Get username with platform suffix
    String username = await getUsernameWithPlatform();

    // Initialize API service
    WireguardApiService apiService = WireguardApiService(baseUrl: serverUrl);

    // Get or create client configuration
    WireguardClientConfig config = await apiService.getOrCreateClient(username);

    return config;
  }

  /// Generate complete WireGuard configuration JSON for SafePro
  /// Uses the client configuration from the server and parses it
  static Future<String> generateWireguardConfig({
    required String serverUrl,
  }) async {
    // Fetch or create client configuration
    WireguardClientConfig clientConfig = await fetchOrCreateClientConfig(
      serverUrl: serverUrl,
    );

    // Parse the WireGuard config to extract parameters
    ParsedWireguardConfig parsed = parseWireguardConfig(clientConfig.config);

    // Get ad blocker status from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool adBlockerEnabled = prefs.getBool('adBlockerEnabled') ?? false;

    // Generate and return the SafePro WireGuard configuration
    return jsonEncode({
      'config': clientConfig.config,
      'ip': parsed.address,
      'name': clientConfig.name,
      'qr_code': clientConfig.qrCode,
      'private_key': parsed.privateKey,
      'address': parsed.address,
      'peer_public_key': parsed.peerPublicKey,
      'peer_address': parsed.peerAddress,
      'peer_port': parsed.peerPort,
      'dns': parsed.dns,
      'ad_blocker_enabled': adBlockerEnabled,
    });
  }

  /// Get WireGuard configuration as a JSON string
  /// This is the main entry point for getting WireGuard config
  /// @param serverUrl: Base URL for the API (e.g., "http://your-server.com:5000")
  static Future<String> getWireguardConfigJson({
    required String serverUrl,
  }) async {
    return await generateWireguardConfig(serverUrl: serverUrl);
  }

  /// Get the complete client configuration object
  /// Useful for accessing individual configuration parameters
  static Future<WireguardClientConfig> getClientConfig({
    required String serverUrl,
  }) async {
    return await fetchOrCreateClientConfig(serverUrl: serverUrl);
  }

  /// Get parsed WireGuard configuration with all extracted parameters
  static Future<ParsedWireguardConfig> getParsedConfig({
    required String serverUrl,
  }) async {
    WireguardClientConfig clientConfig = await fetchOrCreateClientConfig(
      serverUrl: serverUrl,
    );
    return parseWireguardConfig(clientConfig.config);
  }

  /// Check if client config exists on server
  /// Returns true if config exists, false otherwise
  static Future<bool> configExists({required String serverUrl}) async {
    try {
      String username = await getUsernameWithPlatform();
      WireguardApiService apiService = WireguardApiService(baseUrl: serverUrl);

      WireguardClientConfig? config = await apiService.getClientConfig(
        username,
      );
      return config != null;
    } catch (e) {
      return false;
    }
  }

  /// Delete current client from server
  /// Returns true if successful
  static Future<bool> deleteClient({required String serverUrl}) async {
    try {
      String username = await getUsernameWithPlatform();
      WireguardApiService apiService = WireguardApiService(baseUrl: serverUrl);

      return await apiService.deleteClient(username);
    } catch (e) {
      throw Exception('Error deleting client: $e');
    }
  }

  /// Reset username (generate new username)
  static Future<void> resetCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
  }

  /// Get stored username
  static Future<String> getStoredUsername() async {
    return await getUsername();
  }

  /// Get the raw WireGuard config (not SafePro format)
  /// Returns the standard WireGuard .conf format
  static Future<String> getRawWireguardConfig({
    required String serverUrl,
  }) async {
    WireguardClientConfig clientConfig = await fetchOrCreateClientConfig(
      serverUrl: serverUrl,
    );
    return clientConfig.config;
  }

  /// Get QR code for WireGuard config (base64 image)
  static Future<String> getQrCode({required String serverUrl}) async {
    WireguardClientConfig clientConfig = await fetchOrCreateClientConfig(
      serverUrl: serverUrl,
    );
    return clientConfig.qrCode;
  }
}
