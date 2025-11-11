import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/app/app_fonts.dart';

class GridviewPart extends StatelessWidget {
  const GridviewPart({
    super.key,
    required this.texts,
    required this.functions,
    required this.icons,
  });

  final List<String> texts;
  final List<dynamic Function()?> functions;
  final List<IconData?> icons;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: texts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return (texts[index] != '' || texts[index].isNotEmpty)
            ? GestureDetector(
                onTap: functions[index],
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300,
                    boxShadow: [
                      const BoxShadow(
                        blurRadius: 30,
                        offset: Offset(-15, -15),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        texts[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.monserratBold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
