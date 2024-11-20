// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:textfield_tags/textfield_tags.dart';

class TaggableTextWidgetSharedState {
  List<String> _tagsList = [];

  TaggableTextWidgetSharedState._privateConstructor();

  static final TaggableTextWidgetSharedState _instance =
      TaggableTextWidgetSharedState._privateConstructor();

  factory TaggableTextWidgetSharedState() {
    return _instance;
  }

  List<String> get tagsList => _tagsList;

  set tagsList(List<String> tagsList) {
    _tagsList = tagsList;
  }
}

class TaggableTextWidget extends StatefulWidget {
  const TaggableTextWidget({
    super.key,
    this.width,
    this.height,
    required this.prefixIcon,
  });

  final double? width;
  final double? height;
  final Widget prefixIcon;

  @override
  State<TaggableTextWidget> createState() => _TaggableTextWidgetState();
}

class _TaggableTextWidgetState extends State<TaggableTextWidget> {
  late final StringTagController _stringTagController;
  late double _distanceToField;

  TaggableTextWidgetSharedState _taggableTextWidgetSharedState =
      new TaggableTextWidgetSharedState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
    print(_distanceToField);
  }

  @override
  void initState() {
    super.initState();
    _stringTagController = StringTagController(); // Initialize the controller
  }

  @override
  void dispose() {
    _stringTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double maxAvailableWidth = MediaQuery.of(context).size.width - 20;
    const boxConstrainConst = BoxConstraints(
      minWidth: 50,
      maxWidth: 400,
    );

    return TextFieldTags<String>(
      textfieldTagsController: _stringTagController,
      initialTags: [],
      textSeparators: const [' ', ','],
      validator: (String tag) {
        if (_stringTagController.getTags!.contains(tag)) {
          return 'You\'ve already entered that';
        }
        return null;
      },
      inputFieldBuilder: (context, inputFieldValues) {
        return TextField(
          controller: inputFieldValues.textEditingController,
          focusNode: inputFieldValues.focusNode,
          //onChanged: inputFieldValues.onTagChanged,
          onChanged: (value) {
            inputFieldValues.onTagChanged(value);
            _taggableTextWidgetSharedState.tagsList =
                _stringTagController.getTags ?? [];
          },
          //onSubmitted: inputFieldValues.onTagSubmitted,
          onSubmitted: (value) {
            inputFieldValues.onTagSubmitted(value);
            _taggableTextWidgetSharedState.tagsList =
                _stringTagController.getTags ?? [];
          },
          decoration: InputDecoration(
            isDense: true,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF474344),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF474344),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            errorText: inputFieldValues.error,
            prefixIconConstraints: boxConstrainConst,
            prefixIcon: Row(
              mainAxisSize: MainAxisSize
                  .min, // Prevent the Row from expanding unnecessarily
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: widget.prefixIcon,
                ),
                if (inputFieldValues.tags.isNotEmpty) // Check if there are tags
                  Flexible(
                    child: SingleChildScrollView(
                      controller: inputFieldValues.tagScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: inputFieldValues.tags.map((String tag) {
                          return Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              color: Color(0xFFFEFEFE),
                            ),
                            margin: const EdgeInsets.only(right: 10.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4.0),
                            child: Row(
                              children: [
                                InkWell(
                                  child: Text(
                                    '$tag',
                                    style: const TextStyle(
                                        color: Color(0xFF353435)),
                                  ),
                                  onTap: () {
                                    // Handle tag tap
                                  },
                                ),
                                const SizedBox(width: 4.0),
                                InkWell(
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 14.0,
                                    color: Color.fromARGB(255, 233, 233, 233),
                                  ),
                                  onTap: () {
                                    inputFieldValues.onTagRemoved(tag);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}