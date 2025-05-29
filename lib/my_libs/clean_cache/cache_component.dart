import 'package:flutter/material.dart';
import 'package:t_widgets/extensions/index.dart';
import 'package:t_widgets/t_widgets.dart';
import '../setting/t_messenger.dart';
import 'cache_extensions.dart';


import 'cache_services.dart';

class CacheComponent extends StatefulWidget {
  const CacheComponent({super.key});

  @override
  State<CacheComponent> createState() => _CacheComponentState();
}

class _CacheComponentState extends State<CacheComponent> {
  void _clean() async {
    showDialog(
      context: context,
      builder: (ctx) => TConfirmDialog(
        title: 'အတည်ပြုခြင်း',
        contentText: 'Cache ရှင်းချင်တာ သေချာပြီလား?',
        submitText: 'ရှင်းမယ်',
        onSubmit: () async {
          TMessenger.instance.showMessage(ctx, 'Cache Cleaning...');
          await CacheServices.clean();
          // if (!ctx.mounted) return;
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CacheServices.getList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return TLoader();
        }
        final list = snapshot.data ?? [];
        if (list.isEmpty) {
          return const SizedBox.shrink();
        }
        return TListTileWithDesc(
          onClick: _clean,
          leading: const Icon(Icons.storage),
          title: 'Cache',
          desc:
              'Count:${list.length} \nSize: ${list.getSize().toDouble().toFileSizeLabel()}',
        );
      },
    );
  }
}
