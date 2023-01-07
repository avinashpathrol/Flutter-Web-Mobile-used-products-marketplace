import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import '../model/Agreement.dart';
import 'printable_data.dart';
import 'package:http/http.dart' as http;
// import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SaveBtnBuilder extends StatelessWidget {
  SaveBtnBuilder(this.agreement);
  late final Agreement agreement;

  @override
  Widget build(BuildContext context) {
    AssetImage(agreement.img) as ImageProvider;
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.indigo,
            primary: Colors.indigo,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () => printDoc(),
          child: const Text(
            "Save as PDF",
            style: TextStyle(color: Colors.white, fontSize: 20.00),
          ),
        ),
      ),
    );
  }

  Future<void> printDoc() async {
    final image = await imageFromAssetBundle(
      "assets/images/eagree.png",
    );

    final doc = pw.Document();
    final pimage = await networkImage(agreement.img);
    final netImage = await networkImage(agreement.signature);
    final netImage1 = await networkImage(agreement.client_signature);

    doc.addPage(pw.Page(build: (pw.Context context) {
      return pw.Column(
        children: [
          pw.Text(" Agreement",
              style: pw.TextStyle(
                  fontSize: 25.00, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10.00),
          pw.Divider(),
          pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.SizedBox(width: 10),
                    pw.Image(
                      pimage,
                      width: 100,
                      height: 100,
                    ),
                  ])),
          pw.Column(
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [],
              ),
              pw.SizedBox(height: 10.00),
              pw.Container(
                // color: const PdfColor(0.5, 1, 0.5, 0.7),
                width: double.infinity,
                height: 36.00,
                child: pw.Center(
                  child: pw.Text(
                    "Product Details",
                    style: pw.TextStyle(
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                        fontSize: 20.00,
                        fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              // for (var i = 0; i < 3; i++)
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Product Name : ${agreement.name}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Product Price : \$${agreement.price}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Seller Name : \$${agreement.seller_name}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Product Description : ${agreement.description}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Product Location : ${agreement.location}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Product Price : ${agreement.price}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                child: pw.Container(
                  child: pw.Text(
                    "Buyer Details",
                    style: pw.TextStyle(
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                        fontSize: 20.00,
                        fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Buyer Name : ${agreement.client_name}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Buyer Location : ${agreement.client_location}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Purchase Date  : ${agreement.client_date}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                child: pw.Container(
                  child: pw.Text(
                    "Buyer Payment Details",
                    style: pw.TextStyle(
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                        fontSize: 20.00,
                        fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Account Number  : ${agreement.account_no}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Institution Number  : ${agreement.institution_no}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Container(
                width: double.infinity,
                height: 30.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Text(
                    "Transit Number  : ${agreement.transit_no}",
                    style: pw.TextStyle(
                        fontSize: 16.00, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Seller Signature'),
                        pw.Text('Client Signature'),
                      ])),
              pw.SizedBox(height: 20),
              pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Image(
                          netImage,
                          width: 100,
                          height: 100,
                        ),
                        pw.Image(
                          netImage1,
                          width: 100,
                          height: 100,
                        ),
                      ])),
            ],
          )
        ],
      ); // Center
    }));

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
