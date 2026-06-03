import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:skillbantuin/services/marketplace_service.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String redirectUrl;
  final String orderId;

  const PaymentWebViewScreen({
    super.key,
    required this.redirectUrl,
    required this.orderId,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  final MarketplaceService _marketplaceService = MarketplaceService();
  bool _isPolling = false;
  bool _isCompleted = false;
  bool _isCheckingStatus = false;

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
    _startPolling();
  }

  void _startPolling() {
    if (_isPolling) return;
    _isPolling = true;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted || _isCompleted) return false;
      final done = await _checkPaymentStatus(showPendingMessage: false);
      return !done;
    });
  }

  Future<bool> _checkPaymentStatus({required bool showPendingMessage}) async {
    if (_isCompleted) return true;

    if (showPendingMessage) {
      setState(() => _isCheckingStatus = true);
    }

    try {
      final status = await _marketplaceService.fetchTransactionStatus(
        widget.orderId,
      );
      final normalizedStatus = status.toLowerCase();

      if (normalizedStatus == 'settlement' || normalizedStatus == 'capture') {
        _isCompleted = true;
        if (!mounted) return true;
        Navigator.pop(context, 'success');
        return true;
      }

      if (normalizedStatus == 'expire' ||
          normalizedStatus == 'failed' ||
          normalizedStatus == 'deny' ||
          normalizedStatus == 'cancel') {
        _isCompleted = true;
        if (!mounted) return true;
        Navigator.pop(context, 'failed');
        return true;
      }

      if (showPendingMessage && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              normalizedStatus == 'pending'
                  ? 'Pembayaran masih pending di Midtrans.'
                  : 'Status pembayaran: $status',
            ),
          ),
        );
      }
      return false;
    } catch (error) {
      if (showPendingMessage && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
      return false;
    } finally {
      if (showPendingMessage && mounted) {
        setState(() => _isCheckingStatus = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Midtrans'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, 'pending'),
          icon: const Icon(Icons.close_rounded),
        ),
        actions: [
          TextButton(
            onPressed: _isCheckingStatus
                ? null
                : () => _checkPaymentStatus(showPendingMessage: true),
            child: _isCheckingStatus
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Cek Status'),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
