
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../image_full_view/view.dart';
import 'logic.dart';
import 'state.dart';

class TableDetailPage extends StatefulWidget {
  const TableDetailPage({Key? key, this.productModel, this.isProduct})
      : super(key: key);

  final DocumentSnapshot? productModel;
  final bool? isProduct;
  @override
  _TableDetailPageState createState() => _TableDetailPageState();
}

class _TableDetailPageState extends State<TableDetailPage> {
  final TableDetailLogic logic = Get.put(TableDetailLogic());
  final TableDetailState state = Get.find<TableDetailLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logic.currentProduct(
        widget.productModel,  'products' );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableDetailLogic>(
      builder: (_productDetailLogic) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 15,
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
            child: ListView(
              children: [
                ///---image
                Hero(
                    tag: '${widget.productModel!.get('image')}',
                    child: Material(
                        child: InkWell(
                      onTap: () {
                        Get.to(ImageViewScreen(
                          networkImage: '${widget.productModel!.get('image')}',
                        ));
                      },
                      child: Container(
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                      
                        borderRadius: BorderRadius.circular(20)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            '${widget.productModel!.get('image')}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ))),

                ///---name
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text(
                      '${widget.productModel!.get('table_name')}',
                      textAlign: TextAlign.center,
                      style: state.productNameStyle),
                ),
                SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                Text('is Reserve :             ${widget.productModel!.get('is_reserve')}'),
                SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                Text('chairs count :         ${widget.productModel!.get('table_chairs_count')}'),
                SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                Text('table note:               ${widget.productModel!.get('table_note')}'),
                SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                Text('Reservation from : ${widget.productModel!.get('reservation_from').toDate().toString().substring(0,16)}'),
                SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                Text('Reservation to     : ${widget.productModel!.get('reservation_to').toDate().toString().substring(0,16)}'),
              ],
            ),
          ),
        ),
     
      ),
    );
  }
}
