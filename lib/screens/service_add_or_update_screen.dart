import 'dart:io';
import 'dart:typed_data';
import 'package:expertis/data/response/status.dart';
import 'package:expertis/models/categories_model.dart';
import 'package:expertis/models/shop_model.dart';
import 'package:expertis/utils/assets.dart';
import 'package:expertis/view_model/categories_view_model.dart';
import 'package:expertis/view_model/shop_view_model.dart';
import 'package:expertis/view_model/user_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../utils/BMColors.dart';
import '../utils/BMWidgets.dart';
import 'package:dotted_border/dotted_border.dart';

class CreateUpdateServiceScreen extends StatefulWidget {
  final String? serviceId;
  Services? service = Services();

  CreateUpdateServiceScreen({Key? key, this.serviceId, this.service})
      : super(key: key);

  @override
  CreateUpdateServiceScreenState createState() =>
      CreateUpdateServiceScreenState();
}

class CreateUpdateServiceScreenState extends State<CreateUpdateServiceScreen> {
  CategoryViewModel categoryViewModel = CategoryViewModel();

  FocusNode description = FocusNode();

  bool isFileSelected = false;
  File? pickedImage;
  Uint8List webImage = Uint8List(8);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setStatusBarColor(bmSpecialColor);
    widget.service ??= Services();
    categoryViewModel.fetchCategoryListApi();

    UserViewModel.getUser()
        .then((value) => {widget.service?.shop = value.shop!.first.id});
    if (widget.serviceId != null) {}
    super.initState();
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent);
    super.dispose();
  }

  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(
          source: source, maxHeight: 200, maxWidth: 200);
      if (image == null) {
        return;
      }
      // final newImage = await File(image.path).copy(imageFile.path);
      setState(() => widget.service?.photo = image.path);

      setState(() {
        isFileSelected = true;
        pickedImage = File(image.path);
      });
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          pickedImage = File('a');
          isFileSelected = true;
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("hii hell namaskara");
    // print('id is ${widget.serviceId}');
    print('Add or update services');
    ShopViewModel shopViewModel = Provider.of<ShopViewModel>(
      context,
    );

    return Scaffold(
      backgroundColor: appStore.isDarkModeOn
          ? appStore.scaffoldBackground!
          : bmLightScaffoldBackgroundColor,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            upperContainer(
              screenContext: context,
              child: headerText(
                  title: widget.serviceId == null
                      ? 'Add Service'
                      : 'Update Service'),
            ),
            lowerContainer(
                screenContext: context,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.height,

                      Text('Service Name',
                          style: primaryTextStyle(
                              color: appStore.isDarkModeOn
                                  ? bmTextColorDarkMode
                                  : bmSpecialColor,
                              size: 14)),
                      AppTextField(
                        keyboardType: TextInputType.text,
                        nextFocus: description,
                        initialValue: widget.service?.serviceName ?? '',
                        onChanged: (value) {
                          widget.service?.serviceName = value;
                        },
                        textFieldType: TextFieldType.NAME,
                        errorThisFieldRequired: 'Name is required',
                        autoFocus: true,
                        cursorColor: bmPrimaryColor,
                        textStyle: boldTextStyle(
                            color: appStore.isDarkModeOn
                                ? bmTextColorDarkMode
                                : bmPrimaryColor),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                        ),
                      ),
                      16.height,
                      Text('Price',
                          style: primaryTextStyle(
                              color: appStore.isDarkModeOn
                                  ? bmTextColorDarkMode
                                  : bmSpecialColor,
                              size: 14)),
                      AppTextField(
                        // focus: phone,
                        initialValue: widget.service?.price.toString() != 'null'
                            ? widget.service?.price.toString()
                            : '',
                        textFieldType: TextFieldType.PHONE,
                        maxLength: 5,
                        onChanged: (val) => widget.service?.price = val.toInt(),
                        // nextFocus: address,
                        // controller: _phoneController,
                        // validator: (value) {
                        //   Pattern pattern =
                        //       r'^(\+91[\-\s]?)?[0]?(91)?[789]\d{9}$';
                        //   RegExp regex = RegExp(pattern.toString());

                        //   if (value!.length != 10) {
                        //     return 'Phone number must be 10 digits';
                        //   } else if (!regex.hasMatch(value)) {
                        //     return 'Invalid phone number';
                        //   }
                        //   return null;
                        // },
                        errorThisFieldRequired: 'Price is required',
                        cursorColor: bmPrimaryColor,
                        textStyle: boldTextStyle(
                            color: appStore.isDarkModeOn
                                ? bmTextColorDarkMode
                                : bmPrimaryColor),
                        suffixIconColor: bmPrimaryColor,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                        ),
                      ),

                      Text('Time (in minutes)',
                          style: primaryTextStyle(
                              color: appStore.isDarkModeOn
                                  ? bmTextColorDarkMode
                                  : bmSpecialColor,
                              size: 14)),
                      AppTextField(
                        // focus: phone,
                        initialValue: widget.service?.time.toString() != 'null'
                            ? widget.service?.time.toString()
                            : '',
                        textFieldType: TextFieldType.PHONE,
                        maxLength: 5,
                        onChanged: (val) => widget.service?.time = val,
                        // nextFocus: address,
                        // controller: _phoneController,
                        // validator: (value) {
                        //   Pattern pattern =
                        //       r'^(\+91[\-\s]?)?[0]?(91)?[789]\d{9}$';
                        //   RegExp regex = RegExp(pattern.toString());

                        //   if (value!.length != 10) {
                        //     return 'Phone number must be 10 digits';
                        //   } else if (!regex.hasMatch(value)) {
                        //     return 'Invalid phone number';
                        //   }
                        //   return null;
                        // },
                        errorThisFieldRequired: 'Time is required',
                        cursorColor: bmPrimaryColor,
                        textStyle: boldTextStyle(
                            color: appStore.isDarkModeOn
                                ? bmTextColorDarkMode
                                : bmPrimaryColor),
                        suffixIconColor: bmPrimaryColor,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                        ),
                      ),

                      Text('Service Photo',
                          style: primaryTextStyle(
                              color: appStore.isDarkModeOn
                                  ? bmTextColorDarkMode
                                  : bmSpecialColor,
                              size: 14)),
                      // Image to be picked code is here
                      Row(children: [
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: isFileSelected == false &&
                                          widget.service?.photo != null &&
                                          widget.service?.photo != ""
                                      ? Image.network(
                                          widget.service?.photo ??
                                              Assets.defaultCategoryImage,
                                          fit: BoxFit.fill,
                                          width: 200,
                                          height: 200)
                                      : pickedImage == null
                                          ? dottedBorder(color: Colors.grey)
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: kIsWeb
                                                  ? Image.memory(webImage,
                                                      fit: BoxFit.fill,
                                                      width: 200,
                                                      height: 200)
                                                  : Image.file(pickedImage!,
                                                      fit: BoxFit.fill,
                                                      width: 200,
                                                      height: 200),
                                            )),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              AppButton(
                                child: Text('Clear',
                                    style: boldTextStyle(color: Colors.red)),
                                padding: EdgeInsets.all(16),
                                width: 150,
                                onTap: () {
                                  setState(() {
                                    pickedImage = null;
                                    isFileSelected = false;
                                    webImage = Uint8List(8);
                                  });
                                },
                              ),
                              SizedBox(height: 12),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      color: appStore.isDarkModeOn
                                          ? bmTextColorDarkMode
                                          : bmPrimaryColor,
                                      icon: Icon(Icons.photo),
                                      onPressed: () {
                                        pickImage(source: ImageSource.gallery);
                                      },
                                    ),
                                    IconButton(
                                      color: appStore.isDarkModeOn
                                          ? bmTextColorDarkMode
                                          : bmPrimaryColor,
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: () {
                                        pickImage(source: ImageSource.camera);
                                      },
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ]),
                      Divider(
                        color: appStore.isDarkModeOn
                            ? bmTextColorDarkMode
                            : bmPrimaryColor,
                        thickness: 1,
                      ),
                      16.height,
                      Text('Category',
                          style: primaryTextStyle(
                              color: appStore.isDarkModeOn
                                  ? bmTextColorDarkMode
                                  : bmSpecialColor,
                              size: 14)),
                      ChangeNotifierProvider<CategoryViewModel>(
                        create: (BuildContext context) => categoryViewModel,
                        child: Consumer<CategoryViewModel>(
                            builder: (context, value, _) {
                          switch (value.categoryList.status) {
                            case Status.LOADING:
                              return const Center(
                                  child: CircularProgressIndicator());
                            case Status.ERROR:
                              return Center(
                                  child: Text(
                                      value.categoryList.message.toString()));
                            case Status.COMPLETED:
                              List<CategoryModel> categories =
                                  value.categoryList.data?.categories ?? [];
                              List<CategoryModel> selectedCategories = [];
                              widget.service!.tags?.forEach((tag) {
                                selectedCategories.add(categories.firstWhere(
                                    (category) => category.id == tag));
                              });
                              print(selectedCategories);

                              return MultiSelectDialogField(
                                searchable: true,
                                initialValue: selectedCategories,
                                items: categories
                                    .map((e) =>
                                        MultiSelectItem(e, e.tagName ?? ''))
                                    .toList(),
                                listType: MultiSelectListType.CHIP,
                                onConfirm: (values) {
                                  List<dynamic> selectedCategories =
                                      values as List<CategoryModel>;
                                  widget.service?.tags = selectedCategories
                                      .map((e) => e.id.toString())
                                      .toList();
                                  print(widget.service?.tags);
                                },
                              );
                            default:
                              return Container();
                          }
                        }),
                      ),
                      20.height,

                      Text('Service Description',
                          style: primaryTextStyle(
                              color: appStore.isDarkModeOn
                                  ? bmTextColorDarkMode
                                  : bmSpecialColor,
                              size: 14)),
                      AppTextField(
                        keyboardType: TextInputType.multiline,
                        focus: description,
                        initialValue: widget.service?.description ?? '',
                        nextFocus: null,
                        textFieldType: TextFieldType.MULTILINE,
                        onChanged: (value) {
                          print(widget.service?.toString());
                          widget.service?.description = value;
                        },

                        // controller: _addressController,
                        cursorColor: bmPrimaryColor,
                        textStyle: boldTextStyle(
                            color: appStore.isDarkModeOn
                                ? bmTextColorDarkMode
                                : bmPrimaryColor),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: appStore.isDarkModeOn
                                      ? bmTextColorDarkMode
                                      : bmPrimaryColor)),
                        ),
                      ),

                      30.height,
                      AppButton(
                        width: context.width() - 32,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        padding: const EdgeInsets.all(16),
                        color: bmPrimaryColor,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            print(
                                ' after validate ${widget.service?.price.toString()}');
                            // if (!kIsWeb) {
                            //   if (pickedImage == null) {
                            //     Utils.flushBarErrorMessage(
                            //         "Please pic a shop logo", context);
                            //     return;
                            //   }
                            // }

                            if (kDebugMode) {
                              print("form is valid");

                              print(widget.service?.price.toString());
                            }

                            Map serviceData = widget.service!.toJson()
                              ..removeWhere((key, value) =>
                                  value == null ||
                                  value == '' ||
                                  value == 'null' ||
                                  value == []);

                            if (serviceData["tags"] != null) {
                              List<String> tags = serviceData["tags"];
                              print('tags: $tags');
                              tags.forEach((e) {
                                serviceData["tags[${tags.indexOf(e)}]"] =
                                    e.toString();
                                print("added tag: $e");
                              });
                              print(serviceData);
                            }
                            serviceData.remove('tags');

                            Map<String, String> data = serviceData
                                .map((k, v) => MapEntry(k, v.toString()));

                            Map<String, dynamic?> files = {
                              'photo': widget.service?.photo,
                            };
                            data.remove('photo');

                            if (kDebugMode) {
                              print('data: $data');
                              print('files: $files');
                            }
                            shopViewModel.sendServiceData(
                                widget.service?.id != null,
                                data,
                                false,
                                files,
                                context);
                          }
                        },
                        child: shopViewModel.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                widget.serviceId == null ? 'Submit' : 'Update',
                                style: boldTextStyle(color: Colors.white)),
                      ),
                      30.height,
                    ],
                  ).paddingSymmetric(horizontal: 16),
                )).expand()
          ],
        ),
      ),
    );
  }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          dashPattern: const [6.7],
          borderType: BorderType.RRect,
          color: color,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Drag and drop image here',
                  style: boldTextStyle(
                    color: color,
                    size: 14,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
