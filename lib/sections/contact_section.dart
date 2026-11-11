import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/open.dart';
import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hover_card.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';
import '../widgets/section_shell.dart';

/// Limits mirrored in firestore.rules — keep both in sync.
abstract final class ContactLimits {
  static const name = 100;
  static const email = 254;
  static const message = 2000;
}

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    _formKey.currentState?.reset();
  }

  Future<void> _submit() async {
    if (_sending || !(_formKey.currentState?.validate() ?? false)) return;

    if (!kIsWeb) {
      // Firebase is only configured for web; compose an email instead.
      await _sendByEmail();
      return;
    }

    setState(() => _sending = true);
    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .add({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'message': _messageController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 20));
      if (!mounted) return;
      _clearForm();
      _showSnack("Thanks for reaching out — I'll get back to you soon!");
    } catch (error) {
      // Network stall or rejected write: fall back to the visitor's email
      // client so the message isn't lost.
      debugPrint('Firestore submit error: $error');
      await _sendByEmail(fallback: true);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  /// Opens a pre-filled email. The form is kept, since we can't know whether
  /// the visitor actually sends it.
  Future<void> _sendByEmail({bool fallback = false}) async {
    final name = _nameController.text.trim();
    final uri = Uri(
      scheme: 'mailto',
      path: AppLinks.email,
      query: _encodeQuery({
        'subject': 'Portfolio message from $name',
        'body':
            'Name: $name\nEmail: ${_emailController.text.trim()}\n\n'
            '${_messageController.text.trim()}',
      }),
    );
    await openUrl(uri.toString());
    if (!mounted) return;
    _showSnack(
      fallback
          ? "Couldn't reach the server, so I've opened your email app — hit send there and I'll get it!"
          : "I've opened your email app with the message filled in — just hit send.",
    );
  }

  // Uri(queryParameters:) encodes spaces as '+', which mail clients show
  // literally; encode with %20 instead.
  static String _encodeQuery(Map<String, String> params) => params.entries
      .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
      .join('&');

  @override
  Widget build(BuildContext context) {
    final wide = deviceOf(context) == DeviceType.desktop;
    final form = _ContactForm(
      formKey: _formKey,
      nameController: _nameController,
      emailController: _emailController,
      messageController: _messageController,
      sending: _sending,
      onSubmit: _submit,
    );

    return SectionShell(
      heading: const SectionHeading(
        order: '06',
        label: 'Contact',
        title: 'Get in Touch',
        subtitle:
            "Have a project in mind or want to discuss opportunities? I'd love to hear from you.",
      ),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 4, child: _ContactLinks()),
                const SizedBox(width: 40),
                Expanded(flex: 5, child: form),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _ContactLinks(),
                const SizedBox(height: 40),
                form,
              ],
            ),
    );
  }
}

class _ContactLinks extends StatelessWidget {
  const _ContactLinks();

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < contactLinks.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == contactLinks.length - 1 ? 0 : 12,
              ),
              child: ScrollReveal(
                delay: Duration(milliseconds: 50 * i),
                offsetY: 12,
                child: _ContactLinkCard(link: contactLinks[i]),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContactLinkCard extends StatelessWidget {
  const _ContactLinkCard({required this.link});

  final ContactLink link;

  @override
  Widget build(BuildContext context) {
    final url = link.url;
    return HoverCard(
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      onTap: url == null ? null : () => openUrl(url),
      isLink: true,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.cyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(link.icon, size: 17, color: AppColors.cyan),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  link.label,
                  style: AppText.display(13, weight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  link.value,
                  style: AppText.mono(12, letterSpacing: 0.4),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (url != null)
            const Icon(
              Icons.open_in_new_rounded,
              size: 15,
              color: AppColors.textMuted,
            ),
        ],
      ),
    );
  }
}

class _ContactForm extends StatelessWidget {
  const _ContactForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.messageController,
    required this.sending,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final bool sending;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      offsetY: 22,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Form(
          key: formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Send a Message',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                _FormTextField(
                  controller: nameController,
                  label: 'Your Name',
                  hint: 'e.g. Priya Sharma',
                  icon: Icons.person_outline_rounded,
                  maxLength: ContactLimits.name,
                  autofillHints: const [AutofillHints.name],
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 18),
                _FormTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'you@example.com',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: ContactLimits.email,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Please enter an email';
                    if (!_emailPattern.hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                _FormTextField(
                  controller: messageController,
                  label: 'Message',
                  hint: 'How can I help?',
                  icon: Icons.chat_bubble_outline_rounded,
                  maxLines: 5,
                  maxLength: ContactLimits.message,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter a message'
                      : null,
                ),
                const SizedBox(height: 24),
                GradientButton(
                  label: sending ? 'Sending…' : 'Send Message',
                  icon: Icons.send_rounded,
                  loading: sending,
                  onPressed: onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormTextField extends StatelessWidget {
  const _FormTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.maxLength,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.autofillHints,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLength;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        prefixIcon: Icon(icon, size: 17, color: AppColors.textMuted),
      ),
    );
  }
}
