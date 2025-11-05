import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/database/functions/terminal.dart';
import 'package:shaylan_agent/database/functions/visit_payment.dart';
import 'package:shaylan_agent/database/functions/visit_payment_invoice.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/models/visit_payment.dart';
import 'package:shaylan_agent/models/visit_payment_invoice.dart';
import 'package:shaylan_agent/providers/local_storadge.dart';
import 'package:shaylan_agent/methods/snackbars.dart';
import 'package:shaylan_agent/utilities/alert_utils.dart';

class NewPaymentInputPage extends ConsumerStatefulWidget {
  const NewPaymentInputPage({
    super.key,
    required this.creditReportLine,
    required this.visitID,
    required this.cardCode,
    required this.paymentType,
  });

  final CreditReportLine creditReportLine;
  final int visitID;
  final String cardCode;
  final String paymentType;

  @override
  ConsumerState<NewPaymentInputPage> createState() =>
      _NewPaymentInputPageState();
}

class _NewPaymentInputPageState extends ConsumerState<NewPaymentInputPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController checkNumberController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    commentController.dispose();
    checkNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          lang.payment,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${lang.documentNumber}: ${widget.creditReportLine.docNum}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${lang.remainder}: ${widget.creditReportLine.balance} man',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 40),
                if (widget.paymentType == VisitPaymentType.terminal)
                  Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Text(
                              '${lang.checkNumber} * :',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: checkNumberController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        'Töleg möçberi * :',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  lang.comment,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        lang.cancel,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        await _processPayment(context, ref, lang);
                      },
                      child: Text(
                        lang.payment,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _processPayment(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations lang,
  ) async {
    if (amountController.text.isEmpty) {
      if (context.mounted) {
        showErrSnackBar(context, 'Töleg möçberini giriziň!');
      }
      return;
    }

    final amount = num.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      if (context.mounted) {
        showErrSnackBar(context, 'Dogry san giriziň!');
      }
      return;
    }

    if (amount > widget.creditReportLine.balance) {
      if (context.mounted) {
        showErrSnackBar(
          context,
          'Töleg möçberi galyndydan uly bolup bilmez!',
        );
      }
      return;
    }

    if (widget.paymentType == VisitPaymentType.terminal &&
        checkNumberController.text.isEmpty) {
      if (context.mounted) {
        showErrSnackBar(context, 'Çek nomeri giriziň !!!');
      }
      return;
    }

    User user = await getUser();
    String terminalNumber = await ref.read(selectedTerminalProvider);
    String terminalAccount = await getTerminalBySerNo(terminalNumber);

    num docEntry = widget.creditReportLine.docEntryInv != 0
        ? widget.creditReportLine.docEntryInv
        : widget.creditReportLine.docEntryRin;

    VisitPayment visitPayment = VisitPayment(
      visitId: widget.visitID,
      comment: commentController.text,
      cashAccount: widget.paymentType == VisitPaymentType.terminal
          ? terminalAccount
          : user.account,
      paymentType: widget.paymentType,
      cardCode: widget.cardCode,
      status: VisitPaymentStatus.dontSent,
      paySum: amount,
      terminalNumber:
          widget.paymentType == VisitPaymentType.terminal ? terminalNumber : '',
      checkNumber: widget.paymentType == VisitPaymentType.terminal
          ? int.parse(checkNumberController.text)
          : 0,
    );

    int visitPaymentID = await createVisitPayment(visitPayment);

    VisitPaymentInvoice visitPaymentInvoice = VisitPaymentInvoice(
      invPayId: visitPaymentID,
      docEntry: docEntry,
      sumApplied: amount,
    );

    await createVisitPaymentInvoice(visitPaymentInvoice);

    if (context.mounted) {
      AlertUtils.showSuccessAlert(context: context, message: 'Töleg üstünlikli girizildi!', lang: lang);
      Navigator.of(context)
        ..pop()
        ..pop()
        ..pop();
    }
  }
}
