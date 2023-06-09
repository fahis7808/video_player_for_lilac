import 'package:auto_binding_field/auto_binding_field.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player_for_lilac/provider/authentication_provider.dart';


class Registration extends StatelessWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticationProvider(),
      child: Consumer<AuthenticationProvider>(builder: (context, data, _) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                      child: InkWell(
                        onTap: () {
                          data.selectImage(context);
                        },
                        child: data.image == null
                            ? CircleAvatar(
                          backgroundColor: context.theme.colorScheme.primary,
                          radius: 70,
                          child: Icon(
                            Icons.account_circle,
                            color: context.theme.colorScheme.onPrimary,
                            size: 100,
                          ),
                        )
                            : CircleAvatar(
                          backgroundImage: FileImage(data.image!),
                          radius: 70,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 50  ,
                ),
                AutoBindingTextField(
                  value: data.name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: context.theme.colorScheme.primary,
                    ),
                    border: InputBorder.none,
                    hintText: "Full Name",
                  ),
                  onChanged: (val) {
                    data.name = val;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                AutoBindingTextField(
                  value: data.email,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail,
                      color: context.theme.colorScheme.primary,
                    ),
                    border: InputBorder.none,
                    hintText: "Email",
                  ),
                  onChanged: (val) {
                    data.email = val;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                AutoBindingTextField(
                  value: data.pickedDate,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                     data.selectDate(context);
                      },
                      icon: Icon(Icons.calendar_month,
                          color: context.theme.colorScheme.primary),
                    ),
                    border: InputBorder.none,
                    hintText: "Date of Birth",
                  ),
                  onChanged: (val) {
                    data.pickedDate = val;
                  },
                ),
                const SizedBox(height: 50,),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(onPressed: (){
                      data.registerData(context);
                    }, child: const Text('Next')))
              ],
            ),
          ),
        );
      }),
    );
  }

}
