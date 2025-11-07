import 'dart:io';
import 'package:intl/intl.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/visit_step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/models/inventor_image.dart';
import 'package:shaylan_agent/functions/file_upload.dart';
import 'package:shaylan_agent/utilities/alert_utils.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/database/functions/visit.dart';
import 'package:shaylan_agent/database/functions/visit_step.dart';
import 'package:shaylan_agent/providers/database/inventor_image.dart';
import 'package:shaylan_agent/database/functions/inventor_images.dart';
import 'package:shaylan_agent/pages/credit_reports/new_credit_reports.dart';

class InventorNewPage extends ConsumerStatefulWidget {
  const InventorNewPage({
    super.key,
    required this.visitID,
    required this.cardCode,
  });

  final int visitID;
  final String cardCode;

  @override
  ConsumerState<InventorNewPage> createState() => _InventorNewPageState();
}

class _InventorNewPageState extends ConsumerState<InventorNewPage> {
  // Just empty column

  bool hasInventor = false;
  bool hasContract = true;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    debugPrint("-----------onInventorNewPage");
    var lang = AppLocalizations.of(context)!;
    final inventorImages = ref.watch(
      getInventorImagesByVisitIDProvider(widget.visitID),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          lang.inventorControl,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.monserratBold,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            IconlyLight.arrow_left_2,
            color: Colors.white,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Center(
                      child: Text(
                        "${lang.hasInventor}?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          fontFamily: AppFonts.monserratBold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CheckboxListTile(
                      title: Text(
                        lang.no,
                        style: TextStyle(
                          fontFamily: AppFonts.monserratBold,
                          fontSize: 14.sp,
                        ),
                      ),
                      value: !hasInventor,
                      onChanged: (value) {
                        setState(() {
                          hasInventor = false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    CheckboxListTile(
                      title: Text(
                        lang.yes,
                        style: TextStyle(
                          fontFamily: AppFonts.monserratBold,
                          fontSize: 14.sp,
                        ),
                      ),
                      value: hasInventor,
                      onChanged: (value) {
                        setState(() {
                          hasInventor = true;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              if (hasInventor) ...[
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Center(
                        child: Text(
                          "${lang.hasInventorContract}?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            fontFamily: AppFonts.monserratBold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      CheckboxListTile(
                        title: Text(
                          lang.no,
                          style: TextStyle(
                            fontFamily: AppFonts.monserratBold,
                            fontSize: 14.sp,
                          ),
                        ),
                        value: !hasContract,
                        onChanged: (value) {
                          setState(() {
                            hasContract = false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                      CheckboxListTile(
                        title: Text(
                          lang.yes,
                          style: TextStyle(
                            fontFamily: AppFonts.monserratBold,
                            fontSize: 14.sp,
                          ),
                        ),
                        value: hasContract,
                        onChanged: (value) {
                          setState(() {
                            hasContract = true;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          lang.inventoryPhotos,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.monserratBold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 90.h,
                        child: inventorImages.when(
                          data: (images) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length + 1,
                              itemBuilder: (context, index) {
                                if (index == images.length) {
                                  return Container(
                                    width: 100.w,
                                    margin: EdgeInsets.only(right: 8.w),
                                    child: InkWell(
                                      onTap: _takePhoto,
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color: Theme.of(context).primaryColor,
                                            width: 2,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 42.sp,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                final image = images[index];
                                return Container(
                                  width: 100.w,
                                  margin: EdgeInsets.only(right: 8.w),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.r),
                                        child: Image.file(
                                          File(image.imagePath!),
                                          fit: BoxFit.cover,
                                          width: 100.w,
                                          height: 100.h,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => _deletePhoto(image),
                                          child: Container(
                                            padding: EdgeInsets.all(4.w),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.3),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          loading: () => Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.h),
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                          error: (error, stack) => Center(
                            child: Text(
                              lang.unsuccessfully,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            minimumSize: Size(double.infinity, 40.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0.r),
            ),
          ),
          onPressed: isProcessing ? null : _completeInventorStepsAndProceed,
          child: isProcessing
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.next,
                      style: TextStyle(
                        fontSize: 18.0.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.monserratBold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    User user = await getUser();
    String currentTime = DateFormat('dd-MM-yyyy_kkmmss').format(DateTime.now());
    String fileName = '${user.empId}-${widget.cardCode}-${widget.visitID}-$currentTime';

    await getImageFromCamera(ref, 3, 4, widget.visitID, fileName);
    ref.invalidate(getInventorImagesByVisitIDProvider(widget.visitID));
  }

  Future<void> _deletePhoto(InventorImage image) async {
    await deleteFile(image.imagePath!);
    await removeInventorImageById(image.id!);
    ref.invalidate(getInventorImagesByVisitIDProvider(widget.visitID));
  }

  Future<void> _completeInventorStepsAndProceed() async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    try {
      var lang = AppLocalizations.of(context)!;
      String currentTime = DateTime.now().toIso8601String();

      // Update visit with inventor information
      if (hasInventor) {
        await updateVisitHasInventor(1);
        await updateVisitHasInventorContract(hasContract ? 1 : 0);
      } else {
        await updateVisitHasInventor(0);
      }

      // Create Step 1: Reconciliation of Mutual Settlements
      VisitStepModel step1 = VisitStepModel(
        startTime: currentTime,
        name: 'step 1',
        visitID: widget.visitID,
        description: lang.reconciliationOfMutualSettlements,
      );

      await createVisitStep(step1);
      await setEndTimeToVisitStep(widget.visitID, 'step 1', currentTime);

      VisitStepModel step2 = VisitStepModel(
        startTime: currentTime,
        name: 'step 2',
        visitID: widget.visitID,
        description: lang.workOnSpecialTasks,
      );

      await createVisitStep(step2);
      await setCanPayToVisitStep(widget.visitID, 'step 2', 'Y');
      await setEndTimeToVisitStep(widget.visitID, 'step 2', currentTime);

      // Create Step 3: Collection of Payment
      VisitStepModel step3 = VisitStepModel(
        startTime: currentTime,
        name: 'step 3',
        visitID: widget.visitID,
        description: lang.collectionOfPayment,
      );
      await createVisitStep(step3);

      // Navigate to NewCreditReportsPage
      if (context.mounted) {
        if (mounted) {
          navigatorPushMethod(
            context,
            NewCreditReportsPage(
              visitID: widget.visitID,
              cardCode: widget.cardCode,
            ),
            false,
          );
        }
      }
    } catch (e) {
      debugPrint('Error completing inventor steps: $e');
      if (mounted) {
        AlertUtils.showSnackBarError(
          context: context,
          message: AppLocalizations.of(context)!.unsuccessfully,
          second: 3,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  // Just empty column
}
