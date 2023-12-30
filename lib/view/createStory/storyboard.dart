import 'dart:developer';

import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:talecraft/utils/app_colors.dart';

import '../../utils/app_strings.dart';
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
          ),
          body: Column(
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
                      onDragEnd: (_) {
                        setState(() {
                          maxId += 1;
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
                      onDragEnd: (_) {
                        setState(() {
                          maxId += 1;
                        });
                      },
                    ),
                  ],
                ),
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
                      willConnect: (node) {
                        log("Will Connect: ${node.data!.id}");
                        if (node.data?.oneOut == true) {
                          return node.nextList.isEmpty;
                        } else if (node.data != null && !node.data!.oneOut) {
                          return true;
                        }
                        return false;
                      },
                      builder: (context, node) {
                        return Container(
                          color: Colors.white60,
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            (node.data as Block).shortDescription,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                      nodeSecondaryMenuItems: (node) {
                        return [
                          PopupMenuItem(
                            child: Text('Delete'),
                            onTap: () {
                              setter(() {
                                node.deleteSelf();
                              });
                            },
                          )
                        ];
                      },
                      onEdgeColor: (n1, n2) {
                        if (n1.data?.oneOut == false &&
                            n2.data?.multiIn == false) {
                          return AppColors.red;
                        } else {
                          return AppColors.black;
                        }
                      },
                    );
                  },
                ),
              )
            ],
          ),
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
  final int id;
  final BlockType type;
  final String shortDescription;
  final String text;
  final bool oneOut;
  final bool multiIn;

  Block({
    required this.id,
    required this.type,
    required this.shortDescription,
    required this.text,
    required this.oneOut,
    required this.multiIn,
  });
}
