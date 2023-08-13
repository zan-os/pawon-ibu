import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';

import '../../common/utils/currency_formatter.dart';
import 'divider_widget.dart';

class ProductListTile extends StatelessWidget {
  final String? image;
  final String? productName;
  final int? productPrice;
  final String? productQty;
  final bool inCart;
  final Function? onAddTap;
  final Function? onMinTap;

  const ProductListTile({
    super.key,
    required this.image,
    required this.productName,
    required this.productPrice,
    required this.productQty,
    this.inCart = false,
    this.onAddTap,
    this.onMinTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: image ?? '',
                  height: 80,
                  width: 80,
                  errorWidget: (context, url, error) {
                    return const Icon(
                      Icons.broken_image_outlined,
                      size: 80,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(productName ?? '-', style: productNameStyle),
                      const SizedBox(height: 16.0),
                      Text(formatRupiah(productPrice), style: blackTextStyle),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Jumlah',
                    style: blackTextStyle,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (inCart)
                        InkWell(
                          onTap: () {
                            if (onAddTap != null) {
                              onAddTap!();
                            }
                          },
                          child: const Icon(Icons.add_rounded),
                        )
                      else
                        const SizedBox.shrink(),
                      const SizedBox(width: 6.0),
                      Text(
                        productQty ?? '0',
                        style: blackTextStyle,
                      ),
                      const SizedBox(width: 6.0),
                      if (inCart)
                        InkWell(
                          onTap: () {
                            if (onMinTap != null) {
                              onMinTap!();
                            }
                          },
                          child: const Icon(Icons.remove),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const DividerWidget()
      ],
    );
  }
}
