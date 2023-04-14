import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/view/Marketplace/_marketplace.dart';
import 'package:utmletgo/viewmodel/MarketplaceViewModel.dart';

class CategoryCardList extends StatelessWidget {
  const CategoryCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketplaceViewModel>.nonReactive(
        viewModelBuilder: () => MarketplaceViewModel(),
        builder: (context, model, child) {
          return Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: categoryList.length,
                itemBuilder: (BuildContext context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: CategoryCard(
                        onTap: () {
                          model.passDataToNextWidget(
                              'category', categoryList[index].name);
                          model.navigateToItemListScreen();
                        },
                        begin: categoryList[index].begin,
                        end: categoryList[index].end,
                        name: categoryList[index].name,
                        imgPath: categoryList[index].imgPath,
                      ),
                    )),
          );
        });
  }
}
