import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get
import '../API/CallApi.dart';
import '../Models/Data.dart';

class AllData extends StatefulWidget {
  AllData({Key? key}) : super(key: key);

  @override
  _AllDataState createState() => _AllDataState();
}

class _AllDataState extends State<AllData> {
  // Declare a controller for state management
  final DataController dataController = Get.put(DataController());
  int currentPage = 0;
  int itemsPerPage = 4;

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'All Data',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Obx(
            () => dataController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: dataController.paginatedData.length,
          itemBuilder: (context, index) {
            return buildCustomDataCard(dataController.paginatedData[index]);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: currentPage > 0 ? () => setPage(currentPage - 1) : null,
              child: Text('Previous'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: currentPage < (dataController.allData.length / itemsPerPage - 1) ? () => setPage(currentPage + 1) : null,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomDataCard(Data data) {
    return Container(
      margin: EdgeInsets.only(bottom: 15, left: 15, right: 15,top: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(3),
        },
        children: [
          TableRow(
            children: [
              TableCell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    'ID',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16,

                    ),
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text('${data.id}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              TableCell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    'Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text('${data.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              TableCell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    'Body',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    '${data.body ?? ""}',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Future<void> getAllData() async {
    try {
      dataController.setLoading(true); // Set loading to true

      final response = await CallApi().getData('posts');

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);

        if (decodedData != null && decodedData is List) {
          List<Data> dataList = List<Data>.from(
              decodedData.map((data) => Data.fromJson(data)));

          print("Length: ${dataList.length}");

          // Update the state using the controller
          dataController.setAllData(dataList);

          // Update the paginatedData with the initial page
          updatePaginatedData();
        } else {
          print("Invalid data format in the API response.");
        }
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception caught: $e");
    } finally {
      dataController.setLoading(false);
    }
  }

  void setPage(int page) {
    setState(() {
      currentPage = page;
      updatePaginatedData();
    });
  }

  void updatePaginatedData() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;
    if (endIndex > dataController.allData.length) {
      endIndex = dataController.allData.length;
    }
    dataController.setPaginatedData(dataController.allData.sublist(startIndex, endIndex));
  }
}

class DataController extends GetxController {
  RxList<Data> allData = <Data>[].obs;
  RxBool isLoading = true.obs;
  RxList<Data> paginatedData = <Data>[].obs; // Added a new RxList for paginated data

  void setAllData(List<Data> Data) {
    allData.assignAll(Data);
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setPaginatedData(List<Data> Data) {
    paginatedData.assignAll(Data);
  }
}
