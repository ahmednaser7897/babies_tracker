import 'dart:io';
import 'package:babies_tracker/model/mother_model.dart';
import 'package:babies_tracker/ui/mother/pdfs/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class MotherHealthPdf {
  static Future<File> generate(MotherModel model) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      margin: const EdgeInsets.all(10),
      build: (context) => [
        buildHeader(model),
        SizedBox(height: .5 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
        motyerHealth(model),
        SizedBox(height: .5 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
        motherMedications(model),
        SizedBox(height: .5 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
        // motherBabys(model),
        // SizedBox(height: .5 * PdfPageFormat.cm),
        // Divider(),
        // SizedBox(height: .5 * PdfPageFormat.cm),
      ],
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(MotherModel model) => Row(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Genral information :-',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 0.3 * PdfPageFormat.cm),
            Text('Name : ${model.name}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text('Email : ${model.email ?? ''}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text('phone : ${model.phone ?? ''}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text('Address : ${model.address ?? ''}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
            SizedBox(height: 1 * PdfPageFormat.mm),
            Text('Doctor notes : ${model.doctorNotes ?? ''}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
          ],
        )
      ]);

  static Widget motyerHealth(MotherModel model) {
    print(model.healthyHistory);
    print(model.postpartumHealth);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Health information :-',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      Text(
        "Healthy History :",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: .2 * PdfPageFormat.cm),
      showList(
        model.healthyHistory ?? [],
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      Text(
        "Postpar tumHealth :",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: .2 * PdfPageFormat.cm),
      showList(
        model.postpartumHealth ?? [],
      ),
    ]);
  }

  static Widget showList(List<String> myList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(myList.length, (index) {
        return Column(children: [
          Text(
            '${index + 1} - ${myList[index]}',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: PdfColors.black),
          )
        ]);
      }),
    );
  }

  static Widget motherMedications(MotherModel model) {
    final headers = [
      'Name',
      //'Purpose',
      'Frequency',
      'Dosage',
      'Start Date',
      'End Date',
    ];
    final List<List<dynamic>> data = [];
    model.medications!.forEach((element) {
      data.add([
        element.name,
        //element.purpose,
        element.frequency,
        element.dosage,
        element.startDate,
        element.endDate,
      ]);
    });

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Current medications :-',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      TableHelper.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        cellHeight: 20,
        columnWidths: {
          0: const FlexColumnWidth(2),
          //1: const FlexColumnWidth(2),
          1: const FlexColumnWidth(1),
          2: const FlexColumnWidth(1),
          3: const FlexColumnWidth(1),
          4: const FlexColumnWidth(1),
        },
        cellAlignments: {
          0: Alignment.centerLeft,
          // 1: Alignment.center,
          1: Alignment.center,
          2: Alignment.center,
          3: Alignment.center,
          4: Alignment.centerRight,
        },
      )
    ]);
  }

  //  Widget userImage(MothermyList[index] model)pw.async {
  //   final image = await imageFromAssetBundle(AppAssets.mother);
  //   final provider = await flutterImageProvider(
  //       NetworkImage(uri.toString()));
  //   return Column(
  //     children: [
  //       Container(
  //         height: 15.w,
  //        child:
  //          (model.image != null && model.image!.isNotEmpty)
  //                 ?pw.Image(image)
  //                 :pw.Image(image) ,
  //         decoration:const BoxDecoration(shape: BoxShape.circle),
  //       )
  //     ],
  //   );
  // }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style =
        titleStyle ?? TextStyle(fontWeight: FontWeight.normal, fontSize: 18);

    return Container(
      width: width,
      child: Row(
        children: [
          Text('$title : ', style: style),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
