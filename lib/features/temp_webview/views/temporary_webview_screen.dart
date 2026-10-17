import 'dart:io' show Platform;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../../core/constants/temp_webview_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/common_widgets.dart';

/// Temporary WebView screen for website functionality testing only.
class TemporaryWebViewScreen extends StatefulWidget {
  const TemporaryWebViewScreen({super.key});

  @override
  State<TemporaryWebViewScreen> createState() => _TemporaryWebViewScreenState();
}

class _TemporaryWebViewScreenState extends State<TemporaryWebViewScreen> {
  WebViewController? _controller;
  var _progress = 0;
  var _hasError = false;
  var _isLoading = true;
  var _loadFailed = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🌐 Opening Temporary WebView');
    debugPrint('URL:\n$kTemporaryWebViewUrl');
    _setupController();
  }

  void _setupController() {
    late final PlatformWebViewControllerCreationParams params;
    if (!kIsWeb && Platform.isIOS) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            debugPrint('📄 Page Loading');
            _loadFailed = false;
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _hasError = false;
              _progress = 0;
            });
          },
          onProgress: (progress) {
            if (!mounted) return;
            setState(() => _progress = progress);
          },
          onPageFinished: (_) {
            // Chromium still fires onPageFinished after SSL failure (blank/error page).
            if (_loadFailed) {
              debugPrint('❌ Page Failed');
              if (!mounted) return;
              setState(() {
                _hasError = true;
                _isLoading = false;
              });
              return;
            }
            debugPrint('✅ Page Loaded Successfully');
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              _progress = 100;
              _hasError = false;
            });
          },
          onWebResourceError: (error) {
            final isMainFrame = error.isForMainFrame ?? true;
            if (!isMainFrame) return;
            _loadFailed = true;
            debugPrint('❌ Page Failed');
            debugPrint(
              'errorCode=${error.errorCode} type=${error.errorType} '
              'desc=${error.description}',
            );
            if (!mounted) return;
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          },
          // TEMPORARY TESTING ONLY — site uses a self-signed certificate.
          // Do NOT keep proceed() in production.
          onSslAuthError: (error) async {
            debugPrint(
              '⚠️ SSL auth error (self-signed cert). Proceeding for temp testing.',
            );
            await error.proceed();
          },
        ),
      );

    if (controller.platform is AndroidWebViewController) {
      final android = controller.platform as AndroidWebViewController;
      AndroidWebViewController.enableDebugging(true);
      android.setMediaPlaybackRequiresUserGesture(false);
      android.setTextZoom(100);
      android.setOnShowFileSelector((params) async {
        final result = await FilePicker.pickFiles(
          allowMultiple: params.mode == FileSelectorMode.openMultiple,
        );
        if (result == null) return <String>[];
        return result.paths
            .whereType<String>()
            .map((path) => Uri.file(path).toString())
            .toList();
      });
    }

    if (controller.platform is WebKitWebViewController) {
      final ios = controller.platform as WebKitWebViewController;
      ios.setAllowsBackForwardNavigationGestures(true);
    }

    controller.loadRequest(Uri.parse(kTemporaryWebViewUrl));
    _controller = controller;
  }

  Future<void> _reload() async {
    debugPrint('📄 Page Loading');
    _loadFailed = false;
    setState(() {
      _hasError = false;
      _isLoading = true;
      _progress = 0;
    });
    await _controller?.loadRequest(Uri.parse(kTemporaryWebViewUrl));
  }

  Future<void> _handleBack() async {
    final controller = _controller;
    if (controller != null && await controller.canGoBack()) {
      await controller.goBack();
      return;
    }
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _hasError
              ? _ErrorView(onRetry: _reload)
              : _controller == null
                  ? const SizedBox.shrink()
                  : Stack(
                      children: [
                        WebViewWidget(controller: _controller!),
                        if (_isLoading || (_progress > 0 && _progress < 100))
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(
                              value: _progress > 0 ? _progress / 100 : null,
                              minHeight: 2.5,
                              backgroundColor: AppColors.border,
                              color: AppColors.primaryDark,
                            ),
                          ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 20),
            const Text(
              'Unable to load website',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check your connection or retry.\n(Self-signed SSL may need trust.)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.caption,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: PrimaryButton(label: 'Retry', onPressed: onRetry),
            ),
          ],
        ),
      ),
    );
  }
}
