import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:skillbantuin/services/marketplace_service.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String redirectUrl;
  final String orderId;
  final Function(String status) onPaymentComplete;

  const PaymentWebViewScreen({
    Key? key,
    required this.redirectUrl,
    required this.orderId,
    required this.onPaymentComplete,
  }) : super(key: key);

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  final MarketplaceService _marketplaceService = MarketplaceService();
  bool _isPolling = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            // Jika URL mengandung '/finish' atau '/success', mulai polling
            if (url.contains('/finish') || url.contains('/success')) {
              _startPolling();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  void _startPolling() {
    if (_isPolling) return;
    _isPolling = true;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      final status = await _marketplaceService.fetchTransactionStatus(widget.orderId);
      if (status == 'settlement') {
        widget.onPaymentComplete('success');
        if (mounted) Navigator.pop(context);
        return false;
      } else if (status == 'expire' || status == 'failed' || status == 'deny') {
        widget.onPaymentComplete('failed');
        if (mounted) Navigator.pop(context);
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Midtrans'),
        automaticallyImplyLeading: false,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}