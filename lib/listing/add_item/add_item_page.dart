import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/core/navigation_service.dart';
import 'package:flutter_starterkit_firebase/listing/add_item/bloc/additem_bloc.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/model/user.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:flutter_starterkit_firebase/utils/utility.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPage createState() => _AddItemPage();
}

class _AddItemPage extends State<AddItemPage> {
  ItemType _selectedItemType = ItemType.newItem;
  List<Asset> images = [];
  AdditemBloc _addItemBloc;
  AuthenticationBloc _authBloc;
  NavigationService navigationService;
  UtilityProvider utility;
  final _formkey = GlobalKey<FormState>();

  String _title, _description, _address;
  double _price;

  User get _user => (_authBloc.state as Authenticated)?.user;

  @override
  void initState() {
    super.initState();
    _addItemBloc = BlocProvider.of<AdditemBloc>(context);
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
    navigationService = context.read<NavigationService>();
    utility = context.read<UtilityProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdditemBloc, AdditemState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case NewItemSelected:
            _selectedItemType = ItemType.newItem;
            break;
          case UsedItemSelected:
            _selectedItemType = ItemType.UsedItem;
            break;
          case MultipleImageSelected:
            final temp = state as MultipleImageSelected;
            images = temp.assetList;
            break;
        }

        if ((_authBloc.state as Authenticated)?.user == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Add Item',
                style: style,
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign up to post stuff'),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: ColorPalette.primary,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () => navigationService.navigateTo('/login'),
                        child: Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: style.copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Add Item',
              style: style,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: Spacing.fab,
              child: Form(
                child: Column(
                  children: [
                    if (images.isEmpty)
                      GestureDetector(
                        child: Icon(
                          Icons.image,
                          size: 250,
                          color: ColorPalette.grey,
                        ),
                        onTap: () => loadAssets(),
                        behavior: HitTestBehavior.opaque,
                      )
                    else
                      GridView.count(
                        crossAxisCount: 3,
                        children: List.generate(images.length, (index) {
                          final asset = images[index];
                          return AssetThumb(
                            asset: asset,
                            width: 300,
                            height: 300,
                          );
                        }),
                        shrinkWrap: true,
                      ),
                    Sizing.fab,
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Title'),
                      onSaved: (value) => _title = value.trim(),
                      validator: (value) => value.isEmpty ? 'Field is required' : null,
                    ),
                    Sizing.medium,
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Description'),
                      onSaved: (value) => _description = value.trim(),
                      validator: (value) => value.isEmpty ? 'Field is required' : null,
                    ),
                    Sizing.medium,
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Price'),
                      onSaved: (value) => _price = double.tryParse(value),
                      validator: (value) => value.isEmpty ? 'Field is required' : null,
                    ),
                    Sizing.medium,
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Address'),
                      onSaved: (value) => _address = value.trim(),
                      validator: (value) => value.isEmpty ? 'Field is required' : null,
                    ),
                    Sizing.medium,
                    Row(
                      children: [
                        Radio<ItemType>(
                          groupValue: _selectedItemType,
                          onChanged: _itemTypeChanged,
                          value: ItemType.newItem,
                        ),
                        VerticalDivider(),
                        Text(
                          'New Item',
                          style: style,
                        ),
                        Radio<ItemType>(
                          groupValue: _selectedItemType,
                          onChanged: _itemTypeChanged,
                          value: ItemType.UsedItem,
                        ),
                        VerticalDivider(),
                        Text(
                          'Used Item',
                          style: style,
                        ),
                      ],
                    ),
                    Sizing.medium,
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: ColorPalette.primary,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () => attemptSubmit(),
                        child: Text(
                          'Submit Item',
                          textAlign: TextAlign.center,
                          style: style.copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                key: _formkey,
              ),
            ),
          ),
        );
      },
      buildWhen: (AdditemState oldState, AdditemState currentState) {
        switch (currentState.runtimeType) {
          case StartLoading:
            utility.startLoading(context);
            break;
          case LoadingFailed:
            final temp = currentState as LoadingFailed;
            utility.loadingFailed(temp.msg);
            break;
          case LoadingSuccessful:
            final temp = currentState as LoadingSuccessful;
            utility.loadingSuccessful(temp.msg);
            navigationService.goBack();
            break;
        }
        return currentState is! StartLoading || currentState is! LoadingFailed || currentState is! LoadingSuccessful;
      },
    );
  }

  Future<void> loadAssets() async {
    var resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: 'gallery'),
        materialOptions: MaterialOptions(
          actionBarColor: '#abcdef',
          actionBarTitle: 'SellIt',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor: '#000000',
        ),
      );

      _addItemBloc.add(ImageSelectedEvent(resultList));
    } on Exception catch (e) {
      print(e);
    }
  }

  void _itemTypeChanged(ItemType value) {
    _addItemBloc.add(ItemTypeChangedEvent(value));
  }

  void attemptSubmit() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      final entity = ItemEntity(
        uid: null,
        author: _user,
        dateCreated: _addItemBloc.currentDate.millisecondsSinceEpoch,
        title: _title,
        description: _description,
        price: _price,
        location: _address,
        type: describeEnum(_selectedItemType),
      );
      _addItemBloc.add(SubmitAddItemEvent(images, entity));
    }
  }
}

enum ItemType { newItem, UsedItem }
