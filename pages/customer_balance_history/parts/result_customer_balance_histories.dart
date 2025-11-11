import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/customer_balance_history_expansion_tile.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/customer_balance_invoice_history_expansion_tile.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/customer_balance_payment_history_expansion_tile.dart';
import 'package:shaylan_agent/providers/database/customer_balance_history.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';

class ResultCustomerBalanceHistories extends ConsumerWidget {
  const ResultCustomerBalanceHistories({super.key, required this.cardCode});

  final String cardCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    AsyncValue<ResultCustomerBalanceHistory> resultCustomerBalanceHistory = ref.watch(getAllCustomerBalanceHistoriesProvider(cardCode));
    AsyncValue<num> visitPayments = ref.watch(getSumVisitPaymentInvoicesByCardCodeProvider(cardCode));
    return resultCustomerBalanceHistory.when(
      data: (data) {
        if (data.error != '') {
          return Center(child: Text(data.error));
        }

        if (data.customerBalanceHistories == null ||
            data.customerBalanceHistories!.isEmpty) {
          return Center(
            child: Text(
              lang.noData,
              style: const TextStyle(fontSize: 20),
            ),
          );
        }

        num sumBalanceDue = 0;

        CustomerBalanceHistoryGroup invoices = CustomerBalanceHistoryGroup(
          movementType: lang.invoice,
          customerBalanceHistories: [],
        );
        CustomerBalanceHistoryGroup payments = CustomerBalanceHistoryGroup(
          movementType: lang.payment,
          customerBalanceHistories: [],
        );
        CustomerBalanceHistoryGroup invoiceCorrections =
            CustomerBalanceHistoryGroup(
          movementType: lang.returns,
          customerBalanceHistories: [],
        );

        for (CustomerBalanceHistory cbh in data.customerBalanceHistories!) {
          sumBalanceDue += cbh.balanceDue;

          switch (cbh.movementType) {
            case CustomerBalanceHistoryMovementTypes.faktura:
              invoices.customerBalanceHistories.add(cbh);
              break;
            case CustomerBalanceHistoryMovementTypes.toleg:
              payments.customerBalanceHistories.add(cbh);
              break;
            case CustomerBalanceHistoryMovementTypes.wozwrat:
              invoiceCorrections.customerBalanceHistories.add(cbh);
              break;
            default:
          }
        }

        return ListView(
          children: [
            visitPayments.when(
              data: (response) {
                return Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${lang.totalAmountRemainder} : ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.monserratBold,
                              ),
                            ),
                            Text(
                              "${sumBalanceDue.toStringAsFixed(2)} ${lang.manat}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.monserratBold,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        response != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${lang.assigned} : ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.monserratBold,
                                    ),
                                  ),
                                  Text(
                                    "${response.toStringAsFixed(2)} ${lang.manat}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.monserratBold,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 10),
                        response != 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${lang.remainder} : ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.monserratBold,
                                    ),
                                  ),
                                  Text(
                                    "${(sumBalanceDue - response).toStringAsFixed(2)} ${lang.manat}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.monserratBold,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                );
              },
              error: (error, stackTrace) => errorMethod(error),
              loading: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 10),
            CustomerBalanceInvoiceHistoryExpansionTile(
              cbhg: invoices,
              cardCode: cardCode,
            ),
            CustomerBalancePaymentHistoryExpansionTile(
              customerBalanceHistoryGroup: payments,
              cardCode: cardCode,
            ),
            CustomerBalanceHistoryExpansionTile(
              customerBalanceHistoryGroup: invoiceCorrections,
            ),
          ],
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
