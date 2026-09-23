import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/anchors.dart';
import '../core/open.dart';
import '../core/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hover_card.dart';
import '../widgets/scroll_reveal.dart';
import '../widgets/section_heading.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({
    super.key,
    required this.anchors,
    required this.controller,
  });

  final Anchors anchors;
  final ScrollController controller;

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _submit();
    }
  }

  Future<void> _submit() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sending your message…')),
    );
    if (!kIsWeb) {
      // Desktop / mobile: Firebase isn't configured here, so compose the
      // message in the user's email client instead.
      _sendByEmail();
      return;
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thanks for reaching out — I\'ll get back to you soon!'),
        ),
      );
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    } on TimeoutException {
      // Request stalled on the network — fall back to email so the message
      // isn't lost.
      _sendByEmail(showInfo: true);
    } catch (error) {
      // Database write failed, fall back to email so the visitor can still
      // get in touch.
      debugPrint('Firestore submit error: $error');
      _sendByEmail(showInfo: true);
    }
  }

  void _sendByEmail({bool showInfo = false}) {
    final subject = Uri.encodeComponent(
      'Portfolio message from ${_nameController.text.trim()}',
    );
    final body = Uri.encodeComponent(
      'Name: ${_nameController.text.trim()}\n'
      'Email: ${_emailController.text.trim()}\n\n'
      '${_messageController.text.trim()}',
    );
    openUrl('${AppLinks.mailto}?subject=$subject&body=$body');
    if (!mounted) return;
    if (showInfo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Couldn\'t reach the server, so I\'ve opened your email — '
            'hit send there and I\'ll get it!',
          ),
        ),
      );
    }
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final padding = contentPaddingOf(context);
    final wide = deviceOf(context) == DeviceType.desktop;

    return Container(
      key: widget.anchors.contact,
      padding: EdgeInsets.fromLTRB(padding, 56, padding, 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollReveal(
                controller: widget.controller,
                child: const SectionHeading(
                  order: '06',
                  label: 'Contact',
                  title: 'Get in Touch',
                  subtitle:
                      'Have a project in mind or want to discuss opportunities? I\'d love to hear from you.',
                ),
              ),
              const SizedBox(height: 36),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _ContactLinks(controller: widget.controller)),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 5,
                      child: _ContactForm(
                        formKey: _formKey,
                        nameController: _nameController,
                        emailController: _emailController,
                        messageController: _messageController,
                        onSubmit: _handleSubmit,
                        controller: widget.controller,
                      ),
                    ),
                  ],
                )
              else ...[
                _ContactLinks(controller: widget.controller),
                const SizedBox(height: 40),
                _ContactForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  messageController: _messageController,
                  onSubmit: _handleSubmit,
                  controller: widget.controller,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactLinks extends StatelessWidget {
  const _ContactLinks({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      controller: controller,
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
              padding: EdgeInsets.only(bottom: i == contactLinks.length - 1 ? 0 : 12),
              child: ScrollReveal(
                controller: controller,
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
    final hasUrl = link.url != null;
    return HoverCard(
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      onTap: hasUrl ? () => openUrl(link.url!) : null,
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
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 13, fontFamily: AppText.displayFont),
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
          if (hasUrl)
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
    required this.onSubmit,
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final VoidCallback onSubmit;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      controller: controller,
      offsetY: 22,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.cyan.withValues(alpha: 0.04),
              blurRadius: 36,
              spreadRadius: -10,
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send a Message',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _FormTextField(
                controller: nameController,
                label: 'Your Name',
                hint: 'e.g. Amrut',
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 18),
              _FormTextField(
                controller: emailController,
                label: 'Email',
                hint: 'you@example.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Please enter an email';
                  if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 18),
              _FormTextField(
                controller: messageController,
                label: 'Message',
                hint: 'How can I help?',
                icon: Icons.chat_bubble_outline_rounded,
                maxLines: 4,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Please enter a message' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  label: 'Send Message',
                  icon: Icons.send_rounded,
                  onPressed: onSubmit,
                ),
              ),
            ],
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
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 17, color: AppColors.textMuted),
      ),
    );
  }
}