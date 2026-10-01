import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dhikr_model.dart';
import '../services/localization_service.dart';
import '../services/storage_service.dart';

class DhikrListScreen extends StatefulWidget {
  final StorageService storageService;
  final DhikrModel activeDhikr;
  final String languageCode;
  final Function(DhikrModel) onSelectDhikr;

  const DhikrListScreen({
    super.key,
    required this.storageService,
    required this.activeDhikr,
    required this.languageCode,
    required this.onSelectDhikr,
  });

  @override
  State<DhikrListScreen> createState() => _DhikrListScreenState();
}

class _DhikrListScreenState extends State<DhikrListScreen> {
  late List<DhikrModel> _dhikrs;
  String _selectedCategoryKey = 'all';

  @override
  void initState() {
    super.initState();
    _loadDhikrs();
  }

  void _loadDhikrs() {
    setState(() {
      _dhikrs = widget.storageService.getDhikrs();
    });
  }

  void _addCustomDhikrDialog() {
    final lang = widget.languageCode;
    final titleController = TextEditingController();
    final arabicController = TextEditingController();
    final targetController = TextEditingController(text: '100');
    final meaningController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          LocalizationService.get('addCustomDhikr', lang),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: LocalizationService.get('titleLabel', lang),
                  hintText: "Örn: Lâ Havle...",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: arabicController,
                style: const TextStyle(color: Colors.white),
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: LocalizationService.get('arabicLabel', lang),
                  hintText: "لَا حَوْلَ...",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: LocalizationService.get('targetLabel', lang),
                  hintText: "33, 99, 100...",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: meaningController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: LocalizationService.get('meaningLabel', lang),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              LocalizationService.get('cancel', lang),
              style: GoogleFonts.outfit(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) return;
              final target = int.tryParse(targetController.text) ?? 100;

              final newDhikr = DhikrModel(
                id: "custom_${DateTime.now().millisecondsSinceEpoch}",
                title: title,
                arabic: arabicController.text.trim(),
                meaning: meaningController.text.trim(),
                virtue: 'Özel Zikrim',
                target: target,
                isCustom: true,
                category: 'Özel Zikirler',
              );

              final updated = [..._dhikrs, newDhikr];
              widget.storageService.saveDhikrs(updated);
              Navigator.pop(ctx);
              _loadDhikrs();
              widget.onSelectDhikr(newDhikr);
            },
            child: Text(
              LocalizationService.get('addAndSelect', lang),
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteDhikr(DhikrModel dhikr) {
    final lang = widget.languageCode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(LocalizationService.get('delete', lang),
            style: GoogleFonts.outfit(color: Colors.white)),
        content: Text(
          LocalizationService.get('deleteConfirm', lang)
              .replaceAll('{name}', LocalizationService.getDhikrTitle(dhikr, lang)),
          style: GoogleFonts.outfit(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocalizationService.get('cancel', lang),
                style: GoogleFonts.outfit(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              final updated = _dhikrs.where((d) => d.id != dhikr.id).toList();
              widget.storageService.saveDhikrs(updated);
              _loadDhikrs();
              if (widget.activeDhikr.id == dhikr.id && updated.isNotEmpty) {
                widget.onSelectDhikr(updated.first);
              }
            },
            child: Text(LocalizationService.get('delete', lang)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final lang = widget.languageCode;

    final categoryKeys = [
      {'key': 'all', 'label': LocalizationService.get('allCategories', lang)},
      {
        'key': 'Namaz Tesbihatı',
        'label': LocalizationService.get('prayerTesbihat', lang)
      },
      {
        'key': 'Günün Zikirleri',
        'label': LocalizationService.get('dailyDhikrCat', lang)
      },
      {
        'key': 'Esmâ-ül Hüsnâ',
        'label': LocalizationService.get('esmaulHusna', lang)
      },
      {
        'key': 'Özel Zikirler',
        'label': LocalizationService.get('customDhikrsCat', lang)
      },
    ];

    final filteredDhikrs = _selectedCategoryKey == 'all'
        ? _dhikrs
        : _dhikrs.where((d) => d.category == _selectedCategoryKey).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.get('tabDhikrs', lang)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCustomDhikrDialog,
        backgroundColor: primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          LocalizationService.get('addCustomDhikr', lang),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Category chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: categoryKeys.map((cat) {
                final isSelected = _selectedCategoryKey == cat['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    selectedColor: primary.withValues(alpha: 0.25),
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    labelStyle: GoogleFonts.outfit(
                      color: isSelected ? primary : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? primary : Colors.transparent,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategoryKey = cat['key']!);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Dhikrs list
          Expanded(
            child: filteredDhikrs.isEmpty
                ? Center(
                    child: Text(
                      "Kayıtlı zikir bulunamadı.",
                      style: GoogleFonts.outfit(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: filteredDhikrs.length,
                    itemBuilder: (context, index) {
                      final item = filteredDhikrs[index];
                      final isActive = item.id == widget.activeDhikr.id;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isActive ? primary : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            widget.onSelectDhikr(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "\"${item.title}\" sayaca aktarıldı.",
                                  style: GoogleFonts.outfit(),
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Progress or count circle
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isActive
                                        ? primary.withValues(alpha: 0.2)
                                        : Colors.white.withValues(alpha: 0.06),
                                    border: Border.all(
                                      color: isActive
                                          ? primary
                                          : Colors.white24,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${item.count}",
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color:
                                          isActive ? primary : Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Title and Arabic
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocalizationService.getDhikrTitle(item, lang),
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (item.arabic.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          item.arabic,
                                          style: GoogleFonts.amiri(
                                            fontSize: 16,
                                            color: secondary,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 4),
                                      Text(
                                        "${LocalizationService.get('goal', lang)}: ${item.target} • ${LocalizationService.get('total', lang)}: ${item.totalCount}",
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Actions
                                if (item.isCustom)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                    onPressed: () => _deleteDhikr(item),
                                  )
                                else if (isActive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: primary.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Aktif",
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
