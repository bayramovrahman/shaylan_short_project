import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/models/visit_payment_invoice.dart';
import 'package:shaylan_agent/providers/pages/credit_reports.dart';

class CreditReportPayInput extends ConsumerStatefulWidget {
  const CreditReportPayInput({super.key, required this.creditReportLine});

  final CreditReportLine creditReportLine;

  @override
  ConsumerState<CreditReportPayInput> createState() =>
      _CreditReportPayInputState();
}

class _CreditReportPayInputState extends ConsumerState<CreditReportPayInput> {
  String errText = '';

  @override
  Widget build(BuildContext context) {

    debugPrint("-----------------------------------onCreditReportPayInput");

    num docEntry = 0;
    VisitPaymentInvoice? visitPaymentInvoice;

    if (widget.creditReportLine.docEntryInv != 0) {
      docEntry = widget.creditReportLine.docEntryInv;
    } else {
      docEntry = widget.creditReportLine.docEntryRin;
    }

    List<VisitPaymentInvoice> visitPaymentInvoices =
        ref.watch(visitPaymentInvoiceProvider);

    for (VisitPaymentInvoice vpi in visitPaymentInvoices) {
      if (vpi.docEntry == docEntry) {
        visitPaymentInvoice = vpi;
      }
    }

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: TextFormField(
              cursorHeight: 20,
              textAlignVertical: TextAlignVertical.center,
              initialValue: visitPaymentInvoice != null
                  ? visitPaymentInvoice.sumApplied.toString()
                  : '',
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              ),
              onFieldSubmitted: (value) async {
                if (value.isEmpty) {
                  await ref
                      .read(visitPaymentInvoiceProvider.notifier)
                      .removePaidByDocEntry(docEntry);
                  return;
                }

                final parsedValue = num.tryParse(value);
                if (parsedValue == null) {
                  setState(() {
                    errText = 'Geçersiz sayı girdiniz.';
                  });
                  return;
                }

                if (parsedValue > widget.creditReportLine.balance) {
                  setState(() {
                    errText =
                        ' ${widget.creditReportLine.balance} < $parsedValue';
                  });
                  return;
                }

                setState(() {
                  errText = '';
                });

                VisitPaymentInvoice vpi = VisitPaymentInvoice(
                  docEntry: docEntry,
                  sumApplied: parsedValue,
                );
                await ref
                    .read(visitPaymentInvoiceProvider.notifier)
                    .addPaidOrUpdate(vpi);
              },
            ),
          ),
          Expanded(
            child: errText != ''
                ? Text(errText, style: const TextStyle(color: Colors.red))
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
