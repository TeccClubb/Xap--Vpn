import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:safeprovpn/Utils/urls.dart';
import 'package:xap_vpn/Defaults/utils.dart';

class WireguardApiService {
  /// Base URL
  final String baseUrl;

  WireguardApiService({required this.baseUrl});

  /// Get headers with API key
  Map<String, String> get _headers => {
    'X-API-Token': VPS_API_KEY,
    'Content-Type': 'application/json',
  };

  /// Generate a new client (create user)
  /// Returns the WireGuard configuration
  Future<WireguardClientConfig> generateClient(String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/clients/generate'),
        headers: _headers,
        body: jsonEncode({'name': name}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return WireguardClientConfig.fromJson(data);
      } else {
        throw Exception(
          'Failed to generate client: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error generating client: $e');
    }
  }

  /// Get client config
  /// Returns null if client config not found (404)
  Future<WireguardClientConfig?> getClientConfig(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/clients/$name'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WireguardClientConfig.fromJson(data);
      } else if (response.statusCode == 404) {
        // Client config not found
        return null;
      } else {
        throw Exception(
          'Failed to get client config: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error getting client config: $e');
    }
  }

  /// Delete a client
  /// Returns true if successful
  Future<bool> deleteClient(String name) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/clients/$name'),
        headers: _headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete client: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting client: $e');
    }
  }

  /// Get or create client config
  /// 1. Try to get config
  /// 2. If 404 (not found), generate client
  /// Returns the WireGuard config
  Future<WireguardClientConfig> getOrCreateClient(String name) async {
    // Try to get existing config
    WireguardClientConfig? config = await getClientConfig(name);

    if (config == null) {
      // Config not found, generate new client
      config = await generateClient(name);
    }

    return config;
  }
}

/// Model class for WireGuard client configuration
class WireguardClientConfig {
  final String config; // Raw WireGuard config
  final String ip;
  final String name;
  final String qrCode; // Base64 QR code image

  WireguardClientConfig({
    required this.config,
    required this.ip,
    required this.name,
    required this.qrCode,
  });

  factory WireguardClientConfig.fromJson(Map<String, dynamic> json) {
    return WireguardClientConfig(
      config: json['config'] ?? '',
      ip: json['ip'] ?? '',
      name: json['name'] ?? '',
      qrCode: json['qr_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'config': config, 'ip': ip, 'name': name, 'qr_code': qrCode};
  }

  @override
  String toString() {
    return 'WireguardClientConfig(name: $name, ip: $ip, configLength: ${config.length} bytes)';
  }
}

/// Parsed WireGuard configuration
class ParsedWireguardConfig {
  final String privateKey;
  final String address;
  final String peerPublicKey;
  final String peerAddress; // Server IP from Endpoint
  final int peerPort; // Server port from Endpoint
  final String dns;

  ParsedWireguardConfig({
    required this.privateKey,
    required this.address,
    required this.peerPublicKey,
    required this.peerAddress,
    required this.peerPort,
    required this.dns,
  });

  @override
  String toString() {
    return 'ParsedWireguardConfig(address: $address, peerAddress: $peerAddress:$peerPort)';
  }
}
