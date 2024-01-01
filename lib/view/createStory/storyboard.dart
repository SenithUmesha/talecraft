import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_colors.dart';

import '../../controller/storyboard_controller.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';

class Storyboard extends StatelessWidget {
  const Storyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableNodePage();
  }

  // @override
  // Widget build(BuildContext context) {
  //   var height = MediaQuery.of(context).size.height;
  //   var width = MediaQuery.of(context).size.width;
  //   return Container(
  //       color: AppColors.white,
  //       child: SafeArea(
  //           child: Scaffold(
  //         appBar: CustomAppBar(
  //           title: AppStrings.newStory,
  //           cantGoBack: true,
  //           actions: <Widget>[
  //             IconButton(
  //               icon: const Icon(
  //                 Icons.add_rounded,
  //                 color: Colors.black,
  //                 size: 28,
  //               ),
  //               onPressed: () {
  //                 Get.find<StoryboardController>().showAddBlockDialog();
  //               },
  //             ),
  //           ],
  //         ),
  //         body: GetBuilder<StoryboardController>(
  //             init: StoryboardController(),
  //             builder: (controller) {
  //               return Column(
  //                 children: [
  //                   Expanded(
  //                       child: Padding(
  //                     padding:
  //                         const EdgeInsets.only(left: 20, right: 20, top: 25),
  //                     child: Column(
  //                       children: [
  //                         Expanded(
  //                           child: Container(
  //                             height: height,
  //                             width: width,
  //                             child: ReorderableListView(
  //                               physics: BouncingScrollPhysics(),
  //                               shrinkWrap: true,
  //                               padding: const EdgeInsets.only(bottom: 30),
  //                               scrollDirection: Axis.vertical,
  //                               children: [
  //                                 for (final block in controller.blocks)
  //                                   Padding(
  //                                     key: ValueKey(block),
  //                                     padding: const EdgeInsets.only(bottom: 8),
  //                                     child: Container(
  //                                       decoration: BoxDecoration(
  //                                         color: block.type == BlockType.Story
  //                                             ? AppColors.grey.withOpacity(0.1)
  //                                             : AppColors.red.withOpacity(0.1),
  //                                         borderRadius:
  //                                             BorderRadius.circular(8),
  //                                       ),
  //                                       child: block.type == BlockType.Story
  //                                           ? ListTile(
  //                                               title: AppWidgets.regularText(
  //                                                 text: block.toString(),
  //                                                 size: 16.0,
  //                                                 color: AppColors.black,
  //                                                 weight: FontWeight.w400,
  //                                               ),
  //                                             )
  //                                           : ListTile(
  //                                               title: ReorderableListView(
  //                                                 physics:
  //                                                     BouncingScrollPhysics(),
  //                                                 shrinkWrap: true,
  //                                                 scrollDirection:
  //                                                     Axis.vertical,
  //                                                 children: [],
  //                                                 onReorder:
  //                                                     (oldIndex, newIndex) {},
  //                                               ),
  //                                             ),
  //                                     ),
  //                                   ),
  //                               ],
  //                               onReorder: (oldIndex, newIndex) {
  //                                 controller.updateBlocks(oldIndex, newIndex);
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ))
  //                 ],
  //               );
  //             }),
  //       )));
  // }
}

class DraggableNodePage extends StatefulWidget {
  const DraggableNodePage({Key? key}) : super(key: key);

  @override
  _DraggableNodePageState createState() => _DraggableNodePageState();
}

class _DraggableNodePageState extends State<DraggableNodePage> {
  late GraphNode<Block> root;
  late GraphNode<Block>? draggedNode;
  int maxId = 0;

  @override
  void initState() {
    root = GraphNode<Block>(
      data: Block(
        id: 0,
        type: BlockType.story,
        shortDescription: 'Add Story',
        text: '',
        oneOut: false,
        multiIn: false,
      ),
      isRoot: true,
    );
    super.initState();
  }

  Map<String, dynamic> graphToJson(GraphNode<Block> node) {
    Map<String, dynamic> json = node.data!.toJson();
    json['nextList'] = [];

    for (var nextNode in node.nextList) {
      json['nextList'].add(graphToJson(nextNode as GraphNode<Block>));
    }

    return json;
  }

  Map<String, dynamic> serializeGraph(GraphNode<Block> root) {
    return graphToJson(root);
  }

  void graphFromJson(GraphNode<Block> root, Map<String, dynamic> json) {
    root.data = Block.fromJson(json);

    if (json.containsKey('nextList')) {
      var nextListJson = json['nextList'] as List<dynamic>;
      for (var nextNodeJson in nextListJson) {
        var nextNode = GraphNode<Block>();
        graphFromJson(nextNode, nextNodeJson as Map<String, dynamic>);
        root.addNext(nextNode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: AppStrings.newStory,
            cantGoBack: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.save_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  Map<String, dynamic> graphJson = serializeGraph(root);
                  String jsonString = json.encode(graphJson);
                  log(jsonString);

                  setState(() {
                    root.clearAllNext();
                  });
                  log("Cleared");
                  Timer(const Duration(seconds: 2), () {
                    setState(() {
                      graphFromJson(root, graphJson);
                    });
                  });
                },
              ),
            ],
          ),
          body: GetBuilder<StoryboardController>(
              init: StoryboardController(),
              builder: (controller) {
                return Column(
                  children: [
                    Container(
                      height: height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Draggable<GraphNodeFactory<Block>>(
                            data: GraphNodeFactory(
                              dataBuilder: () => Block(
                                id: maxId + 1,
                                type: BlockType.story,
                                shortDescription: 'Add Story',
                                text: '',
                                oneOut: false,
                                multiIn: false,
                              ),
                            ),
                            child: Card(
                              elevation: 2,
                              child: storyBlock(width),
                            ),
                            feedback: Card(
                              color: AppColors.white,
                              elevation: 6,
                              child: storyBlock(width),
                            ),
                            onDragStarted: () {
                              setState(() {
                                draggedNode = GraphNode<Block>(
                                    data: Block(
                                  id: maxId + 1,
                                  type: BlockType.story,
                                  shortDescription: 'Add Story',
                                  text: '',
                                  oneOut: false,
                                  multiIn: false,
                                ));
                              });
                            },
                          ),
                          Draggable<GraphNodeFactory<Block>>(
                            data: GraphNodeFactory(
                              dataBuilder: () => Block(
                                id: maxId + 1,
                                type: BlockType.choice,
                                shortDescription: 'Add Choice',
                                text: '',
                                oneOut: true,
                                multiIn: false,
                              ),
                            ),
                            child: Card(
                              elevation: 2,
                              child: choiceBlock(width),
                            ),
                            feedback: Card(
                              color: AppColors.white,
                              elevation: 6,
                              child: choiceBlock(width),
                            ),
                            onDragStarted: () {
                              setState(() {
                                draggedNode = GraphNode<Block>(
                                    data: Block(
                                  id: maxId + 1,
                                  type: BlockType.choice,
                                  shortDescription: 'Add Choice',
                                  text: '',
                                  oneOut: true,
                                  multiIn: false,
                                ));
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help,
                          color: AppColors.grey,
                          size: 14,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        AppWidgets.regularText(
                          text:
                              "Double press to edit block | Hold press to delete block",
                          size: 10.0,
                          alignment: TextAlign.center,
                          color: AppColors.grey,
                          weight: FontWeight.w400,
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      color: AppColors.grey,
                    ),
                    Expanded(
                      child: StatefulBuilder(
                        builder: (context, setter) {
                          return DraggableFlowGraphView<Block>(
                            root: root,
                            direction: Axis.horizontal,
                            centerLayout: true,
                            enableDelete: true,
                            onConnect: (prevNode, node) {
                              setState(() {
                                maxId += 1;
                              });
                            },
                            willConnect: (node) {
                              log("Will Connect: ${node.data!.id} and ${draggedNode!.data!.id}");
                              if (!node.data!.oneOut && !node.data!.multiIn) {
                                // Node - Story Block
                                return draggedNode!.data?.type ==
                                    BlockType.choice;
                              } else if (node.data!.oneOut &&
                                  !node.data!.multiIn) {
                                // Node - Choice Block
                                return draggedNode!.data?.type ==
                                        BlockType.story &&
                                    node.nextList.isEmpty;
                              }

                              return false;
                            },
                            builder: (context, node) {
                              return GestureDetector(
                                onTap: () {
                                  log("Next: ${node.nextList.length}");
                                  log("Prev: ${node.prevList.length}");
                                },
                                onDoubleTap: () {
                                  controller.showAddTextDialog(node.data!);
                                },
                                onLongPress: () {
                                  setter(() {
                                    node.deleteSelf();
                                  });
                                  setState(() {
                                    maxId -= 1;
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.white,
                                        border: Border.all(
                                            color: (node.data as Block).type ==
                                                    BlockType.story
                                                ? AppColors.black
                                                : AppColors.red,
                                            width: 2)),
                                    padding: const EdgeInsets.all(12),
                                    child: AppWidgets.regularText(
                                        text: (node.data as Block)
                                            .shortDescription,
                                        size: 14.0,
                                        alignment: TextAlign.center,
                                        color: AppColors.black,
                                        weight: FontWeight.w400,
                                        textOverFlow: TextOverflow.ellipsis,
                                        maxLines: 1)),
                              );
                            },
                            onEdgeColor: (n1, n2) {
                              if (n1.data?.oneOut == false &&
                                  n2.data?.multiIn == false) {
                                return AppColors.black;
                              } else {
                                return AppColors.red;
                              }
                            },
                          );
                        },
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget storyBlock(double width) => Container(
        width: width * 0.4,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.menu_book_rounded),
            SizedBox(
              width: 16,
            ),
            Text('Story Block')
          ],
        ),
      );

  Widget choiceBlock(double width) => Container(
        width: width * 0.4,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.playlist_add_check),
            SizedBox(
              width: 16,
            ),
            Text('Choice Block')
          ],
        ),
      );
}

enum BlockType { story, choice }

class Block {
  int id;
  BlockType type;
  String shortDescription;
  String text;
  bool oneOut;
  bool multiIn;

  Block({
    required this.id,
    required this.type,
    required this.shortDescription,
    required this.text,
    required this.oneOut,
    required this.multiIn,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'shortDescription': shortDescription,
      'text': text,
      'oneOut': oneOut,
      'multiIn': multiIn,
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'] as int,
      type: json['type'] == 'BlockType.story'
          ? BlockType.story
          : BlockType.choice,
      shortDescription: json['shortDescription'] as String,
      text: json['text'] as String,
      oneOut: json['oneOut'] as bool,
      multiIn: json['multiIn'] as bool,
    );
  }

  void updateText(String shortDescription, String text) {
    this.shortDescription = shortDescription;
    this.text = text;
  }
}
