import 'late.dart';
import 'package:flutter/material.dart';

import '../model/selected_list_item.dart';
import 'app_text_field.dart';

class DropDown {
  /// This will give the list of data.
  final List<SelectedListItem> data;

  /// This will give the call back to the selected items from list.
  final Function(List<dynamic>)? selectedItems;

  /// [listBuilder] will gives [index] as a function parameter and you can return your own widget based on [index].
  final Widget Function(int index)? listBuilder;

  /// This will give selection choice for single or multiple for list.
  final bool enableMultipleSelection;

  /// This gives the bottom sheet title.
  final Widget? bottomSheetTitle;

  /// You can set your custom submit button when the multiple selection is enabled.
  final Widget? submitButtonChild;

  /// [searchWidget] is use to show the text box for the searching.
  /// If you are passing your own widget then you must have to add [TextEditingController] for the [TextFormField].
  final TextFormField? searchWidget;

  /// [isSearchVisible] flag use to manage the search widget visibility
  /// by default it is [True] so widget will be visible.
  final bool isSearchVisible;

  /// [searchText] change the default 'Search' to text you want.
  /// by default it is ["Search"]
  final String? searchText;

  /// This will set the background color to the dropdown.
  final Color dropDownBackgroundColor;

  final bool? pagination;

  final int? limitPerPage;

  final bool btnSwitch;

  final List<Widget>? widgetList;

  final Widget? subtitle;

  final bool confirmarBtn;

  final Map<bool, String>? defaultValue;

  DropDown(
      {Key? key,
      required this.data,
      this.selectedItems,
      this.listBuilder,
      this.enableMultipleSelection = false,
      this.bottomSheetTitle,
      this.submitButtonChild,
      this.searchWidget,
      this.isSearchVisible = true,
      this.dropDownBackgroundColor = Colors.transparent,
      this.searchText,
      this.pagination,
      this.limitPerPage,
      this.widgetList,
      this.btnSwitch = false,
      this.subtitle,
      this.confirmarBtn = false,
      this.defaultValue = const {false: ''}});
}

class DropDownState {
  DropDown dropDown;

  DropDownState(this.dropDown);

  /// This gives the bottom sheet widget.
  void showModal(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return MainBody(dropDown: dropDown);
          },
        );
      },
    );
  }
}

/// This is main class to display the bottom sheet body.
class MainBody extends StatefulWidget {
  final DropDown dropDown;

  const MainBody({required this.dropDown, Key? key}) : super(key: key);

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  /// This list will set when the list of data is not available.
  List<SelectedListItem> mainList = [];
  List<String> strList = [];
  final abc = 'abcdefghijklmnopqrstuvwxyz';
  bool switched = false;
  Late<SelectedListItem> selected = Late();

  @override
  void initState() {
    super.initState();
    mainList = widget.dropDown.data;
    for (var element in mainList) {
      strList.add(element.name);
    }
    _setSearchWidgetListener();

    if (widget.dropDown.defaultValue!.keys.first) {
      selected.val = mainList.singleWhere((element) =>
          element.value == widget.dropDown.defaultValue!.values.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.13,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Bottom sheet title text
                  Expanded(
                    child: widget.dropDown.btnSwitch
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              widget.dropDown.bottomSheetTitle ?? Container(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStatePropertyAll(Size(
                                        MediaQuery.of(context).size.width * 0.8,
                                        MediaQuery.of(context).size.height *
                                            0.05)),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.green.shade400),
                                    elevation:
                                        const MaterialStatePropertyAll(4),
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      switched = !switched;
                                    });
                                  },
                                  icon: Icon(
                                    switched
                                        ? Icons.switch_right
                                        : Icons.switch_left,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    switched
                                        ? 'Pesquisar pelo Nome'
                                        : 'Pesquisar pelo ID',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.dropDown.widgetList!.isNotEmpty)
                                for (var element in widget.dropDown.widgetList!)
                                  element
                            ],
                          )
                        : widget.dropDown.confirmarBtn
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  widget.dropDown.bottomSheetTitle ??
                                      Container(),
                                  if (widget.dropDown.widgetList!.isNotEmpty)
                                    for (var element
                                        in widget.dropDown.widgetList!)
                                      element
                                ],
                              )
                            : widget.dropDown.bottomSheetTitle ?? Container(),
                  ),

                  /// Done button
                  Visibility(
                    visible: widget.dropDown.enableMultipleSelection,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        child: ElevatedButton(
                          onPressed: () {
                            List<SelectedListItem> selectedList = widget
                                .dropDown.data
                                .where((element) => element.isSelected == true)
                                .toList();
                            List<dynamic> selectedNameList = [];

                            for (var element in selectedList) {
                              selectedNameList.add(element);
                            }

                            widget.dropDown.selectedItems
                                ?.call(selectedNameList);
                            _onUnFocusKeyboardAndPop();
                          },
                          child: widget.dropDown.submitButtonChild ??
                              const Text('Done'),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        widget.dropDown.confirmarBtn && selected.isInitialized,
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Material(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.green.shade400),
                                  elevation: const MaterialStatePropertyAll(2),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide.none),
                                  ),
                                ),
                                onPressed: () {
                                  List<SelectedListItem> selectedList = [];
                                  selectedList.add(selected.val);

                                  widget.dropDown.selectedItems
                                      ?.call(selectedList);
                                  _onUnFocusKeyboardAndPop();
                                },
                                child: widget.dropDown.submitButtonChild ??
                                    const Text(
                                      'CONFIRMAR',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// A [TextField] that displays a list of suggestions as the user types with clear button.
            Visibility(
              visible: widget.dropDown.isSearchVisible,
              child: widget.dropDown.searchWidget ??
                  AppTextField(
                    searchText: widget.dropDown.searchText,
                    dropDown: widget.dropDown,
                    onTextChanged: _buildSearchList,
                  ),
            ),

            /// Listview (list of data with check box for multiple selection & on tile tap single selection)
            Expanded(
              child:
                  // child: AlphabetListScrollView(
                  //   strList: strList,
                  //   headerWidgetList: [
                  //     List.generate(abc.le, (index) => null)
                  //     AlphabetScrollListHeader(
                  //         widgetList: List.generate(abc.length, (index) {
                  //           return Text(abc[index]);
                  //         }),
                  //         icon: Icon(Icons.abc),
                  //         indexedHeaderHeight: (i) {
                  //           return 80;
                  //         }),
                  //   ],
                  //   indexedHeight: (i) {
                  //     return 120;
                  //   },
                  //   keyboardUsage: false,
                  //   itemBuilder: (context, index) {
                  //     bool isSelected = mainList[index].isSelected ?? false;
                  //     return InkWell(
                  //       child: Container(
                  //         color: widget.dropDown.dropDownBackgroundColor,
                  //         child: Padding(
                  //           padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  //           child: ListTile(
                  //             title: widget.dropDown.listBuilder?.call(index) ??
                  //                 Text(
                  //                   mainList[index].name,
                  //                 ),
                  //             trailing: widget.dropDown.enableMultipleSelection
                  //                 ? GestureDetector(
                  //                     onTap: () {
                  //                       setState(() {
                  //                         mainList[index].isSelected = !isSelected;
                  //                       });
                  //                     },
                  //                     child: isSelected
                  //                         ? const Icon(Icons.check_box)
                  //                         : const Icon(
                  //                             Icons.check_box_outline_blank),
                  //                   )
                  //                 : const SizedBox(
                  //                     height: 0.0,
                  //                     width: 0.0,
                  //                   ),
                  //           ),
                  //         ),
                  //       ),
                  //       onTap: widget.dropDown.enableMultipleSelection
                  //           ? null
                  //           : () {
                  //               widget.dropDown.selectedItems
                  //                   ?.call([mainList[index]]);
                  //               _onUnFocusKeyboardAndPop();
                  //             },
                  //     );
                  //   },
                  // ),
                  ListView.builder(
                controller: scrollController,
                itemCount: mainList.length,
                itemBuilder: (context, index) {
                  bool isSelected = mainList[index].isSelected ?? false;
                  return InkWell(
                    child: Container(
                      color: widget.dropDown.dropDownBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: ListTile(
                          title: widget.dropDown.listBuilder?.call(index) ??
                              Text(
                                mainList[index].name,
                              ),
                          trailing: widget.dropDown.enableMultipleSelection
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mainList[index].isSelected = !isSelected;
                                    });
                                  },
                                  child: isSelected
                                      ? const Icon(Icons.check_box)
                                      : const Icon(
                                          Icons.check_box_outline_blank),
                                )
                              : const SizedBox(
                                  height: 0.0,
                                  width: 0.0,
                                ),
                        ),
                      ),
                    ),
                    onTap: widget.dropDown.enableMultipleSelection
                        ? null
                        : () {
                            if (!widget.dropDown.confirmarBtn) {
                              widget.dropDown.selectedItems
                                  ?.call([mainList[index]]);
                              _onUnFocusKeyboardAndPop();
                            } else {
                              setState(() {
                                selected.val = mainList[index];
                              });
                              widget.dropDown.selectedItems
                                  ?.call([selected.val]);
                            }
                          },
                  );
                },
              ),
            ),
            Visibility(
              visible: widget.dropDown.confirmarBtn && selected.isInitialized,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('SELECIONADO : '),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            selected.isInitialized
                                ? selected.val.name
                                : 'Carregando..',
                            softWrap: true),
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.restart_alt_rounded,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'LIMPAR',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.grey.shade400),
                            elevation: const MaterialStatePropertyAll(2),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide.none),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selected = Late();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// This helps when search enabled & show the filtered data in list.
  _buildSearchList(String userSearchTerm) {
    final results = switched
        ? widget.dropDown.data
            .where((element) => element.value!
                .toLowerCase()
                .contains(userSearchTerm.toLowerCase()))
            .toList()
        : widget.dropDown.data
            .where((element) => element.name
                .toLowerCase()
                .contains(userSearchTerm.toLowerCase()))
            .toList();
    if (userSearchTerm.isEmpty) {
      mainList = widget.dropDown.data;
    } else {
      mainList = results;
    }
    setState(() {});
  }

  /// This helps to UnFocus the keyboard & pop from the bottom sheet.
  _onUnFocusKeyboardAndPop() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  void _setSearchWidgetListener() {
    TextFormField? _searchField =
        (widget.dropDown.searchWidget as TextFormField?);
    _searchField?.controller?.addListener(() {
      _buildSearchList(_searchField.controller?.text ?? '');
    });
  }
}
