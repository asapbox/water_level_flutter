import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:level_river/generated/l10n.dart';
import 'package:level_river/pages/home_page/cubit/search_gauge_cubit.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _searchActive = false;
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CupertinoSearchTextField(
              onChanged: (value) => context.read<SearchGaugeCubit>().queryChanged(value),
              // focusNode: _searchFocusNode,
              style: theme.textTheme.bodyText1!.copyWith(fontSize: 16),
              placeholder: S.of(context).searchHomePage,
            ),
          ),
          if (_searchActive)
            TextButton(
              onPressed: null,
              child: Text(
                S.of(context).cancel,
                style: TextStyle(fontSize: 14),
              ),
            )
        ],
      ),
    );
  }
}
