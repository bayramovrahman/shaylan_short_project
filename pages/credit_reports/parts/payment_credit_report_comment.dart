import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/database/functions/terminal.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/database/functions/visit_payment.dart';
import 'package:shaylan_agent/database/functions/visit_payment_invoice.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/methods/snackbars.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/models/visit_payment.dart';
import 'package:shaylan_agent/models/visit_payment_invoice.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/continue_pay.dart';
import 'package:shaylan_agent/providers/local_storadge.dart';
import 'package:shaylan_agent/providers/pages/credit_reports.dart';
import 'package:shaylan_agent/providers/pages/select_payment_type_for_kollektor.dart';

class PaymentCreditReportComment extends ConsumerStatefulWidget {
  const PaymentCreditReportComment({
    super.key,
    required this.visitID,
    required this.cardCode,
  });

  final int visitID;
  final String cardCode;
  @override
  ConsumerState<PaymentCreditReportComment> createState() =>
      _PaymentCreditReportCommentState();
}

class _PaymentCreditReportCommentState
    extends ConsumerState<PaymentCreditReportComment> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController checkNumberCtrl = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    checkNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    String paymentType = ref.watch(selectedPaymentTypeProvider);

    List<VisitPaymentInvoice> visitPaymentInvoices =
        ref.watch(visitPaymentInvoiceProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (paymentType == VisitPaymentType.terminal)
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
                          controller: checkNumberCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink(),
              const SizedBox(height: 50),
              Text(
                lang.comment,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              TextField(
                controller: controller,
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      lang.cancel,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 50),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      if (checkNumberCtrl.text.isEmpty &&
                          paymentType == VisitPaymentType.terminal) {
                        if (context.mounted) {
                          showErrSnackBar(context, 'Çek nomeri giriziň !!!');
                        }
                        return;
                      }

                      User user = await getUser();
                      // getting terminal String

                      String terminalNumber =
                          await ref.read(selectedTerminalProvider);

                      String terminalAccount =
                          await getTerminalBySerNo(terminalNumber);

                      num paySum = 0;
                      for (VisitPaymentInvoice vpi in visitPaymentInvoices) {
                        paySum += vpi.sumApplied;
                      }

                      VisitPayment visitPayment = VisitPayment(
                        visitId: widget.visitID,
                        comment: controller.text,
                        cashAccount: paymentType == VisitPaymentType.terminal
                            ? terminalAccount
                            : user.account,
                        paymentType: paymentType,
                        cardCode: widget.cardCode,
                        status: VisitPaymentStatus.dontSent,
                        paySum: paySum,
                        terminalNumber: paymentType == VisitPaymentType.terminal
                            ? terminalNumber
                            : '',
                        checkNumber: paymentType == VisitPaymentType.terminal
                            ? int.parse(checkNumberCtrl.text)
                            : 0,
                      );

                      int visitPaymentID =
                          await createVisitPayment(visitPayment);

                      for (VisitPaymentInvoice vpi in visitPaymentInvoices) {
                        VisitPaymentInvoice visitPaymentInvoice =
                            vpi.copyWith(invPayId: visitPaymentID);

                        await createVisitPaymentInvoice(visitPaymentInvoice);
                      }

                      if (context.mounted) {
                        navigatorPushMethod(
                          context,
                          ContinuePay(
                            visitID: widget.visitID,
                            cardCode: widget.cardCode,
                          ),
                          true,
                        );
                      }
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
    );
  }
}
