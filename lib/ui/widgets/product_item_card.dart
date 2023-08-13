import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawon_ibu_app/common/data/model/product_model.dart';
import 'package:pawon_ibu_app/common/utils/currency_formatter.dart';

import '../../common/router/app_router.dart';
import '../theme/app_theme.dart';

class ProductItemCard extends StatelessWidget {
  const ProductItemCard({
    super.key,
    required this.name,
    required this.desc,
    required this.price,
    required this.isPreview,
    this.product,
    this.imagePath,
    this.imageUrl = '',
  });

  final bool isPreview;
  final ProductModel? product;
  final String name;
  final File? imagePath;
  final String imageUrl;
  final String desc;
  final int price;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isPreview) {
          Navigator.pushNamed(
            context,
            AppRouter.detailProduct,
            arguments: product!,
          );
        }
        return;
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
        child: SizedBox(
          height: 150,
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: const BoxDecoration(
                    color: greenVariantColor,
                  ),
                  child: (imagePath != null)
                      ? Image.file(imagePath!)
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          errorWidget: (context, url, error) {
                            return const Icon(
                              CupertinoIcons.camera_viewfinder,
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: productNameStyle,
                    ),
                  ),
                  Text(
                    formatRupiah(price),
                    style: priceStyle,
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Text(
                desc,
                style: descStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
