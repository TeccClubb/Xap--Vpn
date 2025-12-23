import 'package:flutter/material.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

class WireguardEngine with ChangeNotifier {
  // Wireguard specific implementation will go here
  var _wireguard = WireGuardFlutter.instance;

  // Initialize Wireguard
  Future<void> initializeWireguard() async {
    await _wireguard.initialize(interfaceName: 'SafeProVPN');
  }

  // Start VPN connection
  Future<void> startVpn(String config, address) async {
    await initializeWireguard();
    await _wireguard.startVpn(
      wgQuickConfig: config,
      serverAddress: address,
      providerBundleIdentifier: "com.safeprovpn.ios.PacketTunnel",
    );
  }

  // Stop VPN connection
  Future<void> stopVpn() async {
    await _wireguard.stopVpn();
  }

  // Get VPN connection status
  Future<VpnStage> getVpnStatus() async {
    return await _wireguard.stage();
  }

  // Listen to VPN status changes
  Stream<VpnStage> get vpnStatusStream {
    return _wireguard.vpnStageSnapshot;
  }
}
