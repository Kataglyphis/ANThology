import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:anthology/Layout/ResponsiveDesign/single_page.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/app_attributes.dart';

class OpenSourceLicensesPage extends StatefulWidget {
  const OpenSourceLicensesPage({
    super.key,
    required this.footer,
    required this.appAttributes,
    required this.descriptionTextBuilder,
    required this.errorTextBuilder,
    required this.emptyTextBuilder,
  });

  final Footer footer;
  final AppAttributes appAttributes;
  final String Function(BuildContext) descriptionTextBuilder;
  final String Function(BuildContext) errorTextBuilder;
  final String Function(BuildContext) emptyTextBuilder;

  @override
  State<StatefulWidget> createState() => _OpenSourceLicensesPageState();
}

class _OpenSourceLicensesPageState extends State<OpenSourceLicensesPage> {
  late final Future<List<_PackageLicense>> _licensesFuture;

  @override
  void initState() {
    super.initState();
    _licensesFuture = _loadLicenses();
  }

  Future<List<_PackageLicense>> _loadLicenses() async {
    final Map<String, Set<String>> packageToLicenses = <String, Set<String>>{};

    await for (final LicenseEntry entry in LicenseRegistry.licenses) {
      final String text = entry.paragraphs
          .map((LicenseParagraph paragraph) => paragraph.text)
          .join('\n\n')
          .trim();
      if (text.isEmpty) {
        continue;
      }

      for (final String packageName in entry.packages) {
        packageToLicenses.putIfAbsent(packageName, () => <String>{}).add(text);
      }
    }

    final List<_PackageLicense> licenses =
        packageToLicenses.entries
            .map(
              (MapEntry<String, Set<String>> entry) => _PackageLicense(
                packageName: entry.key,
                licenseText: entry.value.join(
                  '\n\n------------------------------\n\n',
                ),
              ),
            )
            .toList()
          ..sort(
            (_PackageLicense a, _PackageLicense b) => a.packageName
                .toLowerCase()
                .compareTo(b.packageName.toLowerCase()),
          );

    return licenses;
  }

  @override
  Widget build(BuildContext context) {
    return SinglePage(
      footer: widget.footer,
      appAttributes: widget.appAttributes,
      showMediumSizeLayout: widget.appAttributes.showMediumSizeLayout,
      showLargeSizeLayout: widget.appAttributes.showLargeSizeLayout,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            widget.descriptionTextBuilder(context),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        FutureBuilder<List<_PackageLicense>>(
          future: _licensesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.errorTextBuilder(context),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            final List<_PackageLicense> licenses =
                snapshot.data ?? <_PackageLicense>[];
            if (licenses.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.emptyTextBuilder(context),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: licenses.length,
              itemBuilder: (BuildContext context, int index) {
                final _PackageLicense packageLicense = licenses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: ExpansionTile(
                    title: Text(packageLicense.packageName),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: SelectableText(packageLicense.licenseText),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _PackageLicense {
  _PackageLicense({required this.packageName, required this.licenseText});

  final String packageName;
  final String licenseText;
}
